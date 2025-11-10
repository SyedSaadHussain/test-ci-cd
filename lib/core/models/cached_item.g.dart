// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CachedItemAdapter extends TypeAdapter<CachedItem> {
  @override
  final int typeId = 101;

  @override
  CachedItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CachedItem(
      item: fields[0] as dynamic,
      cachedAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CachedItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CachedItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
