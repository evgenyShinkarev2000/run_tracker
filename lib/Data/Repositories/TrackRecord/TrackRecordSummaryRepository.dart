import 'package:drift/drift.dart';
import 'package:run_tracker/Data/Exceptions/export.dart';
import 'package:run_tracker/Data/export.dart';

abstract class TrackRecordSummaryRepository {
  Future<TrackRecordSummary?> getById(int trackRecordId);
  Future<int> addOrUpdate(TrackRecordSummariesCompanion trackRecordSummary);
  Future<TrackRecordSummary> update(TrackRecordSummary trackRecordSummary);
}

class DriftTrackRecordSummaryRepository extends TrackRecordSummaryRepository {
  final AppDatabase _appDatabase;

  DriftTrackRecordSummaryRepository(this._appDatabase);

  @override
  Future<TrackRecordSummary?> getById(int trackRecordId) async {
    final selectStatement = _appDatabase.trackRecordSummaries.select();
    selectStatement.where((s) => s.trackRecordId.equals(trackRecordId));
    selectStatement.limit(1);

    return await selectStatement.getSingleOrNull();
  }

  @override
  Future<int> addOrUpdate(
    TrackRecordSummariesCompanion trackRecordSummary,
  ) async {
    return await _appDatabase.trackRecordSummaries.insertOnConflictUpdate(
      trackRecordSummary,
    );
  }

  @override
  Future<TrackRecordSummary> update(
    TrackRecordSummary trackRecordSummary,
  ) async {
    final updateStatement = _appDatabase.trackRecordSummaries.update();
    updateStatement.whereSamePrimaryKey(trackRecordSummary);
    final result = await updateStatement.writeReturning(trackRecordSummary);
    if (result.isEmpty) {
      throw EntityNotFoundException.fromTypeAndPrimaryKey(
        "TrackRecordSummary",
        trackRecordSummary.trackRecordId.toString(),
      );
    }

    return result.first;
  }
}
