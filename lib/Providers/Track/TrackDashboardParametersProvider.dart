import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

final trackDashboardParametersProvider = Provider<TrackDashboardParameters>(
  (ref) => ref.watch(trackManagerProvider).dashboard,
  dependencies: [trackManagerProvider]
);
