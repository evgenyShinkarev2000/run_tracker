import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/Pulse/ManualTab.dart';
import 'package:run_tracker/Pages/Pulse/MetronomeTab.dart';
import 'package:run_tracker/Pages/Pulse/PPGTab.dart';
import 'package:run_tracker/Services/Pulse/PulseMeasureKind.dart';
import 'package:run_tracker/localization/export.dart';

class PulseCard extends StatelessWidget {
  final void Function(double? pulseBPM)? onPulseChanged;
  final void Function(PulseMeasureKind pulseMeasureKind)?
  onPulseMeasureKindChanged;
  final PulseMeasureKind initialPulseMeasureKind;
  final bool showManual;

  const PulseCard({
    super.key,
    this.showManual = true,
    this.onPulseChanged,
    this.onPulseMeasureKindChanged,
    this.initialPulseMeasureKind = .metronome,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _pulseMeausureKindToIndex(initialPulseMeasureKind),
      length: 2 + (showManual ? 1 : 0),
      child: Column(
        children: [
          TabBar(
            onFocusChange: _handleTabChanged,
            tabs: [
              Tab(text: context.appLocalization.pulseMeasureTabMetronome),
              Tab(text: context.appLocalization.pulseMeasureTabCamera),
              showManual
                  ? Tab(text: context.appLocalization.pulseMeasureTabManual)
                  : null,
            ].nonNulls.toList(),
          ),
          Expanded(
            child: TabBarView(
              children: [
                MetronomeTab(onPulseChanged: onPulseChanged),
                PPGTab(onPulseChanged: onPulseChanged),
                showManual ? ManualTab(onPulseChanged: onPulseChanged) : null,
              ].nonNulls.toList(),
            ),
          ),
        ],
      ),
    );
  }

  static int _pulseMeausureKindToIndex(PulseMeasureKind measureKind) {
    return switch (measureKind) {
      .metronome => 0,
      .ppg => 1,
      .manual => 2,
    };
  }

  void _handleTabChanged(bool isFocused, int index) {
    if (!isFocused) {
      return;
    }

    final PulseMeasureKind measureKind = switch (index) {
      0 => .metronome,
      1 => .ppg,
      2 => .ppg,
      _ => throw AppException(
        message: "_PulseCardState._handleTabChanged: unknown tab index $index",
      ),
    };
    onPulseMeasureKindChanged?.call(measureKind);
    onPulseChanged?.call(null);
  }
}
