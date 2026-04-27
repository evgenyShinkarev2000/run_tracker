import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Pages/TrackRecord/MapTab/MapTabRow.dart';
import 'package:run_tracker/Pages/TrackRecord/MapTab/TrackRecordMap.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Services/export.dart';
import 'package:run_tracker/localization/export.dart';

class MapTabInner extends ConsumerWidget {
  const MapTabInner({super.key, required this.trackRecord});

  final TrackRecordWithSummaryAndPoints trackRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDateTimeConverter = ref.watch(userDateTimeConverterProvider);
    final appDateTimeFormat = ref.watch(appDateTimeFormatProvider);
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: TrackRecordMap(
            orderedPoints: trackRecord.points.orderedPoints,
          ),
        ),
        MapTabRow(
          title: context.appLocalization.runCardCoverBeginDateTime,
          value: trackRecord.summary.start
              ?.fromUtcToUser(userDateTimeConverter)
              .applyFormat(appDateTimeFormat.fullDateFullTime),
        ),
        MapTabRow(
          title: context.appLocalization.runCardCoverEndDateTime,
          value: trackRecord.summary.end
              ?.fromUtcToUser(userDateTimeConverter)
              .applyFormat(appDateTimeFormat.fullDateFullTime),
          isSelected: true,
        ),
        MapTabRow(
          title: context.appLocalization.runCardCoverDuration,
          value: trackRecord.summary.activeDuration?.HHmmss,
        ),
        MapTabRow(
          title: context.appLocalization.runCardCoverDistance,
          value: trackRecord.summary.activeDistance?.meters.toInt().toString(),
          unit: context.appLocalization.unitShortM,
          isSelected: true,
        ),
        MapTabRow(
          title: context.appLocalization.nounSpeed,
          value: trackRecord.summary.speed?.kilometersPerHour.toStringAsFixed(
            1,
          ),
          unit: context.appLocalization.unitShortKmPerHour,
        ),
        MapTabRow(
          title: context.appLocalization.nounPace,
          value: trackRecord.summary.pace?.minutesPerKilometer.toStringAsFixed(
            1,
          ),
          unit: context.appLocalization.unitShortMinPerKm,
          isSelected: true,
        ),
        MapTabRow(
          title: context.appLocalization.nounPulse,
          value: trackRecord.summary.averagePulseBPM?.round().toString(),
          unit: context.appLocalization.unitShortBPM,
        ),
      ],
    );
  }
}
