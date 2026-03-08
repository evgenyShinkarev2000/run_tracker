import 'package:run_tracker/Data/Repositories/TrackRecord/PausePoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/PositionPoint.dart';
import 'package:run_tracker/Data/Repositories/TrackRecord/ResumePoint.dart';

abstract interface class ITrackRrecordPointVisitor<TResult> {
  TResult visitPausePoint(PausePoint pausePoint);
  TResult visitResumePoint(ResumePoint resumePoint);
  TResult visitPositionPoint(PositionPoint positionPoint);
}
