import 'package:run_tracker/helpers/extensions/DurationExtension.dart';

abstract interface class IntervalProcessor {
  double get distanceRemainder => _distanceRemainder!;
  double? _distanceRemainder;

  Duration get durationRemainder => _durationRemainder!;
  Duration? _durationRemainder;

  bool get wasNewInterval => _wasNewInterval;
  bool _wasNewInterval = false;

  void add(double distance, Duration duration);
}

class IntervalByTime extends IntervalProcessor {
  final Duration timeLimit;
  Duration _accumulatedDuration = Duration.zero;

  IntervalByTime({required this.timeLimit});

  @override
  void add(double distance, Duration duration) {
    assert(duration < timeLimit);

    final newTotalDuration = _accumulatedDuration + duration;
    if (newTotalDuration >= timeLimit) {
      _wasNewInterval = true;
      final overflowDuration = newTotalDuration - timeLimit;
      _accumulatedDuration = overflowDuration;
      _durationRemainder = overflowDuration;
      _distanceRemainder = overflowDuration.inSecondsDouble / duration.inSecondsDouble * distance;
    } else {
      _wasNewInterval = false;
      _accumulatedDuration += duration;
    }
  }
}

class IntervalByDistance extends IntervalProcessor {
  final double distanceLimit;
  double _accumulatedDistance = 0;

  IntervalByDistance({required this.distanceLimit});

  @override
  void add(double distance, Duration duration) {
    assert(distance < distanceLimit);

    _wasNewInterval = true;
    final newTotalDistance = _accumulatedDistance + distance;
    if (newTotalDistance >= distanceLimit) {
      final overflowDistance = newTotalDistance - distanceLimit;
      _accumulatedDistance = overflowDistance;
      _durationRemainder = Duration(microseconds: (overflowDistance / distance * duration.inMicroseconds).round());
      _distanceRemainder = overflowDistance;
    } else {
      _wasNewInterval = false;
      _accumulatedDistance += distance;
    }
  }
}
