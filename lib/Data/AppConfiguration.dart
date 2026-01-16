class AppConfiguration {
  const AppConfiguration();

  static String get NativeMapUriTemplate => _hasNativeMapUriTempalte
      ? _nativeMapUriTemplate
      : throw Exception(
          "Configuration value for key $_hasNativeMapUriTempalte must be set",
        );
  static const String _nativeMapUriTempalteKey = "NATIVE_MAP_URI_TEMPLATE";
  static const String _nativeMapUriTemplate = String.fromEnvironment(
    _nativeMapUriTempalteKey,
  );
  static const bool _hasNativeMapUriTempalte = bool.fromEnvironment(
    _nativeMapUriTempalteKey,
  );

  static const String WebMapUriTemplate = String.fromEnvironment(
    "WEB_MAP_URI_TEMPLATE",
    defaultValue: "map/{z}/{x}/{y}.png",
  );
}
