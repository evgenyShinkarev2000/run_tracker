import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/drift.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/AppDatabase.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/BasePoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/PausePoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/PositionPoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/ResumePoint.dart';

abstract class TrackRecordPointsRepository {
  Future<int> addResumePoint(ResumePoint point);
  Future<int> addPausePoint(PausePoint point);
  Future<int> addPositionPoint(PositionPoint point);
  Future<Iterable<BasePoint>> getPointsByTrackRecordId(
    int trackRecordId, [
    CancellationToken? ct,
  ]);
}

class DriftTrackRecordPointsRepository extends TrackRecordPointsRepository {
  final AppDatabase _appDatabase;
  DriftTrackRecordPointsRepository(this._appDatabase);

  @override
  Future<int> addResumePoint(ResumePoint point) async {
    final insertModel = TrackRecordPointsCompanion.insert(
      trackRecordId: point.trackRecordId,
      createdAt: point.createdAt,
      discriminator: ResumePoint.Discriminator,
    );

    return await _appDatabase.trackRecordPoints.insertOne(insertModel);
  }

  @override
  Future<int> addPausePoint(PausePoint point) async {
    final insertModel = TrackRecordPointsCompanion.insert(
      trackRecordId: point.trackRecordId,
      createdAt: point.createdAt,
      discriminator: PausePoint.Discriminator,
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
      createdAt: point.createdAt,
      latitude: point.latitude,
      longitude: point.longitude,
      altitude: point.altitude,
    );
  }

  BasePoint _mapTrackRecordPoint(TrackRecordPoint point) {
    return switch (point.discriminator) {
      PausePoint.Discriminator => PausePoint(
        id: point.id,
        trackRecordId: point.trackRecordId,
        createdAt: point.createdAt,
      ),
      ResumePoint.Discriminator => ResumePoint(
        id: point.id,
        trackRecordId: point.trackRecordId,
        createdAt: point.createdAt,
      ),
      _ => throw NotSupportedException(
        message: "Discriminator ${point.discriminator} not supported",
        data: {"TrackRecordPoint": point.toJson()},
      ),
    };
  }
}
