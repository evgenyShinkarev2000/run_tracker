import 'package:flutter/material.dart';
import 'package:run_tracker/themes/MapPainterFullTheme.dart';

import 'DashBoardTheme.dart';

const blue = Colors.blue;
final grey200 = Colors.grey[200]!;
final grey100 = Colors.grey[100]!;
const black = Colors.black;
final brightGreen = Color.fromARGB(255, 68, 248, 74);
final brightRed = Color.fromARGB(255, 255, 62, 62);

ThemeData _applyThemeChanges(ThemeData themeData) {
  return themeData.copyWith(
      iconButtonTheme: IconButtonThemeData(
        style: themeData.iconButtonTheme.style?.copyWith(iconSize: MaterialStatePropertyAll<double>(40)),
      ),
      extensions: [
        CustomColors(),
        DashBoardTheme(
          backgroundColor: themeData.colorScheme.background,
          outerBorderColor: black,
          innerBorderColor: blue,
        ),
        MapPainterFullTheme(
          startMarkerColor: brightGreen,
          stopMarkerColor: brightRed,
        ),
      ]);
}

final AppThemeLight = _applyThemeChanges(ThemeData.from(colorScheme: ColorScheme.light(primary: blue)));
final AppThemeDark = _applyThemeChanges(ThemeData.dark());

extension ThemeDataExtension on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
  DashBoardTheme get dashBoardTheme => extension<DashBoardTheme>()!;
  MapPainterFullTheme get mapPainterFullTheme => extension<MapPainterFullTheme>()!;
}

class CustomColors extends ThemeExtension<CustomColors> {
  @override
  ThemeExtension<CustomColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<CustomColors> lerp(covariant ThemeExtension<CustomColors>? other, double t) {
    return this;
  }
}
