import 'package:hive/hive.dart';
import 'package:run_tracker/data/models/RunCoverData.dart';

class RunCoverDataAdapter extends TypeAdapter<RunCoverData> {
  @override
  final int typeId = 1;

  @override
  RunCoverData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RunCoverData(
      title: fields[0] as String,
      startDateTime: fields[1] as DateTime,
      duration: fields[3] as int,
      distance: fields[5] as double,
      runPointsKey: fields[4] as int?,
      averageSpeed: fields[2] as double?,
      averagePulse: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, RunCoverData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.startDateTime)
      ..writeByte(2)
      ..write(obj.averageSpeed)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.runPointsKey)
      ..writeByte(5)
      ..write(obj.distance)
      ..writeByte(6)
      ..write(obj.averagePulse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunCoverDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
