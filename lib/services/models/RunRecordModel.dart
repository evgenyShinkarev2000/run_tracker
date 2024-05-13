part of models;

@JsonSerializable(explicitToJson: true)
class RunRecordModel {
  RunCoverData runCoverData;
  RunPointsData runPointsData;

  RunRecordModel({required this.runCoverData, required this.runPointsData});

  static RunRecordModel fromJson(Map<String, dynamic> json) => _$RunRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$RunRecordModelToJson(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunRecordModel _$RunRecordModelFromJson(Map<String, dynamic> json) => RunRecordModel(
      runCoverData: RunCoverData.fromJson(json['runCoverData'] as Map<String, dynamic>),
      runPointsData: RunPointsData.fromJson(json['runPointsData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RunRecordModelToJson(RunRecordModel instance) => <String, dynamic>{
      'runCoverData': instance.runCoverData.toJson(),
      'runPointsData': instance.runPointsData.toJson(),
    };
