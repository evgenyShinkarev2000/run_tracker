part of mappers;

class RunPointStopToData implements CoreToDataMapper<RunPointStop, RunPointStopData> {
  const RunPointStopToData();
  @override
  RunPointStopData map(RunPointStop core) {
    final geo = core.geolocation != null
        ? RunPointGeolocationToData().map(RunPointGeolocation(geolocation: core.geolocation!))
        : null;
    return RunPointStopData(dateTime: core.dateTime, geolocation: geo);
  }
}
