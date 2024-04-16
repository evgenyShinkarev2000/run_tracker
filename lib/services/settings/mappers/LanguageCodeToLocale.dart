import 'package:flutter/material.dart';
import 'package:run_tracker/helpers/AppLanguageCode.dart';
import 'package:run_tracker/services/settings/mappers/IVariantToValueMapper.dart';

class LanguageCodeToLocale implements IVariantToValueMapper<AppLanguageCode, Locale> {
  @override
  Locale map(AppLanguageCode variant) {
    switch (variant) {
      case AppLanguageCode.ru:
        return Locale("ru");
      case AppLanguageCode.en:
        return Locale("en");
    }
  }
}
