import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';
import 'package:run_tracker/services/mappers/CoreToDataMapper.dart';
import 'package:run_tracker/services/mappers/RunPointGeolocationToData.dart';
import 'package:run_tracker/services/mappers/RunPointStartToData.dart';
import 'package:run_tracker/services/mappers/RunPointStopToData.dart';

class RunPointsToData
    implements CoreToDataMapper<List<RunPoint>, RunPointsData> {
  static const RunPointGeolocationToData _runPointGeolocationToData =
      RunPointGeolocationToData();
  static const RunPointStartToData _runPointStartToData = RunPointStartToData();
  static const RunPointStopToData _runPointStopToData = RunPointStopToData();

  @override
  RunPointsData map(List<RunPoint> runPoints) {
    return RunPointsData(
        geolocations: runPoints
            .whereType<RunPointGeolocation>()
            .map((rpg) => _runPointGeolocationToData.map(rpg))
            .toList(),
        start: runPoints
            .whereType<RunPointStart>()
            .map((rps) => _runPointStartToData.map(rps))
            .first,
        stop: runPoints
            .whereType<RunPointStop>()
            .map((rps) => _runPointStopToData.map(rps))
            .first);
  }
}
