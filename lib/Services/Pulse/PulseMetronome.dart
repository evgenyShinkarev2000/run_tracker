import 'dart:async';

import 'package:run_tracker/Core/export.dart';

class PulseMetronomeFactory {
  PulseMetronome build() => PulseMetronome();
}

class PulseMetronome implements IDisposable {
  Stream<double> get pulseBPMStream => _pulseController.stream;

  final StreamController<double> _pulseController =
      StreamController.broadcast();
  final Duration _minPulsePeriod = Duration(seconds: 2);
  final Duration _maxPulsePeriod = Duration(milliseconds: 250);
  final IntervalAverageGeneric<(double, double)> _average =
      IntervalAverageGeneric(
        getX: (v) => v.$1,
        getY: (v) => v.$2,
        intervalSize: 2,
      );

  DateTime? prevTimestamp;
  DateTime? firstTimestamp;

  @override
  void dispose() {
    _pulseController.close();
  }

  void tap(DateTime timestamp) {
    if (prevTimestamp == null) {
      prevTimestamp = timestamp;
      firstTimestamp = timestamp;
      return;
    }
    final difference = timestamp.difference(prevTimestamp!);
    if (difference < _maxPulsePeriod) {
      return;
    }
    if (difference > _minPulsePeriod) {
      prevTimestamp = timestamp;
      firstTimestamp = timestamp;
      return;
    }

    _average.add((
      timestamp.difference(firstTimestamp!).inSecondsDouble,
      60 / difference.inSecondsDouble,
    ));
    _pulseController.add(_average.average);

    prevTimestamp = timestamp;
  }

  void reset() {
    prevTimestamp = null;
    firstTimestamp = null;
    _average.reset();
  }
}
