import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/TransformMethods.dart';
import 'package:run_tracker/Pages/PulseDev/DashboardChart.dart';
import 'package:run_tracker/Pages/PulseDev/Dashboards.dart';
import 'package:run_tracker/Services/Pulse/export.dart';

class PulseCharts extends StatefulWidget {
  const PulseCharts({super.key});

  @override
  State<PulseCharts> createState() => PulseChartsState();
}

class PulseChartsState extends State<PulseCharts> {
  static const double width = 2400;
  static const double height = 800;

  List<BrightnessWithDuration> data = [];
  List<FlSpot> rawDataSpots = [];
  List<FlSpot> data1 = [];
  List<FlSpot> data2 = [];
  List<FlSpot> data3 = [];

  RangeValues rangeValues = RangeValues(0, 0);
  double? minX;
  double? maxX;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text("no data"));
    }

    return Column(
      children: [
        RangeSlider(
          values: rangeValues,
          onChanged: _handleRangeValuesChanged,
          min: minX ?? 0,
          max: maxX ?? 0,
        ),
        TextButton(
          onPressed: _handleUpdateButtonPressed,
          child: Text("update"),
        ),
        Expanded(
          child: Dashboards(
            width: width,
            height: height,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardChart(
                          title: "raw data",
                          minX: rangeValues.start,
                          maxX: rangeValues.end,
                          spots: rawDataSpots,
                        ),
                      ),
                      Expanded(
                        child: DashboardChart(
                          title: "data 1",
                          minX: rangeValues.start,
                          maxX: rangeValues.end,
                          spots: data1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardChart(
                          title: "data 2",
                          minX: rangeValues.start,
                          maxX: rangeValues.end,
                          spots: data2,
                        ),
                      ),
                      Expanded(
                        child: DashboardChart(
                          title: "data 3",
                          minX: rangeValues.start,
                          maxX: rangeValues.end,
                          spots: data3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void updateCharts(List<BrightnessWithDuration> data) {
    this.data = data;
    setState(() {
      _updateLimits();
      _updateCharts();
    });
  }

  void _handleUpdateButtonPressed() {
    setState(() {
      _updateCharts();
    });
  }

  void _updateCharts() {
    rawDataSpots = data
        .map((e) => FlSpot(e.duration.inSecondsDouble, e.brightness))
        .toList();

    data2 = rawDataSpots
        .removeOffset(0.3)
        .average(0.3)
        .average(0.2)
        .average(0.1)
        .toList();

    final TransformBuilder _transform = TransformBuilder()
      ..removeOffset(0.3)
      ..average(0.3)
      ..average(0.2)
      ..average(0.1);

    data3 = [];
    for (final spot in rawDataSpots) {
      data3.addAll(_transform.add(spot));
    }
  }

  void _handleRangeValuesChanged(RangeValues values) {
    setState(() {
      rangeValues = values;
    });
  }

  void _updateLimits() {
    if (data.isEmpty) {
      minX = 0;
      maxX = 0;
      rangeValues = RangeValues(0, 0);

      return;
    }

    minX = data.first.duration.inSecondsDouble;
    maxX = data.last.duration.inSecondsDouble;
    rangeValues = RangeValues(minX!, maxX!);
  }
}
