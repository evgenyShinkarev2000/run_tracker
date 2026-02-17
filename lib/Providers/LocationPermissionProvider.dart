import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/LocationPermissionServiceProvider.dart';
import 'package:run_tracker/Services/export.dart';

final locationPermissionProivder = FutureProvider((ref) async {
  return await ref.watch(
    detailedLocationPermissionProvider.selectAsync(
      LocationPermissionServiceExtension.DetailedToSimple,
    ),
  );
});

final detailedLocationPermissionProvider = StreamProvider((ref) {
  return ref.watch(locationPermissionServiceProvider).stream;
});
