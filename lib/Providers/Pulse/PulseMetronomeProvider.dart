import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Services/Pulse/export.dart';

final pulseMetronomeFactoryProvider = Provider((ref) {
  return PulseMetronomeFactory();
});
