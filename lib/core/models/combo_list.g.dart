// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_list.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ComboItemAdapter extends TypeAdapter<ComboItem> {
  @override
  final int typeId = 5;

  @override
  ComboItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ComboItem(
      key: fields[1] as dynamic,
      value: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ComboItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComboItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
