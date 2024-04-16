import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/helpers/AppLanguageCode.dart';
import 'package:run_tracker/helpers/AppTheme.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/extensions/SettingExtension.dart';
import 'package:run_tracker/pages/SettingPage/ChooseSettingVariant.dart';
import 'package:run_tracker/pages/SettingPage/ChooseSettingVariantDialog.dart';
import 'package:run_tracker/services/settings/SettingsProvider.dart';

import '../../helpers/GeolocationProviderKind.dart';
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

    showChooseLanguageDialog() => showDialog(
          context: context,
          builder: (_) => ChooseSettingVariantDialog<AppLanguageCode>(
            variants: supportedLanguages,
            onSelect: (variant) => appSettings.locale.setVariant(variant),
            selected: appSettings.locale.variantOrDefault,
          ),
        );
    showChooseGeolocationProviderDialog() => showDialog(
          context: context,
          builder: (_) => ChooseSettingVariantDialog(
            variants: supportedGeolocationProviders,
            onSelect: (variant) => appSettings.geolocation.ProviderKind.setValue(variant),
            selected: appSettings.geolocation.ProviderKind.valueOrDefault,
            defaultVariant: appSettings.geolocation.ProviderKind.defaultValue,
          ),
        );

    final supportedThemes = [
      SettingVariantView(title: context.appLocalization.settingVariantThemeLigth, variant: AppTheme.light),
      SettingVariantView(title: context.appLocalization.settingVariantThemeDark, variant: AppTheme.dark),
    ];
    showChooseThemeDialog() => showDialog(
          context: context,
          builder: (_) => ChooseSettingVariantDialog<AppTheme>(
            variants: supportedThemes,
            onSelect: (variant) => appSettings.theme.setVariant(variant),
            selected: appSettings.theme.variantOrDefault,
            defaultVariant: appSettings.theme.defaultVariant,
          ),
        );

    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: Center(
        child: ListView(
          children: [
            ChooseSettingVariant(
              name: context.appLocalization.settingsLanguage,
              variantTitle: supportedLanguages.getSelectedOrDefaultTitle(appSettings.locale),
              onTap: showChooseLanguageDialog,
              icon: CupertinoIcons.globe,
            ),
            ChooseSettingVariant(
              name: context.appLocalization.settingsTheme,
              onTap: showChooseThemeDialog,
              variantTitle: supportedThemes.getSelectedOrDefaultTitle(appSettings.theme),
              icon: Icons.palette_outlined,
            ),
            ChooseSettingVariant(
              name: "Geolocation Provider",
              onTap: showChooseGeolocationProviderDialog,
              variantTitle: appSettings.geolocation.ProviderKind.value?.name ??
                  appSettings.geolocation.ProviderKind.defaultValue?.name,
              icon: CupertinoIcons.placemark,
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
