import 'package:run_tracker/Data/export.dart';

abstract class TrackRecordWriter {
  Future<void> startWrite();
  Future<void> stopWrite();
  Future<void> writePosition(AppPosition appPosition);
  Future<void> writeResume();
  Future<void> writePause();
}

class ExistingTrackRecordWriter extends TrackRecordWriter {
  final int _trackRecordId;
  final TrackRecordPointsRepository _repository;

  ExistingTrackRecordWriter(this._trackRecordId, this._repository);

  @override
  Future<void> startWrite() async {
    await writeResume();
  }

  @override
  Future<void> stopWrite() async {
    await writePause();
  }

  @override
  Future<void> writePause() async {
    await _repository.addPausePoint(
      PausePoint.insert(
        trackRecordId: _trackRecordId,
        createdAt: DateTime.timestamp(),
      ),
    );
  }

  @override
  Future<void> writePosition(AppPosition appPosition) async {
    await _repository.addPositionPoint(
      PositionPoint.insert(
        trackRecordId: _trackRecordId,
        createdAt: appPosition.timestamp ?? DateTime.timestamp(),
        latitude: appPosition.latitude?.value,
        longitude: appPosition.longitude?.value,
        altitude: appPosition.altitude?.value,
      ),
    );
  }

  @override
  Future<void> writeResume() async {
    await _repository.addResumePoint(
      ResumePoint.insert(
        trackRecordId: _trackRecordId,
        createdAt: DateTime.timestamp(),
      ),
    );
  }
}