import 'package:flutter/material.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/BarHeader.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/BarTable.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/DropDownControls.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/IntervalType.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/UnitType.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Theme/export.dart';

class BarTab extends StatefulWidget {
  final TrackRecordWithSummaryAndPoints trackRecord;
  const BarTab({super.key, required this.trackRecord});

  @override
  State<BarTab> createState() => _BarTabState();
}

class _BarTabState extends State<BarTab> {
  Distance distance = Distance(1000);
  Duration duration = Duration(minutes: 5);
  IntervalType intervalType = .distance;
  UnitType unitType = .speed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.themeData.colorScheme.secondaryContainer,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: BarHeader(
            unitType: unitType,
            onUnitTypeChange: _handleUnitTypeChange,
            intervalType: intervalType,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 8),
          child: Divider(height: 1),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BarTable(
              trackRecord: widget.trackRecord,
              intervalType: intervalType,
              unitType: unitType,
              durationInterval: duration,
              distanceInterval: distance,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropDownControls(
            onDistanceChange: _handleDistanceChange,
            distance: distance,
            onDurationChange: _handleDurationChange,
            duration: duration,
            onIntervalTypeChange: _handleIntervalTypeChange,
            intervalType: intervalType,
          ),
        ),
      ],
    );
  }

  void _handleUnitTypeChange(UnitType unitType) {
    setState(() {
      this.unitType = unitType;
    });
  }

  void _handleIntervalTypeChange(IntervalType intervalType) {
    setState(() {
      this.intervalType = intervalType;
    });
  }

  void _handleDistanceChange(Distance distance) {
    setState(() {
      this.distance = distance;
    });
  }

  void _handleDurationChange(Duration duration) {
    setState(() {
      this.duration = duration;
    });
  }
}
