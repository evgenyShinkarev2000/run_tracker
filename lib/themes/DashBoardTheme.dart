import 'package:flutter/material.dart';

class DashBoardTheme extends ThemeExtension<DashBoardTheme> {
  final Color backgroundColor;
  final Color outerBorderColor;
  final Color innerBorderColor;

  DashBoardTheme(
      {required this.backgroundColor,
      required this.outerBorderColor,
      required this.innerBorderColor});

  @override
  ThemeExtension<DashBoardTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<DashBoardTheme> lerp(
      covariant ThemeExtension<DashBoardTheme>? other, double t) {
    return this;
  }
}
