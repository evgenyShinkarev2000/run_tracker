import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as pp;
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/core/RunRecord.dart';
import 'package:run_tracker/data/mappers/mappers.dart';
import 'package:run_tracker/data/repositories/repositories.dart';
import 'package:run_tracker/services/mappers/mappers.dart';
import 'package:run_tracker/services/models/models.dart';

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

  Future<void> removeByModel(RunRecordModel runRecordModel) async {
    assert(runRecordModel.runCoverData.key != null && runRecordModel.runCoverData.key != null);

    await Future.wait([
      _runCoverRepository.removeByKey(runRecordModel.runCoverData.key!),
      _runPointsRepository.removeByKey(runRecordModel.runPointsData.key!),
    ]);
  }

  /// return path to file
  Future<String> export(RunRecordModel runRecordModel) async {
    final directory = await pp.getDownloadsDirectory();
    final jsonString = json.encode(runRecordModel);
    final fileName = getFileNameByModel(runRecordModel);
    final fullPath = "${directory!.path}/$fileName.json";
    final file = File(fullPath);

    await file.writeAsString(jsonString, mode: FileMode.writeOnly);

    return fullPath;
  }

  String getFileNameByModel(RunRecordModel runRecordModel) {
    return runRecordModel.runCoverData.title.isNotEmpty
        ? runRecordModel.runCoverData.title
        : runRecordModel.runCoverData.startDateTime.toIso8601String();
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
