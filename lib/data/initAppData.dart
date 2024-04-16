import 'package:hive_flutter/hive_flutter.dart';
import 'package:run_tracker/data/adapters/RunPointGeolocationDataAdapter.dart';
import 'package:run_tracker/data/adapters/RunPointStartData.dart';
import 'package:run_tracker/data/adapters/RunPointStopData.dart';
import 'package:run_tracker/data/adapters/RunPointsDataAdapter.dart';
import 'package:run_tracker/data/adapters/SettingDataAdpter.dart';

import 'adapters/RunCoverDataAdapter.dart';

Future<void> initAppData() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RunCoverDataAdapter());
  Hive.registerAdapter(RunRecordDataAdapter());
  Hive.registerAdapter(RunPointGeolocationDataAdapter());
  Hive.registerAdapter(RunPointStartDataAdapter());
  Hive.registerAdapter(RunPointStopDataAdapter());
  Hive.registerAdapter(SettingDataAdapter());
}
