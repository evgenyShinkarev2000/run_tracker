import 'package:run_tracker/Data/Repositories/TrackRecord/ITrackRecordPointVisitor.dart';

abstract class BasePoint {
  int get id;
  int get trackRecordId;
  DateTime get createdAt;

  TResult accept<TResult>(ITrackRrecordPointVisitor<TResult> visitor);
}
