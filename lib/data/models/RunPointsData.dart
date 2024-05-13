part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.runPoints)
class RunPointsData extends AppHiveObject {
  @HiveField(0)
  int? runCoverKey;

  @HiveField(1)
  final List<RunPointGeolocationData> geolocations;

  @HiveField(2)
  final RunPointStartData start;

  @HiveField(3)
  final RunPointStopData stop;

  @HiveField(4)
  final List<PulseMeasurementData> pulseMeasurements;

  RunPointsData({
    required this.geolocations,
    required this.start,
    required this.stop,
    required this.pulseMeasurements,
  });

  static RunPointsData fromJson(Map<String, dynamic> json) => _$RunPointsDataFromJson(json);

  Map<String, dynamic> toJson() => _$RunPointsDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunPointsData _$RunPointsDataFromJson(Map<String, dynamic> json) => RunPointsData(
      geolocations: (json['geolocations'] as List<dynamic>)
          .map((e) => RunPointGeolocationData.fromJson(e as Map<String, dynamic>))
          .toList(),
      start: RunPointStartData.fromJson(json['start'] as Map<String, dynamic>),
      stop: RunPointStopData.fromJson(json['stop'] as Map<String, dynamic>),
      pulseMeasurements: (json['pulseMeasurements'] as List<dynamic>)
          .map((e) => PulseMeasurementData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..runCoverKey = (json['runCoverKey'] as num?)?.toInt();

Map<String, dynamic> _$RunPointsDataToJson(RunPointsData instance) => <String, dynamic>{
      'runCoverKey': instance.runCoverKey,
      'geolocations': instance.geolocations,
      'start': instance.start,
      'stop': instance.stop,
      'pulseMeasurements': instance.pulseMeasurements,
    };
