import 'dart:async';

import 'package:drift/drift.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
import 'package:run_tracker/Services/Position/export.dart';
import 'package:run_tracker/Services/Track/export.dart';
import 'package:rxdart/rxdart.dart';

abstract class TrackStateProvider {
  Stream<TrackState> get stateStream;
  TrackState get state;
}

abstract class TrackControllerCommandProvider {
  Stream<TrackControllerCommand> get commandStream;
}

class TrackManager
    implements IDisposable, TrackStateProvider, TrackControllerCommandProvider {
  @override
  Stream<TrackState> get stateStream => _stateSubject.stream;
  @override
  TrackState get state => _stateSubject.value;
  final BehaviorSubject<TrackState> _stateSubject = BehaviorSubject.seeded(
    TrackState.Loading,
  );
  @override
  Stream<TrackControllerCommand> get commandStream =>
      _commandStreamController.stream;
  final StreamController<TrackControllerCommand> _commandStreamController =
      StreamController.broadcast();
  TrackDashboardParameters get dashboard => _dashboard;

  bool _isInitialized = false;
  bool _isDisposed = false;

  TrackRecord? _processedTrack;
  TrackRecorder? _recorder;
  TrackRecordWriter? _writer;
  late final TrackDashboardParameters _dashboard;

  final TrackRecordRepository _trackRecordRepository;
  final TrackRecordPointsRepository _trackRecordPointsRepository;
  final PositionProvider _positionDataProvider;
  final TrackService _trackService;

  TrackManager(
    this._trackRecordRepository,
    this._trackRecordPointsRepository,
    this._trackService,
    this._positionDataProvider,
  ) {
    _dashboard = TrackDashboardParameters(
      this,
      positionProvider: _positionDataProvider,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _stateSubject.close();
    _commandStreamController.close();
    _recorder?.dispose();
    _dashboard.dispose();
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      throw StateError("mustn't be initialized more then once");
    }
    _isInitialized = true;

    final lastTrack = await _trackRecordRepository.getLast();
    if (lastTrack == null || lastTrack.isCompleted) {
      _stateSubject.add(TrackState.Ready);
      return;
    }
    _processedTrack = lastTrack;
    _stateSubject.add(TrackState.Aborted);
  }

  Future<void> start() async {
    _ensureState(TrackState.Ready);

    _stateSubject.add(TrackState.Running);

    _processedTrack = await _trackRecordRepository.create(
      TrackRecordsCompanion.insert(
        createdAt: DateTime.now(),
        isCompleted: false,
        source: Value("egn_run_tracker"),
      ),
    );
    if (_isDisposed) {
      await _trackRecordRepository.remove(_processedTrack!.id);
      return;
    }
    await _initializeInternal();
  }

  Future<void> continueAborted() async {
    _ensureState(TrackState.Aborted);

    await _normilizeAborted();
    await _initializeInternal();

    _stateSubject.add(TrackState.Paused);
  }

  Future<void> dropAborted() async {
    _ensureState(TrackState.Aborted);

    await _trackRecordRepository.update(
      _processedTrack!.copyWith(isCompleted: true),
    );
    final trackRecordWithSummary = await _trackRecordRepository
        .getTrackRecordWithSummaryById(_processedTrack!.id);
    if (trackRecordWithSummary != null &&
        trackRecordWithSummary.trackRecordSummary == null) {
      await _trackService.generateOrUpdateSummary(_processedTrack!.id);
    }
    _stateSubject.add(TrackState.Ready);
  }

  Future<void> pause() async {
    _ensureState(TrackState.Running);
    _stateSubject.add(TrackState.Paused);
    await _writer!.writePause();
  }

  Future<void> complete() async {
    switch (_stateSubject.value) {
      case TrackState.Running || TrackState.Paused:
        _stateSubject.add(TrackState.Completed);
        await _writer!.stopWrite();
        await _trackRecordRepository.update(
          _processedTrack!.copyWith(isCompleted: true),
        );
        await _trackService.generateOrUpdateSummary(_processedTrack!.id);
        break;
      default:
        _throwStateMustBeOneOfError([TrackState.Running, TrackState.Paused]);
    }
  }

  Future<void> resume() async {
    _ensureState(TrackState.Paused);
    _stateSubject.add(TrackState.Running);
    _writer!.writeResume();
  }

  Future<void> _normilizeAborted() async {
    final lastPoint = await _trackRecordPointsRepository.getLastPoint(
      _processedTrack!.id,
    );
    if (lastPoint != null) {
      final pointType = CheckPointTypeVisitor.determineType(lastPoint);
      switch (pointType) {
        case PointType.Pause:
          break;
        case PointType.Resume || PointType.Position:
          if (pointType == PointType.Resume) {
            await _trackRecordPointsRepository.removePoint(lastPoint);
          }
          await _trackRecordPointsRepository.addPausePoint(
            PausePoint.insert(
              trackRecordId: lastPoint.trackRecordId,
              createdAt: lastPoint.createdAt,
            ),
          );
          break;
      }
      final summary = await _trackService.calculateSummary(_processedTrack!.id);
      _dashboard.setParameters(
        duration: summary.activeDuration,
        distance: summary.activeDistance,
      );
    }
  }

  Future<void> _initializeInternal() async {
    _writer = ExistingTrackRecordWriter(
      _processedTrack!.id,
      _trackRecordPointsRepository,
    );
    _recorder = TrackRecorder(
      _writer!,
      stateProvider: this,
      positionProvider: _positionDataProvider,
    );
  }

  void _ensureState(TrackState state) {
    if (_stateSubject.value != state) {
      _throwStateMustBeError(state);
    }
  }

  void _throwStateMustBeError(TrackState state) {
    throw StateError(
      "TrackManager must be in state $state, current state ${_stateSubject.value}",
    );
  }

  void _throwStateMustBeOneOfError(List<TrackState> states) {
    throw StateError(
      "TrackManager must be in one of states ${states.join(", ")}, current state ${_stateSubject.value}",
    );
  }
}
