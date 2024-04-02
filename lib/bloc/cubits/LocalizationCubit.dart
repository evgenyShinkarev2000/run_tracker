import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/helpers/LanguageCode.dart';

class LocalizationCubit extends Cubit<Locale> {
  static final ruLocale = Locale(LanguageCode.ru.name);
  static final enLocale = Locale(LanguageCode.en.name);

  LocalizationCubit(super.initialState);

  void setRus() => emit(ruLocale);
  void setEng() => emit(enLocale);
}
