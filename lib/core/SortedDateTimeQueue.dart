import 'package:run_tracker/core/DataWithDateTime.dart';
import 'package:run_tracker/core/library/SortedQueue.dart';

class SortedDateTimeQueue<T extends Comparable> {
  final Duration expiredDuration;
  final SortedQueue<DataWithDateTime<T>> _sortedQueue = SortedQueue(
    toComparable: (e) => e.data,
    checkIsExpired: (first) => false,
  );

  int get length => _sortedQueue.length;
  bool get isEmpty => length == 0;

  SortedDateTimeQueue({this.expiredDuration = const Duration(seconds: 5)});

  void add(DataWithDateTime<T> value) {
    final expiredDateTime = value.dateTime.subtract(expiredDuration);
    _sortedQueue.checkIsExpired = (first) => first.dateTime.isBefore(expiredDateTime);

    _sortedQueue.add(value);
  }

  DataWithDateTime<T>? getBottomMedianElement() => getBottomPartElement(0.5);

  DataWithDateTime<T>? getBottomNithDecileElement() => getBottomPartElement(0.9);

  DataWithDateTime<T>? getBottomFirstDecileElement() => getBottomPartElement(0.1);

  DataWithDateTime<T>? getBottomPartElement(double part) {
    assert(part > 0 && part < 1);
    if (_sortedQueue.length == 0) {
      return null;
    }

    final sortedList = _sortedQueue.getSortedList();

    return sortedList[_sortedQueue.findBottomIndexOfPart(part)];
  }
}
