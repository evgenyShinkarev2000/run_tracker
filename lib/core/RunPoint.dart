import 'AppGeolocation.dart';

abstract class RunPoint {
  DateTime get dateTime;
}

abstract class RunPointNullableGeolocation implements RunPoint {
  AppGeolocation? get geolocation;
}

class RunPointGeolocation implements RunPoint, RunPointNullableGeolocation {
  @override
  final AppGeolocation geolocation;
  @override
  DateTime get dateTime => geolocation.dateTime;

  RunPointGeolocation({required this.geolocation});
}

class RunPointStart implements RunPoint, RunPointNullableGeolocation {
  @override
  final DateTime dateTime;
  @override
  AppGeolocation? get geolocation => _geolocation;
  AppGeolocation? _geolocation;

  RunPointStart({required this.dateTime, AppGeolocation? geolocation})
      : _geolocation = geolocation;

  void setStartGeolocation(AppGeolocation geolocation) {
    _geolocation = geolocation;
  }
}

class RunPointStop implements RunPoint, RunPointNullableGeolocation {
  @override
  final DateTime dateTime;
  @override
  AppGeolocation? get geolocation => _geolocation;
  AppGeolocation? _geolocation;

  double? get distance => _distance;
  double? _distance;

  RunPointStop(
      {required this.dateTime, AppGeolocation? geolocation, double? distance})
      : _distance = distance,
        _geolocation = geolocation;

  void setStopGeolocation(AppGeolocation geolocation) {
    _geolocation = geolocation;
  }

  void setDistance(double distance) {
    _distance = distance;
  }
}
