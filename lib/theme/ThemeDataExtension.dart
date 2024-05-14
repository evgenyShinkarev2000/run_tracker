part of theme;

extension ThemeDataExtension on ThemeData {
  DashBoardTheme get dashBoardTheme => extension<DashBoardTheme>()!;
  MapPainterFullTheme get mapPainterFullTheme => extension<MapPainterFullTheme>()!;
  CustomColors get customColors => extension<CustomColors>()!;
  AppMapScreenButtonTheme get mapScreenButtonTheme => extension<AppMapScreenButtonTheme>()!;
}
