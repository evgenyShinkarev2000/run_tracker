part of data;

Future<void> initAppData() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RunCoverDataAdapter());
  Hive.registerAdapter(RunPointsDataAdapter());
  Hive.registerAdapter(RunPointGeolocationDataAdapter());
  Hive.registerAdapter(RunPointStartDataAdapter());
  Hive.registerAdapter(RunPointStopDataAdapter());
  Hive.registerAdapter(SettingDataAdapter());
  Hive.registerAdapter(PulseMeasurementDataAdapter());
}
