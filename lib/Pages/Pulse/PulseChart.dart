import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PulseChart extends StatelessWidget {
  final List<FlSpot> spots;
  final double minX;
  final double maxX;
  final double? minY;
  final double? maxY;
  final GlobalKey _emptyKey = GlobalKey(debugLabel: "empty line chart");

  PulseChart({
    super.key,
    required this.spots,
    required this.minX,
    required this.maxX,
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      // prevent LateInitializationError: Field 'mostLeftSpot' has not been initialized.The relevant error-causing widget was: LineChart
      // key: spots.isEmpty ? _emptyKey : null,
      LineChartData(
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(spots: spots, dotData: FlDotData(show: false)),
        ],
        lineTouchData: LineTouchData(enabled: false),
        titlesData: FlTitlesData(show: false),
        clipData: FlClipData.all(),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
