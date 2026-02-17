import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/export.dart';

abstract class MapUriTemplateRepository extends CommonValueRepository<String>
    implements IResetDefault {}

class DriftMapUriTemplateRepository extends MapUriTemplateRepository {
  static const String key = "MapUriTemplate";
  final AppDatabase _database;
  final AppSettings appSettings;

  DriftMapUriTemplateRepository(this._database, this.appSettings);

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
  Future<void> Set(String model, [CancellationToken? ct]) async {
    ct?.throwIfCancelled();

    await _database.settings
        .insertOnConflictUpdate(Setting(name: key, value: model))
        .asCancellable(ct);

    await super.Set(model, ct);
  }

  @override
  Future ResertToDefault([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final defaultValue = _getDefaultUri();

    await Set(defaultValue, ct);
  }

  String _getDefaultUri() => appSettings.mapUriTemplate;
}
