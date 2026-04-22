import 'dart:async';

import 'package:run_tracker/Core/export.dart';
import 'package:rxdart/rxdart.dart';

class LazyBehaviorSubject<T> implements IDisposable {
  Stream<T> get stream => behaviorSubject.stream;

  late final BehaviorSubject<T> behaviorSubject = BehaviorSubject(
    onListen: _listen,
  );
  late final Future<T> Function() _getInitialValue;
  bool _isLoading = false;

  LazyBehaviorSubject(Future<T> Function() getInitialValue) {
    _getInitialValue = getInitialValue;
  }

  @override
  void dispose() {
    behaviorSubject.close();
  }

  void add(T value) {
    behaviorSubject.add(value);
  }

  void _listen() async {
    if (behaviorSubject.hasValue || _isLoading) {
      return;
    }

    _isLoading = true;
    T? value;

    try {
      value = await _getInitialValue();
    } finally {
      _isLoading = false;
    }

    if (behaviorSubject.hasValue) {
      return;
    }
    behaviorSubject.add(value as T);
  }
}

class OptionalLazyBehaviorSubject<T> implements IDisposable {
  Stream<T> get stream => behaviorSubject.stream;

  late final BehaviorSubject<T> behaviorSubject = BehaviorSubject(
    onListen: _listen,
  );
  late final Future<OptionalValue<T>> Function() _getInitialValue;
  bool _isLoading = false;
  bool _isSkipped = false;

  OptionalLazyBehaviorSubject(
    Future<OptionalValue<T>> Function() getInitialValue,
  ) {
    _getInitialValue = getInitialValue;
  }

  @override
  void dispose() {
    behaviorSubject.close();
  }

  void add(T value) {
    behaviorSubject.add(value);
  }

  void _listen() async {
    if (behaviorSubject.hasValue || _isLoading || _isSkipped) {
      return;
    }

    _isLoading = true;
    OptionalValue<T> optionalValue;

    try {
      optionalValue = await _getInitialValue();
    } finally {
      _isLoading = false;
    }

    if (!optionalValue.hasValue) {
      _isSkipped = true;
      return;
    }
    if (behaviorSubject.hasValue) {
      return;
    }
    behaviorSubject.add(optionalValue.value);
  }
}
