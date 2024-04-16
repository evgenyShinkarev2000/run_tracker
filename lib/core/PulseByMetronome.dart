import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/core/SortedDateTimeQueue.dart';
import 'package:run_tracker/core/library/MovingAverage.dart';

class PulseByMetronome {
  final SortedDateTimeQueue<int> _sortedQueue = SortedDateTimeQueue();
  final Duration _resetDuration = Duration(seconds: 2);
  final MovingAverage _movingAverage;
  final int minPulse;
  final int maxPulse;

  /// 1 / medianFilterTresholdCoef = how many times should current value differ from median value to trigger filter
  final double medianFilterTresholdCoef;

  DateTime? _lastClick;

  PulseByMetronome({int averageCount = 4, this.minPulse = 40, this.maxPulse = 300, this.medianFilterTresholdCoef = 0.8})
      : _movingAverage = MovingAverage(averageCount);

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
    if (currentBPM > maxPulse || currentBPM < minPulse) {
      return null;
    }

    if (isMedianBpmStable()) {
      final medianBpm = _sortedQueue.getBottomMedianElement()!.data;

      if (((currentBPM - medianBpm) / medianBpm).abs() > medianFilterTresholdCoef) {
        _sortedQueue.add(DataWithDateTime(timeClick, currentBPM.round()));

        return null;
      }
    }

    _movingAverage.add(currentBPM);
    _lastClick = timeClick;
    final averageBPM = _movingAverage.average!.round();
    _sortedQueue.add(DataWithDateTime(timeClick, averageBPM));

    return averageBPM;
  }

  bool isMedianBpmStable() => _sortedQueue.length > 3;
}
