import 'package:hive/hive.dart';
import 'package:run_tracker/data/models/SettingData.dart';

class SettingRepository {
  final Box<SettingData> settingBox;

  SettingRepository(this.settingBox);

  Future<SettingData?> getByKey(String key) {
    return Future.value(settingBox.get(key));
  }

  Future<void> put(String key, SettingData settingData) async {
    await settingBox.put(key, settingData);
  }
}

class SettingRepositoryFactory {
  static const String settingBoxName = "Settings";
  Future<SettingRepository> create() async {
    if (Hive.isBoxOpen(settingBoxName)) {
      return SettingRepository(Hive.box(settingBoxName));
    }
    try {
      await Hive.openBox<SettingData>(settingBoxName);

      return SettingRepository(Hive.box(settingBoxName));
    } catch (ex) {
      rethrow;
    }
  }
}
