part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.setting)
class SettingData extends HiveObject {
  @override
  String? get key => super.key;

  String? get watchKey => _watchKey ?? key;
  final String? _watchKey;

  @HiveField(0)
  String? value;

  SettingData({this.value, String? watchKey}) : _watchKey = watchKey;

  static SettingData fromJson(Map<String, dynamic> json) => _$SettingDataFromJson(json);

  Map<String, dynamic> toJson() => _$SettingDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingData _$SettingDataFromJson(Map<String, dynamic> json) => SettingData(
      value: json['value'] as String?,
      watchKey: json['watchKey'] as String?,
    );

Map<String, dynamic> _$SettingDataToJson(SettingData instance) => <String, dynamic>{
      'watchKey': instance.watchKey,
      'value': instance.value,
    };
