part of mappers;

class RunPointStartToData implements CoreToDataMapper<RunPointStart, RunPointStartData> {
  const RunPointStartToData();

  @override
  RunPointStartData map(RunPointStart core) {
    final geoMapper = RunPointGeolocationToData();
    final geo = core.geolocation != null ? geoMapper.map(RunPointGeolocation(geolocation: core.geolocation!)) : null;
    return RunPointStartData(dateTime: core.dateTime, geolocation: geo);
  }
}
