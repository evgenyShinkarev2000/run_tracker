import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:run_tracker/components/map_painter/MapPainterFull.dart';
import 'package:run_tracker/data/mappers/RunPointGeolocationDataToCore.dart';
import 'package:run_tracker/helpers/extensions/AppGeolocationExtension.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DateTimeExtension.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';
import 'package:run_tracker/helpers/SpeedHelper.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordRow.dart';
import 'package:run_tracker/services/models/RunRecordModel.dart';

class RunRecordMapTab extends StatelessWidget {
  final RunRecordModel runRecordModel;
  final RunPointGeolocationDataToCore runPointGeolocationDataToCore = RunPointGeolocationDataToCore();

  RunRecordMapTab({super.key, required this.runRecordModel});

  @override
  Widget build(BuildContext context) {
    final beginDateTimeLabel = context.appLocalization.runCardCoverBeginDateTime;
    final durationLabel = context.appLocalization.runCardCoverDuration;
    final distanceLabel = context.appLocalization.runCardCoverDistance;
    final speedLabel = context.appLocalization.runCardCoverSpeed;
    final paceLabel = context.appLocalization.runCardCoverPace;
    final pulseLabel = context.appLocalization.runcardCoverPulse;

    final geolocations = runRecordModel.runPointsData.geolocations
        .map((rpgd) => runPointGeolocationDataToCore.map(rpgd).geolocation.toLatLng())
        .toList();
    final start = runRecordModel.runPointsData.start.geolocation != null
        ? runPointGeolocationDataToCore.map(runRecordModel.runPointsData.start.geolocation!).geolocation.toLatLng()
        : null;
    final stop = runRecordModel.runPointsData.stop.geolocation != null
        ? runPointGeolocationDataToCore.map(runRecordModel.runPointsData.stop.geolocation!).geolocation.toLatLng()
        : null;

    return Column(children: [
      AspectRatio(
        aspectRatio: 1,
        child: MapPainterFull(
          geolocations: geolocations,
          start: start,
          stop: stop,
        ),
      ),
      Column(
        children: [
          RunRecordRow(
            beginDateTimeLabel,
            runRecordModel.runCoverData.startDateTime.dateSpaceTime,
          ),
          RunRecordRow(
            durationLabel,
            durationToView(Duration(microseconds: runRecordModel.runCoverData.duration)),
            isSelected: true,
          ),
          RunRecordRow(
            distanceLabel,
            runRecordModel.runCoverData.distance.round().toString(),
            unit: context.appLocalization.unitShortM,
          ),
          RunRecordRow(
            speedLabel,
            runRecordModel.runCoverData.averageSpeed?.round().toString() ?? "",
            unit: context.appLocalization.unitShortKmPerHour,
            isSelected: true,
          ),
          RunRecordRow(
            paceLabel,
            SpeedHelper.speedToPace(runRecordModel.runCoverData.averageSpeed)?.mmss ?? "0",
            unit: context.appLocalization.unitShortMinPerKm,
          ),
          RunRecordRow(
            pulseLabel,
            100.toString(),
            unit: context.appLocalization.unitShortBPM,
            isSelected: true,
          ),
        ],
      ),
    ]);
  }

  String durationToView(Duration duration) {
    return duration.hhmmss;
  }
}
