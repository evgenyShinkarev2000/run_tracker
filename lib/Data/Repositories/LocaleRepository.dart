import 'dart:async';
import 'dart:ui';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/localization/export.dart';

mixin class LocaleRepository
    implements
        IValueRepository<Locale>,
        IStreamValueRepository<Locale>,
        IDisposable {
  Locale _currentLocal = AppLocales.ru;
  final StreamController<Locale> _streamController =
      StreamController.broadcast();

  @override
  void Dispose() {
    _streamController.close();
  }

  @override
  Future<Locale> Get([CancellationToken? ct]) {
    return Future.value(_currentLocal);
  }

  @override
  Future Set(model, [CancellationToken? ct]) {
    _currentLocal = model;
    _streamController.add(_currentLocal);

    return Future.value();
  }

  @override
  Stream<Locale> StreamValue() {
    return _streamController.stream;
  }
}
