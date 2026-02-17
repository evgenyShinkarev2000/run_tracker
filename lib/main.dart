import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Components/Loader/AppInitLoader.dart';
import 'package:run_tracker/Data/AppDatabase.dart';
import 'package:run_tracker/Data/AppSettings.dart';
import 'package:run_tracker/Providers/AppSettingsProvider.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/Routing/export.dart';
import 'package:run_tracker/l10n/app_localizations.dart';
import 'package:run_tracker/localization/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.Initialize();

  final appSettings = await _loadAppSettings();

  runApp(
    ProviderScope(
      overrides: [appSettingsProvider.overrideWithValue(appSettings)],
      child: MyApp(),
    ),
  );
}

Future<AppSettings> _loadAppSettings() async {
  final serializedAppSettings = await rootBundle.loadString("appsettings.json");

  return AppSettings.fromJson(
    jsonDecode(serializedAppSettings) as Map<String, dynamic>,
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locale = ref.watch(localeProvider);
    if (locale.isLoading) {
      return AppInitLoader();
    }

    return MaterialApp.router(
      title: 'Run tracker',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale.value,
      supportedLocales: AppLocales.supported,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Roboto',
      ),
      routerConfig: appRouter,
    );
  }
}
