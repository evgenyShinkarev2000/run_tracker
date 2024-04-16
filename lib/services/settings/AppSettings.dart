import 'package:flutter/material.dart';
import 'package:run_tracker/data/repositories/SettingRepository.dart';
import 'package:run_tracker/helpers/AppLanguageCode.dart';
import 'package:run_tracker/helpers/AppTheme.dart';
import 'package:run_tracker/services/settings/GeolocationSettings.dart';
import 'package:run_tracker/services/settings/PulseByCameraSettings.dart';
import 'package:run_tracker/services/settings/Setting.dart';
import 'package:run_tracker/services/settings/SettingFactory.dart';
import 'package:run_tracker/services/settings/SettingSetBase.dart';
import 'package:run_tracker/services/settings/mappers/LanguageCodeToLocale.dart';
import 'package:run_tracker/services/settings/mappers/ThemeNameToThemeData.dart';

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
    pulseByCamera = PulseByCameraSettings(_settingFactory);
    geolocation = GeolocationSettings(_settingFactory);
  }

  @override
  Future<void> init() async {
    await initFutures(() => [
          _settingFactory
              .initSettingVariantWithStringSerializer(
                  buildSettingName("Locale"), AppLanguageCode.values, LanguageCodeToLocale().map, AppLanguageCode.en)
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
}
