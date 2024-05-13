part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.runPointGeolocation)
class RunPointGeolocationData implements RunItemData {
  @override
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final double? speed;

  @HiveField(2)
  final double altitude;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final double? accuracy;

  RunPointGeolocationData(
      {required this.dateTime,
      this.speed,
      required this.altitude,
      required this.latitude,
      required this.longitude,
      this.accuracy});

  static RunPointGeolocationData fromJson(Map<String, dynamic> json) => _$RunPointGeolocationDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunPointGeolocationDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunPointGeolocationData _$RunPointGeolocationDataFromJson(Map<String, dynamic> json) => RunPointGeolocationData(
      dateTime: DateTime.parse(json['dateTime'] as String),
      speed: (json['speed'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RunPointGeolocationDataToJson(RunPointGeolocationData instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'speed': instance.speed,
      'altitude': instance.altitude,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'accuracy': instance.accuracy,
    };
