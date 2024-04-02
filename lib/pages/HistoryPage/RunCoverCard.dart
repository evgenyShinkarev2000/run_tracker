import 'package:flutter/material.dart';
import 'package:run_tracker/components/map_painter/MapPainterShort.dart';
import 'package:run_tracker/core/AppGeolocation.dart';
import 'package:run_tracker/helpers/extensions/AppGeolocationExtension.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/DateTimeExtension.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';

class RunCoverCard extends StatelessWidget {
  final String name;
  final DateTime beginDateTime;
  final Duration duration;
  final double distance;
  final Duration pace;
  final int pulse;
  final Iterable<AppGeolocation> geolocations;
  final void Function() onTap;

  const RunCoverCard({
    super.key,
    required this.name,
    required this.beginDateTime,
    required this.duration,
    required this.distance,
    required this.pace,
    required this.pulse,
    required this.geolocations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nameLabel = context.appLocalization.runCardCoverName;
    final beginDateTimeLabel = context.appLocalization.runCardCoverBeginDateTime;
    final durationLabel = context.appLocalization.runCardCoverDuration;
    final distanceLabel = context.appLocalization.runCardCoverDistance;
    final paceLabel = context.appLocalization.runCardCoverPace;
    final pulseLabel = context.appLocalization.runcardCoverPulse;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntrinsicHeight(
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                    ),
                    child: MapPainterShort(geolocations: geolocations.map((appGeo) => appGeo.toLatLng()).toList()),
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nameLabel),
                    Text(beginDateTimeLabel),
                    Text(durationLabel),
                    Text(distanceLabel),
                    Text(paceLabel),
                    Text(pulseLabel),
                  ],
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Text(
                        beginDateTime.dateSpaceTime,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                      Text(
                        duration.hhmmss,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                      Text(
                        distance.toStringAsFixed(0),
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                      Text(
                        pace.mmss,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                      Text(
                        pulse.toString(),
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
