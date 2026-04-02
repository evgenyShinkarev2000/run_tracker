import 'package:run_tracker/Core/Math/export.dart';

class CenteredIntervalAverageGeneric<T> {
  final double Function(T) _getX;
  final double Function(T) _getY;

  CenteredIntervalAverageGeneric({
    required double Function(T) getX,
    required double Function(T) getY,
  }) : _getX = getX,
       _getY = getY;

  Iterable<(T, double)> mapByCenteredAverage(
    Iterable<T> items,
    double intervalSize,
  ) {
    final processor = InternalCenteredIntervalAverageGeneric(
      intervalSize: intervalSize,
      getX: _getX,
      getY: _getY,
    );

    return processor.mapByCenteredAverage(items);
  }
}

class InternalCenteredIntervalAverageGeneric<T> {
  final double intervalSize;
  final double Function(T) _getX;
  final double Function(T) _getY;

  final QueueAverageGeneric<T> _prevQueue;
  final QueueAverageGeneric<T> _nextQueue;

  InternalCenteredIntervalAverageGeneric({
    required this.intervalSize,
    required double Function(T) getX,
    required double Function(T) getY,
  }) : assert(intervalSize > 0),
       _getX = getX,
       _getY = getY,
       _prevQueue = QueueAverageGeneric(getY: getY),
       _nextQueue = QueueAverageGeneric(getY: getY);

  Iterable<(T, double)> mapByCenteredAverage(Iterable<T> items) sync* {
    for (var item in items) {
      final itemX = _getX(item);

      while (_nextQueue.isNotEmpty &&
          itemX - _getX(_nextQueue.peekFirst()) > intervalSize) {
        yield _dequeueAndProcessNext();
      }

      _nextQueue.enqueue(item);
    }

    while (_nextQueue.isNotEmpty) {
      yield _dequeueAndProcessNext();
    }
  }

  (T, double) _dequeueAndProcessNext() {
    final current = _nextQueue.dequeue();
    final currentX = _getX(current);

    while (_prevQueue.isNotEmpty &&
        currentX - _getX(_prevQueue.peekFirst()) > intervalSize) {
      _prevQueue.dequeue();
    }

    final totalCount = _prevQueue.count + _nextQueue.count + 1;
    final average =
        _prevQueue.count / totalCount * _prevQueue.average +
        _getY(current) / totalCount +
        _nextQueue.count / totalCount * _nextQueue.average;
    _prevQueue.enqueue(current);

    return (current, average);
  }
}
