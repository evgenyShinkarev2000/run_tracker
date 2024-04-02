import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';

import 'IntervalType.dart';

class DropDownControls extends StatefulWidget {
  void Function(double? distance) onSelectDistance;
  double initialDistance;
  void Function(Duration? duration) onSelectDuration;
  Duration initialDuration;
  void Function(IntervalType? intervalType) onSelectIntervalType;
  IntervalType intervalTypeInitial;

  DropDownControls(
      {required this.onSelectDistance,
      required this.initialDistance,
      required this.onSelectDuration,
      required this.initialDuration,
      required this.onSelectIntervalType,
      required this.intervalTypeInitial});

  @override
  State<DropDownControls> createState() => _DropDownControlsState();
}

class _DropDownControlsState extends State<DropDownControls> {
  late IntervalType intervalType;

  @override
  void initState() {
    intervalType = widget.intervalTypeInitial;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: LayoutBuilder(builder: (context, constraints) {
        final dropdownWidth = constraints.maxWidth / 2 - 8;
        var index = 0;
        switch (intervalType) {
          case IntervalType.distance:
            index = 0;
            break;
          case IntervalType.time:
            index = 1;
            break;
        }

        return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IndexedStack(
            index: index,
            children: [
              DropdownMenu<double>(
                searchCallback: (entries, query) =>
                    entries.indexWhere((element) => element.label.compareTo(query) == 0),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 100, label: "0.1"),
                  DropdownMenuEntry(value: 500, label: "0.5"),
                  DropdownMenuEntry(value: 1000, label: "1"),
                  DropdownMenuEntry(value: 5000, label: "5"),
                ],
                initialSelection: widget.initialDistance,
                onSelected: widget.onSelectDistance,
                label: Text("${context.appLocalization.nounDistance}, ${context.appLocalization.unitShortKm}"),
                width: dropdownWidth,
              ),
              DropdownMenu<Duration>(
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: Duration(minutes: 1), label: "1 ${context.appLocalization.unitShortMinute}"),
                  DropdownMenuEntry(value: Duration(minutes: 5), label: "5 ${context.appLocalization.unitShortMinute}"),
                  DropdownMenuEntry(
                      value: Duration(minutes: 10), label: "10 ${context.appLocalization.unitShortMinute}"),
                ],
                initialSelection: widget.initialDuration,
                onSelected: widget.onSelectDuration,
                label: Text(
                  context.appLocalization.nounInterval,
                ),
                width: dropdownWidth,
              ),
            ],
          ),
          SizedBox(width: 16),
          DropdownMenu(
            dropdownMenuEntries: [
              DropdownMenuEntry(value: IntervalType.distance, label: context.appLocalization.nounDistance),
              DropdownMenuEntry(value: IntervalType.time, label: context.appLocalization.nounTime),
            ],
            initialSelection: IntervalType.distance,
            onSelected: setIntervalType,
            label: Text(context.appLocalization.runRecordBarIntervalType),
            width: dropdownWidth,
          ),
        ]);
      }),
    );
  }

  void setIntervalType(IntervalType? intervalType) {
    if (intervalType == null) {
      return;
    }

    setState(() {
      this.intervalType = intervalType;
    });
    widget.onSelectIntervalType(intervalType);
  }
}
