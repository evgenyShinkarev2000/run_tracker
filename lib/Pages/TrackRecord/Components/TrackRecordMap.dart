import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Components/Map/MapIcon.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/localization/export.dart';

class TrackRecordMap extends ConsumerStatefulWidget {
  final Iterable<BasePoint> orderedPoints;

  const TrackRecordMap({super.key, required this.orderedPoints})
    : assert(orderedPoints.length > 0);

  @override
  ConsumerState<TrackRecordMap> createState() => _TrackRecordMapState();
}

class _TrackRecordMapState extends ConsumerState<TrackRecordMap> {
  final List<LatLng> points = [];
  final List<Polyline> polylines = [];
  final List<Marker> markers = [];

  _TrackRecordMapState();

  @override
  void initState() {
    super.initState();

    LatLng? prevLatLng;
    final List<List<LatLng>> lines = [];
    var linePoints = <LatLng>[];
    var isPaused = false;
    var needAddResume = false;

    for (final point in widget.orderedPoints) {
      switch (CheckPointTypeVisitor.determineType(point)) {
        case PointType.Position:
          if (isPaused) {
            break;
          }
          final positionPoint = point as PositionPoint;
          if (!positionPoint.hasLatLng) {
            break;
          }
          final latLng = positionPoint.toLatLng();
          points.add(latLng);
          linePoints.add(latLng);
          if (needAddResume) {
            markers.add(
              Marker(point: latLng, child: MapIcon(Icons.play_arrow)),
            );
            needAddResume = false;
          }
          if (prevLatLng == null) {
            markers.add(
              Marker(point: latLng, child: MapIcon(Icons.play_arrow)),
            );
          }
          prevLatLng = latLng;
          break;
        case PointType.Pause:
          isPaused = true;
          if (linePoints.isNotEmpty) {
            lines.add(linePoints);
            linePoints = [];
          }
          if (prevLatLng != null) {
            markers.add(Marker(point: prevLatLng, child: MapIcon(Icons.pause)));
            prevLatLng = null;
          }
          break;
        case PointType.Resume:
          isPaused = false;
          needAddResume = true;
          break;
      }
    }
    if (points.isEmpty) {
      return;
    }

    markers.add(Marker(point: points.last, child: MapIcon(Icons.stop)));
    for (var points in lines) {
      polylines.add(Polyline(points: points));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return Center(child: Text(context.appLocalization.nounNoData));
    }

    final urlTempalte = ref.watch(mapUriTemplateProvider);
    final overrideMapCacheDuration = ref.watch(mapCacheDurationProvider);
    if (urlTempalte.isLoading || overrideMapCacheDuration.isLoading) {
      return AppLoader();
    }

    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: points,
          padding: EdgeInsets.all(32),
        ),
        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
      ),
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
        PolylineLayer(polylines: polylines, simplificationTolerance: 1),
        MarkerLayer(markers: markers, alignment: Alignment.topCenter),
      ],
    );
  }
}
