import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/AppTheme.dart';
import 'package:run_tracker/services/settings/mappers/IVariantToValueMapper.dart';
import 'package:run_tracker/themes/Theme.dart';

class ThemeNameToThemeData implements IVariantToValueMapper<AppTheme, ThemeData> {
  @override
  ThemeData map(AppTheme variant) {
    switch (variant) {
      case AppTheme.light:
        return AppThemeLight;
      case AppTheme.dark:
        return AppThemeDark;
    }
  }
}
