import 'package:run_tracker/Core/Math/QueueAverageGeneric.dart';

class IntervalAverageGeneric<T> {
  final double intervalSize;
  final double Function(T) _getX;

  double get average => _averageQueue.average;
  final QueueAverageGeneric<T> _averageQueue;

  IntervalAverageGeneric({
    required double Function(T) getX,
    required double Function(T) getY,
    required this.intervalSize,
  }) : assert(intervalSize > 0),
       _getX = getX,
       _averageQueue = QueueAverageGeneric(getY: getY);

  double add(T item) {
    final point = _getX(item);
    while (_averageQueue.isNotEmpty &&
        _getX(_averageQueue.peekFirst()) < point - intervalSize) {
      _averageQueue.dequeue();
    }
    _averageQueue.enqueue(item);

    return _averageQueue.average;
  }
}
