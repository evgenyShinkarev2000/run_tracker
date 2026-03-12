import 'dart:async';

import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/export.dart';
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
  late final TrackDashboardParameters _dashboard;

  final TrackRecordRepository _trackRecordRepository;
  final TrackRecordPointsRepository _trackRecordPointsRepository;
  final PositionDataProvider _positionDataProvider;

  TrackManager(
    this._trackRecordRepository,
    this._trackRecordPointsRepository,
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
      _initializeNewTrack();
      return;
    }
    _initializeExistingTrack(lastTrack);
  }

  Future<void> startNew() async {
    if (_stateSubject.value != TrackState.Ready) {
      throw StateError("must be in state ${TrackState.Ready}");
    }

    _processedTrack = await _trackRecordRepository.create(
      TrackRecordsCompanion.insert(
        createdAt: DateTime.now(),
        isCompleted: false,
      ),
    );
    if (_isDisposed) {
      await _trackRecordRepository.remove(_processedTrack!.id);
      return;
    }

    final writer = ExistingTrackRecordWriter(
      _processedTrack!.id,
      _trackRecordPointsRepository,
    );
    _recorder = TrackRecorder(
      writer,
      stateProvider: this,
      positionProvider: _positionDataProvider,
    );

    _stateSubject.add(TrackState.Running);
  }

  Future<void> continueAborted() {
    if (_stateSubject.value != TrackState.Aborted) {
      throw StateError("must be in state ${TrackState.Aborted}");
    }
    //TODO доделать
    throw UnimplementedError();
  }

  Future<void> dropAborted() async {
    if (_stateSubject.value != TrackState.Aborted) {
      throw StateError("must be in state ${TrackState.Aborted}");
    }

    await _trackRecordRepository.update(
      _processedTrack!.copyWith(isCompleted: true),
    );
    _initializeNewTrack();
  }

  Future<void> pause() {
    throw UnimplementedError();
  }

  Future<void> complete() {
    throw UnimplementedError();
  }

  Future<void> resume() {
    throw UnimplementedError();
  }

  void _initializeNewTrack() {
    _stateSubject.add(TrackState.Ready);
  }

  void _initializeExistingTrack(TrackRecord trackRecord) {
    _processedTrack = trackRecord;
    _stateSubject.add(TrackState.Aborted);
  }
}
