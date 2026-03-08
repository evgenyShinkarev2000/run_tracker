import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Track/TrackDashboardParametersProvider.dart';

final dashboardSpeedProvider = StreamProvider((ref){
  return ref.watch(trackDashboardParametersProvider).speed;
});