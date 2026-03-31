import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Repositories/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/GPX/export.dart';

final gpxImportProvider = Provider((ref) {
  return GPXImport(
    ref.watch(loggerProvider),
    ref.watch(trackRecordRepositoryProvider),
    ref.watch(trackRecordPointsRepositoryProvider),
  );
});
