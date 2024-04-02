import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/core/RunRecorder.dart';

class RunRecorderCubit extends Cubit<RunRecorderState> {
  final IRunRecorder _runRecorder;
  late final StreamSubscription<RunRecorderPhase> _phaseSubscription;
  RunRecorderCubit({required IRunRecorder runRecorderProxy})
      : _runRecorder = runRecorderProxy,
        super(RunRecorderState(runRecorderPhase: runRecorderProxy.phase)) {
    _phaseSubscription = runRecorderProxy.phaseStream.listen((phase) {
      emit(RunRecorderState(runRecorderPhase: phase));
    });
  }

  @override
  Future<void> close() {
    _phaseSubscription.cancel();

    return super.close();
  }

  void startTap() {
    _runRecorder.start();
  }

  void pauseTap() {
    _runRecorder.pause();
  }

  void resumeTap() {
    _runRecorder.resume();
  }

  void stopTap() {
    _runRecorder.stop();
  }

  List<RunPoint> GetRunPoints() {
    return _runRecorder.runPoints;
  }

  DateTime GetStartDateTime() {
    return _runRecorder.runPoints.first.dateTime;
  }
}

class RunRecorderState {
  final RunRecorderPhase runRecorderPhase;

  RunRecorderState({required this.runRecorderPhase});
}
