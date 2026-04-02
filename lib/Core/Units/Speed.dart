import 'package:run_tracker/Core/Units/Pace.dart';

class Speed {
  static const zero = Speed(0);

  final double metersPerSecond;
  double get kilometersPerHour => metersPerSecond * 3.6;

  const Speed(this.metersPerSecond);

  @override
  bool operator ==(Object other) {
    return other is Speed && other.metersPerSecond == metersPerSecond;
  }

  @override
  int get hashCode => metersPerSecond.hashCode;

  bool operator >(Speed other) => metersPerSecond > other.metersPerSecond;
  bool operator <(Speed other) => metersPerSecond < other.metersPerSecond;

  double operator /(Speed other) => metersPerSecond / other.metersPerSecond;

  Pace toPace() {
    return Pace(metersPerSecondToMinutesPerKilometer(metersPerSecond));
  }

  static double metersPerSecondToMinutesPerKilometer(double metersPerSecond) {
    return (50 / 3) / metersPerSecond; // 1 / (metersPerSecond / 1000 * 60)
  }

  static double metersPerSecondToKilometersPerHour(double metersPerSecond) =>
      metersPerSecond * 3.6;
}
