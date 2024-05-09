extension ListDoubleExtension on List<double> {
  double fastAverage() => sum() / length;

  double sum() {
    var sum = 0.0;
    for (var number in this) {
      sum += number;
    }

    return sum;
  }
}

extension ListExtension<T> on List<T> {
  double sum(double Function(T) selector) {
    var sum = 0.0;
    for (var element in this) {
      sum += selector(element);
    }

    return sum;
  }

  double fastAverage(double Function(T) selector) {
    return sum(selector) / length;
  }
}
