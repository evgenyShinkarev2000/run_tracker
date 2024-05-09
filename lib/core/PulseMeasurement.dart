class PulseMeasurementBase {
  DateTime dateTime;
  double pulse;

  PulseMeasurementBase({required this.dateTime, required this.pulse});
}

class PulseMeasurementByMetronome extends PulseMeasurementBase {
  PulseMeasurementByMetronome({required super.dateTime, required super.pulse});
}

class PulseMeasurementByCamera extends PulseMeasurementBase {
  PulseMeasurementByCamera({required super.dateTime, required super.pulse});
}

class PulseMeasurementByTimer extends PulseMeasurementBase {
  PulseMeasurementByTimer({required super.dateTime, required super.pulse});
}

class PulseMeasurementByManual extends PulseMeasurementBase {
  PulseMeasurementByManual({required super.dateTime, required super.pulse});
}
