class Distribution {
  double get min {
    assert(_values.isNotEmpty);
    return _values[0];
  }

  double get max {
    assert(_values.isNotEmpty);
    return _values[_values.length - 1];
  }

  List<double> _values = [];

  void initialize(List<double> values) {
    _values = List.from(values, growable: false);
    _values.sort();
  }

  double findQuantileValue(double quantile) {
    assert(quantile >= 0 && quantile <= 100);
    assert(_values.isNotEmpty);

    final floatIndex = _values.length * (quantile / 100);
    var floor = floatIndex.floor();
    var ceil = floor.ceil();
    if (ceil > _values.length - 1) {
      ceil = _values.length - 1;
    }
    if (floor > _values.length - 1) {
      floor = _values.length - 1;
    }
    final lineCoef = floatIndex - floor;

    return _values[floor] * lineCoef + _values[ceil] * (1 - lineCoef);
  }
}
