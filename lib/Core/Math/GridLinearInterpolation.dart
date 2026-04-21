import 'package:run_tracker/Core/export.dart';

class GridLinearInterpolation {
  final double interval;

  double _prevX = 0;
  double _prevY = 0;
  double _firstGridX = 0;
  int _step = 0;

  GridLinearInterpolation(this.interval);

  Iterable<(double, double)> interpolate(double x, double y) sync* {
    if (_step == 0) {
      _prevX = x;
      _prevY = y;
      _firstGridX = x;
      ++_step;

      yield (x, y);
      return;
    }
    final dX = x - _prevX;
    if (dX == 0) {
      return;
    }
    if (dX < 0) {
      throw AppException(
        message:
            "GridLinearInterpolation.interpolate: x < _prevX, decreasing x not supported",
      );
    }

    var currentGridX = _firstGridX + _step * interval;

    while (currentGridX <= x) {
      final t = (currentGridX - _prevX) / dX;
      final interpolatedY = _prevY + t * (y - _prevY);
      yield (currentGridX, interpolatedY);
      ++_step;
      currentGridX += interval;
    }

    _prevX = x;
    _prevY = y;
  }
}

class GridLinearInterpolationReversed {
  final double interval;

  double _nextX = 0;
  double _nextY = 0;
  double _lastGridX = 0;
  int _step = 0;

  GridLinearInterpolationReversed(this.interval);

  Iterable<(double, double)> interpolate(double x, double y) sync* {
    if (_step == 0) {
      _nextX = x;
      _nextY = y;
      _lastGridX = x;
      ++_step;

      yield (x, y);
      return;
    }
    final dX = _nextX - x;
    if (dX == 0) {
      return;
    }
    if (dX < 0) {
      throw AppException(
        message:
            "GridLinearInterpolationReversed.interpolate: _nextX < x, increasing x not supported",
      );
    }

    var currentGridX = _lastGridX - _step * interval;

    while (currentGridX >= x) {
      final t = (_nextX - currentGridX) / dX;
      final interpolatedY = _nextY + t * (y - _nextY);
      yield (currentGridX, interpolatedY);
      ++_step;
      currentGridX -= interval;
    }

    _nextX = x;
    _nextY = y;
  }
}
