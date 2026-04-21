import 'package:fftea/fftea.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/DashboardChart.dart';
import 'package:run_tracker/Pages/PulseDev/Dashboards.dart';
import 'package:run_tracker/Pages/PulseDev/FFTHelper.dart';
import 'package:run_tracker/Pages/PulseDev/TransformMethods.dart';
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
  List<FlSpot> prepearedData = [];
  List<FlSpot> rawSpectogram = [];
  List<FlSpot> paddedSpectogram = [];

  RangeValues rangeValues = RangeValues(0, 0);
  double? minX;
  double? maxX;

  @override
  Widget build(BuildContext context) {
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
                          title: "prepearedData",
                          minX: rangeValues.start,
                          maxX: rangeValues.end,
                          spots: prepearedData,
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
                          title: "raw spectogram, x - index",
                          spots: rawSpectogram,
                          allowTouch: true,
                        ),
                      ),
                      Expanded(
                        child: DashboardChart(
                          title: "padded spectogram, x - frequency",
                          spots: paddedSpectogram,
                          allowTouch: true,
                          roundX: 2,
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

    prepearedData = rawDataSpots
        .removeOffset(0.3)
        .average(0.3)
        .average(0.2)
        .average(0.1)
        .toList();

    final interpolatedSpots = prepearedData.interpolateAll(1 / 30).toList();
    final maxInterpolatedX = interpolatedSpots.lastOrNull?.x;
    if (maxInterpolatedX != null) {
      updateFFT(interpolatedSpots.map((v) => v.y).toList(), maxInterpolatedX);
    } else {
      rawSpectogram = [];
      paddedSpectogram = [];
    }
  }

  void updateFFT(List<double> interpolated, double maxX) {
    final rawFFT = FFT(interpolated.length);
    final rawResult = rawFFT.realFft(interpolated);
    rawSpectogram = rawResult
        .magnitudes()
        .take((rawResult.length / 2).floor())
        .indexed
        .map((v) => FlSpot(v.$1.toDouble(), v.$2))
        .toList();

    final paddedFFT = FFTHelper(
      size: interpolated.length,
      durationSeconds: maxX,
      wantedFrequencyAccuracy: 1 / 60,
    );
    final spectogramResult = paddedFFT.findSpectogram(
      interpolated,
      maxFrequency: 4,
    );
    paddedSpectogram = spectogramResult.spectogram.indexed
        .map((v) => FlSpot(spectogramResult.indexToFrequency(v.$1), v.$2))
        .toList();
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
