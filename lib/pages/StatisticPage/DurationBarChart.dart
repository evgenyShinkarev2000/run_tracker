import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';
import 'package:run_tracker/pages/StatisticPage/BarChartTimeInterval.dart';
import 'package:run_tracker/pages/StatisticPage/BaseBarChart.dart';

class DurationBarChart extends StatelessWidget {
  final BarChartTimeInterval barChartTimeMode;
  final int dayInMonth;
  final Map<int, Duration> rods;

  DurationBarChart({
    required this.barChartTimeMode,
    required this.dayInMonth,
    required this.rods,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBarChart(
        barChartTimeMode: barChartTimeMode,
        dayInMonth: dayInMonth,
        rods: rods.map((key, value) => MapEntry(key, value.inSecondsDouble)),
        getTouchTooltip: (value) {
          final duration = Duration(microseconds: (value * 1e6).round());

          return duration.hhmmss;
        },
        getLeftTitlesWidget: (value, meta) {
          final duration = Duration(microseconds: (value * 1e6).round());
          if (duration.inMinutes == 0 && value != meta.min) {
            return Container();
          }

          return Text(
            duration.inMinutes.toString(),
            maxLines: 1,
            textAlign: TextAlign.center,
          );
        });
  }
}
