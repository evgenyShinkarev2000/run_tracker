import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/AppDatabase.dart';

extension TrackRecordSummaryExtension on TrackRecordSummary {
  Speed? get speed =>
      activeDistance == null || activePositioningDuration == null
      ? null
      : activeDistance! / activePositioningDuration!;
  Pace? get pace => activeDistance == null || activePositioningDuration == null
    ? null
    : activePositioningDuration! / activeDistance!;
}
