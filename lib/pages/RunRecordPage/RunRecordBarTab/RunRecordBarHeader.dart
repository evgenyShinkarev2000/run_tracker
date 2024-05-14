import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/IntervalType.dart';

class RunRecordBarHeader extends StatefulWidget {
  final IntervalType intervalType;
  final UnitType initialUnitType;
  final void Function(UnitType? unitType) onSelectUnitType;

  RunRecordBarHeader({required this.intervalType, required this.initialUnitType, required this.onSelectUnitType});

  @override
  State<RunRecordBarHeader> createState() => _RunRecordBarHeaderState();
}

class _RunRecordBarHeaderState extends State<RunRecordBarHeader> {
  late UnitType unitType;

  @override
  void initState() {
    unitType = widget.initialUnitType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.themeData.textTheme.bodyLarge;
    final inputTheme = context.themeData.inputDecorationTheme;
    inputTheme.copyWith(
      disabledBorder: InputBorder.none,
      outlineBorder: BorderSide.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
      activeIndicatorBorder: BorderSide.none,
      constraints: BoxConstraints.tight(Size.zero),
    );

    return ListTile(
      minLeadingWidth: 48,
      leading: Text(
        getIntervalLabel(),
        style: textStyle,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownMenu(
            width: 130,
            dropdownMenuEntries: [
              DropdownMenuEntry(value: UnitType.speed, label: context.appLocalization.nounSpeed),
              DropdownMenuEntry(value: UnitType.pace, label: context.appLocalization.nounPace),
            ],
            initialSelection: unitType,
            onSelected: setUnitType,
            inputDecorationTheme: inputTheme,
          ),
          Text(
            getUnitLabel(),
            style: textStyle,
          ),
        ],
      ),
      tileColor: context.themeData.appBarTheme.backgroundColor,
    );
  }

  String getIntervalLabel() {
    switch (widget.intervalType) {
      case IntervalType.distance:
        return context.appLocalization.unitShortKm;
      case IntervalType.time:
        return context.appLocalization.nounTime;
    }
  }

  String getUnitLabel() {
    switch (unitType) {
      case UnitType.speed:
        return context.appLocalization.unitShortKmPerHour;
      case UnitType.pace:
        return context.appLocalization.unitShortMinPerKm;
    }
  }

  void setUnitType(final UnitType? unitType) {
    if (unitType == null) {
      return;
    }

    setState(() {
      this.unitType = unitType;
    });

    widget.onSelectUnitType(unitType);
  }
}

enum UnitType {
  speed,
  pace,
}
