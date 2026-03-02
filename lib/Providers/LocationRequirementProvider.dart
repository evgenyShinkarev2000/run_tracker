import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';

final locationRequirementProvider = StreamProvider((ref) {
  return ref.watch(locationRequirementRepositoryProvider).stream;
});
