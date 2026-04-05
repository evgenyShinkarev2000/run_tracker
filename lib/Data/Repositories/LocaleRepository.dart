import 'dart:async';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Data/Contracts/ICommonValueRepository.dart';
import 'package:run_tracker/Data/Repositories/SettingRepository.dart';
import 'package:run_tracker/localization/export.dart';

abstract class LocaleRepository implements ICommonValueRepository<AppLocale> {}

class MemoryLocaleRepository with CommonValueRepository<AppLocale> {
  AppLocale _currentLocal = AppLocales.ru;

  @override
  Future<AppLocale> Get([CancellationToken? ct]) {
    ct?.throwIfCancelled();
    return Future.value(_currentLocal);
  }

  @override
  Future Set(model, [CancellationToken? ct]) {
    ct?.throwIfCancelled();
    _currentLocal = model;
    super.Set(model);

    return Future.value();
  }
}

class DriftLocaleRepository extends BaseSettingRepository<AppLocale> with CommonValueRepository<AppLocale> implements LocaleRepository  {
  @override
  String get key => "Locale";

  DriftLocaleRepository(super.appDatabase);

  @override
  Future<AppLocale> Get([CancellationToken? ct]) async {
    return (await protectedGet(ct)) ?? AppLocales.fallback;
  }

  @override
  Future<void> Set(AppLocale model, [CancellationToken? ct]) async {
    await protectedSet(model, ct);
    await super.Set(model, ct);
  }

  @override
  AppLocale protectedDeserialize(String serializedModel) {
    return AppLocales.fromCodeOrFallback(serializedModel);
  }

  @override
  String protectedSerialize(AppLocale model) {
    return model.locale.languageCode;
  }
}
