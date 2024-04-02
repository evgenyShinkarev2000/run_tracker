import 'package:hive/hive.dart';
import 'package:run_tracker/data/HiveTypeId.dart';
import 'package:run_tracker/data/models/RunItemGeolocationData.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';

@HiveType(typeId: HiveTypeId.runPointStart)
class RunPointStartData implements RunItemData {
  @override
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final RunPointGeolocationData? geolocation;

  RunPointStartData({required this.dateTime, this.geolocation});
}
