import 'dart:collection';

import 'package:run_tracker/Core/Math/Distribution.dart';

class DistributionQueueGeneric<T> {
  final double Function(T item) _getY;
  final Queue<T> _queue = Queue();

  Distribution get distribution {
    _ensureInitialized();
    return _distribution;
  }

  final Distribution _distribution = Distribution();
  bool _isInitialized = false;

  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;
  T get peekFirst => _queue.first;
  Iterator<T> get iterator => _queue.iterator;

  double get minValue {
    assert(_queue.isNotEmpty);
    _ensureInitialized();

    return _distribution.min;
  }

  double get maxValue {
    assert(_queue.isNotEmpty);
    _ensureInitialized();

    return _distribution.max;
  }

  DistributionQueueGeneric({required double Function(T item) getY})
    : _getY = getY;

  void enqueue(T value) {
    _queue.add(value);
    _isInitialized = false;
  }

  T dequeue() {
    _isInitialized = false;
    return _queue.removeFirst();
  }

  double findQuantileValue(double quantile) {
    _ensureInitialized();

    return _distribution.findQuantileValue(quantile);
  }

  void _ensureInitialized() {
    //TODO наверное, есть более подходящая структура данных
    if (!_isInitialized) {
      _distribution.initialize(_queue.map(_getY).toList());
      _isInitialized = true;
    }
  }
}
