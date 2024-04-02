import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:run_tracker/bloc/cubits/GeolocationProviderCubit.dart';
import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/helpers/IDisposable.dart';

abstract class IGeolocationRepository {
  Stream<AppGeolocation> get geolocationStream;
  AppGeolocation? get lastGeolocation;
  Future<AppGeolocation> determineGeolocation();
}

abstract class IGeolocationProvider implements IDisposable {
  Stream<AppGeolocation> get geolocationStream;
  Duration get updateInterval;
  AppGeolocation? get lastGeolocation;
}

class GeolocationProviderFactory {
  final GeolocatorWrapper _geolocatorWrapper;
  GeolocationProviderFactory(GeolocatorWrapper geolocatorWrapper) : _geolocatorWrapper = geolocatorWrapper;

  IGeolocationProvider create(GeolocationProviderKind geolocationProviderKind) {
    switch (geolocationProviderKind) {
      case GeolocationProviderKind.Timer:
        return TimerGeolocationProvider(geolocatorWrapper: _geolocatorWrapper);
      case GeolocationProviderKind.Subscription:
        return SubscriptionGeolocationProvider(geolocatorWrapper: _geolocatorWrapper);
      case GeolocationProviderKind.TimerWithSubscription:
        return TimerWithSubscriptionGeolocationProvider(geolocatorWrapper: _geolocatorWrapper);
      case GeolocationProviderKind.Combined:
        return CombinedGeolocationProvider(geolocatorWrapper: _geolocatorWrapper);
    }
  }
}

class CombinedGeolocationProvider implements IGeolocationProvider {
  @override
  Stream<AppGeolocation> get geolocationStream => _streamController.stream;
  @override
  bool isDisposed = false;
  @override
  AppGeolocation? lastGeolocation;
  @override
  Duration updateInterval;

  late final StreamController<AppGeolocation> _streamController;
  late final SubscriptionGeolocationProvider _subscriptionGeolocationProvider;
  late final TimerGeolocationProvider _timerGeolocationProvider;
  final List<StreamSubscription> _subscription = [];

  CombinedGeolocationProvider({required GeolocatorWrapper geolocatorWrapper, Duration? updateInterval})
      : updateInterval = updateInterval ?? Duration(seconds: 1) {
    _streamController = StreamController.broadcast(onListen: _listen, onCancel: _cancel);
    _subscriptionGeolocationProvider = SubscriptionGeolocationProvider(geolocatorWrapper: geolocatorWrapper);
    _timerGeolocationProvider = TimerGeolocationProvider(geolocatorWrapper: geolocatorWrapper);
  }

  @override
  void dispose() {
    _cancel();
    _subscriptionGeolocationProvider.dispose();
    _timerGeolocationProvider.dispose();
    _streamController.close();

    isDisposed = true;
  }

  void _listen() {
    _subscription.add(
        _subscriptionGeolocationProvider.geolocationStream.listen((geolocation) => _processGeolocation(geolocation)));
    _subscription
        .add(_timerGeolocationProvider.geolocationStream.listen((geolocation) => _processGeolocation(geolocation)));
  }

  void _cancel() {
    for (var s in _subscription) {
      s.cancel();
    }
    _subscription.clear();
  }

  void _processGeolocation(AppGeolocation geolocation) {
    if (lastGeolocation != null &&
        lastGeolocation!.dateTime.microsecondsSinceEpoch == geolocation.dateTime.microsecondsSinceEpoch) {
      return;
    }

    final updateGeolocation = AppGeolocation(
        dateTime: geolocation.dateTime,
        altitude: geolocation.altitude,
        latitude: geolocation.latitude,
        longitude: geolocation.longitude,
        accuracy: geolocation.accuracy,
        speed: _findSpeed(geolocation));

    lastGeolocation = updateGeolocation;
    _streamController.sink.add(updateGeolocation);
  }

  double? _findSpeed(AppGeolocation geolocation) {
    if (lastGeolocation != null) {
      return GeolocatorWrapper.distanceBetweenGeolocations(lastGeolocation!, geolocation) /
          (geolocation.dateTime.microsecondsSinceEpoch - lastGeolocation!.dateTime.microsecondsSinceEpoch) *
          1e6;
    }

    return null;
  }
}

class SubscriptionGeolocationProvider implements IGeolocationProvider {
  @override
  Stream<AppGeolocation> get geolocationStream => _streamController.stream;
  @override
  bool isDisposed = false;
  @override
  AppGeolocation? lastGeolocation;
  @override
  Duration updateInterval;

