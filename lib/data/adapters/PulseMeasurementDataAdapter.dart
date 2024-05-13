part of adapters;

class PulseMeasurementDataAdapter extends TypeAdapter<PulseMeasurementData> {
  @override
  final int typeId = 7;

  @override
  PulseMeasurementData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PulseMeasurementData(
      dateTime: fields[0] as DateTime,
      pulse: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PulseMeasurementData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dateTime)
      ..writeByte(1)
      ..write(obj.pulse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PulseMeasurementDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
