extension IterableExtension<T> on Iterable<T> {
  N? selectMaxNum<N extends num>(N Function(T item) selector) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    var max = selector(iterator.current);
    while (iterator.moveNext()) {
      final currentValue = selector(iterator.current);
      if (currentValue > max) {
        max = currentValue;
      }
    }

    return max;
  }

  T? selectMaxItem<N extends num>(N Function(T item) selector) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var maxItem = iterator.current;
    var maxNum = selector(iterator.current);
    while (iterator.moveNext()) {
      final currentNum = selector(iterator.current);
      if (currentNum > maxNum) {
        maxNum = currentNum;
        maxItem = iterator.current;
      }
    }

    return maxItem;
  }

  (N, N)? selectMinMaxNum<N extends num>(N Function(T item) selector) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }
    var max = selector(iterator.current);
    var min = selector(iterator.current);
    while (iterator.moveNext()) {
      final currentValue = selector(iterator.current);
      if (currentValue > max) {
        max = currentValue;
      } else if (currentValue < min) {
        min = currentValue;
      }
    }

    return (min, max);
  }
}
