import 'package:run_tracker/core/PulseMeasurement.dart';

class PulseRecorder {
  final List<PulseMeasurementBase> _pulseMeasurements = [];
  Iterable<PulseMeasurementBase> get pulseMeasurement => _pulseMeasurements;

  void addMeasurement(PulseMeasurementBase pulseMeasurement) {
    _pulseMeasurements.add(pulseMeasurement);
  }
}
