import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Providers/export.dart';

final trackRecordSummaryRepositoryProvider = Provider<TrackRecordSummaryRepository>((ref){
  return DriftTrackRecordSummaryRepository(ref.watch(appDatabaseProvider));
});