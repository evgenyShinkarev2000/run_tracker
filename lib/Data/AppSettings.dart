import 'package:flutter/foundation.dart';

class AppSettings {
  final String? nativeMapUriTempalate;
  final String? webMapUriTemplate;
  String get mapUriTemplate =>
      kIsWeb ? webMapUriTemplate! : nativeMapUriTempalate!;

  final Duration? overrideMapCacheDuration;

  AppSettings.AppSettings({
    required this.nativeMapUriTempalate,
    required this.webMapUriTemplate,
    required this.overrideMapCacheDuration,
  }) : assert(
         kIsWeb ||
             (nativeMapUriTempalate != null &&
                 nativeMapUriTempalate.isNotEmpty),
         "nativeMapUriTempalte musn't be null or empty, when !kIsWeb",
       ),
       assert(
         !kIsWeb || (webMapUriTemplate != null && webMapUriTemplate.isNotEmpty),
         "webMapUriTemplate musn't be null or empty, when kIsWeb",
       );

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    final overrideMapCacheDurationDay =
        json["overrideMapCacheDurationDay"] as int?;
    Duration? overrideMapCacheDuration;
    if (overrideMapCacheDurationDay != null) {
      overrideMapCacheDuration = Duration(days: overrideMapCacheDurationDay);
    }

    return AppSettings.AppSettings(
      nativeMapUriTempalate: json["nativeMapUriTemplate"] as String?,
      webMapUriTemplate: json["webMapUriTemplate"] as String?,
      overrideMapCacheDuration: overrideMapCacheDuration,
    );
  }
}
