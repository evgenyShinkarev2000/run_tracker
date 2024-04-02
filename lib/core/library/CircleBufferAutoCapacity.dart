import 'package:run_tracker/core/library/CircleBuffer.dart';

class CircleBufferAutoCapacity<T> implements ICircleBuffer<T> {
  @override
  int get capacity => _queueBuffer.capacity;

  @override
  int get length => _queueBuffer.length;

  final CircleBuffer<T> _queueBuffer;

  CircleBufferAutoCapacity([int capacity = 1])
      : assert(capacity >= 1),
        _queueBuffer = CircleBuffer(capacity);

  bool _wasFullLength = false;

  @override
  T? add(T value) {
    final result = _queueBuffer.add(value);

    if (_queueBuffer.length == _queueBuffer.capacity) {
      _wasFullLength = true;
    }

    return result;
  }

  @override
  T? dequeue() {
    final result = _queueBuffer.dequeue();
    if (result == null) {
      if (_wasFullLength) {
        _queueBuffer.setCapacity(_queueBuffer.capacity + 1);
        _wasFullLength = false;
      }
    }

    return result;
  }
}
