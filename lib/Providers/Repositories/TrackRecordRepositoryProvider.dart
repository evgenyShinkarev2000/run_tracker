import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';

final trackRecordRepositoryProvider = Provider<TrackRecordRepository>((ref) {
  return DriftTrackRecordRepository(ref.watch(appDatabaseProvider));
});
