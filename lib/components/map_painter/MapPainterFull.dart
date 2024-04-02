import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/pages/MapPage/MapTileLayer.dart';
import 'package:run_tracker/themes/Theme.dart';

class MapPainterFull extends StatelessWidget {
  final List<LatLng> geolocations;
  final LatLng? start;
  final LatLng? stop;
  static const double markerSize = 48;

  MapPainterFull({required this.geolocations, this.start, this.stop});

  @override
  Widget build(BuildContext context) {
    if (geolocations.isEmpty) {
      return Center(
        child: Text("no data"),
      );
    }

    final theme = context.themeDate.mapPainterFullTheme;

    final markers = [
      start != null
          ? Marker(
              height: markerSize - 8,
              alignment: Alignment.topCenter,
              point: start!,
              child: Icon(
                Icons.place,
                color: theme.startMarkerColor,
                size: markerSize,
              ))
          : null,
      stop != null
          ? Marker(
              height: markerSize - 8,
              alignment: Alignment.topCenter,
              point: stop!,
              child: Icon(
                Icons.place,
                color: theme.stopMarkerColor,
                size: markerSize,
              ))
          : null,
    ].nonNulls;

    return FlutterMap(
      options: MapOptions(
        interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
        initialCameraFit: CameraFit.coordinates(coordinates: geolocations, padding: EdgeInsets.all(32)),
        backgroundColor: Colors.white,
      ),
      children: [
        MapTileLayer(),
        PolylineLayer(
          polylines: [
            Polyline(
              color: Colors.blue,
              strokeWidth: 3,
              points: geolocations,
            ),
          ],
        ),
        MarkerLayer(markers: markers.toList()),
      ],
    );
  }
}
