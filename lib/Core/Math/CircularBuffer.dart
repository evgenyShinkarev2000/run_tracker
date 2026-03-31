class CircularBuffer<T> {
  final int maxLength;
  int get count => _count;

  final List<T?> _list = [];
  final int _maxIndex;
  int _count = 0;
  int _startIndex = 0;

  CircularBuffer(this.maxLength) : _maxIndex = maxLength - 1;

  void enqueue(T element) {
    if (maxLength == 0) return;

    if (_count < maxLength) {
      _list.add(element);
      ++_count;
    } else {
      _list[_startIndex] = element;
      ++_startIndex;
      if (_startIndex == maxLength) {
        _startIndex = 0;
      }
    }
  }

  T dequeue() {
    if (_count == 0) {
      throw StateError("queue musn't be empty to dequeue element");
    }

    var element = _list[_startIndex] as T;
    _list[_startIndex] = null;
    --_count;
    ++_startIndex;
    if (_startIndex == maxLength) {
      _startIndex = 0;
    }

    return element;
  }

  List<T> toList() {
    return List<T>.generate(_count, (i) {
      var index = _startIndex + i;
      if (index > _maxIndex) {
        index = index - maxLength;
      }

      return _list[index] as T;
    });
  }
}
