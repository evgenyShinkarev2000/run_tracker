import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';

final locationMarkerHeadingProvider = FutureProvider((ref) async {
  return await ref.watch(
    positionProvider.selectAsync((position) {
      return LocationMarkerHeading(
        heading: position.heading?.value ?? double.nan,
        accuracy: position.heading?.accuracy ?? double.nan,
      );
    }),
  );
});
