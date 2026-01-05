import 'dart:ui';

class AppLocales {
  static const Locale en = Locale('en');
  static const Locale ru = Locale('ru');

  static final List<Locale> supported = [en, ru];

  static Locale get fallback {
    _fallback ??= fromCodeOrNull(PlatformDispatcher.instance.locale.languageCode);

    return _fallback!;
  }

  static Locale? _fallback;

  static Locale? fromCodeOrNull(String? localeCode) {
    if (localeCode == null) {
      return null;
    }
    return supported
        .where(
          (l) => l.languageCode == localeCode || l.countryCode == localeCode,
        )
        .firstOrNull;
  }

  static Locale fromCodeOrFallback(String? localeCode) {
    if (localeCode == null) {
      return AppLocales.fallback;
    }

    return fromCodeOrNull(localeCode) ?? AppLocales.fallback;
  }
}
