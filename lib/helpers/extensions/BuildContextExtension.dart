import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:run_tracker/api/WebApi.dart';
import 'package:run_tracker/helpers/WebApiProvider.dart';

extension AppBuildContextExtension on BuildContext {
  AppLocalizations get appLocalization => AppLocalizations.of(this)!;
  ThemeData get themeData => Theme.of(this);
  WebApi get webApi => read<WebApiProvider>().webApi;
}
