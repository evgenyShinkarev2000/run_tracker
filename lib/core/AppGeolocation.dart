class AppGeolocation {
  final DateTime dateTime;
  final double altitude;
  final double latitude;
  final double longitude;

  /// m/s
  final double? speed;
  /// m
  final double? accuracy;

  AppGeolocation(
      {required this.dateTime,
      required this.altitude,
      required this.latitude,
      required this.longitude,
      this.speed,
      this.accuracy});
}
