import 'package:flutter/material.dart';
import 'package:run_tracker/data/repositories/SettingRepository.dart';
import 'package:run_tracker/services/settings/AppSettings.dart';

class SettingsProvider with ChangeNotifier {
  late final AppSettings appSettings;

  SettingsProvider(SettingRepository settingRepository) {
    appSettings = AppSettings(settingRepository: settingRepository, onChange: handleSettingChange);
  }

  void handleSettingChange() {
    notifyListeners();
  }
}
