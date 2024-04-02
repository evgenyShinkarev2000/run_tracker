import 'package:flutter/material.dart';

class MapPainterFullTheme extends ThemeExtension<MapPainterFullTheme> {
  final Color startMarkerColor;
  final Color stopMarkerColor;

  MapPainterFullTheme(
      {required this.startMarkerColor, required this.stopMarkerColor});

  @override
  ThemeExtension<MapPainterFullTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<MapPainterFullTheme> lerp(
      covariant ThemeExtension<MapPainterFullTheme>? other, double t) {
    return this;
  }
}
