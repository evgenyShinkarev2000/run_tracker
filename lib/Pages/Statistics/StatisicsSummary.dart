import 'package:flutter/material.dart' hide Interval;
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsService.dart';
import 'package:run_tracker/Pages/Statistics/SummaryRow.dart';
import 'package:run_tracker/localization/export.dart';

class StatisticsSummary extends StatefulWidget {
  final List<Interval> intervals;

  const StatisticsSummary({super.key, required this.intervals});

  @override
  State<StatisticsSummary> createState() => _StatisticsSummaryState();
}

class _StatisticsSummaryState extends State<StatisticsSummary> {
  double _distanceMeters = 0;
  double _durationSeconds = 0;

  @override
  void initState() {
    super.initState();

    _updateSummary();
  }

  @override
  void didUpdateWidget(covariant StatisticsSummary oldWidget) {
    if (oldWidget.intervals != widget.intervals) {
      _updateSummary();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        SummaryRow(
          title: context.appLocalization.nounDistance,
          value: _distanceMeters.toStringAsFixed(0),
          unit: context.appLocalization.unitShortM,
        ),
        SummaryRow(
          title: context.appLocalization.runCardCoverDuration,
          value: Duration(
            microseconds: (_durationSeconds * 1e6).toInt(),
          ).HH_noPad_mmss,
        ),
      ],
    );
  }

  void _updateSummary() {
    _distanceMeters = 0;
    _durationSeconds = 0;

    for (final interval in widget.intervals) {
      _distanceMeters += interval.distance.meters;
      _durationSeconds += interval.duration.inSecondsDouble;
    }
  }
}
