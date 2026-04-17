import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/BarTab.dart';
import 'package:run_tracker/Pages/TrackRecord/MapTab/MapTab.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/PlotTab.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Theme/export.dart';

class TrackRecordTabBar extends StatelessWidget {
  final TrackRecordWithSummaryAndPoints trackRecord;

  const TrackRecordTabBar({super.key, required this.trackRecord});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: context.themeData.colorScheme.secondaryContainer,
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.map_outlined)),
                Tab(icon: Icon(Icons.bar_chart_outlined)),
                Tab(icon: Icon(Icons.show_chart_outlined)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                MapTab(trackRecord: trackRecord),
                BarTab(trackRecord: trackRecord),
                PlotTab(trackRecord: trackRecord),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
