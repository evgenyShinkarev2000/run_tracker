import 'package:hive/hive.dart';
import 'package:run_tracker/data/models/RunPointsData.dart';

import '../models/RunItemGeolocationData.dart';
import '../models/RunItemStartData.dart';
import '../models/RunItemStopData.dart';

class RunRecordDataAdapter extends TypeAdapter<RunPointsData> {
  @override
  final int typeId = 2;

  @override
  RunPointsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RunPointsData(
      geolocations: (fields[1] as List).cast<RunPointGeolocationData>(),
      start: fields[2] as RunPointStartData,
      stop: fields[3] as RunPointStopData,
    )..runCoverKey = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, RunPointsData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.runCoverKey)
      ..writeByte(1)
      ..write(obj.geolocations)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.stop);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunRecordDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
