part of mappers;

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
