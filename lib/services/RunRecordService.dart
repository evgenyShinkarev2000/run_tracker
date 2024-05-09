import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/core/RunRecord.dart';
import 'package:run_tracker/data/mappers/RunPointGeolocationDataToCore.dart';
import 'package:run_tracker/data/repositories/RunCoverRepository.dart';
import 'package:run_tracker/data/repositories/RunPointsRepository.dart';
import 'package:run_tracker/services/models/RunRecordModel.dart';
import 'package:run_tracker/services/mappers/RunRecordToData.dart';
import 'package:run_tracker/services/mappers/RunRecordToCoverData.dart';

class RunRecordService {
  static final RunPointGeolocationDataToCore runPointGeolocationDataToCore = RunPointGeolocationDataToCore();
  final RunCoverRepository _runCoverRepository;
  final RunPointsRepository _runPointsRepository;
  RunRecordService({required RunCoverRepository runCoverRepository, required RunPointsRepository runPointsRepository})
      : _runCoverRepository = runCoverRepository,
        _runPointsRepository = runPointsRepository;

  Future<void> saveRecord(RunRecord runRecord) async {
    var runCoverData = RunRecordToCoverData().map(runRecord);
    var runPointsData = RunRecordToData().map(runRecord);

    await Future.wait([_runCoverRepository.add(runCoverData), _runPointsRepository.add(runPointsData)]);

    runCoverData.runPointsKey = runPointsData.key;
    runPointsData.runCoverKey = runCoverData.key;

    await Future.wait([runCoverData.save(), runPointsData.save()]);
  }

  Iterable<Future<RunRecordModel>> getIterator() {
    try {
      final models = _runCoverRepository.getIterator().map((rcdf) async {
        final runCoverData = await rcdf;
        final runPointsData = await _runPointsRepository.getByKey(runCoverData.runPointsKey!);

        return RunRecordModel(runCoverData: runCoverData, runPointsData: runPointsData!);
      });
      return models;
    } catch (ex) {
      rethrow;
    }
  }

  Future<RunRecordModel?> getByCoverKey(int key) async {
    var runCover = await _runCoverRepository.getByKey(key);
    if (runCover == null) {
      return null;
    }
    var runPoints = await _runPointsRepository.getByKey(key);
    if (runPoints == null) {
      return null;
    }

    return RunRecordModel(runCoverData: runCover, runPointsData: runPoints);
  }

  static List<RunPointGeolocation> GetGeolocationsFromModel(RunRecordModel model) {
    final runPointGeolocations = <RunPointGeolocation>[];

    if (model.runPointsData.start.geolocation != null) {
      final firstGeolocation = model.runPointsData.geolocations.firstOrNull;
      if (firstGeolocation != null && !model.runPointsData.start.dateTime.isAtSameMomentAs(firstGeolocation.dateTime)) {
        runPointGeolocations.add(runPointGeolocationDataToCore.map(model.runPointsData.start.geolocation!));
      }
    }

    runPointGeolocations
        .addAll(model.runPointsData.geolocations.map((rpgd) => runPointGeolocationDataToCore.map(rpgd)));

    if (model.runPointsData.stop.geolocation != null) {
      final lastGeolocation = model.runPointsData.geolocations.lastOrNull;
      if (lastGeolocation != null && !model.runPointsData.stop.dateTime.isAtSameMomentAs(lastGeolocation.dateTime)) {
        runPointGeolocations.add(runPointGeolocationDataToCore.map(model.runPointsData.stop.geolocation!));
      }
    }

    return runPointGeolocations;
  }
}
