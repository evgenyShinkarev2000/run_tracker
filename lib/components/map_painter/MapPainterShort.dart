import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/pages/MapPage/MapTileLayer.dart';

class MapPainterShort extends StatelessWidget {
  final List<LatLng> geolocations;

  const MapPainterShort({super.key, required this.geolocations});

  @override
  Widget build(BuildContext context) {
    if (geolocations.isEmpty) {
      return Center(
        child: Text("no data"),
      );
    }

    return FlutterMap(
      options: MapOptions(
        interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
        initialCameraFit: CameraFit.coordinates(coordinates: geolocations, padding: EdgeInsets.all(4)),
        backgroundColor: Colors.white,
      ),
      children: [
        MapTileLayer(),
        PolylineLayer(
          polylines: [
            Polyline(
              color: Colors.black,
              strokeWidth: 1.5,
              points: geolocations,
            ),
          ],
        ),
      ],
    );
  }
}
