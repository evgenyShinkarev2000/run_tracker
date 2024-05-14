library chart_tab;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DoubleExtension.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';
import 'package:run_tracker/helpers/extensions/IterableExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/ValueWithUnit.dart';
import 'package:run_tracker/services/models/models.dart';

part "ChartBase.dart";
part "ChartHelper.dart";
part "PulseChart.dart";
part "SpeedChart.dart";

class RunRecordChartTab extends StatelessWidget {
  final RunRecordModel runRecordModel;

  RunRecordChartTab({required this.runRecordModel});

  @override
  Widget build(BuildContext context) {
    if (runRecordModel.runPointsData.geolocations.isEmpty) {
      return Center(child: Text(context.appLocalization.nounNoData));
    }
    final startTimeOffset = runRecordModel.runCoverData.startDateTime.microsecondsSinceEpoch;
    const minX = 0.0;
    final maxX = runRecordModel.runCoverData.duration.toDouble();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueWithUnit(
                value: context.appLocalization.nounSpeed,
                unit: context.appLocalization.unitShortKmPerHour,
              ),
            ],
          ),
          SpeedChart(
            spots: runRecordModel.runPointsData.geolocations
                .where((g) => g.speed != null)
                .map((g) => FlSpot((g.dateTime.microsecondsSinceEpoch - startTimeOffset).toDouble(), g.speed!))
                .toList(),
            minX: minX,
            maxX: maxX,
          ),
        ],
      ),
    );
  }
}
