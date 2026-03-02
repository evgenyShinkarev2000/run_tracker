import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/export.dart';

abstract class LocationRequirementRepository
    extends CommonValueRepository<LocationRequirement> {}

class DriftLocationRequirementRepository extends LocationRequirementRepository {
  static const String key = "LocationPermission";

  final AppDatabase _appDatabase;
  DriftLocationRequirementRepository(this._appDatabase);

  @override
  Future<LocationRequirement> Get([CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    var setting =
        await (_appDatabase.settings.select()..where((s) => s.name.equals(key)))
            .getSingleOrNull()
            .asCancellable(ct);

    if (setting == null) {
      return _getDefault();
    }

    return LocationRequirement.values.firstWhere(
      (v) => v.name == setting.value,
      orElse: _getDefault,
    );
  }

  @override
  Future<void> Set(model, [CancellationToken? ct]) async {
    ct?.throwIfCancelled();
    await _appDatabase.settings
        .insertOnConflictUpdate(Setting(name: key, value: model.name))
        .asCancellable(ct);

    await super.Set(model, ct);
  }

  LocationRequirement _getDefault() => LocationRequirement.Require;
}

enum LocationRequirement { Require, Ignore }
