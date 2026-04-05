import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:run_tracker/Components/Loader/AppInitLoader.dart';
import 'package:run_tracker/Core/export.dart';
import 'package:run_tracker/Data/AppDatabase.dart';
import 'package:run_tracker/Data/AppSettings.dart';
import 'package:run_tracker/Providers/AppRouterProvider.dart';
import 'package:run_tracker/Providers/Settings/export.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/l10n/app_localizations.dart';
import 'package:run_tracker/localization/export.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppDatabase.Initialize();

  final appSettings = await _loadAppSettings();
  final talker = TalkerFlutter.init(
    logger: TalkerLogger(formatter: ColoredLoggerFormatter()),
  );
  final providerContainer = ProviderContainer(
    observers: [TalkerRiverpodObserver(talker: talker)],
    overrides: [
      appSettingsProvider.overrideWithValue(appSettings),
      talkerProvider.overrideWithValue(talker),
    ],
  );
  final logger = providerContainer.read(loggerProvider);
  FlutterError.onError = (FlutterErrorDetails error) {
    logger.logError(null, appException: FlutterExceptionWrapper(error));
  };

  runApp(
    UncontrolledProviderScope(container: providerContainer, child: MyApp()),
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
    var appLocale = ref.watch(localeProvider);
    if (appLocale.isLoading) {
      return AppInitLoader();
    }
    var appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Run tracker',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: appLocale.value?.locale,
      supportedLocales: AppLocales.supportedLocales,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Roboto',
      ),
      routerConfig: appRouter,
      builder: FToastBuilder(),
    );
  }
}
