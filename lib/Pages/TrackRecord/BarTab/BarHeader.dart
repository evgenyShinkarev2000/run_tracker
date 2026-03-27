import 'package:flutter/material.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/IntervalType.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/UnitType.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class BarHeader extends StatelessWidget {
  final UnitType unitType;
  final void Function(UnitType unitType) onUnitTypeChange;
  final IntervalType intervalType;

  const BarHeader({
    super.key,
    required this.unitType,
    required this.onUnitTypeChange,
    required this.intervalType,
  });

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

    return Row(
      spacing: 8,
      children: [
        SizedBox(
          width: 40,
          child: Text(
            _getIntervalText(context),
            overflow: TextOverflow.clip,
            maxLines: 1,
            softWrap: false,
          ),
        ),
        SizedBox(height: 16, width: 1, child: VerticalDivider()),
        Expanded(
          child: DropdownButton<UnitType>(
            underline: SizedBox(),
            value: unitType,
            onChanged: _handleUnitTypeSelected,
            dropdownColor: context.themeData.colorScheme.surfaceContainer,
            items: [
              DropdownMenuItem(
                value: UnitType.speed,
                child: Text(
                  "${context.appLocalization.nounSpeed}, ${context.appLocalization.unitShortKmPerHour}",
                ),
              ),
              DropdownMenuItem(
                value: UnitType.pace,
                child: Text(
                  "${context.appLocalization.nounPace}, ${context.appLocalization.unitShortMinPerKm}",
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16, width: 1, child: VerticalDivider()),
        SizedBox(
          width: 80,
          child: Text(
            "${context.appLocalization.nounHeight}, ${context.appLocalization.unitShortM}",
            overflow: .clip,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ],
    );
  }

  void _handleUnitTypeSelected(UnitType? unitType) {
    if (unitType == null) {
      return;
    }

    onUnitTypeChange(unitType);
  }

  String _getIntervalText(BuildContext context) {
    return switch (intervalType) {
      .distance => context.appLocalization.unitShortKm,
      .time => context.appLocalization.unitShortMinute,
    };
  }
}
