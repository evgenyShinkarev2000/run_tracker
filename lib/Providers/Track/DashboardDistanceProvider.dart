import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Track/TrackDashboardParametersProvider.dart';

final dashboardDistanceProvider = StreamProvider((ref) {
  return ref.watch(trackDashboardParametersProvider).distance;
}, dependencies: [trackDashboardParametersProvider]);
