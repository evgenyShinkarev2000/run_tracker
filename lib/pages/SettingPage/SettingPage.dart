import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/bloc/cubits/GeolocationProviderCubit.dart';
import 'package:run_tracker/components/drawer/AppMainDrawer.dart';
import 'package:run_tracker/helpers/AppLanguage.dart';
import 'package:run_tracker/helpers/extensions/BuildContextExtension.dart';
import 'package:run_tracker/helpers/LanguageCode.dart';
import 'package:run_tracker/pages/SettingPage/ChooseGeolocationProviderDialog.dart';
import 'package:run_tracker/pages/SettingPage/ChooseLanguageDialog.dart';

final supportedLanguages = <AppLanguage>[
  AppLanguage(LanguageCode.ru, "русский"),
  AppLanguage(LanguageCode.en, "english"),
];

final supportedGeolocationProviders = GeolocationProviderKind.values;

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final currentLanguage = supportedLanguages.where((l) => l.codeString == locale.languageCode).first;
    final language = context.appLocalization.menuSettingsLanguage;
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    showChooseLanguageDialog() => showDialog(
          context: context,
          builder: (_) => ChooseLanguageDialog(
            supportedLanguages: supportedLanguages,
            currentLanguage: currentLanguage,
          ),
        );

    final geolocationProviderCubit = context.watch<GeolocationProviderCubit>();
    showChooseGeolocationProviderDialog() => {
          showDialog(
              context: context,
              builder: (_) => ChooseGeolocationProviderDialog(
                  supportedGeolocationProviders: supportedGeolocationProviders.map((p) => p.name).toList(),
                  currentGeolocationProvider: geolocationProviderCubit.state.name,
                  onSet: (name) => geolocationProviderCubit
                      .set(supportedGeolocationProviders.firstWhere((element) => element.name == name))))
        };

    return Scaffold(
      appBar: AppBar(),
      drawer: AppMainDrawer(),
      body: Center(
        child: ListView(
          children: [
            ListTile(
              onTap: showChooseLanguageDialog,
              leadingAndTrailingTextStyle: textStyle,
              leading: Icon(CupertinoIcons.globe),
              title: Text(language),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(currentLanguage.nativeName),
                  Icon(CupertinoIcons.forward),
                ],
              ),
            ),
            ListTile(
              onTap: showChooseGeolocationProviderDialog,
              leadingAndTrailingTextStyle: textStyle,
              leading: Icon(Icons.place),
              title: Text("GeolocationProvider"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(geolocationProviderCubit.state.name),
                  Icon(CupertinoIcons.forward),
                ],
              ),
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
