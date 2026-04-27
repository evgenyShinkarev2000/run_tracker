import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/BarHeader.dart';
import 'package:run_tracker/Pages/TrackRecord/BarTab/BarTable.dart';
import 'package:run_tracker/Pages/TrackRecord/MapTab/MapTabInnerdart.dart';
import 'package:run_tracker/Pages/TrackRecord/PlotTab/PlotTabInner.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/l10n/app_localizations.dart';

//TODO настройки BarTable
class LongScreenshot extends StatelessWidget {
  final TrackRecordWithSummaryAndPointAndPulse trackRecord;
  final BuildContext mainContext;

  const LongScreenshot({
    super.key,
    required this.trackRecord,
    required this.mainContext,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Directionality.of(mainContext),
      child: Localizations(
        locale: Localizations.localeOf(mainContext),
        delegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        child: MediaQuery(
          data: MediaQuery.of(mainContext),
          child: InheritedTheme.captureAll(
            mainContext,
            UncontrolledProviderScope(
              container: ProviderScope.containerOf(mainContext),
              child: SizedBox(
                width: 500,
                child: IntrinsicHeight(
                  child: Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (context) => Material(
                          child: Column(
                            children: [
                              MapTabInner(trackRecord: trackRecord),
                              Divider(),
                              Column(
                                children: [
                                  ColoredBox(
                                    color: context
                                        .themeData
                                        .colorScheme
                                        .secondaryContainer,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: BarHeader(
                                        unitType: .speed,
                                        onUnitTypeChange: (_) {},
                                        intervalType: .distance,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      top: 8,
                                    ),
                                    child: BarTable(
                                      trackRecord: trackRecord,
                                      intervalType: .distance,
                                      unitType: .speed,
                                      durationInterval: Duration(minutes: 5),
                                      distanceInterval: Distance(1000),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),

                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 24,
                                ),
                                child: PlotTabInner(trackRecord: trackRecord),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
