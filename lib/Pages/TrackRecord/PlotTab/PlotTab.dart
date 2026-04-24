import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/PlotTabInner.dart';
import 'package:run_tracker/Services/Track/export.dart';

class PlotTab extends StatelessWidget {
  final TrackRecordWithSummaryAndPointAndPulse trackRecord;

  const PlotTab({super.key, required this.trackRecord});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlotTabInner(trackRecord: trackRecord),
      ),
    );
  }
}
