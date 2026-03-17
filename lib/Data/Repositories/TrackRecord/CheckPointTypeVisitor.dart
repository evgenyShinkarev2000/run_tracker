import 'package:run_tracker/Data/Repositories/TrackRecord/export.dart';

class CheckPointTypeVisitor implements ITrackRecordPointVisitor<PointType> {
  static final CheckPointTypeVisitor instance = CheckPointTypeVisitor();

  static PointType determineType(BasePoint point) => point.accept(instance);

  @override
  PointType visitPausePoint(PausePoint pausePoint) => PointType.Pause;

  @override
  PointType visitPositionPoint(PositionPoint positionPoint) =>
      PointType.Position;

  @override
  PointType visitResumePoint(ResumePoint resumePoint) => PointType.Resume;
}

enum PointType { Resume, Pause, Position }
