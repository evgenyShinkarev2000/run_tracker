class SpeedHelper {
  /// m/s to minutes/km
  static Duration? speedToPace(final double? speed) {
    if (speed == null || speed < 1e-3 || speed.isInfinite || speed.isNaN) {
      return null;
    }
    final r = Duration(microseconds: 1e9 ~/ speed);
    return r;
  }

  static double meterPerSecondToKilometrPerHour(final double speed) {
    if (speed.isNaN) {
      return double.nan;
    }

    return speed * 3.6;
  }
}
