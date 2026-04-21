import 'package:run_tracker/Core/export.dart';

class BrightnessWithDuration {
  final double brightness;
  final Duration duration;
  final double seconds;

  BrightnessWithDuration({required this.brightness, required this.duration})
    : seconds = duration.inSecondsDouble;

  BrightnessWithDuration copyWithBrightness(double brightness) =>
      BrightnessWithDuration(brightness: brightness, duration: duration);
}
