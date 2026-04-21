import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/DashboardChart.dart';
import 'package:run_tracker/Pages/PulseDev/FFTHelper.dart';
import 'package:run_tracker/Pages/PulseDev/TransformMethods.dart';

class FFTChartTimer extends StatefulWidget {
  final bool processFFT;
  final List<FlSpot> processedSpots;
  const FFTChartTimer({
    super.key,
    required this.processFFT,
    required this.processedSpots,
  });

  @override
  State<FFTChartTimer> createState() => _FFTChartTimerState();
}

class _FFTChartTimerState extends State<FFTChartTimer> {
  static const double frameRate = 30;
  static const double intervalSeconds = 3;

  final FFTHelper fft = FFTHelper(
    size: (frameRate * intervalSeconds).floor(),
    durationSeconds: 3,
    wantedFrequencyAccuracy: 1 / 60,
  );
  List<FlSpot> spectorgram = [];
  List<double> maxFrequencies = [];

  late final Timer timer;

  @override
  void initState() {
    super.initState();
    _update();

    timer = Timer.periodic(Duration(milliseconds: 500), _handleTimerTick);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "max frequencies: ${maxFrequencies.map((f) => f.toStringAsFixed(2)).join(", ")}",
        ),
        Text(
          "pulse: ${maxFrequencies.map((f) => (f * 60).toStringAsFixed(1)).join(", ")}",
        ),
        Expanded(child: DashboardChart(spots: spectorgram)),
      ],
    );
  }

  void clear() {
    setState(() {
      _clear();
    });
  }

  void _clear() {
    maxFrequencies = [];
    spectorgram = [];
  }

  void _handleTimerTick(Timer timer) {
    if (!widget.processFFT) {
      return;
    }

    setState(() {
      _update();
    });
  }

  void _update() {
    if (!_tryUpdateSpectogram()) {
      _clear();
    }
  }

  bool _tryUpdateSpectogram() {
    if (widget.processedSpots.length < fft.size ||
        widget.processedSpots.isEmpty ||
        widget.processedSpots.last.x - widget.processedSpots.first.x <
            intervalSeconds) {
      return false;
    }

    final minWantedX = widget.processedSpots.last.x - intervalSeconds;
    final minWantedXIndex =
        widget.processedSpots.indexWhere((s) => s.x > minWantedX) - 1;
    if (minWantedXIndex < 0) {
      throw AppException(
        message:
            "FFTChartTimer._tryUpdateSpectogram: minWantedXIndex < 0, check first if condition",
      );
    }

    final values = widget.processedSpots
        .skip(minWantedXIndex)
        .interpolateAll(1 / frameRate)
        .map((v) => v.y)
        .toList();

    if (values.length > fft.size) {
      values.removeRange(fft.size, values.length);
    }

    final fftSpectogram = fft.findSpectogram(values, maxFrequency: 4);
    spectorgram = fftSpectogram.spectogram.indexed
        .map((i) => FlSpot(fftSpectogram.indexToFrequency(i.$1), i.$2))
        .toList();
    final copy = List.of(spectorgram);
    copy.sort((a, b) => -a.y.compareTo(b.y));
    maxFrequencies = copy.take(3).map((s) => s.x).toList();

    return true;
  }
}
