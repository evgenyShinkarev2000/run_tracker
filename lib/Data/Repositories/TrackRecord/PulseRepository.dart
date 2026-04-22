import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/DriftExtension/export.dart';
import 'package:run_tracker/Data/export.dart';

class PulseMeasureQueryModel {
  final List<int> trackRecordIds;
  final PaginationModel? pagination;
  final SortDirection? measuredAtSortOrder;

  const PulseMeasureQueryModel({
    this.trackRecordIds = const [],
    this.pagination,
    this.measuredAtSortOrder,
  });
}

abstract class PulseRepository {
  Future<int> addOrUpdate(PulseMeasurementsCompanion pulseMeasurement);
  Future<List<PulseMeasurement>> getByQuery(
    PulseMeasureQueryModel query, [
    CancellationToken? ct,
  ]);
}

class DriftPulseRepository extends PulseRepository {
  final AppDatabase _database;

  DriftPulseRepository(this._database);

  @override
  Future<int> addOrUpdate(PulseMeasurementsCompanion pulseMeasurement) async {
    return await _database.pulseMeasurements.insertOnConflictUpdate(
      pulseMeasurement,
    );
  }

  @override
  Future<List<PulseMeasurement>> getByQuery(
    PulseMeasureQueryModel query, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final select = _database.pulseMeasurements.select();
    if (query.trackRecordIds.isNotEmpty) {
      select.where((pm) => pm.trackRecordId.isIn(query.trackRecordIds));
    }
    if (query.measuredAtSortOrder != null) {
      select.orderBy([
        (pm) => OrderingTerm(
          expression: pm.measuredAt,
          mode: query.measuredAtSortOrder!.drift,
        ),
      ]);
    }
    if (query.pagination != null) {
      select.limit(query.pagination!.take, offset: query.pagination!.skip);
    }

    return await select.get();
  }
}
