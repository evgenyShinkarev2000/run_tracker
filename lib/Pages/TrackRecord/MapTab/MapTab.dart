import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/TrackRecord/MapTab/MapTabInnerdart.dart';
import 'package:run_tracker/Services/Track/export.dart';

class MapTab extends StatelessWidget {
  final TrackRecordWithSummaryAndPoints trackRecord;

  const MapTab({super.key, required this.trackRecord});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: MapTabInner(trackRecord: trackRecord));
  }
}
