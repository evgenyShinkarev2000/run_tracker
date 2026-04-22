import 'package:run_tracker/Services/Pulse/export.dart';

class PulseMeasurement {
  final PulseMeasureKind pulseMeasureKind;
  final double pulseBPM;
  final DateTime measuredAt;

  PulseMeasurement({
    required this.pulseMeasureKind,
    required this.pulseBPM,
    required this.measuredAt,
  });
}