import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/IntervalType.dart';
import 'package:run_tracker/localization/export.dart';

class DropDownControls extends StatelessWidget {
  static const List<DropdownMenuEntry<Duration>> durations = [
    DropdownMenuEntry(value: Duration(minutes: 1), label: "1"),
    DropdownMenuEntry(value: Duration(minutes: 2), label: "2"),
    DropdownMenuEntry(value: Duration(minutes: 3), label: "3"),
    DropdownMenuEntry(value: Duration(minutes: 5), label: "5"),
    DropdownMenuEntry(value: Duration(minutes: 10), label: "10"),
  ];
  static const List<DropdownMenuEntry<Distance>> disntances = [
    DropdownMenuEntry(value: Distance(100), label: "0.1"),
    DropdownMenuEntry(value: Distance(500), label: "0.5"),
    DropdownMenuEntry(value: Distance(1000), label: "1"),
    DropdownMenuEntry(value: Distance(2000), label: "2"),
    DropdownMenuEntry(value: Distance(5000), label: "5"),
  ];

  final void Function(Distance distance) onDistanceChange;
  final Distance distance;
  final void Function(Duration duration) onDurationChange;
  final Duration duration;
  final void Function(IntervalType intervalType) onIntervalTypeChange;
  final IntervalType intervalType;

  const DropDownControls({
    super.key,
    required this.onDistanceChange,
    required this.distance,
    required this.onDurationChange,
    required this.duration,
    required this.onIntervalTypeChange,
    required this.intervalType,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnWidth = (constraints.maxWidth - 16) / 2;
        return Row(
          spacing: 16,
          children: [
            switch (intervalType) {
              .distance => DropdownMenu<Distance>(
                initialSelection: distance,
                onSelected: _setDistance,
                label: Text(
                  "${context.appLocalization.nounDistance}, ${context.appLocalization.unitShortKm}",
                ),
                width: columnWidth,
                dropdownMenuEntries: disntances,
                searchCallback: (entries, query) => entries.indexWhere((e) => e.label == query),
              ),
              .time => DropdownMenu<Duration>(
                initialSelection: duration,
                onSelected: _setDuration,
                label: Text(
                  "${context.appLocalization.nounInterval}, ${context.appLocalization.unitShortMinute}",
                ),
                width: columnWidth,
                dropdownMenuEntries: durations,
              ),
            },
    
            DropdownMenu(
              initialSelection: IntervalType.distance,
              onSelected: _setIntervalType,
              label: Text(context.appLocalization.runRecordBarIntervalType),
              width: columnWidth,
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: IntervalType.distance,
                  label: context.appLocalization.nounDistance,
                ),
                DropdownMenuEntry(
                  value: IntervalType.time,
                  label: context.appLocalization.nounTime,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _setIntervalType(IntervalType? intervalType) {
    if (intervalType == null) {
      return;
    }

    onIntervalTypeChange(intervalType);
  }

  void _setDuration(Duration? duration) {
    if (duration == null) {
      return;
    }

    onDurationChange(duration);
  }

  void _setDistance(Distance? distance) {
    if (distance == null) {
      return;
    }

    onDistanceChange(distance);
  }
}
