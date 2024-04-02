import 'package:hive/hive.dart';
import 'package:run_tracker/data/AppHiveObject.dart';
import 'package:run_tracker/data/HiveTypeId.dart';
import 'package:run_tracker/data/models/RunItemGeolocationData.dart';
import 'package:run_tracker/data/models/RunItemStartData.dart';
import 'package:run_tracker/data/models/RunItemStopData.dart';

@HiveType(typeId: HiveTypeId.runPoints)
class RunPointsData extends AppHiveObject {
  @HiveField(0)
  int? runCoverKey;

  @HiveField(1)
  final List<RunPointGeolocationData> geolocations;

  @HiveField(2)
  final RunPointStartData start;

  @HiveField(3)
  final RunPointStopData stop;

  RunPointsData(
      {required this.geolocations, required this.start, required this.stop});
}

abstract class RunItemData {
  DateTime get dateTime;
}
