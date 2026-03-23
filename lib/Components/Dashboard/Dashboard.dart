import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/Dashboard/SmallDash.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/export.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.themeData.colorScheme.secondaryContainer,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsetsGeometry.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        final asyncDuration = ref.watch(
                          dashboardDurationProvider,
                        );
                        final duration = asyncDuration.value ?? Duration.zero;

                        return SmallDash(
                          value: duration.HHmmss,
                          label: context.appLocalization.runCardCoverDuration,
                        );
                      },
                    ),
                    Divider(),
                    Consumer(
                      builder: (context, ref, child) {
                        final asyncDistance = ref.watch(
                          dashboardDistanceProvider,
                        );
                        final distance = asyncDistance.value ?? Distance.zero;

                        return SmallDash(
                          value: distance.meters.round().toString(),
                          label:
                              "${context.appLocalization.nounDistance}, ${context.appLocalization.unitShortM}",
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(width: 0),
            Consumer(
              builder: (context, ref, child) {
                final asyncSpeed = ref.watch(dashboardSpeedProvider);
                final speed = asyncSpeed.value ?? Speed.zero;
                final pace = speed.toPace().tryConvertToDuration();
                final paceString = pace == null ? "00:00" : pace.mmss;

                return Expanded(
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SmallDash(
                          value: speed.kilometersPerHour.toStringAsFixed(1),
                          label:
                              "${context.appLocalization.nounSpeed}, ${context.appLocalization.unitShortKmPerHour}",
                        ),
                        Divider(),
                        SmallDash(
                          value: paceString,
                          label:
                              "${context.appLocalization.nounPace}, ${context.appLocalization.unitShortMinPerKm}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
