import 'package:run_tracker/Core/Units/Speed.dart';

class Pace {
  static const infinity = Pace(double.infinity);
  static const zero = Pace(0.0);

  final double minutesPerKilometer;

  const Pace(this.minutesPerKilometer);

  @override
  bool operator ==(Object other) {
    return other is Pace && other.minutesPerKilometer == minutesPerKilometer;
  }

  @override
  int get hashCode => minutesPerKilometer.hashCode;

  bool operator >(Pace other) =>
      minutesPerKilometer > other.minutesPerKilometer;
  bool operator <(Pace other) =>
      minutesPerKilometer < other.minutesPerKilometer;

  double operator /(Pace other) =>
      minutesPerKilometer / other.minutesPerKilometer;

  Speed toSpeed() {
    return Speed(
      (50 / 3) / minutesPerKilometer,
    ); // 1 / (minutesPerKilometer * 60 / 1000)
  }

  Duration? tryConvertToDuration() {
    if (minutesPerKilometer.isInfinite) {
      return null;
    }

    return Duration(microseconds: (minutesPerKilometer * 6e7).round());
  }
}
