import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PulsePlot extends StatelessWidget {
  final List<FlSpot> points;

  PulsePlot({required this.points});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            dotData: FlDotData(show: false),
            spots: points,
          ),
        ],
      ),
    );
  }
}
