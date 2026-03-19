import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/AppDatabase.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/export.dart';

abstract class TrackRecordPointsRepository {
  Future<int> addResumePoint(ResumePoint point);
  Future<int> addPausePoint(PausePoint point);
  Future<int> addPositionPoint(PositionPoint point);
  Future<Iterable<BasePoint>> getPointsByTrackRecordId(
    int trackRecordId, [
    CancellationToken? ct,
  ]);
  Future<Map<int, List<BasePoint>>> getTrackRecordPointsByIds(
    List<int> trackRecordIds, [
    CancellationToken? ct,
  ]);
  Future<BasePoint?> getLastPoint(int trackRecordId);
  Future<void> removePoint(BasePoint point);
}

class DriftTrackRecordPointsRepository extends TrackRecordPointsRepository {
  final AppDatabase _appDatabase;
  DriftTrackRecordPointsRepository(this._appDatabase);

  @override
  Future<int> addResumePoint(ResumePoint point) async {
    final insertModel = TrackRecordPointsCompanion.insert(
      trackRecordId: point.trackRecordId,
      createdAt: point.createdAt,
      discriminator: PointType.Resume,
    );

    return await _appDatabase.trackRecordPoints.insertOne(insertModel);
  }

  @override
  Future<int> addPausePoint(PausePoint point) async {
    final insertModel = TrackRecordPointsCompanion.insert(
      trackRecordId: point.trackRecordId,
      createdAt: point.createdAt,
      discriminator: PointType.Pause,
    );

    return await _appDatabase.trackRecordPoints.insertOne(insertModel);
  }

  @override
  Future<int> addPositionPoint(PositionPoint point) async {
    final insertModel = TrackRecordPositionPointsCompanion.insert(
      trackRecordId: point.trackRecordId,
      createdAt: point.createdAt,
      longitude: Value(point.longitude),
      latitude: Value(point.latitude),
      altitude: Value(point.altitude),
    );

    return await _appDatabase.trackRecordPositionPoints.insertOne(insertModel);
  }

  @override
  Future<Iterable<BasePoint>> getPointsByTrackRecordId(
    int trackRecordId, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();

    final positionSelectStatement = _appDatabase.trackRecordPositionPoints
        .select();
    positionSelectStatement.where((p) => p.trackRecordId.equals(trackRecordId));
    final points = await _getTrackRecordPositionPoints(
      positionSelectStatement,
      ct,
    );

    final selectStatement = _appDatabase.trackRecordPoints.select();
    selectStatement.where((p) => p.trackRecordId.equals(trackRecordId));
    final trackRecordPoints = await _getTrackRecordPoints(selectStatement, ct);

    points.addAll(trackRecordPoints);

    return points;
  }

  @override
  Future<Map<int, List<BasePoint>>> getTrackRecordPointsByIds(
    List<int> trackRecordIds, [
    CancellationToken? ct,
  ]) async {
    ct?.throwIfCancelled();
    final positionSelectStatement = _appDatabase.trackRecordPositionPoints
        .select();
    positionSelectStatement.where((p) => p.trackRecordId.isIn(trackRecordIds));
    final positionPoints = await _getTrackRecordPositionPoints(
      positionSelectStatement,
      ct,
    );

    ct?.throwIfCancelled();
    final selectStatement = _appDatabase.trackRecordPoints.select();
    selectStatement.where((p) => p.trackRecordId.isIn(trackRecordIds));
    final dynamicPoints = await _getTrackRecordPoints(selectStatement, ct);

    ct?.throwIfCancelled();
    final Map<int, List<BasePoint>> map = Map.fromIterable(
      trackRecordIds,
      value: (_) => [],
    );

    try {
      _fillMap(map, positionPoints);
      _fillMap(map, dynamicPoints);
    } on AppException catch (ex) {
      ex.data["trackRecordIds"] = trackRecordIds;
      rethrow;
    }

    return map;
  }

