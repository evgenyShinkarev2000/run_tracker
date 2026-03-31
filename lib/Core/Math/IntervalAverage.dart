import 'dart:collection';

import 'package:run_tracker/Core/Math/export.dart';

class IntervalAverageGeneric<T> {
  final double intervalSize;
  final double Function(T) _getX;
  final double Function(T) _getY;

  final Queue<double> _oXPoints = Queue();

  double get average => _averageQueue.average;
  final QueueAverage _averageQueue = QueueAverage();

  IntervalAverageGeneric({
    required double Function(T) getX,
    required double Function(T) getY,
    required this.intervalSize,
  }) : _getX = getX,
       _getY = getY;

  double add(T item) {
    final point = _getX(item);
    final value = _getY(item);
    while (_oXPoints.isNotEmpty && _oXPoints.first < point - intervalSize) {
      _oXPoints.removeFirst();
      _averageQueue.dequeue();
    }
    _oXPoints.add(point);
    _averageQueue.enqueue(value);

    return _averageQueue.average;
  }
}
