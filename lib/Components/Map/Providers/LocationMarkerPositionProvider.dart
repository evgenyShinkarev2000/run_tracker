import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';

final locationMarkerPositionProvider = FutureProvider<LocationMarkerPosition>((
  ref,
) async {
  return await ref.watch(
    positionProvider.selectAsync((position) {
      return LocationMarkerPosition(
        latitude: position.latitude?.value ?? double.nan,
        longitude: position.longitude?.value ?? double.nan,
        accuracy: position.horizontalAccuracy ?? double.nan,
      );
    }),
  );
});
