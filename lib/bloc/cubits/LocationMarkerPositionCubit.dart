import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:run_tracker/helpers/GeolocationProvider.dart';

class LocationMarkerPositionCubit extends Cubit<LocationMarkerPositionState> {
  LocationMarkerPositionCubit({required IGeolocationProvider geolocationProvider})
      : super(LocationMarkerPositionState(
            positionStream: geolocationProvider.geolocationStream.map((appGeolocation) => LocationMarkerPosition(
                latitude: appGeolocation.latitude,
                longitude: appGeolocation.longitude,
                accuracy: appGeolocation.accuracy ?? double.nan))));
}

class LocationMarkerPositionState {
  final Stream<LocationMarkerPosition> positionStream;

  LocationMarkerPositionState({required this.positionStream});
}
