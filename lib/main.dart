import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/components/future_builder_loader/MultiFutureBuilderLoader.dart';
import 'package:run_tracker/data/data.dart';
import 'package:run_tracker/data/repositories/repositories.dart';
import 'package:run_tracker/helpers/AppLanguageCode.dart';
import 'package:run_tracker/helpers/extensions/SettingExtension.dart';
import 'package:run_tracker/services/settings/settings.dart';

void main() async {
  await initAppData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilderLoader(
      loader: (_, __) => Container(),
      register: (builder) {
        builder.register(Future(() async {
          final settingRepository = await SettingRepositoryFactory().create();
          final settingsProvider = SettingsProvider(settingRepository);
          await settingsProvider.appSettings.init();

          return settingsProvider;
        }));
      },
      builder: (context, store) => MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsProvider>(create: (_) => store.get()),
        ],
        child: Builder(
          builder: (context) {
            final appSettings = context.watch<SettingsProvider>().appSettings;

            return MaterialApp.router(
              title: 'Flutter Demo',
              theme: appSettings.theme.valueOrDefault!,
              routerConfig: AppRouterConfig,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              locale: appSettings.locale.valueOrDefault!,
              supportedLocales: [
                Locale(AppLanguageCode.en.name),
                Locale(AppLanguageCode.ru.name),
              ],
            );
          },
        ),
      ),
    );
  }
}
