import 'package:drift/drift.dart';
import 'package:gpx/gpx.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';

//TODO поддержка пульса
class GPXImport {
  final ILogger _logger;
  final TrackRecordRepository _trackRecordRepository;
  final TrackRecordPointsRepository _trackRecordPointsRepository;

  GPXImport(
    this._logger,
    this._trackRecordRepository,
    this._trackRecordPointsRepository,
  );

  Future<TrackRecord> importTrackRecord(String gpxString) async {
    final reader = GpxReader();
    final gpx = reader.fromString(gpxString);

    final trackRecord = await _trackRecordRepository.create(
      TrackRecordsCompanion.insert(
        createdAt: DateTime.timestamp(),
        isCompleted: true,
        source: Value("import_from: ${gpx.creator}"),
      ),
    );

    if (gpx.trks.isEmpty) {
      return trackRecord;
    }
    //TODO поддержка пауз
    if (gpx.trks.length > 1) {
      _logger.logWarning(
        "got gpx with gpx.trks.length = ${gpx.trks.length} > 1",
        data: {"gpxString": gpxString},
      );
    }

    var track = gpx.trks.first;
    for (var segment in track.trksegs) {
      Wpt? lastPoint;
      for (var point in segment.trkpts) {
        if (point.time == null) {
          _logger.logWarning(
            "point.time == null, skip",
            data: {"point": point.toString()},
          );
          continue;
        }
        if (lastPoint == null) {
          await _trackRecordPointsRepository.addResumePoint(
            ResumePoint.insert(
              trackRecordId: trackRecord.id,
              createdAt: point.time!,
            ),
          );
        }
        lastPoint = point;
        await _trackRecordPointsRepository.addPositionPoint(
          PositionPoint.insert(
            trackRecordId: trackRecord.id,
            createdAt: point.time!,
            latitude: point.lat,
            longitude: point.lon,
            altitude: point.ele,
          ),
        );
      }
      if (lastPoint != null) {
        await _trackRecordPointsRepository.addPausePoint(
          PausePoint.insert(
            trackRecordId: trackRecord.id,
            createdAt: lastPoint.time!,
          ),
        );
      }
    }

    return trackRecord;
  }
}
