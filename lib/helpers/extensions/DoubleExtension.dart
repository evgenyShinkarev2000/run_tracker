import 'dart:math';

extension DoubleExtension on double {
  double roundTo(int fractionalCount) {
    assert(fractionalCount >= 0);
    if (fractionalCount == 0) {
      return roundToDouble();
    }

    final powNumber = pow(10, fractionalCount);

    return (this * powNumber).round() / powNumber;
  }
}
