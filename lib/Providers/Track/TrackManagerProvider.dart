import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Services/Track/export.dart';

final trackManagerProvider = Provider<TrackManager>((ref) => throw Exception("trackManagerProvider must be implemented"));