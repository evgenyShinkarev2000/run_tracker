extension IterableExtension<T> on Iterable<T> {
  T? max<TComparable extends Comparable>(TComparable Function(T) selector) {
    if (length == 0) {
      return null;
    }

    var maxElement = first;
    var maxValue = selector(first);

    for (var element in this) {
      var currentValue = selector(element);
      if (currentValue.compareTo(maxValue) > 0) {
        maxElement = element;
        maxValue = currentValue;
      }
    }

    return maxElement;
  }
}

class DSIterable {
  static Iterable segment(int start, int end, [int step = 1]) sync* {
    if (start >= end) {
      return;
    }
    for (var i = start; i <= end; i = i + step) {
      yield i;
    }
  }

  static Iterable ray(int start, int end, [int step = 1]) sync* {
    if (start >= end) {
      return;
    }
    for (var i = start; i < end; i = i + step) {
      yield i;
    }
  }
}
