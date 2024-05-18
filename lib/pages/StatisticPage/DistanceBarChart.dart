import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/DoubleExtension.dart';
import 'package:run_tracker/pages/StatisticPage/BarChartTimeInterval.dart';
import 'package:run_tracker/pages/StatisticPage/BaseBarChart.dart';

class DistanceBarChart extends StatelessWidget {
  final BarChartTimeInterval barChartTimeMode;
  final int dayInMonth;
  final Map<int, double> rods;

  DistanceBarChart({
    required this.barChartTimeMode,
    required this.dayInMonth,
    required this.rods,
  });

  @override
  Widget build(BuildContext context) {
    return BaseBarChart(
      barChartTimeMode: barChartTimeMode,
      dayInMonth: dayInMonth,
      rods: rods,
      getTouchTooltip: (value) => (value / 1000.0).roundTo(3).toStringWithoutTrailingZeros(3),
      getLeftTitlesWidget: (value, meta) => Text(
        (value / 1000).roundTo(1).toStringWithoutTrailingZeros(1),
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}
