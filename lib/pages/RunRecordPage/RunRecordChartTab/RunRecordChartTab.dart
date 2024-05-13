import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/services/models/models.dart';

class RunRecordChartTab extends StatelessWidget {
  final RunRecordModel runRecordModel;

  RunRecordChartTab({required this.runRecordModel});

  @override
  Widget build(BuildContext context) {
    final minX = runRecordModel.runPointsData.start.dateTime.microsecondsSinceEpoch.toDouble();
    final maxX = runRecordModel.runPointsData.stop.dateTime.microsecondsSinceEpoch.toDouble();

    return Column(
      children: [
        Container(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: minX,
              maxX: maxX,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(),
                bottomTitles: AxisTitles(),
                rightTitles: AxisTitles(),
                topTitles: AxisTitles(),
              ),
              lineBarsData: [
                LineChartBarData(
                  dotData: FlDotData(show: false),
                  spots: runRecordModel.runPointsData.geolocations
                      .where((g) => g.speed != null)
                      .map((p) => FlSpot(p.dateTime.microsecondsSinceEpoch.toDouble(), p.speed!))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
