import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/PrepareSpot.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:run_tracker/Services/export.dart';

class PlotTab extends StatefulWidget {
  final TrackRecordWithSummaryAndPoints trackRecord;

  const PlotTab({super.key, required this.trackRecord});

  @override
  State<PlotTab> createState() => _PlotTabState();
}

class _PlotTabState extends State<PlotTab> {
  LineChartData speedChartData = LineChartData();
  LineChartData heightChartData = LineChartData();
  late final List<FlSpot> rawSpeedSpots = [];
  late final List<FlSpot> rawHeightSpots = [];
  List<FlSpot> preparedSpeedSpots = [];
  List<FlSpot> preparedHeightSpots = [];
  late double maxX;

  @override
  void initState() {
    super.initState();

    _initData();
    _updateCharts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(aspectRatio: 1.6, child: LineChart(speedChartData)),
          AspectRatio(aspectRatio: 1.6, child: LineChart(heightChartData)),
        ],
      ),
    );
  }

  void _initData() {
    if (widget.trackRecord.points.orderedPoints.isEmpty) {
      return;
    }
    final DateTime startDateTime =
        widget.trackRecord.points.orderedPoints.first.createdAt;
    PositionPoint? prevPosition;

    for (var path in widget.trackRecord.points.splitActiveSegments()) {
      prevPosition = null;
      for (var point in path) {
        final offset = point.createdAt
            .difference(startDateTime)
            .inSecondsDouble;
        if (point.altitude != null) {
          rawHeightSpots.add(FlSpot(offset, point.altitude!));
        }
        if (prevPosition == null) {
          prevPosition = point;
          continue;
        }
        final distance = point.tryFindDistanceMeters(prevPosition);
        if (distance != null) {
          rawSpeedSpots.add(
            FlSpot(
              offset,
              distance /
                  (point.createdAt
                      .difference(prevPosition.createdAt)
                      .inSecondsDouble),
            ),
          );
        }
      }
    }

    maxX = widget.trackRecord.points.orderedPoints.last.createdAt
        .difference(widget.trackRecord.points.orderedPoints.first.createdAt)
        .inSecondsDouble;
  }

  void _updateCharts() {
    final prepareSpots = PrepareSpots();
    final screen = WidgetsBinding.instance.platformDispatcher.views.first;
    final prepareParams = PrepareSpotsParams(
      applyDownSampling: true,
      applyMovingAverage: true,
      downSamplingThreshold: 
          (screen.physicalSize.width / screen.devicePixelRatio).floor(),
      movingAverageInterval: 5,
    );

    preparedSpeedSpots = prepareSpots
        .process(prepareParams, rawSpeedSpots)
        .toList();
    preparedHeightSpots = prepareSpots
        .process(prepareParams, rawHeightSpots)
        .toList();

    speedChartData = LineChartData(
      minX: 0,
      maxX: maxX,
      minY: 0,
      lineBarsData: [LineChartBarData(spots: preparedSpeedSpots)],
    );
    heightChartData = LineChartData(
      minX: 0,
      maxX: maxX,
      lineBarsData: [LineChartBarData(spots: preparedHeightSpots)],
    );
  }
}
