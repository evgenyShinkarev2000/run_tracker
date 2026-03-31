// https://github.com/sveinn-steinarsson/flot-downsample/

class LargeTriangleDownSamplingGeneric<T> {
  final double Function(T) _getX;
  final double Function(T) _getY;

  LargeTriangleDownSamplingGeneric({
    required double Function(T) getX,
    required double Function(T) getY,
  }) : _getX = getX,
       _getY = getY;

  Iterable<T> downSample(List<T> items, int threshold) sync* {
    assert(threshold > 2);
    if (items.length < threshold) {
      yield* items;
      return;
    }

    yield items.first;

    var aX = _getX(items.first);
    var aY = _getY(items.first);
    var every = (items.length - 2) / (threshold - 2);

    for (var i in Iterable<int>.generate(threshold - 2)) {
      final (cX, cY) = _findCPoint(i, every, items);
      final maxAreaItem = _findMaxAreaItem(aX, aY, cX, cY, every, i, items);

      aX = _getX(maxAreaItem!);
      aY = _getY(maxAreaItem);

      yield maxAreaItem;
    }

    yield items.last;
  }

  T _findMaxAreaItem(
    double aX,
    double aY,
    double cX,
    double cY,
    double every,
    int i,
    List<T> items,
  ) {
    final currentBucketStartIndex = (every * i).floor() + 1;
    final currentBucketEndIndex = (every * (i + 1)).floor() + 1;
    var maxArea = -1.0;
    T? maxAreaItem;
    for (final item
        in items
            .skip(currentBucketStartIndex)
            .take(currentBucketEndIndex - currentBucketStartIndex)) {
      final bX = _getX(item);
      final bY = _getY(item);
      var area =
          ((bX - aX) * (cY - aY) - (cX - aX) * (bY - aY)).abs() /
          2; //https://en.wikipedia.org/wiki/Shoelace_formula
      if (area > maxArea) {
        maxArea = area;
        maxAreaItem = item;
      }
    }

    return maxAreaItem!;
  }

  (double, double) _findCPoint(int index, double every, List<T> items) {
    final nextBucketStartIndex = (every * (index + 1)).floor() + 1;
    var nextBucketEndIndex = (every * (index + 2)).floor() + 1;
    if (nextBucketEndIndex > items.length) {
      nextBucketEndIndex = items.length;
    }

    var length = nextBucketEndIndex - nextBucketStartIndex;
    var sumX = 0.0;
    var sumY = 0.0;
    for (var item in items.skip(nextBucketStartIndex).take(length)) {
      sumX += _getX(item);
      sumY += _getY(item);
    }

    return (sumX / length, sumY / length);
  }
}
