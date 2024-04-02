import 'package:run_tracker/core/library/MovingAverage.dart';

class PulseByMetronome {
  static const Duration _resetDuration = Duration(seconds: 2);

  final MovingAverage _movingAverage = MovingAverage(4);

  DateTime? _lastClick;

  /// beats per minute
  int? findPulse(DateTime timeClick) {
    if (_lastClick == null) {
      _lastClick = timeClick;

      return null;
    }

    final clickTimeDelta = timeClick.microsecondsSinceEpoch - _lastClick!.microsecondsSinceEpoch;
    if (clickTimeDelta >= _resetDuration.inMicroseconds) {
      _lastClick = timeClick;
      _movingAverage.clear();

      return null;
    }

    final currentBPM = 1 / (clickTimeDelta / 1e6) * 60;
    _movingAverage.add(currentBPM);
    _lastClick = timeClick;

    return _movingAverage.average?.round();
  }
}
