import 'package:run_tracker/core/PulseMeasurement.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/core/RunRecord.dart';
import 'package:run_tracker/data/models/PulseMeasurementData.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';
import 'package:run_tracker/services/mappers/CoreToDataMapper.dart';
import 'package:run_tracker/services/mappers/RunPointGeolocationToData.dart';
import 'package:run_tracker/services/mappers/RunPointStartToData.dart';
import 'package:run_tracker/services/mappers/RunPointStopToData.dart';

class RunRecordToData implements CoreToDataMapper<RunRecord, RunPointsData> {
  static const RunPointGeolocationToData _runPointGeolocationToData = RunPointGeolocationToData();
  static const RunPointStartToData _runPointStartToData = RunPointStartToData();
  static const RunPointStopToData _runPointStopToData = RunPointStopToData();

  @override
  RunPointsData map(RunRecord runRecord) {
    return RunPointsData(
        geolocations: runRecord.runPoints
            .whereType<RunPointGeolocation>()
            .map((rpg) => _runPointGeolocationToData.map(rpg))
            .toList(),
        start: runRecord.runPoints.whereType<RunPointStart>().map((rps) => _runPointStartToData.map(rps)).first,
        stop: runRecord.runPoints.whereType<RunPointStop>().map((rps) => _runPointStopToData.map(rps)).first,
        pulseMeasurements: runRecord.pulseMeasurements.map((pm) {
          return PulseMeasurementData(
            dateTime: pm.dateTime,
            pulse: pm.pulse,
          );
        }).toList());
  }
}
