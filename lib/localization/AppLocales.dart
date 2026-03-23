import 'dart:ui';

class AppLocales {
  static const AppLocale en = AppLocale._(Locale('en'), "english");
  static const AppLocale ru = AppLocale._(Locale('ru'), "русский");

  static final Iterable<AppLocale> supported = List.unmodifiable([en, ru]);
  static final Iterable<Locale> supportedLocales = List.unmodifiable(
    supported.map((al) => al.locale),
  );

  static AppLocale get fallback {
    _fallback ??= fromCodeOrNull(
      PlatformDispatcher.instance.locale.languageCode,
    ) ?? en;

    return _fallback!;
  }

  static AppLocale? _fallback;

  static AppLocale? fromCodeOrNull(String? localeCode) {
    if (localeCode == null) {
      return null;
    }
    return supported
        .where(
          (l) =>
              l.locale.languageCode == localeCode ||
              l.locale.countryCode == localeCode,
        )
        .firstOrNull;
  }

  static AppLocale fromCodeOrFallback(String? localeCode) {
    if (localeCode == null) {
      return AppLocales.fallback;
    }

    return fromCodeOrNull(localeCode) ?? AppLocales.fallback;
  }
}

class AppLocale {
  final Locale locale;
  final String displayName;

  const AppLocale._(this.locale, this.displayName);

  @override
  int get hashCode => Object.hash(locale, displayName);

  @override
  bool operator ==(Object other) {
    return other is AppLocale &&
        other.locale == locale &&
        other.displayName == displayName;
  }
}
