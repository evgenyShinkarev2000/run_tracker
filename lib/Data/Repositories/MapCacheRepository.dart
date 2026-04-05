import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Data/Repositories/SettingRepository.dart';
import 'package:run_tracker/Data/export.dart';

abstract class MapCacheDurationRepository
    implements ICommonValueRepository<Duration?>, IResetDefault {}

class DriftMapCacheDurationRepository extends DurationSettingRepository
    with CommonValueRepository<Duration?>
    implements MapCacheDurationRepository {
  final AppSettings _appSettings;
  DriftMapCacheDurationRepository(super.appDatabase, this._appSettings);

  @override
  String get key => "OverrideMapCacheDurationSeconds";

  @override
  Future<Duration?> Get([CancellationToken? ct]) async {
    return await protectedGet(ct);
  }

  @override
  Future<void> ResertToDefault([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final defaultDuration = _getDefault();

    await super.Set(defaultDuration, ct);
  }

  Duration? _getDefault() => _appSettings.overrideMapCacheDuration;
}
