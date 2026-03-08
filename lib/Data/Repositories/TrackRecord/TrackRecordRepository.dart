import 'package:drift/drift.dart';
import 'package:run_tracker/Data/Exceptions/EntityNotFoundException.dart';
import 'package:run_tracker/Data/export.dart';

abstract class TrackRecordRepository {
  Future<TrackRecord?> getLast();
  Future<TrackRecord> update(TrackRecord trackRecord);
  Future<TrackRecord> create(TrackRecordsCompanion insertModel);
  Future<void> remove(int trackRecordId);
}

class DriftTrackRecordRepository extends TrackRecordRepository {
  final AppDatabase _appDatabase;

  DriftTrackRecordRepository(this._appDatabase);

  @override
  Future<TrackRecord?> getLast() async {
    final selectStatement = _appDatabase.trackRecords.select();
    selectStatement.orderBy([(t) => OrderingTerm.desc(t.id)]);

    return await selectStatement.getSingleOrNull();
  }

  @override
  Future<TrackRecord> update(TrackRecord trackRecord) async {
    final updateStatement = _appDatabase.trackRecords.update();
    updateStatement.whereSamePrimaryKey(trackRecord);
    final result = await updateStatement.writeReturning(trackRecord);
    if (result.isEmpty) {
      throw EntityNotFoundException.fromTypeAndPrimaryKey(
        "TrackRecord",
        trackRecord.id.toString(),
        data: {"replacingEntity": trackRecord.toJson()},
      );
    }

    return result.first;
  }

  @override
  Future<TrackRecord> create(TrackRecordsCompanion insertModel) async {
    return await _appDatabase.trackRecords.insertReturning(insertModel);
  }

  @override
  Future<void> remove(int trackRecordId) async {
    await _appDatabase.trackRecords.deleteWhere(
      (tr) => tr.id.equals(trackRecordId),
    );
  }
}