  late final StreamController<AppGeolocation> _streamController;
  late final StreamSubscription<Position> _positionStream;

  SubscriptionGeolocationProvider({Duration? updateInterval, required GeolocatorWrapper geolocatorWrapper})
      : updateInterval = updateInterval ?? Duration(seconds: 1) {
    _streamController = StreamController.broadcast(onListen: _listen, onCancel: _cancel);

    _positionStream = geolocatorWrapper.getPositionStream(this.updateInterval).listen((position) {
      final geolocation = AppGeolocation(
          dateTime: position.timestamp,
          altitude: position.altitude,
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          speed: _findSpeed(position));
      lastGeolocation = geolocation;

      _streamController.sink.add(geolocation);
    });

    _positionStream.pause();
  }

  @override
  void dispose() {
    _positionStream.cancel();
    _streamController.close();
    isDisposed = true;
  }

  void _listen() {
    _positionStream.resume();
  }

  void _cancel() {
    _positionStream.pause();
  }

  double? _findSpeed(Position position) {
    return lastGeolocation != null
        ? GeolocatorWrapper.distanceBetweenGeoAndPos(lastGeolocation!, position) /
            (position.timestamp.microsecondsSinceEpoch - lastGeolocation!.dateTime.microsecondsSinceEpoch) *
            1e6
        : null;
  }
}

class TimerWithSubscriptionGeolocationProvider implements IGeolocationProvider {
  @override
  Stream<AppGeolocation> get geolocationStream => _timerGeolocationProvider.geolocationStream;
  @override
  bool isDisposed = false;
  @override
  AppGeolocation? get lastGeolocation => _timerGeolocationProvider.lastGeolocation;
  @override
  Duration updateInterval;

  late final TimerGeolocationProvider _timerGeolocationProvider;
  late final StreamSubscription<Position> _positionSubscription;

  TimerWithSubscriptionGeolocationProvider({required GeolocatorWrapper geolocatorWrapper, Duration? updateInterval})
      : updateInterval = updateInterval ?? Duration(seconds: 1) {
    _timerGeolocationProvider =
        TimerGeolocationProvider(geolocatorWrapper: geolocatorWrapper, updateInterval: this.updateInterval);
    _positionSubscription = geolocatorWrapper.getPositionStream(updateInterval).listen((_) {});
  }

  @override
  void dispose() {
    _timerGeolocationProvider.dispose();
    _positionSubscription.cancel();
    isDisposed = true;
  }
}

class TimerGeolocationProvider implements IGeolocationProvider {
  @override
  late final Stream<AppGeolocation> geolocationStream;
  late final Sink<AppGeolocation> _geolocationSink;
  late final StreamController<AppGeolocation> _geolocationController;
  final GeolocatorWrapper _geolocatorWrapper;
  @override
  final Duration updateInterval;
  Timer? _timer;
  @override
  AppGeolocation? lastGeolocation;

  @override
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  TimerGeolocationProvider(
      {required GeolocatorWrapper geolocatorWrapper, this.updateInterval = const Duration(seconds: 1)})
      : _geolocatorWrapper = geolocatorWrapper {
    _geolocationController = StreamController<AppGeolocation>.broadcast(onListen: _listen, onCancel: _cancel);
    geolocationStream = _geolocationController.stream;
    _geolocationSink = _geolocationController.sink;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _geolocationController.close();
    _isDisposed = true;
  }

  void _listen() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(updateInterval, (timer) async {
      final position = await _geolocatorWrapper.determinePosition();
      if (lastGeolocation != null &&
          lastGeolocation!.dateTime.microsecondsSinceEpoch == position.timestamp.microsecondsSinceEpoch) {
        return;
      }
      if (!timer.isActive) {
        return;
      }
      final appGeolocation = AppGeolocation(
        altitude: position.altitude,
        dateTime: position.timestamp,
        latitude: position.latitude,
        longitude: position.longitude,
        speed: _findSpeed(position),
        accuracy: position.accuracy,
      );
      lastGeolocation = appGeolocation;
      _geolocationSink.add(appGeolocation);
    });
  }

  void _cancel() {
    _timer?.cancel();
  }

  double? _findSpeed(Position position) {
    if (lastGeolocation != null) {
      return GeolocatorWrapper.distanceBetweenGeoAndPos(lastGeolocation!, position) /
          (position.timestamp.microsecondsSinceEpoch - lastGeolocation!.dateTime.microsecondsSinceEpoch) *
          1e6;
    }

    return null;
  }
}
