import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Data/Repositories/SettingRepository.dart';
import 'package:run_tracker/Data/export.dart';

abstract class IsDevModeRepository implements ICommonValueRepository<bool> {}

class DriftIsDevModelRepository extends BoolSettingRepository
    with CommonValueRepository<bool>
    implements IsDevModeRepository {
  @override
  String get key => "IsDevMode";

  DriftIsDevModelRepository(super.appDatabase);

  @override
  Future<bool> Get([CancellationToken? ct]) async {
    return (await protectedGet(ct)) ?? false;
  }
}
