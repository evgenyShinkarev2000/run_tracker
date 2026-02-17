import 'dart:async';

import 'package:run_tracker/Core/IDisposable.dart';

class LazyBehaviorSubject<T> implements IDisposable {
  Stream<T> get stream => _streamController.stream;

  late final StreamController<T> _streamController = StreamController.broadcast(
    onListen: _listen,
  );
  late final Future<T> Function() _getInitialValue;

  T? _lastValue;
  LazyBehaviorSubjectState _state = LazyBehaviorSubjectState.NotInitialized;

  LazyBehaviorSubject(Future<T> Function() getInitialValue) {
    _getInitialValue = getInitialValue;
  }

  @override
  void Dispose() {
    _streamController.close();
  }

  void Add(T value) {
    if (_state == LazyBehaviorSubjectState.Initializing) {
      throw Exception("Musn't add value during initialization");
    }

    if (_state != LazyBehaviorSubjectState.Initialized) {
      _state = LazyBehaviorSubjectState.Initialized;
    }
    _lastValue = value;
    _streamController.add(value);
  }

  void _listen() async {
    switch (_state) {
      case LazyBehaviorSubjectState.NotInitialized:
        _state = LazyBehaviorSubjectState.Initializing;
        try {
          _lastValue = await _getInitialValue();
        } catch (ex) {
          _state = LazyBehaviorSubjectState.NotInitialized;
          rethrow;
        }
        _state = LazyBehaviorSubjectState.Initialized;
        _streamController.add(_lastValue as T);
        break;
      case LazyBehaviorSubjectState.Initialized:
        _streamController.add(_lastValue as T);
        break;
      case LazyBehaviorSubjectState.Initializing:
        return;
    }
  }
}

enum LazyBehaviorSubjectState { NotInitialized, Initializing, Initialized }
