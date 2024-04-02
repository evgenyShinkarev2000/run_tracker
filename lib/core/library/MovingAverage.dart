import 'dart:collection';

class MovingAverage {
  final int maxPointCount;

  double? get average => _average;
  double? _average;

  final Queue<double> _points = Queue();

  MovingAverage(this.maxPointCount) {
    assert(maxPointCount >= 1);
  }

  void clear() {
    _points.clear();
    _average = null;
  }

  void add(double value) {
    if (_points.isEmpty) {
      _average = value;
      _points.add(value);
    } else if (_points.length < maxPointCount) {
      _points.add(value);
      final count = _points.length;
      _average = 0;
      for (var point in _points) {
        _average = average! + point / count;
      }
    } else {
      _average = _average! + (value - _points.removeFirst()) / maxPointCount;
      _points.addLast(value);
    }
  }
}
