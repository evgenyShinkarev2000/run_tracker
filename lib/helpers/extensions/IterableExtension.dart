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

  T? min<TComparable extends Comparable>(TComparable Function(T) selector) {
    if (length == 0) {
      return null;
    }

    var minElement = first;
    var maxValue = selector(first);

    for (var element in this) {
      var currentValue = selector(element);
      if (currentValue.compareTo(maxValue) < 0) {
        minElement = element;
        maxValue = currentValue;
      }
    }

    return minElement;
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
