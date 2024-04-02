import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/RunRecorder.dart';

class DashBoardDurationCubit extends Cubit<DashBoardDurationState> {
  final IRunRecorder _runRecorder;
  late final StreamSubscription<RunRecorderPhase> _phaseSubscr;
  Timer? _timer;
  DashBoardDurationCubit({required IRunRecorder runRecorder})
      : _runRecorder = runRecorder,
        super(DashBoardDurationState(runningTime: runRecorder.duration)) {
    _phaseSubscr = runRecorder.phaseStream.listen((phase) {
      switch (phase) {
        case RunRecorderPhase.writing:
          _resume();
          break;
        case RunRecorderPhase.paused:
          _pause();
          break;
        default:
          break;
      }
    });

    if (runRecorder.phase == RunRecorderPhase.writing) {
      _resume();
    }
  }

  void _resume() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      emit(DashBoardDurationState(runningTime: _runRecorder.duration));
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _phaseSubscr.cancel();

    return super.close();
  }
}

class DashBoardDurationState {
  final Duration runningTime;

  DashBoardDurationState({required this.runningTime});
}
