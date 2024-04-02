import 'package:hive/hive.dart';
import 'package:run_tracker/data/models/RunItemGeolocationData.dart';
import 'package:run_tracker/data/models/RunItemStopData.dart';

class RunPointStopDataAdapter extends TypeAdapter<RunPointStopData> {
  @override
  final int typeId = 5;

  @override
  RunPointStopData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RunPointStopData(
      dateTime: fields[0] as DateTime,
      geolocation: fields[1] as RunPointGeolocationData?,
    );
  }

  @override
  void write(BinaryWriter writer, RunPointStopData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.geolocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunPointStopDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
