import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Data/Exceptions/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

class TrackRecordWithSummary {
  final TrackRecord track;
  final TrackRecordSummary summary;

  TrackRecordWithSummary({required this.track, required this.summary});
}

class TrackService {
  final TrackRecordRepository _trackRecordRepository;
  final TrackRecordPointsRepository _trackRecordPointsRepository;
  final TrackRecordSummaryRepository _trackRecordSummaryRepository;
  final TrackSummaryCalculator _trackSummaryCalculator;

  TrackService(
    this._trackRecordRepository,
    this._trackRecordPointsRepository,
    this._trackRecordSummaryRepository,
    this._trackSummaryCalculator,
  );

  Future<List<TrackRecordWithSummary>> getTrackRecordWithSummariesOrGenerate(
    TrackRecordWithSummaryQueryModel query, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final models = await _trackRecordRepository
        .getTrackRecordsWithSummaryByQuery(query, ct);
    final result = List<TrackRecordWithSummary>.empty(growable: true);
    for (var model in models) {
      ct?.throwIfCancelled();

      result.add(
        TrackRecordWithSummary(
          track: model.trackRecord,
          summary:
              model.trackRecordSummary ??
              await generateOrUpdateAndGetSummary(model.trackRecord.id, ct),
        ),
      );
    }

    return result;
  }

  Future<TrackSummary> calculateSummary(int trackRecordId) async {
    final points = await _trackRecordPointsRepository.getPointsByTrackRecordId(
      trackRecordId,
    );
    return _trackSummaryCalculator.calculateSummary(points.toList());
  }

  Future<void> generateOrUpdateSummary(int trackRecordId) async {
    final summary = await calculateSummary(trackRecordId);

    await _trackRecordSummaryRepository.addOrUpdate(
      TrackRecordSummariesCompanion.insert(
        trackRecordId: Value(trackRecordId),
        start: Value(summary.start),
        end: Value(summary.end),
        activeDistance: Value(summary.activeDistance),
        activeDuration: Value(summary.activeDuration),
        activePositioningDuration: Value(summary.activePositioningDuration),
      ),
    );
  }

  Future<TrackRecordSummary> generateOrUpdateAndGetSummary(
    int trackRecordId, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();
    await generateOrUpdateSummary(trackRecordId);

    ct?.throwIfCancelled();
    final result = await _trackRecordSummaryRepository.getById(trackRecordId);
    if (result == null) {
      throw EntityNotFoundException.fromTypeAndPrimaryKey(
        "TrackRecordSummary",
        trackRecordId.toString(),
      );
    }

    return result;
  }
}
