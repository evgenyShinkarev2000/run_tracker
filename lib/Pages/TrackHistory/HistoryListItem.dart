import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/Extensions/export.dart';
import 'package:run_tracker/Pages/TrackHistory/ListItemText.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:run_tracker/Theme/export.dart';
import 'package:run_tracker/localization/BuildContextExtension.dart';
import 'package:run_tracker/localization/export.dart';

class HistoryListItem extends ConsumerStatefulWidget {
  final TrackRecordWithSummaryAndPoints item;

  const HistoryListItem({super.key, required this.item});

  @override
  ConsumerState<HistoryListItem> createState() => _HistoryListItemState();
}

class _HistoryListItemState extends ConsumerState<HistoryListItem> {
  late final List<List<LatLng>> polylines;

  @override
  void initState() {
    super.initState();
    polylines = _pointsToPolylines(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeFormat = ref.watch(appDateTimeFormatProvider);

    return InkWell(
      onTap: () => context.appRouter.goTrackRecord(widget.item.track.id),
      child: Container(
        height: 150,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: BoxBorder.all(
            color: context.themeData.colorScheme.secondaryContainer,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          spacing: 8,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: SmallPeviewMap(polylines: polylines),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserDateTime.nullable(
                    utcDateTime: widget.item.summary.start,
                    builder: (context, userDateTime) => ListItemText(
                      title: context.appLocalization.runCardCoverBeginDateTime,
                      content: userDateTime == null
                          ? null
                          : dateTimeFormat.fullDateFullTime.format(userDateTime),
                    ),
                  ),
                  ListItemText(
                    title: context.appLocalization.runCardCoverDuration,
                    content: widget.item.summary.activeDuration?.HHmmss,
                  ),
                  ListItemText(
                    title: context.appLocalization.runCardCoverDistance,
                    content:
                        "${widget.item.summary.activeDistance?.meters.toInt()} ${context.appLocalization.unitShortM}",
                  ),
                  ListItemText(
                    title: context.appLocalization.runCardCoverSpeed,
                    content:
                        "${widget.item.summary.speed?.kilometersPerHour.toStringAsFixed(1)} ${context.appLocalization.unitShortKmPerHour}",
                  ),
                  ListItemText(
                    title: context.appLocalization.runCardCoverPace,
                    content:
                        "${widget.item.summary.pace?.tryConvertToDuration()?.mmss} ${context.appLocalization.unitShortMinPerKm}",
                  ),
                  //TODO add pulse
                  ListItemText(
                    title: context.appLocalization.runcardCoverPulse,
                    content: "developing...",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static List<List<LatLng>> _pointsToPolylines(
    TrackRecordWithSummaryAndPoints model,
  ) {
    return model
        .splitPath()
        .map(
          (points) => points
              .where((p) => p.hasLatLng)
              .map((p) => p.toLatLng())
              .toList(),
        )
        .toList();
  }
}
