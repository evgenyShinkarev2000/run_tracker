import 'dart:collection';

class SortedQueue<T> {
  final Queue<T> _queue = Queue();

  int get length => _queue.length;

  Comparable Function(T) toComparable;
  bool Function(T) checkIsExpired;

  List<T>? _sortedList;

  SortedQueue({required this.toComparable, required this.checkIsExpired});

  void add(T value) {
    while (_queue.isNotEmpty) {
      if (checkIsExpired(_queue.first)) {
        _queue.removeFirst();
      } else {
        break;
      }
    }

    _queue.add(value);
    _sortedList = null;
  }

  List<T> getSortedList() {
    if (_sortedList == null) {
      _sortedList = _queue.toList();
      _sortedList!.sort((a, b) => toComparable(a).compareTo(toComparable(b)));
    }

    return _sortedList!;
  }

  int findBottomIndexOfPart(double part) {
    assert(part > 0 && part < 1);
    assert(_queue.isNotEmpty);

    final sortedList = getSortedList();
    final bottomIndex = (sortedList.length * part).floor();

    return bottomIndex;
  }
}
