import 'package:flutter/material.dart';
import 'package:run_tracker/themes/MapPainterFullTheme.dart';

import 'DashBoardTheme.dart';

const blue = Colors.blue;
final grey200 = Colors.grey[200]!;
final grey100 = Colors.grey[100]!;
const black = Colors.black;
final brightGreen = Color.fromARGB(255, 68, 248, 74);
final brightRed = Color.fromARGB(255, 255, 62, 62);

final AppThemeLight = ThemeData(
    textTheme: TextTheme(
      labelMedium: TextStyle(fontSize: 16),
      labelLarge: TextStyle(fontSize: 20),
    ),
    colorScheme: ColorScheme.light(primary: blue),
    appBarTheme: AppBarTheme(
      backgroundColor: grey200,
      toolbarHeight: 40,
    ),
    dialogTheme: DialogTheme(surfaceTintColor: grey200),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconSize: MaterialStatePropertyAll<double>(40),
      ),
    ),
    useMaterial3: true,
    extensions: [
      CustomColors(),
      DashBoardTheme(
        backgroundColor: grey100,
        outerBorderColor: black,
        innerBorderColor: blue,
      ),
      MapPainterFullTheme(
        startMarkerColor: brightGreen,
        stopMarkerColor: brightRed,
      ),
    ]);

final AppThemeDark = ThemeData();

extension ThemeDataExtension on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
  DashBoardTheme get dashBoardTheme => extension<DashBoardTheme>()!;
  MapPainterFullTheme get mapPainterFullTheme =>
      extension<MapPainterFullTheme>()!;
}

class CustomColors extends ThemeExtension<CustomColors> {
  @override
  ThemeExtension<CustomColors> copyWith() {
    return this;
  }

  @override
  ThemeExtension<CustomColors> lerp(
      covariant ThemeExtension<CustomColors>? other, double t) {
    return this;
  }
}
