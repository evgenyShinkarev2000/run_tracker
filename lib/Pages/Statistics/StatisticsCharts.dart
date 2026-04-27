import 'package:flutter/material.dart' hide Interval;
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsChart.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsInterval.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsService.dart';

class StatisticsCharts extends StatelessWidget {
  final StatisticsInterval intervalKind;
  final List<Interval> intervals;

  const StatisticsCharts({
    super.key,
    required this.intervalKind,
    required this.intervals,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticsChart(
      intervalKind: intervalKind,
      intervals: intervals,
      formatLeftTouchY: _yToDistanceTouch,
      formatLeftTitlesY: _yToDistanceTitle,
      getLeftY: _getDistance,
      formatRightTouchY: _yToDurationTouch,
      formatRightTitlesY: _yToDurationTitle,
      getRightY: _getDuration,
      leftColor: Colors.lightBlue,
      rightColor: Colors.lightGreen,
    );
  }

  static double _getDistance(Interval interval) => interval.distance.meters;
  static String _yToDistanceTouch(double value) =>
      (value / 1000).toStringAsFixed(3);
  static String _yToDistanceTitle(double value) =>
      (value / 1000).toStringAsFixed(0);

  static double _getDuration(Interval interval) =>
      interval.duration.inSecondsDouble;
  static String _yToDurationTouch(double value) =>
      Duration(microseconds: (value * 1e6).toInt()).HH_noPad_mmss;
  static String _yToDurationTitle(double value) =>
      Duration(microseconds: (value * 1e6).toInt()).HH_noPad_mm;
}
