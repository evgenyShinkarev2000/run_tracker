import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/TrackRecord/Components/TrackRecordMap.dart';
import 'package:run_tracker/Services/Track/export.dart';

class TrackRecordCard extends StatelessWidget {
  final TrackRecordWithSummaryAndPoints trackRecord;

  const TrackRecordCard({super.key, required this.trackRecord});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: TrackRecordMap(orderedPoints: trackRecord.points.orderedPoints),
        ),
      ],
    );
  }
}
