import 'dart:async';

abstract class SettingSetBase {
  bool isInitialized = false;

  late final String name;
  SettingSetBase({required String name, String? prefix}) {
    if (prefix != null) {
      this.name = name;
      this.name = buildSettingName(prefix);
    } else {
      this.name = name;
    }
  }

  Future<void> init();

  Future<void> initFutures(Iterable<Future> Function() futuresBuilder) async {
    if (isInitialized) {
      return;
    }
    await Future.wait(futuresBuilder());
    isInitialized = true;
  }

  String buildSettingName(String name) {
    return "${this.name}.$name";
  }
}
