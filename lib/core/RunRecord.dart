import 'package:run_tracker/core/RunPoint.dart';
import 'package:run_tracker/helpers/GeolocatorWrapper.dart';

class RunRecord {
  String get title => _title;
  String _title;

  final List<RunPoint> _runPoints;
  Iterable<RunPoint> get runPoints => _runPoints;

  DateTime? _startDateTime;
  DateTime get startDateTime => _startDateTime!;

  Duration? _runDuration;
  Duration get duration => _runDuration!;

  /// m
  double _distance = 0;

  /// m
  double get distance => _distance;

  DateTime? _stopDateTime;
  DateTime get stopDateTime => _stopDateTime!;

  /// m/s
  double? _averageSpeed;

  /// m/s
  double? get averageSpeed => _averageSpeed;

  late RunPointStart _startItem;
  late RunPointStop _stopItem;

  RunRecord({required String title, required List<RunPoint> runPoints})
      : _runPoints = runPoints,
        _title = title {
    try {
      _processStartItem();
    } catch (ex) {
      print("exception in process start item");
      rethrow;
    }
    try {
      _processStopItem();
    } catch (ex) {
      print("exception in process stop item");
    }

    try {
      _processGeolocationItems();
    } catch (ex) {
      print("exception in process geolocation items");
    }
  }

  void setTitle(String title) {
    _title = title;
  }

  void _processStartItem() {
    _startItem = runPoints.whereType<RunPointStart>().first;
    _startDateTime = _startItem.dateTime;
    final firstGeolocationItem = runPoints.whereType<RunPointGeolocation>().firstOrNull;
    if (_startItem.geolocation == null &&
        firstGeolocationItem?.geolocation != null &&
        firstGeolocationItem!.dateTime.microsecondsSinceEpoch - _startDateTime!.microsecondsSinceEpoch < 3e6) {
      _startItem.setStartGeolocation(firstGeolocationItem.geolocation);
    }
  }

  void _processStopItem() {
    _stopItem = runPoints.whereType<RunPointStop>().first;
    _stopDateTime = _stopItem.dateTime;
    _runDuration = Duration(microseconds: stopDateTime.microsecondsSinceEpoch - startDateTime.microsecondsSinceEpoch);
    final lastGeolocation = runPoints.whereType<RunPointGeolocation>().lastOrNull;
    if (lastGeolocation != null && _stopItem.geolocation == null) {
      _stopItem.setStopGeolocation(lastGeolocation.geolocation);
    }
    if (_stopItem.distance != null) {
      _distance = _stopItem.distance!;
      _averageSpeed = distance / duration.inMicroseconds * 1000000;
    }
  }

  void _processGeolocationItems() {
    var previousGeolocation = runPoints.whereType<RunPointGeolocation>().firstOrNull;
    if (previousGeolocation == null) {
      if (_startItem.geolocation != null && _stopItem.geolocation != null) {
        _distance = GeolocatorWrapper.distanceBetweenGeolocations(_startItem.geolocation!, _stopItem.geolocation!);
        _averageSpeed = _distance / duration.inMicroseconds * 1000000;
      }
    }

    double weightedAverageSpeed = _findWeightedSpeed(_startItem, previousGeolocation!);

    for (var currentGeolocation in runPoints.whereType<RunPointGeolocation>().skip(1)) {
      weightedAverageSpeed += _findWeightedSpeed(previousGeolocation!, currentGeolocation);
      previousGeolocation = currentGeolocation;
    }

    weightedAverageSpeed += _findWeightedSpeed(previousGeolocation!, _stopItem);

    _averageSpeed = weightedAverageSpeed;
  }

  double _findWeightedSpeed(RunPointNullableGeolocation a, RunPointNullableGeolocation b) {
    return GeolocatorWrapper.distanceBetweenGeolocations(a.geolocation!, b.geolocation!) *
        (b.dateTime.microsecondsSinceEpoch - a.dateTime.microsecondsSinceEpoch) /
        duration.inMicroseconds;
  }
}
