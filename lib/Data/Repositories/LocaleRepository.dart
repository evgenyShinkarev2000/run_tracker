import 'dart:async';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/AppDatabase.dart';
import 'package:run_tracker/Data/Contracts/ICommonValueRepository.dart';
import 'package:run_tracker/localization/export.dart';

abstract class LocaleRepository extends CommonValueRepository<AppLocale> {}

class MemoryLocaleRepository extends LocaleRepository {
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

class DriftLocaleRepository extends LocaleRepository {
  static const String key = "Locale";
  final AppDatabase _database;

  DriftLocaleRepository(this._database);

  @override
  Future<AppLocale> Get([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    var setting =
        await (_database.settings.select()..where((s) => s.name.equals(key)))
            .getSingleOrNull()
            .asCancellable(ct);

    return AppLocales.fromCodeOrFallback(setting?.value);
  }

  @override
  Future Set(AppLocale model, [CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    await _database.settings.insertOnConflictUpdate(
      Setting(name: key, value: model.locale.languageCode),
    );
    super.Set(model);
  }
}
