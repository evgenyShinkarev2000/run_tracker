import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/data/mappers/DataToCoreMapper.dart';
import 'package:run_tracker/data/models/RunItemGeolocationData.dart';

class RunPointGeolocationDataToCore
    implements DataToCoreMapper<RunPointGeolocationData, RunPointGeolocation> {
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
