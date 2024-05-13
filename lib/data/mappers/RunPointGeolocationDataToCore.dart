part of mappers;

class RunPointGeolocationDataToCore implements DataToCoreMapper<RunPointGeolocationData, RunPointGeolocation> {
  @override
  RunPointGeolocation map(RunPointGeolocationData data) {
    return RunPointGeolocation(
        geolocation: AppGeolocation(
            altitude: data.altitude,
            latitude: data.latitude,
            longitude: data.longitude,
            dateTime: data.dateTime,
            accuracy: data.accuracy,
            speed: data.speed));
  }
}
