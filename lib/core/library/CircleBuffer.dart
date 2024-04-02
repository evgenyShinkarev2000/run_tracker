import 'dart:collection';

abstract class ICircleBuffer<T> {
  int get capacity;
  int get length;

  T? add(T value);

  T? dequeue();
}

class CircleBuffer<T> implements ICircleBuffer<T> {
  @override
  int get capacity => _capacity;
  int _capacity;

  @override
  int get length => _queue.length;

  final Queue<T> _queue = Queue();

  CircleBuffer([int capacity = 1]) : _capacity = capacity {
    assert(_capacity >= 1);
  }

  @override
  T? add(T value) {
    if (_queue.length == _capacity) {
      return _queue.removeFirst();
    }
    _queue.add(value);

    return null;
  }

  @override
  T? dequeue() {
    if (_queue.isNotEmpty) {
      return _queue.removeFirst();
    }

    return null;
  }

  void setCapacity(int capacity) {
    assert(capacity >= 1);

    _capacity = capacity;
  }
}
