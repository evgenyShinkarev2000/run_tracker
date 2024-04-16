import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/core/SortedDateTimeQueue.dart';

class DecileClampFilter {
  final Duration expireDuration;
  final double thresholdCoef;
  final double borderCoef;
  final SortedDateTimeQueue<double> _sortedQueue;

  DecileClampFilter(
      {this.expireDuration = const Duration(seconds: 5), this.thresholdCoef = 0.75, this.borderCoef = 0.05})
      : _sortedQueue = SortedDateTimeQueue(expiredDuration: expireDuration);

  double filter(DataWithDateTime<double> lumyMeasuring) {
    _sortedQueue.add(lumyMeasuring);
    if (_sortedQueue.length == 1) {
      return lumyMeasuring.data;
    }

    final firstDecileValue = _sortedQueue.getBottomFirstDecileElement()!.data;
    final ninthDecileValue = _sortedQueue.getBottomNithDecileElement()!.data;
    final delta = ninthDecileValue - firstDecileValue;
    final bottomThreshold = firstDecileValue - delta * thresholdCoef;
    final topThreshold = ninthDecileValue + delta * thresholdCoef;
    if (lumyMeasuring.data > topThreshold) {
      return ninthDecileValue + delta * borderCoef;
    }
    if (lumyMeasuring.data < bottomThreshold) {
      return firstDecileValue - delta * borderCoef;
    }

    return lumyMeasuring.data;
  }
}
