import 'dart:async';
import 'dart:ui';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/AppDatabase.dart';
import 'package:run_tracker/Data/Contacts/ICommonValueRepository.dart';
import 'package:run_tracker/localization/export.dart';

abstract class LocaleRepository extends CommonValueRepository<Locale> {}

class MemoryLocaleRepository extends LocaleRepository {
  Locale _currentLocal = AppLocales.ru;

  @override
  Future<Locale> Get([CancellationToken? ct]) {
    return Future.value(_currentLocal);
  }

  @override
  Future Set(model, [CancellationToken? ct]) {
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
  Future<Locale> Get([CancellationToken? ct]) async {
    var setting =
        await (_database.settings.select()..where((s) => s.name.equals(key)))
            .getSingleOrNull()
            .asCancellable(ct);

    return AppLocales.fromCodeOrFallback(setting?.value);
  }

  @override
  Future<dynamic> Set(Locale model, [CancellationToken? ct]) async {
    await _database.settings.insertOnConflictUpdate(
      Setting(name: key, value: model.languageCode),
    );
    super.Set(model);
  }
}
