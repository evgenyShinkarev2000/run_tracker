import 'dart:async';
import 'dart:ui';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Contacts/ICommonValueRepository.dart';
import 'package:run_tracker/localization/export.dart';

mixin class LocaleRepository
    implements ICommonValueRepository<Locale>, IDisposable {
  @override
  Stream<Locale> get stream => _lazyBehaviorSubject.stream;

  Locale _currentLocal = AppLocales.ru;
  late final LazyBehaviorSubject<Locale> _lazyBehaviorSubject =
      LazyBehaviorSubject(Get);

  @override
  void Dispose() {
    _lazyBehaviorSubject.Dispose();
  }

  @override
  Future<Locale> Get([CancellationToken? ct]) {
    return Future.value(_currentLocal);
  }

  @override
  Future Set(model, [CancellationToken? ct]) {
    _currentLocal = model;
    _lazyBehaviorSubject.Add(_currentLocal);

    return Future.value();
  }

  @override
  Stream<Locale> StreamValueWithLastOrGet() {
    return _lazyBehaviorSubject.stream;
  }
}
