import 'dart:collection';

import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';

class PulseMinExtremumFinder {
  bool get hasNewExtremum => _lastExtremum != null;
  DataWithDateTime<double>? _lastExtremum;
  final Queue<DataWithDateTime<double>> _points = Queue();
  final Duration timeInterval;
  PulseMinExtremumFinder([this.timeInterval = const Duration(seconds: 5)]);

  void add(DataWithDateTime<double> point) {
    if (point.data >= 0) {
      return;
    }

    final timeLimit = point.dateTime.subtract(timeInterval);
    _points.removeWhere((point) => point.dateTime.isBefore(timeLimit));
    _points.add(point);

    if (_points.length <= 2) {
      return;
    }

    final median = _points.toList().bottomMedian((p) => p.data)!;
    final p3 = _points.elementAt(_points.length - 3);
    final p2 = _points.elementAt(_points.length - 2);
    final p1 = _points.elementAt(_points.length - 1);

    if (p2.data <= median.data && p2.data < p3.data && p2.data < p1.data) {
      _lastExtremum = p2;
    }
  }

  DataWithDateTime<double>? seizeExtremum() {
    final lastExtremum = _lastExtremum!;
    _lastExtremum = null;

    return lastExtremum;
  }
}
