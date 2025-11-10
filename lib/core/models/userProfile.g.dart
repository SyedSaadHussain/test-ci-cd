// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userProfile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 16;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      userId: fields[0] as int,
      email: fields[2] as String?,
      phone: fields[3] as String?,
      name: fields[1] as String?,
      cityIds: (fields[4] as List?)?.cast<ComboItem>(),
      parentId: fields[5] as int?,
      parent: fields[6] as String?,
      stateIds: (fields[7] as List?)?.cast<ComboItem>(),
      roleNames: (fields[8] as List?)?.cast<String>(),
      employeeId: fields[9] as int?,
      employee: fields[10] as String?,
      moiaCenterIds: (fields[11] as List?)?.cast<ComboItem>(),
      userAppVersion: fields[12] as String?,
      classificationId: fields[13] as int?,
      classification: fields[14] as String?,
      identificationId: fields[15] as String?,
      staffRelationType: fields[16] as String?,
      genderArabic: fields[17] as String?,
      isDeviceVerify: fields[18] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.cityIds)
      ..writeByte(5)
      ..write(obj.parentId)
      ..writeByte(6)
      ..write(obj.parent)
      ..writeByte(7)
      ..write(obj.stateIds)
      ..writeByte(8)
      ..write(obj.roleNames)
      ..writeByte(9)
      ..write(obj.employeeId)
      ..writeByte(10)
      ..write(obj.employee)
      ..writeByte(11)
      ..write(obj.moiaCenterIds)
      ..writeByte(12)
      ..write(obj.userAppVersion)
      ..writeByte(13)
      ..write(obj.classificationId)
      ..writeByte(14)
      ..write(obj.classification)
      ..writeByte(15)
      ..write(obj.identificationId)
      ..writeByte(16)
      ..write(obj.staffRelationType)
      ..writeByte(17)
      ..write(obj.genderArabic)
      ..writeByte(18)
      ..write(obj.isDeviceVerify);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
