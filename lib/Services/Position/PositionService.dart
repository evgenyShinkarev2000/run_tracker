import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Services/Position/export.dart';
import 'package:rxdart/rxdart.dart';

// Есть баг с неправильным определением LocationPermission в firefox https://github.com/Baseflow/flutter-geolocator/issues/1657
//TODO pulling статуса геолокации, т.к. в веб нет поддержки стрима, но на карте почему-то работате и без этого.

abstract interface class PositionService {
  Stream<AppPosition> get positionStream;
  DetailedLocationPermission get permission;
  Stream<DetailedLocationPermission> get permissionStream;
  Future<AppPosition?> tryGetLastPosition();
  Future<void> initializePermission();
  Future<void> requestPermission();
}

class GeolocatorPositionService extends PositionService implements IDisposable {
  @override
  DetailedLocationPermission get permission => _permissionSubject.value;
  @override
  Stream<DetailedLocationPermission> get permissionStream =>
      _permissionSubject.stream;
  @override
  Stream<AppPosition> get positionStream => _positionController.stream;

  final BehaviorSubject<DetailedLocationPermission> _permissionSubject =
      BehaviorSubject.seeded(DetailedLocationPermission.NotInitialized);
  final StreamController<AppPosition> _positionController =
      StreamController.broadcast();
  final ILogger _logger;

  bool _isDisposed = false;
  AppPosition? _lastStreamedPosition;
  StreamSubscription<Position>? _geolocatorPositionSubscription;

  GeolocatorPositionService(this._logger) {
    _positionController.onListen = () {
      _ensureNotDisposed();
      if (_geolocatorPositionSubscription != null) {
        return;
      }
      _updateGeolocatorStream();
    };
  }

  @override
  void dispose() {
    _isDisposed = true;
    _permissionSubject.close();
    _positionController.close();
    _geolocatorPositionSubscription?.cancel();
  }

  @override
  Future<AppPosition?> tryGetLastPosition() async {
    if (_lastStreamedPosition != null) {
      return _lastStreamedPosition;
    }
    try {
      final position = await Geolocator.getLastKnownPosition();
      return position == null ? null : _fromGeolocatorPosition(position);
    } catch (ex, s) {
      _logger.logWarning(
        "Exception thrown in GeolocatorPositionDataProvider in Geolocator.getLastKnownPosition()",
        appException: DartExceptionWrapper(ex, s),
      );
    }

    return null;
  }

  @override
  Future<void> initializePermission() async {
    await _updateLocationState();
  }

  @override
  Future<void> requestPermission() async {
    await _updateLocationState();
    final permission = await Geolocator.requestPermission();
    _setStateAndNotify(_geolocatorToApp(permission));
    if (_positionController.hasListener) {
      _updateGeolocatorStream();
    }
  }

  void _setStateAndNotify(DetailedLocationPermission state) {
    _permissionSubject.add(state);
  }

  Future<void> _updateLocationState() async {
    if (_permissionSubject.value == DetailedLocationPermission.Loading) {
      await permissionStream.first;
      return;
    }
    _setStateAndNotify(DetailedLocationPermission.Loading);
    try {
      final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        _setStateAndNotify(DetailedLocationPermission.Disabled);
        return;
      }

      final permission = await Geolocator.checkPermission();
      _setStateAndNotify(_geolocatorToApp(permission));
    } catch (ex) {
      _setStateAndNotify(DetailedLocationPermission.Unknown);
      rethrow;
    }
  }

  void _updateGeolocatorStream() {
    if (_geolocatorPositionSubscription != null) {
      _geolocatorPositionSubscription!.cancel();
    }
    _geolocatorPositionSubscription = Geolocator.getPositionStream().listen(
      (p) {
        _lastStreamedPosition = _fromGeolocatorPosition(p);
        _positionController.add(_lastStreamedPosition!);
      },
      onError: ((Object e, StackTrace s) {
        //TODO пока игнорируем, потом нужно создать отдельный сервис, который бы учитывал настройки геолокации.
        _logger.logWarning(
          "Exception thrown in GeolocatorPositionDataProvider in Geolocator.getPositionStream().handleError",
          appException: DartExceptionWrapper(e, s),
        );
      }),
    );
  }

  void _ensureNotDisposed() {
    if (_isDisposed) {
      final exception = ObjectDisposedException(
        message: "GeolocatorPositionDataProvider disposed",
      );

      _logger.logError(
        "GeolocatorPositionDataProvider.ensureState",
        appException: exception,
      );
      throw exception;
    }
  }

  static AppPosition _fromGeolocatorPosition(Position position) {
    return AppPosition(
      latitude: AppPositionComponent(position.latitude),
      longitude: AppPositionComponent(position.longitude),
      altitude: AppPositionComponent(
        position.altitude,
        position.altitudeAccuracy,
      ),
      heading: AppPositionComponent(position.heading, position.headingAccuracy),
      horizontalAccuracy: position.accuracy,
      speed: AppPositionComponent(position.speed, position.speedAccuracy),
      timestamp: position.timestamp.toUtc(),
    );
  }
}

DetailedLocationPermission _geolocatorToApp(LocationPermission permission) {
  return switch (permission) {
    LocationPermission.whileInUse => DetailedLocationPermission.PermitedInUse,
    LocationPermission.always => DetailedLocationPermission.Permited,
    LocationPermission.denied => DetailedLocationPermission.Denied,
    LocationPermission.deniedForever =>
      DetailedLocationPermission.DeniedForever,
    LocationPermission.unableToDetermine => DetailedLocationPermission.Unknown,
  };
}

extension LocationPermissionServiceExtension on PositionService {
  SimpleLocationPermission get simpleState => permission.toSimple();
}

/// Только данные от платформы, без учета настроек приложения
enum DetailedLocationPermission {
  NotInitialized,
  Loading,
  Unknown,
  Disabled,
  Permited,
  PermitedInUse,
  Denied,
  DeniedForever,
}

/// Только данные от платформы, без учета настроек приложения
enum SimpleLocationPermission { Loading, Denied, Permited }

extension DetailedLocationPermissionExtension on DetailedLocationPermission {
  SimpleLocationPermission toSimple() => DetailedToSimple(this);

  static SimpleLocationPermission DetailedToSimple(
    DetailedLocationPermission state,
  ) {
    return switch (state) {
      DetailedLocationPermission.NotInitialized ||
      DetailedLocationPermission.Loading => SimpleLocationPermission.Loading,
      DetailedLocationPermission.Disabled ||
      DetailedLocationPermission.Unknown ||
      DetailedLocationPermission.Denied ||
      DetailedLocationPermission.DeniedForever =>
        SimpleLocationPermission.Denied,
      DetailedLocationPermission.Permited ||
      DetailedLocationPermission.PermitedInUse =>
        SimpleLocationPermission.Permited,
    };
  }
}
