import 'package:run_tracker/helpers/AppLanguageCode.dart';

class AppLanguage {
  final AppLanguageCode codeEnum;
  final String nativeName;
  late final String codeString;

  AppLanguage(this.codeEnum, this.nativeName) {
    codeString = codeEnum.name.toLowerCase();
  }
}
