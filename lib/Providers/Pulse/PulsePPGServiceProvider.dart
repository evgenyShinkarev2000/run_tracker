import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Camera/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Pulse/export.dart';

final pulsePPGServiceFactoryProvider = Provider((ref) {
  return PPGCameraServiceFactory(
    camera: ref.watch(cameraFrameServiceProvider),
    logger: ref.watch(loggerProvider),
  );
});
