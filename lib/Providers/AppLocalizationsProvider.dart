import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run_tracker/Providers/export.dart';
import 'package:run_tracker/l10n/app_localizations.dart';
import 'package:run_tracker/localization/export.dart';

final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final locale = ref.watch(localeProvider);

  return lookupAppLocalizations(
    locale.value?.locale ?? AppLocales.fallback.locale,
  );
});
