import 'dart:collection';

import 'package:run_tracker/Core/export.dart';

class QueueAverage {
  double get average => _average.average;
  int get count => _average.count;
  final Average _average = Average();

  Iterable<double> get values => _queue;
  final Queue<double> _queue = Queue();

  void enqueue(double num) {
    _queue.add(num);
    _average.add(num);
  }

  void dequeue() {
    final num = _queue.removeFirst();
    _average.substract(num);
  }

  void reset() {
    _queue.clear();
    _average.reset();
  }
}
