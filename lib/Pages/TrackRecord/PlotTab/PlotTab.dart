import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/NiceChart.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/localization/export.dart';

class PlotTab extends StatefulWidget {
  final TrackRecordWithSummaryAndPoints trackRecord;

  const PlotTab({super.key, required this.trackRecord});

  @override
  State<PlotTab> createState() => _PlotTabState();
}

class _PlotTabState extends State<PlotTab> {
  late final List<FlSpot> speedSpots = [];
  late final List<FlSpot> heightSpots = [];
  late double maxX;

  @override
  void initState() {
    super.initState();

    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            NiceChart(
              title:
                  "${context.appLocalization.nounSpeed}, ${context.appLocalization.unitShortKmPerHour}",
              rawSpots: speedSpots,
              maxX: maxX,
              outlierInterval: 5,
              isZeroBasedY: true,
              mapYToView: _yToSpeed,
              mapXToView: _xToDuration,
            ),
            NiceChart(
              title:
                  "${context.appLocalization.nounHeight}, ${context.appLocalization.unitShortM}",
              rawSpots: heightSpots,
              outlierInterval: 5,
              maxX: maxX,
              mapYToView: _yToHeight,
              mapXToView: _xToDuration,
            ),
            //TODO график пульса
          ],
        ),
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
          heightSpots.add(FlSpot(offset, point.altitude!));
        }
        if (prevPosition == null) {
          prevPosition = point;
          continue;
        }
        final distance = point.tryFindDistanceMeters(prevPosition);
        if (distance != null) {
          speedSpots.add(
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

  static String _yToSpeed(double y) =>
      Speed.metersPerSecondToKilometersPerHour(y).toStringAsFixed(1);
  static String _yToHeight(double y) => y.toStringAsFixed(0);
  static String _xToDuration(double x) => Duration(seconds: x.toInt()).HH_noPad_mmss;
}
