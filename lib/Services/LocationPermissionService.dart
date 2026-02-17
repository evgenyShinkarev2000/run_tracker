import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';

abstract interface class LocationPermissionService
    implements IStreamProvider<DetailedLocationPermission>, IDisposable {
  DetailedLocationPermission get State;
  Future<void> Initialize();
  Future<void> RequestPermission();
  Future<void> ConsiderPermited();
}

class GeolocatorLocationPermissionService extends LocationPermissionService {
  DetailedLocationPermission _state = DetailedLocationPermission.NotInitialized;
  @override
  DetailedLocationPermission get State => _state;
  @override
  Stream<DetailedLocationPermission> get stream => _lazyBehaviorSubject.stream;

  late final LazyBehaviorSubject<DetailedLocationPermission>
  _lazyBehaviorSubject = LazyBehaviorSubject(_getStateFuture);

  @override
  void Dispose() {
    _lazyBehaviorSubject.Dispose();
  }

  @override
  Future<void> Initialize() async {
    await _updateLocationState();
  }

  @override
  Future<void> RequestPermission() async {
    await _updateLocationState();
    final permission = await Geolocator.requestPermission();
    _setStateAndNotify(_geolocatorToApp(permission));
  }

  @override
  Future<void> ConsiderPermited() {
    _setStateAndNotify(DetailedLocationPermission.ConsiderPermited);

    return Future.value();
  }

  void _setStateAndNotify(DetailedLocationPermission state) {
    _state = state;
    _lazyBehaviorSubject.Add(state);
  }

  Future<DetailedLocationPermission> _getStateFuture() {
    return Future.value(_state);
  }

  Future<void> _updateLocationState() async {
    if (_state == DetailedLocationPermission.Loading) {
      await stream.first;
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

extension LocationPermissionServiceExtension on LocationPermissionService{
  SimpleLocationPermission get SimpleState => DetailedToSimple(State);

  static SimpleLocationPermission DetailedToSimple(DetailedLocationPermission state) {
  return switch (state) {
    DetailedLocationPermission.NotInitialized ||
    DetailedLocationPermission.Loading => SimpleLocationPermission.Loading,
    DetailedLocationPermission.Disabled ||
    DetailedLocationPermission.Unknown ||
    DetailedLocationPermission.Denied ||
    DetailedLocationPermission.DeniedForever ||
    DetailedLocationPermission.ConsiderDenied =>
      SimpleLocationPermission.Denied,
    DetailedLocationPermission.Permited ||
    DetailedLocationPermission.PermitedInUse ||
    DetailedLocationPermission.ConsiderPermited =>
      SimpleLocationPermission.Permited,
  };
}
}

enum SimpleLocationPermission { Loading, Denied, Permited }

enum DetailedLocationPermission {
  NotInitialized,
  Loading,
  Unknown,
  Disabled,
  Permited,
  PermitedInUse,
  ConsiderPermited,
  Denied,
  DeniedForever,
  ConsiderDenied,
}
