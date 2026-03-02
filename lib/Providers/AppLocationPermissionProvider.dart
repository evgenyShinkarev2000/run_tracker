import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';

final appLocationPermissionProvider = StreamProvider((ref){
  final service = ref.watch(appLocationPermissionServiceProvider);
  return service.stream;
});