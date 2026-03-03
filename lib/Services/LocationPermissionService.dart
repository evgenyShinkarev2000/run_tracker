import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:rxdart/rxdart.dart';

// Есть баг с неправильным определением LocationPermission в firefox https://github.com/Baseflow/flutter-geolocator/issues/1657
//TODO pulling статуса геолокации, т.к. в веб нет поддержки стрима, но на карте почему-то работате и без этого.

abstract interface class LocationPermissionService
    implements IStreamProvider<DetailedLocationPermission>, IDisposable {
  DetailedLocationPermission get state;
  Future<void> initialize();
  Future<void> requestPermission();
}

class GeolocatorLocationPermissionService extends LocationPermissionService {
  DetailedLocationPermission _state = DetailedLocationPermission.NotInitialized;
  @override
  DetailedLocationPermission get state => _state;
  @override
  Stream<DetailedLocationPermission> get stream => _lazyBehaviorSubject.stream;

  final BehaviorSubject<DetailedLocationPermission> _lazyBehaviorSubject =
      BehaviorSubject.seeded(DetailedLocationPermission.NotInitialized);

  @override
  void dispose() {
    _lazyBehaviorSubject.close();
  }

  @override
  Future<void> initialize() async {
    await _updateLocationState();
  }

  @override
  Future<void> requestPermission() async {
    await _updateLocationState();
    final permission = await Geolocator.requestPermission();
    _setStateAndNotify(_geolocatorToApp(permission));
  }

  void _setStateAndNotify(DetailedLocationPermission state) {
    _state = state;
    _lazyBehaviorSubject.add(state);
  }

  Future<void> _updateLocationState() async {
    if (_state == DetailedLocationPermission.Loading) {
      await stream.first;
      return;
    }
    _setStateAndNotify(DetailedLocationPermission.Loading);
    try {
      final isLocationEnabled =
          await Geolocator.isLocationServiceEnabled();
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
}

DetailedLocationPermission _geolocatorToApp(
  LocationPermission permission,
) {
  return switch (permission) {
    LocationPermission.whileInUse =>
      DetailedLocationPermission.PermitedInUse,
    LocationPermission.always => DetailedLocationPermission.Permited,
    LocationPermission.denied => DetailedLocationPermission.Denied,
    LocationPermission.deniedForever =>
      DetailedLocationPermission.DeniedForever,
    LocationPermission.unableToDetermine =>
      DetailedLocationPermission.Unknown,
  };
}

extension LocationPermissionServiceExtension on LocationPermissionService {
  SimpleLocationPermission get SimpleState => state.toSimple();
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
