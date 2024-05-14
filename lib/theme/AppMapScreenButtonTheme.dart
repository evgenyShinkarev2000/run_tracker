part of theme;

class AppMapScreenButtonTheme extends ThemeExtension<AppMapScreenButtonTheme> {
  final double size;
  final Color color;

  AppMapScreenButtonTheme({this.size = 24, this.color = Colors.black});

  @override
  ThemeExtension<AppMapScreenButtonTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<AppMapScreenButtonTheme> lerp(covariant ThemeExtension<AppMapScreenButtonTheme>? other, double t) {
    return this;
  }
}
