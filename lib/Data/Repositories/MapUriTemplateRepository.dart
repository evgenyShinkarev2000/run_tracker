import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Data/Repositories/SettingRepository.dart';
import 'package:run_tracker/Data/export.dart';

abstract class MapUriTemplateRepository
    implements ICommonValueRepository<String>, IResetDefault {}

class DriftMapUriTemplateRepository extends StringSettingRepository
    with CommonValueRepository<String>
    implements MapUriTemplateRepository {
  @override
  String get key => "MapUriTemplate";
  final AppSettings appSettings;

  DriftMapUriTemplateRepository(super._database, this.appSettings);

  @override
  Future ResertToDefault([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    final defaultValue = _getDefaultUri();

    await super.Set(defaultValue, ct);
  }

  String _getDefaultUri() => appSettings.mapUriTemplate;

  @override
  Future<String> Get([CancellationToken? ct]) async {
    return (await protectedGet(ct)) ?? _getDefaultUri();
  }
}
