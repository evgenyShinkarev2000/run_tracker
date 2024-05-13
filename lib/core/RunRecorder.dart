import 'dart:async';

import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/helpers/IDisposable.dart';
import 'package:run_tracker/helpers/extensions/DisposedException.dart';

import 'AppGeolocation.dart';

abstract class IRunRecorder implements IDisposable {
  Stream<RunRecorderPhase> get phaseStream;
  RunRecorderPhase get phase;
  Duration get duration;
  double get distance;
  List<RunPoint> get runPoints;
  void start();
  void pause();
  void resume();
  void stop();
  void restart();
}

abstract class RunRecorderBase implements IRunRecorder {
  final IGeolocationProvider _geolocationProvider;
  late final StreamSubscription<AppGeolocation> _geoSubscr;

  @override
  RunRecorderPhase get phase;

  @override
  List<RunPoint> runPoints;

  /// m
  @override
  double get distance => _distance;

  /// m
  double _distance = 0;
  AppGeolocation? lastKnownGeolocation;

  RunRecorderBase({required IGeolocationProvider geolocationProvider, required this.runPoints})
      : _geolocationProvider = geolocationProvider {
    _geoSubscr = _geolocationProvider.geolocationStream.listen((appGeolocation) {
      if (lastKnownGeolocation != null && phase == RunRecorderPhase.writing) {
        _distance += GeolocatorWrapper.distanceBetweenGeolocations(lastKnownGeolocation!, appGeolocation);
      }
      lastKnownGeolocation = appGeolocation;
      if (phase != RunRecorderPhase.writing) {
        return;
      }
      final record = RunPointGeolocation(geolocation: appGeolocation);
      runPoints.add(record);
    });
  }

  @override
  void start() {
    runPoints.add(RunPointStart(dateTime: DateTime.now().toUtc(), geolocation: _geolocationProvider.lastGeolocation));
  }

  @override
  void pause() {}

  @override
  void resume() {}

  @override
  void stop() {
    runPoints.add(RunPointStop(
      dateTime: DateTime.now().toUtc(),
      distance: distance,
    ));
  }
}

class RunRecorder extends RunRecorderBase implements IDisposable {
  final StreamController<RunRecorderPhase> _streamController = StreamController.broadcast();
  @override
  Stream<RunRecorderPhase> get phaseStream => _streamController.stream;

  @override
  Duration get duration => Duration(microseconds: _stopwatch.elapsedMicroseconds);

  @override
  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  @override
  RunRecorderPhase get phase => _phase;
  RunRecorderPhase _phase = RunRecorderPhase.ready;

  final Stopwatch _stopwatch = Stopwatch();

  RunRecorder({required super.geolocationProvider}) : super(runPoints: []);

  @override
  void dispose() {
    _streamController.close();
    _geoSubscr.cancel();

    _isDisposed = true;
  }

  Duration getRunningTime() {
    return Duration(microseconds: _stopwatch.elapsedMicroseconds);
  }

  @override
  void start() {
    if (_isDisposed) {
      throw DisposedException();
    }
    assert(_phase == RunRecorderPhase.ready);

    _stopwatch.start();
    super.start();

    _phase = RunRecorderPhase.writing;
    _streamController.sink.add(_phase);
  }

  @override
  void pause() {
    if (_isDisposed) {
      throw DisposedException();
    }
    assert(_phase == RunRecorderPhase.writing);

    _stopwatch.stop();
    super.pause();

    _phase = RunRecorderPhase.paused;
    _streamController.sink.add(_phase);
  }

  @override
  void resume() {
    if (_isDisposed) {
      throw DisposedException();
    }
    assert(_phase == RunRecorderPhase.paused);

    _stopwatch.start();
    super.resume();

    _phase = RunRecorderPhase.writing;
    _streamController.sink.add(_phase);
  }

  @override
  void stop() {
    if (_isDisposed) {
      throw DisposedException();
    }
    assert(_phase == RunRecorderPhase.writing || _phase == RunRecorderPhase.paused);

    super.stop();

    _phase = RunRecorderPhase.stopped;
    _streamController.sink.add(_phase);
  }

  @override
  void restart() {
    if (_isDisposed) {
      throw DisposedException();
    }

    _distance = 0;
    _stopwatch.reset();
    runPoints = [];
  }
}

enum RunRecorderPhase {
  ready,
  writing,
  paused,
  stopped,
}
