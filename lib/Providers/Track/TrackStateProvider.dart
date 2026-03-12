import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

final _trackStateStreamProvider = StreamProvider((ref) {
  return ref.watch(trackManagerProvider).stateStream;
}, dependencies: [trackManagerProvider]);

final trackStateProvider = Provider((ref) {
  return ref.watch(_trackStateStreamProvider).value ?? TrackState.Loading;
}, dependencies: [_trackStateStreamProvider]);
