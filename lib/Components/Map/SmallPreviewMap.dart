import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Providers/export.dart';

class SmallPeviewMap extends ConsumerWidget {
  final List<List<LatLng>> polylines;

  const SmallPeviewMap({super.key, this.polylines = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlTempalte = ref.watch(mapUriTemplateProvider);
    final overrideMapCacheDuration = ref.watch(mapCacheDurationProvider);
    if (urlTempalte.isLoading || overrideMapCacheDuration.isLoading) {
      return AppLoader();
    }

    final points = polylines.expand((l) => l).toList();

    return FlutterMap(
      options: MapOptions(initialCameraFit: CameraFit.coordinates(coordinates: points)),
      children: [
        TileLayer(
          urlTemplate: urlTempalte.value,
          userAgentPackageName: "run_tracker",
          tileProvider: NetworkTileProvider(
            cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(
              overrideFreshAge: overrideMapCacheDuration.requireValue,
            ),
          ),
        ),
        PolylineLayer(
          polylines: polylines
              .map((points) => Polyline(points: points))
              .toList(),
          simplificationTolerance: 2,
        ),
      ],
    );
  }
}
