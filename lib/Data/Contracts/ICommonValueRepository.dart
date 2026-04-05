import 'dart:async';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Contracts/export.dart';

abstract interface class ICommonValueRepository<T>
    implements
        IValueRepository<T>,
        ISetValueRepository<T>,
        IStreamProvider<T> {}

abstract mixin class CommonValueRepository<T>
    implements ICommonValueRepository<T>, IDisposable {
  late final LazyBehaviorSubject<T> _lazyBehaviorSubject = LazyBehaviorSubject(
    Get,
  );

  @override
  Stream<T> get stream => _lazyBehaviorSubject.stream;

  @override
  @mustCallSuper
  void dispose() {
    _lazyBehaviorSubject.dispose();
  }

  @override
  @mustCallSuper
  Future Set(T model, [CancellationToken? ct]) {
    _lazyBehaviorSubject.add(model);

    return Future.value();
  }
}
