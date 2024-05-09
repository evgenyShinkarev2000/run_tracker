import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/core/DataWithDateTime.dart';

class PulsePlot extends StatefulWidget {
  final Iterable<DataWithDateTime<double>> points;

  PulsePlot({required this.points});

  @override
  State<PulsePlot> createState() => _PulsePlotState();
}

class _PulsePlotState extends State<PulsePlot> {
  @override
  Widget build(BuildContext context) {
    var points = widget.points;
    var minX = 0.0;
    double? minY;
    double? maxY;
    if (points.isEmpty) {
      points = [
        DataWithDateTime(DateTime.fromMicrosecondsSinceEpoch(0), 0),
        DataWithDateTime(DateTime.fromMicrosecondsSinceEpoch(1), 0)
      ];
      minY = -1;
      maxY = 1;
    } else {
      minX = DateTime.now().subtract(Duration(seconds: 5)).microsecondsSinceEpoch.toDouble();
    }

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          show: false,
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        clipData: FlClipData.all(),
        minX: minX,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            dotData: FlDotData(show: false),
            spots: points.map((p) => FlSpot(p.dateTime.microsecondsSinceEpoch.toDouble(), p.data)).toList(),
          ),
        ],
      ),
    );
  }
}
