part of settings;

class AppSettings extends SettingSetBase {
  final SettingFactory _settingFactory;

  late final PulseByCameraSettings pulseByCamera;
  late final GeolocationSettings geolocation;

  late final SettingVariant<AppLanguageCode, Locale> locale;
  late final SettingVariant<AppTheme, ThemeData> theme;

  AppSettings({
    required SettingRepository settingRepository,
    required void Function() onChange,
  })  : _settingFactory = SettingFactory(settingRepository, onChange),
        super(name: "AppDevSettings") {
    pulseByCamera = PulseByCameraSettings(_settingFactory, prefix: name);
    geolocation = GeolocationSettings(_settingFactory, prefix: name);
  }

  @override
  Future<void> init() async {
    await initFutures(() => [
          _settingFactory
              .initSettingVariantWithStringSerializer(buildSettingName("Locale"), AppLanguageCode.values,
                  LanguageCodeToLocale().map, getDefaultAppLanguageCode())
              .then((value) => locale = value),
          _settingFactory
              .initSettingVariantWithStringSerializer(
                buildSettingName("Theme"),
                AppTheme.values,
                ThemeNameToThemeData().map,
                ThemeMode.system == ThemeMode.light ? AppTheme.light : AppTheme.dark,
              )
              .then((value) => theme = value),
        ]);
  }

  AppLanguageCode getDefaultAppLanguageCode() {
    final languageCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    switch (languageCode) {
      case "en":
        return AppLanguageCode.en;
      case "ru":
        return AppLanguageCode.ru;
      default:
        return AppLanguageCode.en;
    }
  }
}
