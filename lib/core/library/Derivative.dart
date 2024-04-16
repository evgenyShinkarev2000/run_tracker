import 'dart:math';

class Derivative {
  Point<double>? previousFunctionPoint;

  Point<double>? find(Point<double> point) {
    if (previousFunctionPoint == null) {
      previousFunctionPoint = point;

      return null;
    }

    final result = Point(point.x, (point.y - previousFunctionPoint!.y) / (point.x - previousFunctionPoint!.x));
    previousFunctionPoint = point;

    return result;
  }
}
