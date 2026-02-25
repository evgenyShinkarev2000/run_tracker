import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/LocationPermission/LocationPermissionDialog.dart';
import 'package:run_tracker/Components/Map/Components/export.dart';
import 'package:run_tracker/Components/Map/Providers/LocationMarkerHeadingProvider.dart';
import 'package:run_tracker/Components/Map/Providers/LocationMarkerPositionProvider.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/export.dart';

class FullMap extends ConsumerStatefulWidget {
  const FullMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FullMapState();
}

class _FullMapState extends ConsumerState<FullMap> {
  static const double defaultZoom = 15;

  final StreamController<LocationMarkerPosition>
  _locationMarkerPositionController = StreamController.broadcast();
  final StreamController<LocationMarkerHeading>
  _locationMarkerHeadingController = StreamController.broadcast();
  final MapController _mapController = MapController();
  late final StreamSubscription<MapEvent> _mapEventStreamSubscription;

  ProviderSubscription<AsyncValue<AppPosition>>? _positionSubscription;

  bool _isNavigationLoading = false;
  NavigationButtonState _navigationState = NavigationButtonState.Free;

  @override
  void initState() {
    super.initState();

    _mapEventStreamSubscription = _mapController.mapEventStream.listen((
      mapEvent,
    ) {
      if (mapEvent.source == MapEventSource.onDrag) {
        _handleNavigationStateChange(NavigationButtonState.Free);
      }
    });

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
    _mapController.dispose();
    _mapEventStreamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urlTempalte = ref.watch(mapUriTemplateProvider);
    final locationPermission = ref.watch(locationPermissionProvider);
    final overrideMapCacheDuration = ref.watch(mapCacheDurationProvider);

    if (urlTempalte.isLoading ||
        overrideMapCacheDuration.isLoading) {
      return AppLoader();
    }

    if (locationPermission.value?.ToSimple() != SimpleLocationPermission.Permited) {
      return LocationPermissionDialog();
    }
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(initialZoom: defaultZoom),
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
            CurrentLocationLayer(
              positionStream: _locationMarkerPositionController.stream,
              headingStream: _locationMarkerHeadingController.stream,
            ),
          ],
        ),
        RightPanel(
          isNavigationLoading: _isNavigationLoading,
          navigationState: _navigationState,
          onNavigationStateChange: _handleNavigationStateChange,
        ),
      ],
    );
  }

  Future<void> _handleNavigationStateChange(NavigationButtonState state) async {
    switch (state) {
      case NavigationButtonState.Free:
        _positionSubscription?.close();
        setState(() {
          _navigationState = NavigationButtonState.Free;
          _isNavigationLoading = false;
        });
        break;
      case NavigationButtonState.Navigated:
        _subscribePosition(_move, NavigationButtonState.Navigated);
        break;
      case NavigationButtonState.Locked:
        _subscribePosition(_moveAndRotate, NavigationButtonState.Locked);
        break;
    }
  }

  void _subscribePosition(
    void Function(AppPosition) onPosition,
    NavigationButtonState targetState,
  ) {
    final position = ref.read(positionProvider);
    if (position.hasValue) {
      onPosition(position.requireValue);
      setState(() {
        _navigationState = targetState;
      });
    } else {
      setState(() {
        _navigationState = targetState;
        _isNavigationLoading = true;
      });
    }
    _positionSubscription?.close();
    _positionSubscription = ref.listenManual(positionProvider, (prev, cur) {
      if (!cur.hasValue) {
        return;
      }
      if (_isNavigationLoading) {
        setState(() {
          _isNavigationLoading = false;
        });
      }
      onPosition(cur.requireValue);
    });
  }

  void _move(AppPosition position) {
    if (position.HasLatLng) {
      _mapController.move(position.ToLatLng(), defaultZoom);
    }
  }

  void _moveAndRotate(AppPosition position) {
    if (position.heading != null && position.HasLatLng) {
      _mapController.moveAndRotate(
        position.ToLatLng(),
        defaultZoom,
        position.heading!.value,
      );
      return;
    }
    if (position.HasLatLng) {
      _mapController.move(position.ToLatLng(), defaultZoom);
      return;
    }
  }
}
