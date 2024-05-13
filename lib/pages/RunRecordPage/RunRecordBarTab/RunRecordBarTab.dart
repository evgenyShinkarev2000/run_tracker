import 'package:flutter/material.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/helpers/SpeedHelper.dart';
import 'package:run_tracker/helpers/extensions/DoubleExtension.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/DropdownControls.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/RunRecordBarHeader.dart';
import 'package:run_tracker/services/RunRecordService.dart';
import 'package:run_tracker/services/models/models.dart';

import 'IntervalType.dart';
import 'RunRecordBarTable.dart';

class RunRecordBarTab extends StatefulWidget {
  final RunRecordModel runRecordModel;

  RunRecordBarTab({required this.runRecordModel});

  @override
  State<RunRecordBarTab> createState() => _RunRecordBarTabState();
}

class _RunRecordBarTabState extends State<RunRecordBarTab> {
  double distanceLimit = 1000;
  Duration timelimit = Duration(minutes: 5);
  IntervalType intervalType = IntervalType.distance;
  UnitType unitType = UnitType.speed;

  @override
  Widget build(BuildContext context) {
    final rowModels = getFormatedRows();

    return Column(
      children: [
        RunRecordBarHeader(
          intervalType: intervalType,
          onSelectUnitType: handleSelectUnitType,
          initialUnitType: unitType,
        ),
        RunRecordBarTable(rowModels: rowModels),
        DropDownControls(
          onSelectDistance: handleSelectDistanceLimit,
          initialDistance: distanceLimit,
          onSelectDuration: handleSelectTimeLimit,
          initialDuration: timelimit,
          onSelectIntervalType: handleSelectIntervalType,
          intervalTypeInitial: intervalType,
        )
      ],
    );
  }

  void handleSelectUnitType(final UnitType? unitType) {
    if (unitType == null) {
      return;
    }

    setState(() {
      this.unitType = unitType;
    });
  }

  void handleSelectDistanceLimit(final double? distance) {
    if (distance == null) {
      return;
    }

    setState(() {
      distanceLimit = distance;
    });
  }

  void handleSelectTimeLimit(final Duration? duration) {
    if (duration == null) {
      return;
    }

    setState(() {
      timelimit = duration;
    });
  }

  void handleSelectIntervalType(final IntervalType? intervalType) {
    if (intervalType == null) {
      return;
    }

    setState(() {
      this.intervalType = intervalType;
    });
  }

  List<RunRecordBarRowModel<String, String>> getFormatedRows() {
    final geolocations = RunRecordService.GetGeolocationsFromModel(widget.runRecordModel);
    String Function(double speed) speedTransform;
    switch (unitType) {
      case UnitType.speed:
        speedTransform = (speed) => SpeedHelper.meterPerSecondToKilometrPerHour(speed).toStringAsFixed(1);
        break;
      case UnitType.pace:
        speedTransform = (speed) => SpeedHelper.speedToPace(speed)!.mmss;
    }

    switch (intervalType) {
      case IntervalType.distance:
        var rowModels = geolocationsToRowModelsByDistance(geolocations, distanceLimit);
        var rowModelsWithLength = appendLength(rowModels);

        return rowModelsWithLength.map((row) {
          return RunRecordBarRowModel(
              (row.label / 1000).roundTo(3).toString().padRight(1, "0"), speedTransform(row.value), row.length);
        }).toList();
      case IntervalType.time:
        var rowModels = geolocationsToRowModelsByTime(geolocations, timelimit);
        var rowModelsWithLength = appendLength(rowModels);
        final hasHour = rowModels.any((row) => row.label.hours > 0);

        return rowModelsWithLength.map((row) {
          return RunRecordBarRowModel(
              hasHour ? row.label.hhmmss : row.label.mmss, speedTransform(row.value), row.length);
        }).toList();
    }
  }

  static List<RunRecordBarRowModel<Duration, double>> geolocationsToRowModelsByTime(
      List<RunPointGeolocation> points, Duration timeLimit) {
    //TODO segment doesn't match geolocation exactly
    if (points.isEmpty) {
      return List.empty();
    }

    final durationLimitMicroseconds = timeLimit.inMicroseconds;
    final rowModels = <RunRecordBarRowModel<Duration, double>>[];
    var distance = 0.0;
    var durationMicroseconds = 0;
    var segmentCount = 0;
    var previousPoint = points.first;

    for (var point in points.skip(1)) {
      distance += GeolocatorWrapper.distanceBetweenGeolocations(previousPoint.geolocation, point.geolocation);
      durationMicroseconds += point.dateTime.microsecondsSinceEpoch - previousPoint.dateTime.microsecondsSinceEpoch;
      if (durationMicroseconds > durationLimitMicroseconds) {
        ++segmentCount;
        rowModels.add(RunRecordBarRowModel(
            Duration(microseconds: segmentCount * durationLimitMicroseconds), distance / durationMicroseconds * 1e6));
        distance = 0;
        durationMicroseconds = 0;
      }
      previousPoint = point;
    }

    if (durationMicroseconds != 0) {
      rowModels.add(RunRecordBarRowModel(
          Duration(microseconds: segmentCount * durationLimitMicroseconds + durationMicroseconds),
          distance / durationMicroseconds * 1e6));
    }

    return rowModels;
  }

  static List<RunRecordBarRowModel<double, double>> geolocationsToRowModelsByDistance(
      List<RunPointGeolocation> points, double segmentLimit) {
    //TODO segment doesn't match geolocation exactly
    if (points.isEmpty) {
      return List.empty();
    }

    final rowModels = <RunRecordBarRowModel<double, double>>[];
    var distance = 0.0;
    var durationMicroseconds = 0;
    var segmentCount = 0;
    var previousPoint = points.first;

    for (var point in points.skip(1)) {
      distance += GeolocatorWrapper.distanceBetweenGeolocations(previousPoint.geolocation, point.geolocation);
      durationMicroseconds += point.dateTime.microsecondsSinceEpoch - previousPoint.dateTime.microsecondsSinceEpoch;
      if (distance > segmentLimit) {
        ++segmentCount;
        rowModels.add(RunRecordBarRowModel(segmentCount * segmentLimit, distance / durationMicroseconds * 1e6));
        distance = 0;
        durationMicroseconds = 0;
      }
      previousPoint = point;
    }

    if (distance != 0) {
      rowModels
          .add(RunRecordBarRowModel(segmentCount * segmentLimit + distance, distance / durationMicroseconds * 1e6));
    }

    return rowModels;
  }

  static List<RunRecordBarRowModel<TLabel, double>> appendLength<TLabel>(
      List<RunRecordBarRowModel<TLabel, double>> rowModels) {
    final maxSpeed = rowModels.max((row) => row.value)!.value;
    for (var row in rowModels) {
      row.length = row.value / maxSpeed;
    }

    return rowModels;
  }
}

class RunRecordBarRowModel<TLabel, TValue> {
  TLabel label;
  TValue value;
  double? length;

  RunRecordBarRowModel(this.label, this.value, [this.length]);
}
