import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Camera/export.dart';

final cameraFrameServiceProvider = Provider((ref) {
  final service = CameraFrameWithFlashProvider(ref.watch(loggerProvider));
  ref.onDispose(service.dispose);

  return service;
});