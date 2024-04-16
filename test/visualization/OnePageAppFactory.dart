import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnePageAppFactory {
  Widget create({
    String title = "",
    required Widget home,
  }) {
    return MaterialApp(
      title: title,
      locale: Locale("en"),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(),
        body: home,
      ),
    );
  }
}
