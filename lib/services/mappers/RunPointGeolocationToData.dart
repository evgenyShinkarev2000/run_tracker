part of mappers;

class RunPointGeolocationToData implements CoreToDataMapper<RunPointGeolocation, RunPointGeolocationData> {
  const RunPointGeolocationToData();
  @override
  RunPointGeolocationData map(RunPointGeolocation core) {
    return RunPointGeolocationData(
        dateTime: core.dateTime,
        speed: core.geolocation.speed,
        altitude: core.geolocation.altitude,
        latitude: core.geolocation.latitude,
        longitude: core.geolocation.longitude,
        accuracy: core.geolocation.accuracy);
  }
}