  @override
  Future<BasePoint?> getLastPoint(int trackRecordId) async {
    final selectPointStatement = _appDatabase.trackRecordPoints.select();
    selectPointStatement.where((p) => p.trackRecordId.equals(trackRecordId));
    selectPointStatement.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    selectPointStatement.limit(1);
    final point = await selectPointStatement.getSingleOrNull();

    final selectPositionPointStatement = _appDatabase.trackRecordPositionPoints
        .select();
    selectPositionPointStatement.where(
      (p) => p.trackRecordId.equals(trackRecordId),
    );
    selectPositionPointStatement.orderBy([
      (p) => OrderingTerm.desc(p.createdAt),
    ]);
    selectPositionPointStatement.limit(1);
    final positionPoint = await selectPositionPointStatement.getSingleOrNull();

    if (positionPoint != null &&
        (point == null || positionPoint.createdAt.isAfter(point.createdAt))) {
      return _mapTrackRecordPositionPoint(positionPoint);
    }
    if (point != null &&
        (positionPoint == null ||
            point.createdAt.isAfter(positionPoint.createdAt))) {
      return _mapTrackRecordPoint(point);
    }

    return null;
  }

  @override
  Future<void> removePoint(BasePoint point) async {
    switch (CheckPointTypeVisitor.determineType(point)) {
      case PointType.Position:
        await _appDatabase.trackRecordPositionPoints.deleteWhere(
          (p) => p.id.equals(point.id),
        );
        break;
      case PointType.Resume || PointType.Pause:
        await _appDatabase.trackRecordPoints.deleteWhere(
          (p) => p.id.equals(point.id),
        );
        break;
    }
  }

  Future<List<BasePoint>> _getTrackRecordPoints(
    SimpleSelectStatement<$TrackRecordPointsTable, TrackRecordPoint>
    selectStatement,
    CancellationToken? ct,
  ) async {
    final trackRecordPoints = await selectStatement.get().asCancellable(ct);

    return trackRecordPoints.map(_mapTrackRecordPoint).toList();
  }

  Future<List<BasePoint>> _getTrackRecordPositionPoints(
    SimpleSelectStatement<
      $TrackRecordPositionPointsTable,
      TrackRecordPositionPoint
    >
    selectStatement,
    CancellationToken? ct,
  ) async {
    final trackRecordPositionPoints = await selectStatement.get().asCancellable(
      ct,
    );

    return trackRecordPositionPoints.map(_mapTrackRecordPositionPoint).toList();
  }

  BasePoint _mapTrackRecordPositionPoint(TrackRecordPositionPoint point) {
    return PositionPoint(
      id: point.id,
      trackRecordId: point.trackRecordId,
      createdAt: point.createdAt.toUtc(),
      latitude: point.latitude,
      longitude: point.longitude,
      altitude: point.altitude,
    );
  }

  void _fillMap(Map<int, List<BasePoint>> map, List<BasePoint> points) {
    for (var point in points) {
      final list = map[point.trackRecordId];
      if (list == null) {
        throw AppException(
          message: "Got point not suitable for query",
          data: {
            "pointId": point.id,
            "pointType": CheckPointTypeVisitor.determineType(point),
          },
        );
      }
      list.add(point);
    }
  }

  BasePoint _mapTrackRecordPoint(TrackRecordPoint point) {
    return switch (point.discriminator) {
      PointType.Pause => PausePoint(
        id: point.id,
        trackRecordId: point.trackRecordId,
        createdAt: point.createdAt.toUtc(),
      ),
      PointType.Resume => ResumePoint(
        id: point.id,
        trackRecordId: point.trackRecordId,
        createdAt: point.createdAt.toUtc(),
      ),
      _ => throw NotSupportedException(
        message: "Discriminator ${point.discriminator} not supported",
        data: {"TrackRecordPoint": point.toJson()},
      ),
    };
  }
}
