import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/data/models/RunItemStartData.dart';
import 'package:run_tracker/services/mappers/CoreToDataMapper.dart';
import 'package:run_tracker/services/mappers/RunPointGeolocationToData.dart';

class RunPointStartToData
    implements CoreToDataMapper<RunPointStart, RunPointStartData> {
  const RunPointStartToData();

  @override
  RunPointStartData map(RunPointStart core) {
    final geoMapper = RunPointGeolocationToData();
    final geo = core.geolocation != null
        ? geoMapper.map(RunPointGeolocation(geolocation: core.geolocation!))
        : null;
    return RunPointStartData(dateTime: core.dateTime, geolocation: geo);
  }
}
