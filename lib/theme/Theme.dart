library theme;

import 'package:flutter/material.dart';

part "DashBoardTheme.dart";
part "MapPainterFullTheme.dart";
part "ThemeDataExtension.dart";

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
      ]);
}

final AppThemeLight = _applyThemeChanges(ThemeData.from(colorScheme: ColorScheme.light(primary: blue)));
final AppThemeDark = _applyThemeChanges(ThemeData.dark());
