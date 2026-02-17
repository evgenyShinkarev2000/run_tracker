import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/export.dart';

abstract class MapCacheDurationRepository
    extends CommonValueRepository<Duration?>
    implements IResetDefault {}

class DriftMapCacheDurationRepository extends MapCacheDurationRepository {
  static const String key = "OverrideMapCacheDurationSeconds";
  final AppDatabase _database;
  final AppSettings _appSettings;

  DriftMapCacheDurationRepository(this._database, this._appSettings);

  @override
  Future<Duration?> Get([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final setting =
        await (_database.settings.select()..where((s) => s.name.equals(key)))
            .getSingleOrNull()
            .asCancellable(ct);
    if (setting == null) {
      return _getDefault();
    }
    final durationSeconds = int.tryParse(setting.value);
    if (durationSeconds == null) {
      return _getDefault();
    }

    return Duration(seconds: durationSeconds);
  }

  @override
  Future<void> Set(Duration? model, [CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    if (model == null) {
      await _database.settings
          .deleteWhere((s) => s.name.equals(key))
          .asCancellable(ct);
    } else {
      final stringSecondsDuration = model.inSeconds.toString();
      await _database.settings
          .insertOnConflictUpdate(
            Setting(name: key, value: stringSecondsDuration),
          )
          .asCancellable(ct);
    }

    super.Set(model, ct);
  }

  @override
  Future<void> ResertToDefault([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final defaultDuration = _getDefault();

    await Set(defaultDuration, ct);
  }

  Duration? _getDefault() => _appSettings.overrideMapCacheDuration;
}
