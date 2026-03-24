import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Core/Exceptions/AppException.dart';
import 'package:run_tracker/Data/DriftExtension/export.dart';
import 'package:run_tracker/Data/Exceptions/export.dart';
import 'package:run_tracker/Data/export.dart';

abstract class TrackRecordRepository {
  Future<TrackRecord?> getLast();
  Future<TrackRecordLeftJoinSummary?> getTrackRecordWithSummaryById(
    int trackRecordId,
  );
  Future<List<TrackRecordLeftJoinSummary>> getTrackRecordsWithSummaryByQuery(
    TrackRecordQueryModel queryModel, [
    CancellationToken? ct,
  ]);
  Future<List<TrackRecordLeftJoinSummaryAndPoints>>
  getTrackRecordsWithSummaryAndPointsByQuery(
    TrackRecordQueryModel queryModel, [
    CancellationToken? ct,
  ]);
  Future<TrackRecordLeftJoinSummaryAndPoints?>
  getTrackRecordsWithSummaryAndPointsById(
    int trackRecordId, [
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

class TrackRecordLeftJoinSummaryAndPoints {
  final TrackRecord track;
  final TrackRecordSummary? summary;
  final List<BasePoint> points;

  TrackRecordLeftJoinSummaryAndPoints({
    required this.track,
    required this.summary,
    required this.points,
  });

  factory TrackRecordLeftJoinSummaryAndPoints.fromJoinAndPoints(
    AppDatabase appDatabase,
    TypedResult result,
    List<BasePoint> points,
  ) {
    return TrackRecordLeftJoinSummaryAndPoints(
      track: result.readTable(appDatabase.trackRecords),
      summary: result.readTableOrNull(appDatabase.trackRecordSummaries),
      points: points,
    );
  }
}

class TrackRecordQueryModel {
  final PaginationModel? pagination;
  final SortDirection? trackCreatedAtSort;
  final DateTime? trackCreatedAtStart;
  final DateTime? trackCreatedAtEnd;

  TrackRecordQueryModel({
    this.pagination,
    this.trackCreatedAtSort,
    this.trackCreatedAtStart,
    this.trackCreatedAtEnd,
  });
}

class DriftTrackRecordRepository extends TrackRecordRepository {
  final AppDatabase _appDatabase;
  final TrackRecordPointsRepository _trackRecordPointsRepository;

  DriftTrackRecordRepository(
    this._appDatabase,
    this._trackRecordPointsRepository,
  );

  @override
  Future<TrackRecord?> getLast() async {
    final selectStatement = _appDatabase.trackRecords.select();
    selectStatement.orderBy([(t) => OrderingTerm.desc(t.id)]);
    selectStatement.limit(1);

    return await selectStatement.getSingleOrNull();
  }

  @override
  Future<List<TrackRecordLeftJoinSummaryAndPoints>>
  getTrackRecordsWithSummaryAndPointsByQuery(
    TrackRecordQueryModel queryModel, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final joined = await getTrackRecordsWithSummaryByQuery(queryModel, ct);
    final groupedPoints = await _trackRecordPointsRepository
        .getTrackRecordPointsByIds(
          joined.map((j) => j.trackRecord.id).toList(),
          ct,
        );

    return joined.map((j) {
      final points = groupedPoints[j.trackRecord.id];
      if (points == null) {
        throw AppException(
          message: "Missed group for trackRecord with id ${j.trackRecord.id}",
        );
      }

      return TrackRecordLeftJoinSummaryAndPoints(
        track: j.trackRecord,
        summary: j.trackRecordSummary,
        points: points,
      );
    }).toList();
  }

  @override
  Future<List<TrackRecordLeftJoinSummary>> getTrackRecordsWithSummaryByQuery(
    TrackRecordQueryModel queryModel, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final result = await _selectRecordLeftJoinSummaryWithQuery(
      queryModel,
    ).get();

    return result
        .map((r) => TrackRecordLeftJoinSummary.fromJoin(_appDatabase, r))
        .toList();
  }

  @override
  Future<TrackRecordLeftJoinSummary?> getTrackRecordWithSummaryById(
    int trackRecordId,
  ) async {
    final result = await _getTrackRecordWithSummaryResultById(trackRecordId);
    if (result == null) {
      return null;
    }

    return TrackRecordLeftJoinSummary.fromJoin(_appDatabase, result);
  }

  @override
  Future<TrackRecordLeftJoinSummaryAndPoints?>
  getTrackRecordsWithSummaryAndPointsById(
    int trackRecordId, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();
    final result = await _getTrackRecordWithSummaryResultById(trackRecordId);
    if (result == null) {
      return null;
    }

    ct?.throwIfCancelled();
    final points = await _trackRecordPointsRepository.getPointsByTrackRecordId(
      trackRecordId,
      ct,
    );

    return TrackRecordLeftJoinSummaryAndPoints.fromJoinAndPoints(
      _appDatabase,
      result,
      points.toList(),
    );
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

  JoinedSelectStatement _selectRecordLeftJoinSummary() {
    return _appDatabase.trackRecords.select().join([
      leftOuterJoin(
        _appDatabase.trackRecordSummaries,
        _appDatabase.trackRecordSummaries.trackRecordId.equalsExp(
          _appDatabase.trackRecords.id,
        ),
      ),
    ]);
  }

  Future<TypedResult?> _getTrackRecordWithSummaryResultById(
    int trackRecordId,
  ) async {
    final selectStatement = _selectRecordLeftJoinSummary();
    selectStatement.where(_appDatabase.trackRecords.id.equals(trackRecordId));
    selectStatement.limit(1);

    return await selectStatement.getSingleOrNull();
  }

  JoinedSelectStatement _selectRecordLeftJoinSummaryWithQuery(
    TrackRecordQueryModel queryModel,
  ) {
    final selectStatement = _selectRecordLeftJoinSummary();

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

    return selectStatement;
  }
}
