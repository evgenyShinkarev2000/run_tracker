import 'package:cancellation_token/cancellation_token.dart';
import 'package:run_tracker/Data/Repositories/SettingRepository.dart';
import 'package:run_tracker/Data/export.dart';

abstract class LocationRequirementRepository
    implements ICommonValueRepository<LocationRequirement> {}

class DriftLocationRequirementRepository
    extends EnumSettingRepository<LocationRequirement>
    with CommonValueRepository<LocationRequirement>
    implements LocationRequirementRepository {
  DriftLocationRequirementRepository(super.appDatabase);

  @override
  String get key => "LocationRequirement";

  @override
  List<LocationRequirement> get enumValues => LocationRequirement.values;

  @override
  Future<LocationRequirement> Get([CancellationToken? ct]) async {
    return (await protectedGet(ct)) ?? LocationRequirement.RequireAndUse;
  }
}

enum LocationRequirement { RequireAndUse, SilentUse, Ignore }
