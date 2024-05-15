import 'package:flutter/material.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';
import 'package:run_tracker/helpers/extensions/DoubleExtension.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';
import 'package:run_tracker/helpers/units_helper/units_helper.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/DropdownControls.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/IntervalInfo.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/IntervalProcessor.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/RunRecordBarHeader.dart';
import 'package:run_tracker/services/RunRecordService.dart';
import 'package:run_tracker/services/models/models.dart';

import 'BarModel.dart';
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
  Duration timeLimit = Duration(minutes: 5);
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
        RunRecordBarTable(
          rowModels: rowModels,
          unitType: unitType,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: DropDownControls(
            onSelectDistance: handleSelectDistanceLimit,
            initialDistance: distanceLimit,
            onSelectDuration: handleSelectTimeLimit,
            initialDuration: timeLimit,
            onSelectIntervalType: handleSelectIntervalType,
            intervalTypeInitial: intervalType,
          ),
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
      timeLimit = duration;
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

  List<BarModel> getFormatedRows() {
    final geolocations = RunRecordService.GetGeolocationsFromModel(widget.runRecordModel);
    if (geolocations.isEmpty) {
      return List.empty();
    }

    String Function(Speed speed) speedToTitle;
    switch (unitType) {
      case UnitType.speed:
        speedToTitle = (speed) => speed.kilometersPerHour.toStringAsFixed(1);
      case UnitType.pace:
        speedToTitle = (speed) => speed.toPace().toDurationKm().mmss;
    }

    IntervalProcessor intervalProcessor;
    String Function(IntervalInfo intervalInfo, int index, int intervalCount) intervalInfoToLeading;
    switch (intervalType) {
      case IntervalType.time:
        intervalProcessor = IntervalByTime(timeLimit: timeLimit);
        intervalInfoToLeading = buildIntervalInfoToTimeTitle(timeLimit);
      case IntervalType.distance:
        intervalProcessor = IntervalByDistance(distanceLimit: distanceLimit);
        intervalInfoToLeading = buildIntervalInfoToDistanceTitle(distanceLimit);
    }

    final intervals = getIntervals(intervalProcessor, geolocations);

    return buildRows(intervals.toList(), speedToTitle, intervalInfoToLeading).toList();
  }

  static String Function(IntervalInfo, int, int) buildIntervalInfoToTimeTitle(Duration timeLimit) {
    return (intervalInfo, index, intervalCount) {
      Duration Function(Duration) roundDuration;
      if (index == intervalCount - 1) {
        roundDuration = (duration) =>
            Duration(microseconds: timeLimit.inMicroseconds * index + intervalInfo.duration.inMicroseconds);
      } else {
        roundDuration = (duration) => Duration(microseconds: timeLimit.inMicroseconds * (index + 1));
      }

      final roundedDuration = roundDuration(intervalInfo.duration);

      return roundedDuration.hours > 0 ? roundedDuration.hhmmss : roundedDuration.mmss;
    };
  }

  static String Function(IntervalInfo, int, int) buildIntervalInfoToDistanceTitle(double distanceLimit) {
    return (intervalInfo, index, intervalCount) {
      if (index == intervalCount - 1) {
        return ((distanceLimit * index + intervalInfo.distance) / 1000).toStringAsFixed(3);
      }

      return ((distanceLimit * (index + 1)) / 1000).toStringAsFixed(1);
    };
  }

  static Iterable<BarModel> buildRows(List<IntervalInfo> intervals, String Function(Speed) speedTitleSelector,
      String Function(IntervalInfo, int, int) leadingSelector) sync* {
    final speeds = intervals.map((i) => i.distance / i.duration.inSecondsDouble).toList();
    final maxSpeed = speeds.max((s) => s)!;
    double? previousHeight;

    var i = 0;
    final length = intervals.length;
    for (var interval in intervals) {
      String heightTrailing = "0";
      if (previousHeight != null) {
        final deltaHeight = (interval.averageHeight - previousHeight).roundTo(1);
        var sign = "";
        if (deltaHeight < 0) {
          sign = "-";
        } else if (deltaHeight > 0) {
          sign = "+";
        }
        heightTrailing = "$sign${deltaHeight.abs().toStringWithoutTrailingZeros()}";
      }

      yield BarModel(
        leading: leadingSelector(interval, i, length),
        value: speedTitleSelector((Speed.fromMetersPerSecond(speeds[i]))),
        trailing: heightTrailing,
        trackLength: speeds[i] / maxSpeed,
      );

      previousHeight = interval.averageHeight;
      ++i;
    }
  }

  static Iterable<IntervalInfo> getIntervals(
    IntervalProcessor intervalProcessor,
    Iterable<RunPointGeolocation> geolocations,
  ) sync* {
    var previousPoint = geolocations.first;
    var intervalDuration = Duration.zero;
    var intervalDistance = 0.0;
    var heightSum = previousPoint.geolocation.altitude;
    var pointsCount = 1;

    for (var point in geolocations.skip(1)) {
      ++pointsCount;
      heightSum += point.geolocation.altitude;
      final distance = GeolocatorWrapper.distanceBetweenGeolocations(previousPoint.geolocation, point.geolocation);
      final duration =
          Duration(microseconds: point.dateTime.microsecondsSinceEpoch - previousPoint.dateTime.microsecondsSinceEpoch);
      intervalProcessor.add(distance, duration);
      if (intervalProcessor.wasNewInterval) {
        yield IntervalInfo(
            distance: intervalDistance + distance - intervalProcessor.distanceRemainder,
            duration: intervalDuration + duration - intervalProcessor.durationRemainder,
            averageHeight: heightSum / pointsCount);

        intervalDistance = intervalProcessor.distanceRemainder;
        intervalDuration = intervalProcessor.durationRemainder;
        pointsCount = 0;
        heightSum = 0;
      } else {
        intervalDistance += distance;
        intervalDuration += duration;
      }
      previousPoint = point;
    }

    if (pointsCount != 0) {
      yield IntervalInfo(
        distance: intervalDistance,
        duration: intervalDuration,
        averageHeight: heightSum / pointsCount,
      );
    }
  }
}
