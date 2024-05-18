import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:run_tracker/components/ValueWithUnit.dart';
import 'package:run_tracker/data/models/models.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/StatisticPage/BarChartTimeInterval.dart';
import 'package:run_tracker/pages/StatisticPage/DistanceBarChart.dart';
import 'package:run_tracker/pages/StatisticPage/DropdownControls.dart';
import 'package:run_tracker/pages/StatisticPage/DurationBarChart.dart';

class Gistograms extends StatefulWidget {
  final List<RunCoverData> runCovers;

  Gistograms({required this.runCovers});

  @override
  State<Gistograms> createState() => _GistogramsState();
}

class _GistogramsState extends State<Gistograms> {
  BarChartTimeInterval barChartTimeInterval = BarChartTimeInterval.week;
  late DateTime startDateTime;

  @override
  void initState() {
    startDateTime = DateHelper.dateTimeToStartInterval(DateTime.now(), BarChartTimeInterval.week);

    super.initState();
  }

  @override
  void dispose() {
    setVerticalOrientation();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dayInMonth = DateUtils.getDaysInMonth(startDateTime.year, startDateTime.month);
    final runCoversInsideInterval = getRunCoversInsideInterval();
    final groupedRunCovers = groupCoversByTime(runCoversInsideInterval);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          DropdownControls(
            startDateTime: startDateTime,
            onDateTimeSelected: handleSelectStartDate,
            timeIntervalSelection: barChartTimeInterval,
            onTimeIntervalSelected: handleSelectTimeInterval,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueWithUnit(value: context.appLocalization.nounDistance, unit: context.appLocalization.unitShortKm),
            ],
          ),
          SizedBox(height: 8),
          DistanceBarChart(
            barChartTimeMode: barChartTimeInterval,
            dayInMonth: dayInMonth,
            rods: aggregateDistance(groupedRunCovers),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueWithUnit(value: context.appLocalization.nounTime, unit: context.appLocalization.unitShortMinute),
            ],
          ),
          SizedBox(height: 8),
          DurationBarChart(
            barChartTimeMode: barChartTimeInterval,
            dayInMonth: dayInMonth,
            rods: aggregateTime(groupedRunCovers),
          ),
        ],
      ),
    );
  }

  Map<int, Duration> aggregateTime(Map<int, List<RunCoverData>> runCoversMap) {
    return runCoversMap.map((key, value) => MapEntry(key, Duration(microseconds: value.map((rc) => rc.duration).sum)));
  }

  Map<int, double> aggregateDistance(Map<int, List<RunCoverData>> runCoversMap) {
    return runCoversMap.map((key, value) => MapEntry(key, value.map((rc) => rc.distance).sum));
  }

  Iterable<RunCoverData> getRunCoversInsideInterval() {
    final endDateTime = getIntervalEndDateTime();

    return widget.runCovers
        .where((rc) => rc.startDateTime.isAfter(startDateTime) && rc.startDateTime.isBefore(endDateTime));
  }

  Map<int, List<RunCoverData>> groupCoversByTime(Iterable<RunCoverData> runCoversCut) {
    switch (barChartTimeInterval) {
      case BarChartTimeInterval.week:
        return runCoversCut.groupListsBy((rc) => rc.startDateTime.weekday - 1);
      case BarChartTimeInterval.month:
        return runCoversCut.groupListsBy((rc) => rc.startDateTime.day - 1);
      case BarChartTimeInterval.year:
        return runCoversCut.groupListsBy((rc) => rc.startDateTime.month - 1);
    }
  }

  DateTime getIntervalEndDateTime() {
    switch (barChartTimeInterval) {
      case BarChartTimeInterval.week:
        return startDateTime.add(Duration(days: 7));
      case BarChartTimeInterval.month:
        return startDateTime.add(Duration(days: DateUtils.getDaysInMonth(startDateTime.year, startDateTime.month)));
      case BarChartTimeInterval.year:
        return DateTime(startDateTime.year + 1);
    }
  }

  void handleSelectTimeInterval(BarChartTimeInterval? timeInverval) {
    if (timeInverval == null) {
      return;
    }

    setState(() {
      barChartTimeInterval = timeInverval;
      startDateTime = DateHelper.dateTimeToStartInterval(startDateTime, barChartTimeInterval);
    });

    switch (timeInverval) {
      case BarChartTimeInterval.week:
        setVerticalOrientation();
      default:
        setHorizontalOrientation();
    }
  }

  void handleSelectStartDate(DateTime dateTime) {
    setState(() {
      startDateTime = DateHelper.dateTimeToStartInterval(dateTime, barChartTimeInterval);
    });
  }

  void setVerticalOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  void setHorizontalOrientation() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }
}

class DateHelper {
  static DateTime dateTimeToStartInterval(DateTime dateTime, BarChartTimeInterval barChartTimeInterval) {
    switch (barChartTimeInterval) {
      case BarChartTimeInterval.week:
        final startDateTimeWithTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));

        return DateUtils.dateOnly(startDateTimeWithTime);

      case BarChartTimeInterval.month:
        return DateTime(dateTime.year, dateTime.month);
      case BarChartTimeInterval.year:
        return DateTime(dateTime.year);
    }
  }
}
