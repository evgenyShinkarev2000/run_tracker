part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.runPointStart)
class RunPointStartData implements RunItemData {
  @override
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final RunPointGeolocationData? geolocation;

  RunPointStartData({required this.dateTime, this.geolocation});

  static RunPointStartData fromJson(Map<String, dynamic> json) => _$RunPointStartDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunPointStartDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunPointStartData _$RunPointStartDataFromJson(Map<String, dynamic> json) => RunPointStartData(
      dateTime: DateTime.parse(json['dateTime'] as String),
      geolocation: json['geolocation'] == null
          ? null
          : RunPointGeolocationData.fromJson(json['geolocation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RunPointStartDataToJson(RunPointStartData instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'geolocation': instance.geolocation,
    };
