import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Pages/Statistics/StatisticsService.dart';
import 'package:run_tracker/Providers/Repositories/export.dart';
import 'package:run_tracker/Providers/export.dart';

final statisticsServiceProvider = Provider((ref) {
  return StatisticsService(
    ref.read(trackRecordSummaryRepositoryProvider),
    ref.read(userDateTimeConverterProvider),
  );
}, isAutoDispose: true);
