import 'package:run_tracker/Core/Units/Speed.dart';

class Pace {
  static const infinity = Pace(double.infinity);

  final double minutesPerKilometer;

  const Pace(this.minutesPerKilometer);

  @override
  bool operator ==(Object other) {
    return other is Pace && other.minutesPerKilometer == minutesPerKilometer;
  }

  @override
  int get hashCode => minutesPerKilometer.hashCode;

  Speed toSpeed() {
    return Speed(
      (50 / 3) / minutesPerKilometer,
    ); // 1 / (minutesPerKilometer * 60 / 1000)
  }
}
