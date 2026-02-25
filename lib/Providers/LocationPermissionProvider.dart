import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/LocationPermissionServiceProvider.dart';

final locationPermissionProvider = StreamProvider((ref) {
  return ref.watch(locationPermissionServiceProvider).stream;
});
