import 'dart:collection';

class CenteredProcessorGeneric<T> {
  final double Function(T item) _getX;
  final double prevInterval;
  final double nextInterval;

  final Queue<double> _prevItemsX = Queue();
  final Queue<T> _nextItems = Queue();

  CenteredProcessorGeneric({
    required double Function(T item) getX,
    required this.prevInterval,
    required this.nextInterval,
  }) : _getX = getX;

  Iterable<(int, T)> add(T item) sync* {
    final itemX = _getX(item);
    while (_nextItems.isNotEmpty &&
        itemX - _getX(_nextItems.first) > nextInterval) {
      yield* _dequeueAndMove();
    }
    _nextItems.add(item);
  }

  Iterable<(int, T)> complete() sync* {
    while (_nextItems.isNotEmpty) {
      yield* _dequeueAndMove();
    }
  }

  /// returns (removed items count, center item)
  Iterable<(int, T)> _dequeueAndMove() sync* {
    final centerItem = _nextItems.removeFirst();
    final centerItemX = _getX(centerItem);
    var removedItemCount = 0;
    while (_prevItemsX.isNotEmpty &&
        centerItemX - _prevItemsX.first > prevInterval) {
      _prevItemsX.removeFirst();
      --removedItemCount;
    }
    _prevItemsX.add(centerItemX);

    yield (removedItemCount, centerItem);
  }
}
