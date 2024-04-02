import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:run_tracker/themes/Theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit(super.initialState);

  void setLight() => emit(AppThemeLight);
  void setDark() => emit(AppThemeDark);
}
