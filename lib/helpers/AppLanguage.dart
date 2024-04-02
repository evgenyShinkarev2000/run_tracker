
import 'package:run_tracker/helpers/LanguageCode.dart';

class AppLanguage {
  final LanguageCode codeEnum;
  final String nativeName;
  late final String codeString;

  AppLanguage(this.codeEnum, this.nativeName) {
    codeString = codeEnum.name.toLowerCase();
  }
}
