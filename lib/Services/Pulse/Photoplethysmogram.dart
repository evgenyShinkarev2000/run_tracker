import 'package:run_tracker/Services/Pulse/BrightnessWithDuration.dart';

class Photoplethysmogram{
  Iterable<BrightnessWithDuration> get brightnessMeasurements => brightnessMeasurements;
  final List<BrightnessWithDuration>  _brightnessMeasurements;

  Photoplethysmogram(this._brightnessMeasurements);
}