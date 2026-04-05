import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:run_tracker/Components/Map/Components/BottomButtons.dart';
import 'package:run_tracker/Components/Map/Components/CheckAbortedTrackDialog.dart';
import 'package:run_tracker/Components/Map/Components/TopDashboard.dart';
import 'package:run_tracker/Components/Map/Components/export.dart';
import 'package:run_tracker/Components/Map/Providers/LocationMarkerHeadingProvider.dart';
import 'package:run_tracker/Components/Map/Providers/LocationMarkerPositionProvider.dart';
import 'package:run_tracker/Components/export.dart';
import 'package:run_tracker/Providers/Settings/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
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
  late final Future<AppPosition?> _initialPositionFuture;

  ProviderSubscription<AsyncValue<AppPosition>>? _positionSubscription;

  bool _isNavigationLoading = false;
  NavigationButtonState _navigationState = NavigationButtonState.Free;

  @override
  void initState() {
    super.initState();

    _initialPositionFuture = ref
        .read(positionServiceProvider)
        .tryGetLastPosition();

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
    final overrideMapCacheDuration = ref.watch(mapCacheDurationProvider);
    final needShowLocationDialog = ref.watch(needShowLocationDialogProvider);

    if (urlTempalte.isLoading || overrideMapCacheDuration.isLoading) {
      return AppLoader();
    }

    if (needShowLocationDialog) {
      return LocationPermissionDialog();
    }

    final trackState = ref.watch(trackStateProvider);

    return Stack(
      children: [
        FutureBuilder(
          future: _initialPositionFuture,
          builder: (context, state) => switch (state.connectionState) {
            ConnectionState.waiting || ConnectionState.active => AppLoader(),
            _ => FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialZoom: defaultZoom,
                initialCenter:
                    state.data?.toLatLng() ?? const LatLng(50.5, 30.51),
              ),
              children: [
                TileLayer(
                  urlTemplate: urlTempalte.value,
                  userAgentPackageName: "run_tracker",
                  tileProvider: NetworkTileProvider(
                    cachingProvider:
                        BuiltInMapCachingProvider.getOrCreateInstance(
                          overrideFreshAge:
                              overrideMapCacheDuration.requireValue,
                        ),
                  ),
                ),
                CurrentLocationLayer(
                  positionStream: _locationMarkerPositionController.stream,
                  headingStream: _locationMarkerHeadingController.stream,
                ),
              ],
            ),
          },
        ),
        RightPanel(
          isNavigationLoading: _isNavigationLoading,
          navigationState: _navigationState,
          onNavigationStateChange: _handleNavigationStateChange,
        ),
        TopDashboard(),
        BottomButtons(),
        trackState == TrackState.Aborted
            ? SizedBox.expand(child: CheckAbortedTrackDialog())
            : null,
      ].nonNulls.toList(),
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
    if (position.hasLatLng) {
      _mapController.move(position.toLatLng(), _mapController.camera.zoom);
    }
  }

  void _moveAndRotate(AppPosition position) {
    if (position.heading != null && position.hasLatLng) {
      _mapController.moveAndRotate(
        position.toLatLng(),
        _mapController.camera.zoom,
        position.heading!.value,
      );
      return;
    }
    if (position.hasLatLng) {
      _mapController.move(position.toLatLng(), _mapController.camera.zoom);
      return;
    }
  }
}
