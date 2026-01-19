import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';

final locationMarkerHeadingProvider = StreamProvider((ref) async* {
  final position = await ref.watch(positionProvider.future);

  yield LocationMarkerHeading(
    heading: position.heading?.value ?? double.nan,
    accuracy: position.heading?.accuracy ?? double.nan,
  );
});
