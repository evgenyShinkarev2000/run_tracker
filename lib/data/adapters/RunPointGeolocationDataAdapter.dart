part of adapters;

class RunPointGeolocationDataAdapter extends TypeAdapter<RunPointGeolocationData> {
  @override
  final int typeId = 3;

  @override
  RunPointGeolocationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RunPointGeolocationData(
      dateTime: fields[0] as DateTime,
      speed: fields[1] as double?,
      altitude: fields[2] as double,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RunPointGeolocationData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.speed)
      ..writeByte(2)
      ..write(obj.altitude)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunPointGeolocationDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
