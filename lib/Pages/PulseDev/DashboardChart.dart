import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;
  final List<FlSpot> spots;
  final String? title;

  const DashboardChart({
    super.key,
    required this.spots,
    this.title,
    this.minX,
    this.maxX,
    this.maxY,
    this.minY,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title ?? ""),
        Flexible(
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              clipData: FlClipData.all(),
              lineBarsData: [
                LineChartBarData(spots: spots, dotData: FlDotData(show: false)),
              ],
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    maxIncluded: false,
                    minIncluded: false,
                    reservedSize: 48,
                  ),
                ),
              ),
              lineTouchData: LineTouchData(enabled: false),
            ),
          ),
        ),
      ],
    );
  }
}
