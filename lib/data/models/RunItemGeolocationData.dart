import 'package:hive/hive.dart';
import 'package:run_tracker/data/HiveTypeId.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';

@HiveType(typeId: HiveTypeId.runPointGeolocation)
class RunPointGeolocationData implements RunItemData {
  @override
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final double? speed;

  @HiveField(2)
  final double altitude;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final double? accuracy;

  RunPointGeolocationData(
      {required this.dateTime,
      this.speed,
      required this.altitude,
      required this.latitude,
      required this.longitude,
      this.accuracy});
}
