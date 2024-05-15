import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/RunRecordPage/RunRecordBarTab/IntervalType.dart';

class RunRecordBarHeader extends StatefulWidget {
  final IntervalType intervalType;
  final UnitType initialUnitType;
  final double gap;
  final void Function(UnitType? unitType) onSelectUnitType;

  RunRecordBarHeader({
    required this.intervalType,
    required this.initialUnitType,
    required this.onSelectUnitType,
    this.gap = 16,
  });

  @override
  State<RunRecordBarHeader> createState() => _RunRecordBarHeaderState();
}

class _RunRecordBarHeaderState extends State<RunRecordBarHeader> {
  late UnitType unitType;

  Widget get Gap => SizedBox(width: widget.gap);
  Widget get Divider => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: VerticalDivider(
          width: 0,
        ),
      );

  @override
  void initState() {
    unitType = widget.initialUnitType;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final inputTheme = context.themeData.inputDecorationTheme;
    inputTheme.copyWith(
      disabledBorder: InputBorder.none,
      outlineBorder: BorderSide.none,
      isDense: true,
      contentPadding: EdgeInsets.zero,
      activeIndicatorBorder: BorderSide.none,
      constraints: BoxConstraints.tight(Size.zero),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.themeData.appBarTheme.backgroundColor,
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: getIntervalWidget(context),
            ),
            Gap,
            Divider,
            Gap,
            DropdownMenu(
              width: 160,
              textStyle: context.themeData.textTheme.bodyMedium,
              dropdownMenuEntries: [
                DropdownMenuEntry(
                  value: UnitType.speed,
                  label: "${context.appLocalization.nounSpeed}, ${context.appLocalization.unitShortKmPerHour}",
                ),
                DropdownMenuEntry(
                  value: UnitType.pace,
                  label: "${context.appLocalization.nounPace}, ${context.appLocalization.unitShortMinPerKm}",
                ),
              ],
              initialSelection: unitType,
              onSelected: setUnitType,
              inputDecorationTheme: inputTheme,
            ),
            Expanded(
              child: SizedBox(),
            ),
            Gap,
            Divider,
            Gap,
            SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.appLocalization.nounHeight,
                    style: context.themeData.textTheme.bodyMedium,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                  ),
                  Text(
                    context.appLocalization.unitShortM,
                    style: context.themeData.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getIntervalWidget(BuildContext context) {
    switch (widget.intervalType) {
      case IntervalType.distance:
        return Center(
          child: Text(
            context.appLocalization.unitShortKm,
            style: context.themeData.textTheme.bodyMedium,
          ),
        );
      case IntervalType.time:
        return Center(
          child: Text(
            context.appLocalization.nounTime,
            style: context.themeData.textTheme.bodyMedium,
          ),
        );
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
