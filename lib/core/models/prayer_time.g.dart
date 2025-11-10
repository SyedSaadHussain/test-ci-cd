// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_time.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerTimeAdapter extends TypeAdapter<PrayerTime> {
  @override
  final int typeId = 6;

  @override
  PrayerTime read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerTime(
      fajarTime: fields[0] as DateTime?,
      duharTime: fields[1] as DateTime?,
      asarTime: fields[2] as DateTime?,
      magribTime: fields[3] as DateTime?,
      ishaTime: fields[4] as DateTime?,
      cityId: fields[5] as int?,
      cityName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerTime obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.fajarTime)
      ..writeByte(1)
      ..write(obj.duharTime)
      ..writeByte(2)
      ..write(obj.asarTime)
      ..writeByte(3)
      ..write(obj.magribTime)
      ..writeByte(4)
      ..write(obj.ishaTime)
      ..writeByte(5)
      ..write(obj.cityId)
      ..writeByte(6)
      ..write(obj.cityName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerTimeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
