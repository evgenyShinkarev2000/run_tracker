import 'dart:async';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Contacts/IValueRepository.dart';

abstract interface class ICommonValueRepository<T>
    implements IValueRepository<T> {
  Stream<T> StreamValueWithLastOrGet();
}

abstract class CommonValueRepository<T> extends ICommonValueRepository<T>
    implements IDisposable {
  late final LazyBehaviorSubject<T> _lazyBehaviorSubject = LazyBehaviorSubject(
    Get,
  );

  @override
  @mustCallSuper
  void Dispose() {
    _lazyBehaviorSubject.Dispose();
  }

  @override
  @mustCallSuper
  Future Set(T model, [CancellationToken? ct]) {
    _lazyBehaviorSubject.Add(model);

    return Future.value();
  }

  @override
  Stream<T> StreamValueWithLastOrGet() {
    return _lazyBehaviorSubject.stream;
  }
}
