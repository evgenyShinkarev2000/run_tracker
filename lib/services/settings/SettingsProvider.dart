part of settings;

class SettingsProvider with ChangeNotifier {
  late final AppSettings appSettings;

  SettingsProvider(SettingRepository settingRepository) {
    appSettings = AppSettings(settingRepository: settingRepository, onChange: handleSettingChange);
  }

  void handleSettingChange() {
    notifyListeners();
  }
}
