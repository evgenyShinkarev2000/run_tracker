class Average {
  double get average => _average;
  double _average = 0;

  int get count => _count;
  int _count = 0;

  double add(double num) {
    _average += (num - _average) / ++_count;

    return _average;
  }

  double substract(double num) {
    --_count;
    if (count == 0) {
      _average = 0;
    } else {
      _average += (_average - num) / _count;
    }

    return _average;
  }

  void reset() {
    _count = 0;
    _average = 0;
  }
}
