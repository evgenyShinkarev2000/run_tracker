part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.runPointStop)
class RunPointStopData implements RunItemData {
  @override
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final RunPointGeolocationData? geolocation;

  RunPointStopData({required this.dateTime, this.geolocation});

  static RunPointStopData fromJson(Map<String, dynamic> json) => _$RunPointStopDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunPointStopDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunPointStopData _$RunPointStopDataFromJson(Map<String, dynamic> json) => RunPointStopData(
      dateTime: DateTime.parse(json['dateTime'] as String),
      geolocation: json['geolocation'] == null
          ? null
          : RunPointGeolocationData.fromJson(json['geolocation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RunPointStopDataToJson(RunPointStopData instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'geolocation': instance.geolocation,
    };
