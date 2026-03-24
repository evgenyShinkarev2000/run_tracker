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

class TrackRecordWithSummaryAndPoints extends TrackRecordWithSummary {
  final List<BasePoint> orderedPoints;

  TrackRecordWithSummaryAndPoints({
    required super.track,
    required super.summary,
    required this.orderedPoints,
  });

  Iterable<List<PositionPoint>> splitPath() sync* {
    List<PositionPoint> positionPoints = [];
    for (var point in orderedPoints) {
      switch (CheckPointTypeVisitor.determineType(point)) {
        case PointType.Pause:
          if (positionPoints.isNotEmpty) {
            yield positionPoints;
            positionPoints = [];
          }
          break;
        case PointType.Position:
          positionPoints.add(point as PositionPoint);
          break;
        case PointType.Resume:
          break;
      }
    }
    if (positionPoints.isNotEmpty) {
      yield positionPoints;
    }
  }
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

  Future<List<TrackRecordWithSummary>> getTrackRecordWithSummaryOrGenerate(
    TrackRecordQueryModel query, [
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

  Future<List<TrackRecordWithSummaryAndPoints>>
  getTrackRecordWithSummaryAndPointsOrGenerate(
    TrackRecordQueryModel queryModel, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();
    final models = await _trackRecordRepository
        .getTrackRecordsWithSummaryAndPointsByQuery(queryModel, ct);
    final List<TrackRecordWithSummaryAndPoints> result = [];

    for (var model in models) {
      ct?.throwIfCancelled();
      model.points.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      result.add(
        TrackRecordWithSummaryAndPoints(
          track: model.track,
          summary:
              model.summary ??
              await generateOrUpdateAndGetSummary(model.track.id),
          orderedPoints: model.points,
        ),
      );
    }

    return result;
  }

  Future<TrackRecordWithSummaryAndPoints?>
  getTrackRecordWithSummaryAndPointsOrGenerateById(
    int trackRecordId, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final result = await _trackRecordRepository
        .getTrackRecordsWithSummaryAndPointsById(trackRecordId, ct);
    if (result == null) {
      return null;
    }

    result.points.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return TrackRecordWithSummaryAndPoints(
      track: result.track,
      summary: result.summary == null
          ? await generateOrUpdateAndGetSummary(trackRecordId)
          : result.summary!,
      orderedPoints: result.points,
    );
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
