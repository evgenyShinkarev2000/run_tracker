import 'package:run_tracker/Core/Units/export.dart';

class Distance {
  static const Distance zero = Distance(0);

  final double meters;

  const Distance(this.meters);

  Distance addMeters(double meters) {
    return Distance(this.meters + meters);
  }

  Distance operator +(Distance other) {
    return addMeters(other.meters);
  }

  @override
  bool operator ==(Object other) {
    return other is Distance && other.meters == meters;
  }

  Speed operator /(Duration duration) {
    return Speed(meters / duration.inMicroseconds * 1_000_000);
  }

  @override
  int get hashCode => meters.hashCode;
}
