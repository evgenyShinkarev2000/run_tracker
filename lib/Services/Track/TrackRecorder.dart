import 'dart:async';

import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Services/Track/TrackManager.dart';
import 'package:run_tracker/Services/Track/TrackState.dart';
import 'package:run_tracker/Services/Track/TrackWriter.dart';

class TrackRecorder implements IDisposable {
  final PositionDataProvider? _positionProvider;
  final TrackRecordWriter _writer;
  final TrackStateProvider _stateProvider;

  StreamSubscription<AppPosition>? _positionSubscription;

  TrackRecorder(
    this._writer, {
    required TrackStateProvider stateProvider,
    PositionDataProvider? positionProvider
  }) : _positionProvider = positionProvider,
       _stateProvider = stateProvider {
    _positionSubscription = _positionProvider?.stream.listen(_listenPosition);
  }

  void _listenPosition(AppPosition position) {
    if (_stateProvider.state != TrackState.Running) {
      return;
    }
    _writer.writePosition(position);
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
  }
}
