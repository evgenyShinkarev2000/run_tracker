import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Theme/export.dart';

class DashboardChart extends StatelessWidget {
  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;
  final List<FlSpot> spots;
  final String? title;
  final bool allowTouch;
  final int roundX;

  const DashboardChart({
    super.key,
    required this.spots,
    this.title,
    this.minX,
    this.maxX,
    this.maxY,
    this.minY,
    this.allowTouch = false,
    this.roundX = 1,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.themeData.textTheme.bodyMedium!;
    final touchTooltipBackgroundColor =
        context.themeData.colorScheme.surfaceContainer;
    Color getBackgroundColor(LineBarSpot _) => touchTooltipBackgroundColor;
    List<LineTooltipItem> getLineTooltipItems(List<LineBarSpot> touchedSpots) =>
        touchedSpots
            .map(
              (ts) => LineTooltipItem(
                "${ts.y.toStringAsFixed(1)}\n${ts.x.toStringAsFixed(roundX)}",
                textStyle,
              ),
            )
            .toList();

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
              lineTouchData: LineTouchData(
                enabled: allowTouch,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: getBackgroundColor,
                  getTooltipItems: getLineTooltipItems,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
