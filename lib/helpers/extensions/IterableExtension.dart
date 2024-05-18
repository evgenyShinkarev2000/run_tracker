extension IterableExtension<T> on Iterable<T> {
  T? max<TComparable extends Comparable>(TComparable Function(T) selector) {
    if (length == 0) {
      return null;
    }

    var maxElement = first;
    var maxValue = selector(first);

    for (var element in skip(1)) {
      var currentValue = selector(element);
      if (currentValue.compareTo(maxValue) > 0) {
        maxElement = element;
        maxValue = currentValue;
      }
    }

    return maxElement;
  }

  T? min<TComparable extends Comparable>(TComparable Function(T) selector) {
    if (length == 0) {
      return null;
    }

    var minElement = first;
    var minValue = selector(first);

    for (var element in skip(1)) {
      var currentValue = selector(element);
      if (currentValue.compareTo(minValue) < 0) {
        minElement = element;
        minValue = currentValue;
      }
    }

    return minElement;
  }

  (T, T)? minMax<TComparable extends Comparable>(TComparable Function(T) selector) {
    if (length == 0) {
      return null;
    }
    var minElement = first;
    var minValue = selector(first);
    var maxElement = minElement;
    var maxValue = minValue;

    for (var element in skip(1)) {
      var currentValue = selector(element);
      if (currentValue.compareTo(minValue) < 0) {
        minElement = element;
        minValue = currentValue;
      } else if (currentValue.compareTo(maxValue) > 0) {
        maxElement = element;
        maxValue = currentValue;
      }
    }

    return (minElement, maxElement);
  }

//TODO O(n) time https://habr.com/en/articles/346930/
  T? bottomMedian<TComparable extends Comparable>(TComparable Function(T) selector) {
    if (isEmpty) {
      return null;
    }

    final sorted = List.from(this, growable: false);
    sorted.sort((a, b) => selector(a).compareTo(selector(b)));

    return sorted[(sorted.length / 2).floor()];
  }

  Iterable<T> padRightOrCutToLength(int length, T padValue) sync* {
    final iteratorInstance = this.iterator;
    for (var _ in Iterable.generate(length, (index) => index)) {
      if (iteratorInstance.moveNext()) {
        yield iteratorInstance.current;
      } else {
        yield padValue;
      }
    }
  }
}

extension IterableEnumExtension<T extends Enum> on Iterable<T> {
  T? byName(String nameWithPrefix) {
    for (var enumName in this) {
      if (nameWithPrefix.endsWith(enumName.name)) {
        return enumName;
      }
    }

    return null;
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
