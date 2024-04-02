import 'package:run_tracker/services/mappers/CoreToDataMapper.dart';
import 'package:run_tracker/services/mappers/RunPointGeolocationToData.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/data/models/RunItemStopData.dart';

class RunPointStopToData
    implements CoreToDataMapper<RunPointStop, RunPointStopData> {
  const RunPointStopToData();
  @override
  RunPointStopData map(RunPointStop core) {
    final geo = core.geolocation != null
        ? RunPointGeolocationToData()
            .map(RunPointGeolocation(geolocation: core.geolocation!))
        : null;
    return RunPointStopData(dateTime: core.dateTime, geolocation: geo);
  }
}
