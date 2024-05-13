part of models;

@JsonSerializable()
@HiveType(typeId: HiveTypeId.pulseMeasurement)
class PulseMeasurementData {
  @HiveField(0)
  final DateTime dateTime;

  @HiveField(1)
  final double pulse;

  PulseMeasurementData({
    required this.dateTime,
    required this.pulse,
  });

  static PulseMeasurementData fromJson(Map<String, dynamic> json) => _$PulseMeasurementDataFromJson(json);

  Map<String, dynamic> toJson() => _$PulseMeasurementDataToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PulseMeasurementData _$PulseMeasurementDataFromJson(Map<String, dynamic> json) => PulseMeasurementData(
      dateTime: DateTime.parse(json['dateTime'] as String),
      pulse: (json['pulse'] as num).toDouble(),
    );

Map<String, dynamic> _$PulseMeasurementDataToJson(PulseMeasurementData instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'pulse': instance.pulse,
    };
