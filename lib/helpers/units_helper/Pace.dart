part of units_helper;

class Pace {
  double get minutesPerKilometer =>
      secondsPerMeter * Factors.toMeters(DistanceUnit.kilometer) / Factors.toSeconds(TimeUnit.minute);
  double get secondsPerKilometer => secondsPerMeter * Factors.toMeters(DistanceUnit.kilometer);

  final double secondsPerMeter;

  Pace({required DistanceUnit distanceUnit, required TimeUnit timeUnit, required double value})
      : assert(!value.isNaN),
        secondsPerMeter = value * Factors.toMeters(distanceUnit) / Factors.toSeconds(timeUnit);

  static Pace fromSecondsPerMeter(double secondsPerMeter) =>
      Pace(distanceUnit: DistanceUnit.meter, timeUnit: TimeUnit.second, value: secondsPerMeter);

  static Pace fromMinutesPerKilometer(double minutesPerKilometer) =>
      Pace(distanceUnit: DistanceUnit.kilometer, timeUnit: TimeUnit.minute, value: minutesPerKilometer);

  Speed toSpeed() => Speed(distanceUnit: DistanceUnit.meter, timeUnit: TimeUnit.second, value: 1 / secondsPerMeter);

  Duration toDurationKm() => Duration(microseconds: (secondsPerKilometer * 1e6).round());
}
