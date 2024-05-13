part of adapters;

class SettingDataAdapter extends TypeAdapter<SettingData> {
  @override
  final int typeId = 6;

  @override
  SettingData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingData(
      value: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingData obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
