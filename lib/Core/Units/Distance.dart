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

  @override
  int get hashCode => meters.hashCode;
}
