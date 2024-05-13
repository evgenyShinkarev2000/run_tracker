part of adapters;

class RunPointStartDataAdapter extends TypeAdapter<RunPointStartData> {
  @override
  final int typeId = 4;

  @override
  RunPointStartData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RunPointStartData(
      dateTime: fields[0] as DateTime,
      geolocation: fields[1] as RunPointGeolocationData?,
    );
  }

  @override
  void write(BinaryWriter writer, RunPointStartData obj) {
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
      other is RunPointStartDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
