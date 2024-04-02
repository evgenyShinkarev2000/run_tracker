import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:run_tracker/Router.dart';
import 'package:run_tracker/bloc/cubits/GeolocationProviderCubit.dart';
import 'package:run_tracker/themes/Theme.dart';
import 'package:run_tracker/bloc/cubits/LocalizationCubit.dart';
import 'package:run_tracker/bloc/cubits/ThemeCubit.dart';
import 'package:run_tracker/data/initAppData.dart';

void main() async {
  await initAppData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LocalizationCubit(WidgetsBinding.instance.platformDispatcher.locale)),
        BlocProvider(create: (_) => ThemeCubit(AppThemeLight)),
        BlocProvider(create: (_) => GeolocationProviderCubit(GeolocationProviderKind.Subscription)),
      ],
      child: Builder(
        builder: (context) {
          final blocLocale = context.watch<LocalizationCubit>().state;
          final blocTheme = context.watch<ThemeCubit>().state;

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: blocTheme,
            routerConfig: AppRouterConfig,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            locale: blocLocale,
            supportedLocales: [
              LocalizationCubit.enLocale,
              LocalizationCubit.ruLocale,
            ],
          );
        },
      ),
    );
  }
}
