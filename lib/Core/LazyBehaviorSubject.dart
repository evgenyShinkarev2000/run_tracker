import 'dart:async';

import 'package:run_tracker/Core/IDisposable.dart';
import 'package:rxdart/rxdart.dart';

class LazyBehaviorSubject<T> implements IDisposable {
  Stream<T> get stream => _behaviorSubject.stream;

  late final BehaviorSubject<T> _behaviorSubject = BehaviorSubject(
    onListen: _listen,
  );
  late final Future<T> Function() _getInitialValue;
  bool _isLoading = false;

  LazyBehaviorSubject(Future<T> Function() getInitialValue) {
    _getInitialValue = getInitialValue;
  }

  @override
  void dispose() {
    _behaviorSubject.close();
  }

  void add(T value) {
    _behaviorSubject.add(value);
  }

  void _listen() async {
    if (_behaviorSubject.hasValue || _isLoading) {
      return;
    }

    _isLoading = true;
    T? value;

    try {
      value = await _getInitialValue();
    } finally {
      _isLoading = false;
    }

    if (_behaviorSubject.hasValue) {
      return;
    }
    _behaviorSubject.add(value!);
  }
}
