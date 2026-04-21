import 'package:fftea/fftea.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/DashboardChart.dart';

class FFTChartUpdated extends StatefulWidget {
  const FFTChartUpdated({super.key});

  @override
  State<FFTChartUpdated> createState() => FFTChartUpdatedState();
}

class FFTChartUpdatedState extends State<FFTChartUpdated> {
  static const frameRate = 30;
  List<FlSpot> fftSpots = [];

  @override
  Widget build(BuildContext context) {
    return DashboardChart(spots: fftSpots, title: "fft spectogram", allowTouch: true,);
  }

  void updateFFT(List<FlSpot> prepearedSpots) {
    final gridInterpolator = GridLinearInterpolation(1 / frameRate);
    final values = <double>[];
    for (final spot in prepearedSpots) {
      values.addAll(
        gridInterpolator.interpolate(spot.x, spot.y).map((r) => r.$2),
      );
    }

    final fft = FFT(values.length);

    final fftResult = fft.realFft(values);
    fftSpots = fftResult
        .magnitudes()
        .take((fft.size / 2).floor())
        .indexed
        .map((m) => FlSpot(m.$1.toDouble(), m.$2))
        .toList();
  }
}
