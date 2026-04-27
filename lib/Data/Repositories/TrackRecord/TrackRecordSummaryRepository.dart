import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/DriftExtension/export.dart';
import 'package:run_tracker/Data/Exceptions/export.dart';
import 'package:run_tracker/Data/export.dart';

class TrackRecordSummaryQueryModel {
  final OptionalValue<DateTime> startStart;
  final OptionalValue<DateTime> startEnd;

  const TrackRecordSummaryQueryModel({
    this.startStart = const OptionalValue.empty(),
    this.startEnd = const OptionalValue.empty(),
  });
}

abstract class TrackRecordSummaryRepository {
  Future<TrackRecordSummary?> getById(int trackRecordId);
  Future<int> addOrUpdate(TrackRecordSummariesCompanion trackRecordSummary);
  Future<TrackRecordSummary> update(TrackRecordSummary trackRecordSummary);
  Future<List<TrackRecordSummary>> getByQuery(
    TrackRecordSummaryQueryModel queryModel, [
    CancellationToken? ct,
  ]);
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

  @override
  Future<List<TrackRecordSummary>> getByQuery(
    TrackRecordSummaryQueryModel queryModel, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final query = _appDatabase.trackRecordSummaries.select();
    final builder = PredicateBuilder();
    if (queryModel.startStart.hasValue) {
      builder.and(
        _appDatabase.trackRecordSummaries.start.isBiggerOrEqualValue(
          queryModel.startStart.value,
        ),
      );
    }
    if (queryModel.startEnd.hasValue) {
      builder.and(
        _appDatabase.trackRecordSummaries.start.isSmallerOrEqualValue(
          queryModel.startEnd.value,
        ),
      );
    }
    if (builder.predicate != null) {
      query.where((f) => builder.predicate!);
    }

    return await query.get().asCancellable(ct);
  }
}
