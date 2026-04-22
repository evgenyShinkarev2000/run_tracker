import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Providers/Repositories/export.dart';
import 'package:run_tracker/Providers/Track/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

class MapScope extends ConsumerStatefulWidget {
  final Widget mapWidget;

  const MapScope({super.key, required this.mapWidget});

  @override
  ConsumerState<MapScope> createState() => _MapScopeState();
}

class _MapScopeState extends ConsumerState<MapScope> {
  late final TrackManager _manager;

  @override
  void initState() {
    super.initState();
    //TODO используется read, но все зависимости работают с watch
    _manager = TrackManager(
      ref.read(trackRecordRepositoryProvider),
      ref.read(trackRecordPointsRepositoryProvider),
      ref.read(pulseRepositoryProvider),
      ref.read(trackServiceProvider),
      ref.read(positionStreamProvider),
      ref.read(loggerProvider),
    );
    final logger = ref.read(loggerProvider);
    _manager.initialize().catchError((ex, s){
      logger.logError("Can't initialize TrackManager", appException: AppException.caught(ex, s));
      throw ex;
    });
  }

  @override
  void dispose() {
    _manager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [trackManagerProvider.overrideWithValue(_manager)],
      child: widget.mapWidget,
    );
  }
}
