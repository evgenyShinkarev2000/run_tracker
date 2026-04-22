import 'dart:async';

import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Services/Position/export.dart';
import 'package:run_tracker/Services/Track/export.dart';

class TrackRecorder implements IDisposable {
  final PositionProvider? _positionProvider;
  final TrackRecordWriter _writer;
  final TrackStateProvider _stateProvider;
  final ILogger _logger;
  //TODO вынести в конфигурацию
  final Duration _positionPeriod = Duration(seconds: 1);
  DateTime? _prevPositionTimestamp;

  StreamSubscription<AppPosition>? _positionSubscription;

  TrackRecorder(
    this._logger,
    this._writer, {
    required TrackStateProvider stateProvider,
    PositionProvider? positionProvider,
  }) : _positionProvider = positionProvider,
       _stateProvider = stateProvider {
    _positionSubscription = _positionProvider?.stream.listen(_listenPosition);
  }

  void _listenPosition(AppPosition position) {
    if (_stateProvider.state != TrackState.Running) {
      return;
    }
    final timestamp = position.timestamp ?? DateTime.timestamp();
    if (_prevPositionTimestamp == null ||
        timestamp.difference(_prevPositionTimestamp!) >= _positionPeriod) {
      _prevPositionTimestamp = timestamp;
      _writer.writePosition(position);
    } else {
      _logger.logTrace(
        "TrackRecorder._listenPosition: maximum frequency reached, skip write position",
      );
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
  }
}
