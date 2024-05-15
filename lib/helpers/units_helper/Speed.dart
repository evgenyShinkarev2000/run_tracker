part of units_helper;

class Speed {
  double get kilometersPerHour =>
      metersPerSecond / Factors.toMeters(DistanceUnit.kilometer) * Factors.toSeconds(TimeUnit.hour);

  final double metersPerSecond;

  Speed({required DistanceUnit distanceUnit, required TimeUnit timeUnit, required double value})
      : assert(!value.isNaN),
        metersPerSecond = value / Factors.toMeters(distanceUnit) * Factors.toSeconds(timeUnit);

  static Speed fromMetersPerSecond(double metersPerSeconds) =>
      Speed(distanceUnit: DistanceUnit.meter, timeUnit: TimeUnit.second, value: metersPerSeconds);

  static Speed fromKilometersPerHour(double kilometersPerHours) =>
      Speed(distanceUnit: DistanceUnit.kilometer, timeUnit: TimeUnit.hour, value: kilometersPerHours);

  Pace toPace() => Pace(distanceUnit: DistanceUnit.meter, timeUnit: TimeUnit.second, value: 1 / metersPerSecond);
}
