import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/core/PulseByMetronome.dart';

class PulseMetronomeCubit extends Cubit<PulseMetronomeCubitState> {
  final PulseByMetronome _pulseByMetronome = PulseByMetronome();

  PulseMetronomeCubit() : super(PulseMetronomeCubitState(0));

  void metronomeTap() {
    final pulseBPM = _pulseByMetronome.findPulse(DateTime.now());
    if (pulseBPM != null) {
      emit(PulseMetronomeCubitState(pulseBPM));
    }
  }
}

class PulseMetronomeCubitState {
  /// beats pre minute
  final double? pulseBPM;

  PulseMetronomeCubitState(this.pulseBPM);
}
