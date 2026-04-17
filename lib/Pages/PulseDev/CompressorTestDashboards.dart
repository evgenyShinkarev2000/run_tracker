import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/PulseDev/DashboardChart.dart';
import 'package:run_tracker/Pages/PulseDev/Dashboards.dart';

class CompressorTestDashboards extends StatefulWidget {
  const CompressorTestDashboards({super.key});

  @override
  State<CompressorTestDashboards> createState() =>
      _CompressorTestDashboardsState();
}

class _CompressorTestDashboardsState extends State<CompressorTestDashboards> {
  List<FlSpot> rawSin = [];
  List<FlSpot> compressedSin = [];
  List<FlSpot> biasSin = [];
  List<FlSpot> compressedBiasSin = [];

  double? minRawX;
  double? maxRawX;
  double? minRawY;
  double? maxRawY;
  double? minBiasX;
  double? maxBiasX;
  double? minBiasY;
  double? maxBiasY;

  @override
  void initState() {
    super.initState();

    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: _handleUpdateButtonPressed,
          child: Text("update"),
        ),
        Expanded(
          child: Dashboards(
            width: 2000,
            height: 1000,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardChart(
                          title: "raw sin",
                          spots: rawSin,
                          minX: minRawX,
                          maxX: maxRawX,
                          minY: minRawY,
                          maxY: maxRawY,
                        ),
                      ),
                      Expanded(
                        child: DashboardChart(
                          title: "compressed",
                          spots: compressedSin,
                          minX: minRawX,
                          maxX: maxRawX,
                          minY: minRawY,
                          maxY: maxRawY,
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: DashboardChart(
                          title: "bias sin",
                          spots: biasSin,
                          minX: minBiasX,
                          maxX: maxBiasX,
                          minY: minBiasY,
                          maxY: maxBiasY,
                        ),
                      ),
                      Expanded(
                        child: DashboardChart(
                          title: "bias sin compressed",
                          spots: compressedBiasSin,
                          minX: minBiasX,
                          maxX: maxBiasX,
                          minY: minBiasY,
                          maxY: maxBiasY,
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
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

  void _update() {
    rawSin = _buildSin(Duration(seconds: 10), 30, 3).toList();
    minRawX = rawSin.firstOrNull?.x;
    maxRawX = rawSin.lastOrNull?.x;
    final minMax = rawSin.selectMinMaxNum((s) => s.y);
    minRawY = minMax?.$1;
    maxRawY = minMax?.$2;
    compressedSin = _compress(rawSin).toList();

    biasSin = _buildSin(Duration(seconds: 10), 30, 1.2).indexed.map((i) {
      if (i.$1 < rawSin.length) {
        return i.$2.copyWith(y: i.$2.y + rawSin[i.$1].y);
      }

      return i.$2;
    }).toList();
    compressedBiasSin = _compress(biasSin).toList();
  }

  void _handleUpdateButtonPressed() {
    setState(() {
      _update();
    });
  }

  static Iterable<double> _getFrames(Duration duration, double frameRate) {
    return Iterable.generate(
      (duration.inSecondsDouble * frameRate).toInt(),
      (i) => i / frameRate,
    );
  }

  static Iterable<FlSpot> _compress(Iterable<FlSpot> spots) {
    final compressor = CompressorGeneric<FlSpot>.symmetricQuantilePow(
      getX: (s) => s.x,
      getY: (s) => s.y,
      interval: 5,
      power: 0.5,
      quantile: 50,
    );

    return compressor.compress(spots).map((s) => s.$1.copyWith(y: s.$2));
  }

  static Iterable<FlSpot> _buildSin(
    Duration duration,
    double frameRate,
    double periodCount,
  ) {
    final radianPerSecond =
        CompressorFunctions.interpolationParameter(
          duration.inSecondsDouble,
          0,
          pi * 2,
        ) /
        periodCount *
        2 *
        pi;

    return _getFrames(
      duration,
      frameRate,
    ).map((t) => FlSpot(t, sin(t * radianPerSecond)));
  }
}
