part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.runCover)
class RunCoverData extends AppHiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime startDateTime;

  @HiveField(2)
  double? averageSpeed;

  // mks
  @HiveField(3)
  int duration;

  @HiveField(4)
  int? runPointsKey;

  @HiveField(5)
  double distance;

  @HiveField(6)
  double? averagePulse;

  RunCoverData(
      {required this.title,
      required this.startDateTime,
      required this.duration,
      required this.distance,
      this.runPointsKey,
      this.averageSpeed,
      this.averagePulse});

  static RunCoverData fromJson(Map<String, dynamic> json) => _$RunCoverDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunCoverDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunCoverData _$RunCoverDataFromJson(Map<String, dynamic> json) => RunCoverData(
      title: json['title'] as String,
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      duration: (json['duration'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      runPointsKey: (json['runPointsKey'] as num?)?.toInt(),
      averageSpeed: (json['averageSpeed'] as num?)?.toDouble(),
      averagePulse: (json['averagePulse'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$RunCoverDataToJson(RunCoverData instance) => <String, dynamic>{
      'title': instance.title,
      'startDateTime': instance.startDateTime.toIso8601String(),
      'averageSpeed': instance.averageSpeed,
      'duration': instance.duration,
      'runPointsKey': instance.runPointsKey,
      'distance': instance.distance,
      'averagePulse': instance.averagePulse,
    };
