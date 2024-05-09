import 'package:run_tracker/core/RunRecord.dart';
import 'package:run_tracker/data/models/RunCoverData.dart';
import 'package:run_tracker/services/mappers/CoreToDataMapper.dart';

class RunRecordToCoverData implements CoreToDataMapper<RunRecord, RunCoverData> {
  @override
  RunCoverData map(RunRecord core) {
    return RunCoverData(
      title: core.title,
      startDateTime: core.startDateTime,
      averageSpeed: core.averageSpeed,
      duration: core.duration.inMicroseconds,
      distance: core.distance,
      averagePulse: core.averagePulse,
    );
  }
}
