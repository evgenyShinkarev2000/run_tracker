import 'package:hive/hive.dart';
import 'package:run_tracker/data/HiveTypeId.dart';

@HiveType(typeId: HiveTypeId.setting)
class SettingData extends HiveObject {
  @override
  String? get key => super.key;

  String? get watchKey => _watchKey ?? key;
  final String? _watchKey;

  @HiveField(0)
  String? value;

  SettingData({this.value, String? watchKey}) : _watchKey = watchKey;

  Map<String, dynamic> toJson() {
    return {
      "watchKey": key,
      "value": value,
    };
  }

  static SettingData fromJson(Map<dynamic, dynamic> json) {
    return SettingData(watchKey: json["watchKey"], value: json["value"]);
  }
}
