import 'package:run_tracker/services/mappers/CoreToDataMapper.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/data/models/RunItemGeolocationData.dart';

class RunPointGeolocationToData
    implements CoreToDataMapper<RunPointGeolocation, RunPointGeolocationData> {
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
