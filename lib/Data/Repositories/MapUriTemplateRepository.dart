import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:run_tracker/Data/export.dart';

abstract class MapUriTemplateRepository extends CommonValueRepository<String>
    implements IResetDefault {}

class DriftMapUriTemplateRepository extends MapUriTemplateRepository {
  static const String key = "MapUriTemplate";
  final AppDatabase _database;

  DriftMapUriTemplateRepository(this._database);

  @override
  Future<String> Get([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final setting =
        await (_database.settings.select()..where((s) => s.name.equals(key)))
            .getSingleOrNull()
            .asCancellable(ct);
    if (setting == null) {
      return _getDefaultUri();
    }

    return setting.value;
  }

  @override
  Future ResertToDefault([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final defaultValue = _getDefaultUri();

    await _database.settings
        .insertOnConflictUpdate(Setting(name: key, value: defaultValue))
        .asCancellable(ct);
  }

  String _getDefaultUri() {
    if (kIsWeb) {
      return AppConfiguration.WebMapUriTemplate;
    }

    return AppConfiguration.NativeMapUriTemplate;
  }
}
