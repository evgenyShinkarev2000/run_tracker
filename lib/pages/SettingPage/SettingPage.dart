import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/helpers/AppLanguageCode.dart';
import 'package:run_tracker/helpers/AppTheme.dart';
import 'package:run_tracker/helpers/GeolocationProviderKind.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/SettingExtension.dart';
import 'package:run_tracker/pages/SettingPage/Setting.dart';
import 'package:run_tracker/services/settings/settings.dart';
import 'package:run_tracker/helpers/extensions/DurationExtension.dart';

import 'SettingVariantView.dart';

class SettingPageState extends State<SettingPage> {
  final supportedLanguages = [
    SettingVariantView(title: "english", variant: AppLanguageCode.en),
    SettingVariantView(title: "русский", variant: AppLanguageCode.ru),
  ];

  final supportedGeolocationProviders =
      GeolocationProviderKind.values.map((e) => SettingVariantView(title: e.name, variant: e)).toList();

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<SettingsProvider>().appSettings;

    final supportedThemes = [
      SettingVariantView(title: context.appLocalization.settingVariantThemeLigth, variant: AppTheme.light),
      SettingVariantView(title: context.appLocalization.settingVariantThemeDark, variant: AppTheme.dark),
    ];

    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: Center(
        child: ListView(
          children: [
            Setting.withVariantDialog(
              name: context.appLocalization.settingsLanguage,
              variants: supportedLanguages,
              onSelect: appSettings.locale.setVariant,
              icon: CupertinoIcons.globe,
              selected: appSettings.locale.variantOrDefault,
              variantTitle: supportedLanguages.getSelectedOrDefaultTitle(appSettings.locale),
            ),
            Setting.withVariantDialog(
              name: context.appLocalization.settingsTheme,
              variants: supportedThemes,
              onSelect: appSettings.theme.setVariant,
              icon: Icons.palette_outlined,
              selected: appSettings.theme.variantOrDefault,
              defaultVariant: appSettings.theme.defaultVariant,
              variantTitle: supportedThemes.getSelectedOrDefaultTitle(appSettings.theme),
            ),
            Setting.withVariantDialog(
              name: "Geolocation Provider",
              variants: supportedGeolocationProviders,
              onSelect: appSettings.geolocation.providerKind.setValue,
              icon: CupertinoIcons.placemark,
              selected: appSettings.geolocation.providerKind.valueOrDefault,
              defaultVariant: appSettings.geolocation.providerKind.defaultValue,
              variantTitle: appSettings.geolocation.providerKind.valueOrDefault?.name,
            ),
            Setting.withDoubleSliderDialog(
              name: "camera unstable time, s",
              icon: CupertinoIcons.clock,
              onSave: (v) =>
                  appSettings.pulseByCamera.cameraUnstableTime.setValue(Duration(milliseconds: (v * 1000).toInt())),
              value: appSettings.pulseByCamera.cameraUnstableTime.valueOrDefault?.inSecondsDouble,
              defaultValue: appSettings.pulseByCamera.cameraUnstableTime.defaultValue?.inSecondsDouble,
              max: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => SettingPageState();
}
