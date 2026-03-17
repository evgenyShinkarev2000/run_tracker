import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/DriftExtension/export.dart';
import 'package:run_tracker/Data/Exceptions/export.dart';
import 'package:run_tracker/Data/export.dart';

abstract class TrackRecordRepository {
  Future<TrackRecord?> getLast();
  Future<TrackRecordLeftJoinSummary?> getTrackRecordWithSummaryById(
    int trackRecordId,
  );
  Future<List<TrackRecordLeftJoinSummary>> getTrackRecordsWithSummaryByQuery(
    TrackRecordWithSummaryQueryModel queryModel, [
    CancellationToken? ct,
  ]);
  Future<TrackRecord> update(TrackRecord trackRecord);
  Future<TrackRecord> create(TrackRecordsCompanion insertModel);
  Future<void> remove(int trackRecordId);
}

class TrackRecordLeftJoinSummary {
  final TrackRecord trackRecord;
  final TrackRecordSummary? trackRecordSummary;

  TrackRecordLeftJoinSummary({
    required this.trackRecord,
    required this.trackRecordSummary,
  });

  factory TrackRecordLeftJoinSummary.fromJoin(
    AppDatabase appDatabase,
    TypedResult result,
  ) {
    return TrackRecordLeftJoinSummary(
      trackRecord: result.readTable(appDatabase.trackRecords),
      trackRecordSummary: result.readTableOrNull(
        appDatabase.trackRecordSummaries,
      ),
    );
  }
}

class TrackRecordWithSummaryQueryModel {
  final PaginationModel? pagination;
  final SortDirection? trackCreatedAtSort;
  final DateTime? trackCreatedAtStart;
  final DateTime? trackCreatedAtEnd;

  TrackRecordWithSummaryQueryModel({
    this.pagination,
    this.trackCreatedAtSort,
    this.trackCreatedAtStart,
    this.trackCreatedAtEnd,
  });
}

class DriftTrackRecordRepository extends TrackRecordRepository {
  final AppDatabase _appDatabase;

  DriftTrackRecordRepository(this._appDatabase);

  @override
  Future<TrackRecord?> getLast() async {
    final selectStatement = _appDatabase.trackRecords.select();
    selectStatement.orderBy([(t) => OrderingTerm.desc(t.id)]);
    selectStatement.limit(1);

    return await selectStatement.getSingleOrNull();
  }

  @override
  Future<List<TrackRecordLeftJoinSummary>> getTrackRecordsWithSummaryByQuery(
    TrackRecordWithSummaryQueryModel queryModel, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final selectStatement = _appDatabase.trackRecords.select().join([
      leftOuterJoin(
        _appDatabase.trackRecordSummaries,
        _appDatabase.trackRecordSummaries.trackRecordId.equalsExp(
          _appDatabase.trackRecords.id,
        ),
      ),
    ]);

    final predicateBuilder = PredicateBuilder();
    if (queryModel.trackCreatedAtStart != null) {
      predicateBuilder.and(
        _appDatabase.trackRecords.createdAt.isBiggerThanValue(
          queryModel.trackCreatedAtStart!,
        ),
      );
    }
    if (queryModel.trackCreatedAtEnd != null) {
      predicateBuilder.and(
        _appDatabase.trackRecords.createdAt.isSmallerOrEqualValue(
          queryModel.trackCreatedAtEnd!,
        ),
      );
    }
    if (predicateBuilder.predicate != null) {
      selectStatement.where(predicateBuilder.predicate!);
    }

    if (queryModel.trackCreatedAtSort != null) {
      final orderingMode = queryModel.trackCreatedAtSort!.drift;
      selectStatement.orderBy([
        OrderingTerm(
          expression: _appDatabase.trackRecords.createdAt,
          mode: orderingMode,
        ),
        OrderingTerm(
          expression: _appDatabase.trackRecords.id,
          mode: orderingMode,
        ),
      ]);
    }

    if (queryModel.pagination != null) {
      selectStatement.limit(
        queryModel.pagination!.take,
        offset: queryModel.pagination!.skip,
      );
    }

    final result = await selectStatement.get();

    return result
        .map((r) => TrackRecordLeftJoinSummary.fromJoin(_appDatabase, r))
        .toList();
  }

  @override
  Future<TrackRecordLeftJoinSummary?> getTrackRecordWithSummaryById(
    int trackRecordId,
  ) async {
    final selectStatement = _appDatabase.trackRecords.select().join([
      leftOuterJoin(
        _appDatabase.trackRecordSummaries,
        _appDatabase.trackRecordSummaries.trackRecordId.equalsExp(
          _appDatabase.trackRecords.id,
        ),
      ),
    ]);
    selectStatement.where(_appDatabase.trackRecords.id.equals(trackRecordId));
    selectStatement.limit(1);

    final result = await selectStatement.getSingleOrNull();
    if (result == null) {
      return null;
    }

    return TrackRecordLeftJoinSummary.fromJoin(_appDatabase, result);
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
