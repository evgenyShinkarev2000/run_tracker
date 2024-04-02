import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:run_tracker/bloc/cubits/LocationMarkerPositionCubit.dart';
import 'package:run_tracker/bloc/cubits/PositionSignificantCubit.dart';
import 'package:run_tracker/bloc/cubits/RunRecorderCubit.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/helpers/extensions/AppGeolocationExtension.dart';
import 'package:run_tracker/pages/MapPage/DashBoard.dart';
import 'package:run_tracker/pages/MapPage/MapBottomButtons.dart';
import 'package:run_tracker/pages/MapPage/MapContribution.dart';
import 'package:run_tracker/pages/MapPage/MapRightButtons.dart';
import 'package:run_tracker/pages/MapPage/MapTileLayer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();
  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: Stack(
        children: [
          BlocListener<PositionSignificantCubit, PositionSignificantState>(
            listenWhen: (previous, current) =>
                isNavigating && current.isDistanceOffsetSignificant && current.currentGeolocation != null,
            listener: (context, state) {
              mapController.move(state.currentGeolocation!.toLatLng(), mapController.camera.zoom);
            },
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialZoom: 10,
              ),
              children: [
                MapTileLayer(),
                BlocBuilder<LocationMarkerPositionCubit, LocationMarkerPositionState>(
                  builder: (context, cubit) {
                    return CurrentLocationLayer(
                      positionStream: cubit.positionStream,
                    );
                  },
                ),
                Opacity(
                  opacity: 0.5,
                  child: MapContribution(),
                ),
              ],
            ),
          ),
          BlocBuilder<RunRecorderCubit, RunRecorderState>(builder: (context, state) {
            return MapBottomButtons();
          }),
          Builder(builder: (context) {
            final positionCubit = context.read<PositionSignificantCubit>();

            return MapRightButton(
              onNavigateTap: () => navigateTap(positionCubit),
              onStopNavigateTap: () => stopNavigateTap(positionCubit),
              isNavigating: isNavigating,
            );
          }),
          DashBoardContainer(),
        ],
      ),
    );
  }

  void navigateTap(PositionSignificantCubit positionCubit) {
    setState(() {
      isNavigating = false;
    });
    positionCubit.pause();
  }

  void stopNavigateTap(PositionSignificantCubit positionCubit) {
    setState(() {
      isNavigating = true;
    });
    positionCubit.resume();
  }
}
