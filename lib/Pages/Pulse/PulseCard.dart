import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/Pulse/ManualTab.dart';
import 'package:run_tracker/Pages/Pulse/MetronomeTab.dart';
import 'package:run_tracker/Pages/Pulse/PPGTab.dart';
import 'package:run_tracker/localization/export.dart';

class PulseCard extends StatelessWidget {
  const PulseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: context.appLocalization.pulseMeasureTabMetronome),
              Tab(text: context.appLocalization.pulseMeasureTabCamera),
              Tab(text: context.appLocalization.pulseMeasureTabManual),
            ],
          ),
          Expanded(child: TabBarView(children: [MetronomeTab(), PPGTab(), ManualTab()])),
        ],
      ),
    );
  }
}
