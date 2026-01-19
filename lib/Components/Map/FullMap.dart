import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/Map/Providers/LocationMarkerHeadingProvider.dart';
import 'package:run_tracker/Components/Map/Providers/LocationMarkerPositionProvider.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Providers/export.dart';

class FullMap extends ConsumerStatefulWidget {
  const FullMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FullMapState();
}

class _FullMapState extends ConsumerState<FullMap> {
  final StreamController<LocationMarkerPosition>
  _locationMarkerPositionController = StreamController.broadcast();
  final StreamController<LocationMarkerHeading>
  _locationMarkerHeadingController = StreamController.broadcast();
  @override
  void initState() {
    super.initState();

    ref.listenManual(locationMarkerPositionProvider, (prev, cur) {
      if (cur.hasValue) {
        _locationMarkerPositionController.add(cur.requireValue);
      }
    });
    ref.listenManual(locationMarkerHeadingProvider, (prev, cur) {
      if (cur.hasValue) {
        _locationMarkerHeadingController.add(cur.requireValue);
      }
    });
  }

  @override
  void dispose() {
    _locationMarkerPositionController.close();
    _locationMarkerHeadingController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urlTempalte = ref.watch(mapUriTemplateProvider);
    if (urlTempalte.isLoading) {
      return AppLoader();
    }

    return FlutterMap(
      options: MapOptions(interactionOptions: InteractionOptions()),
      children: [
        TileLayer(
          urlTemplate: urlTempalte.value,
          userAgentPackageName: "run_tracker",
          tileProvider: NetworkTileProvider(
            cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(),
          ),
        ),
        CurrentLocationLayer(
          positionStream: _locationMarkerPositionController.stream,
          headingStream: _locationMarkerHeadingController.stream,
        ),
      ],
    );
  }
}
