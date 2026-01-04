import 'package:flutter/material.dart';
import 'package:run_tracker/l10n/app_localizations.dart';

extension AppBuildContextExtension on BuildContext {
  AppLocalizations get appLocalization => AppLocalizations.of(this)!;
}