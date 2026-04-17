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
    double interval,
  ) {
    final processor = InternalCenteredIntervalAverageGeneric(
      interval: interval,
      getX: _getX,
      getY: _getY,
    );

    return processor.mapByCenteredAverage(items);
  }
}

class InternalCenteredIntervalAverageGeneric<T> {
  final double interval;
  final double Function(T) _getX;
  final double Function(T) _getY;

  final QueueAverageGeneric<T> _prevQueue;
  final QueueAverageGeneric<T> _nextQueue;

  InternalCenteredIntervalAverageGeneric({
    required this.interval,
    required double Function(T) getX,
    required double Function(T) getY,
  }) : assert(interval > 0),
       _getX = getX,
       _getY = getY,
       _prevQueue = QueueAverageGeneric(getY: getY),
       _nextQueue = QueueAverageGeneric(getY: getY);

  Stream<(T, double)> mapByCenteredAverageAsync(Stream<T> items) async* {
    await for (var item in items) {
      for (var result in processItem(item)) {
        yield result;
      }
    }

    for (var result in _processQueue()) {
      yield result;
    }
  }

  Iterable<(T, double)> mapByCenteredAverage(Iterable<T> items) sync* {
    for (var item in items) {
      yield* processItem(item);
    }

    yield* _processQueue();
  }

  Iterable<(T, double)> processItem(T item) sync* {
    final itemX = _getX(item);

    while (_nextQueue.isNotEmpty &&
        itemX - _getX(_nextQueue.peekFirst()) > interval) {
      yield _dequeueAndProcessNext();
    }

    _nextQueue.enqueue(item);
  }

  Iterable<(T, double)> _processQueue() sync* {
    while (_nextQueue.isNotEmpty) {
      yield _dequeueAndProcessNext();
    }
  }

  (T, double) _dequeueAndProcessNext() {
    final current = _nextQueue.dequeue();
    final currentX = _getX(current);

    while (_prevQueue.isNotEmpty &&
        currentX - _getX(_prevQueue.peekFirst()) > interval) {
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
