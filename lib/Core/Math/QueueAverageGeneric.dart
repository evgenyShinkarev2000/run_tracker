import 'dart:collection';

import 'package:run_tracker/Core/Math/export.dart';

class QueueAverageGeneric<T> {
  double get average => _average.average;
  final Average _average = Average();

  Iterable<T> get values => _queue;
  int get count => _queue.length;
  bool get isNotEmpty => _queue.isNotEmpty;
  final Queue<T> _queue = Queue();

  final double Function(T) _getY;

  QueueAverageGeneric({required double Function(T) getY}) : _getY = getY;

  void enqueue(T item) {
    _queue.add(item);
    _average.add(_getY(item));
  }

  T dequeue() {
    final item = _queue.removeFirst();
    _average.substract(_getY(item));

    return item;
  }

  T peekFirst() => _queue.first;

  void reset(){
    _queue.clear();
    _average.reset();
  }
}
