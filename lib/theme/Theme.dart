library theme;

import 'package:flutter/material.dart';

part "DashBoardTheme.dart";
part "MapPainterFullTheme.dart";
part "ThemeDataExtension.dart";
part "CustomColors.dart";

const blue = Colors.blue;
const black = Colors.black;
final brightGreen = Color.fromARGB(255, 68, 248, 74);
final brightRed = Color.fromARGB(255, 255, 62, 62);

ThemeData _applyThemeChanges(ThemeData themeData) {
  return themeData.copyWith(
      iconButtonTheme: IconButtonThemeData(
        style: themeData.iconButtonTheme.style?.copyWith(iconSize: MaterialStatePropertyAll<double>(40)),
      ),
      extensions: [
        DashBoardTheme(
          backgroundColor: themeData.colorScheme.background,
          outerBorderColor: black,
          innerBorderColor: blue,
        ),
        MapPainterFullTheme(
          startMarkerColor: brightGreen,
          stopMarkerColor: brightRed,
        ),
        CustomColors(),
      ]);
}

ThemeData _applyLightThemeChanges(ThemeData themeData) {
  return themeData.copyWith(
      appBarTheme: themeData.appBarTheme.copyWith(
    backgroundColor: Color.fromARGB(255, 237, 242, 244),
    // backgroundColor: Color.lerp(themeData.colorScheme.background, themeData.colorScheme.primary, 0.075),
  ));
}

ThemeData _applyDarkThemeChanges(ThemeData themeData) {
  return themeData.copyWith(
      appBarTheme: themeData.appBarTheme.copyWith(
    backgroundColor: Color.lerp(themeData.colorScheme.background, themeData.colorScheme.primary, 0.03),
    // backgroundColor: Color.fromARGB(255, 31, 29, 29),
  ));
}

final AppThemeLight = _applyLightThemeChanges(
  _applyThemeChanges(
    ThemeData.from(colorScheme: ColorScheme.light(primary: blue)),
  ),
);
final AppThemeDark = _applyDarkThemeChanges(
  _applyThemeChanges(
    ThemeData.dark(),
  ),
);
