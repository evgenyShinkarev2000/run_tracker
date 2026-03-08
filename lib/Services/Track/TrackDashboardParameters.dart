import 'dart:async';

import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Services/Track/TrackManager.dart';
import 'package:run_tracker/Services/Track/TrackState.dart';
import 'package:rxdart/rxdart.dart';

class TrackDashboardParameters implements IDisposable {
  Stream<Duration> get duration => _durationSubject.stream;
  final BehaviorSubject<Duration> _durationSubject;
  Stream<Speed> get speed => _speeedSubject.stream;
  final BehaviorSubject<Speed> _speeedSubject = BehaviorSubject<Speed>();
  Stream<Distance> get distance => _distanceSubject.stream;
  final BehaviorSubject<Distance> _distanceSubject;

  DateTime? _lastTick;
  Timer? _timer;
  AppPosition? _lastPosition;

  final TrackStateProvider _trackStateProvider;
  late final StreamSubscription<TrackState> _stateSubscription;
  late final StreamSubscription<AppPosition>? _positionSubscription;

  TrackDashboardParameters(
    TrackStateProvider trackStateProvider, {
    PositionDataProvider? positionProvider,
    Duration initialDuration = Duration.zero,
    Distance initialDistance = Distance.zero,
  }) : _trackStateProvider = trackStateProvider,
       _durationSubject = BehaviorSubject.seeded(initialDuration),
       _distanceSubject = BehaviorSubject.seeded(initialDistance) {
    _stateSubscription = trackStateProvider.stateStream.listen(_listenState);
    _positionSubscription = positionProvider?.stream.listen(_listenPosition);
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    _positionSubscription?.cancel();
    _durationSubject.close();
    _timer?.cancel();
  }

  void _listenPosition(AppPosition position) {
    if (_trackStateProvider.state == TrackState.Running &&
        _lastPosition != null) {
      final distanceDelta = _lastPosition!.tryFindDistanceTo(position);
      if (distanceDelta != null) {
        _distanceSubject.add(_distanceSubject.value.addMeters(distanceDelta));
      }
    }
    if (position.speed != null) {
      _speeedSubject.add(Speed(position.speed!.value));
    }

    _lastPosition = position;
  }

  void _listenState(TrackState state) {
    switch (state) {
      case TrackState.Running:
        _resume();
        break;
      case TrackState.Loading ||
          TrackState.Ready ||
          TrackState.Paused ||
          TrackState.Aborted ||
          TrackState.Completed:
        _pause();
        break;
    }
  }

  void _pause() {
    _timer?.cancel();
  }

  void _resume() {
    _lastTick = DateTime.timestamp();
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), _handleTimerTick);
  }

  void _handleTimerTick(Timer timer) {
    final timeStamp = DateTime.timestamp();

    if (_lastTick != null) {
      _durationSubject.add(
        _durationSubject.value + timeStamp.difference(_lastTick!),
      );
    }

    _lastTick = timeStamp;
  }
}
