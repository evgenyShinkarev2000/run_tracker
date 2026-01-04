import 'dart:ui';

class AppLocales {
  static const Locale en = Locale('en');
  static const Locale ru = Locale('ru');
  
  static final List<Locale> supported = [en, ru];
  
  static Locale get fallback => en;
}