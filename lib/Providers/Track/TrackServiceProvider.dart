import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Repositories/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

final trackServiceProvider = Provider((ref) {
  return TrackService(
    ref.watch(trackRecordRepositoryProvider),
    ref.watch(trackRecordPointsRepositoryProvider),
    ref.watch(trackRecordSummaryRepositoryProvider),
    TrackSummaryCalculator(),
  );
});
