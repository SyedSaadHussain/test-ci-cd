// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeLocalAdapter extends TypeAdapter<EmployeeLocal> {
  @override
  final int typeId = 61;

  @override
  EmployeeLocal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmployeeLocal(
      localId: fields[0] as String,
      parentLocalId: fields[1] as String,
      categoryIds: (fields[2] as List).cast<int>(),
      nameAr: fields[3] as String?,
      nameEn: fields[4] as String?,
      birthday: fields[5] as DateTime?,
      identificationId: fields[6] as String?,
      staffRelationType: fields[7] as String?,
      workEmail: fields[8] as String?,
      workPhone: fields[9] as String?,
      classificationId: fields[10] as int,
      verified: fields[11] as bool,
      gender: fields[12] as String?,
      statusDescAr: fields[13] as String?,
      occupationCode: fields[14] as String?,
      preSamisIssueDate: fields[15] as String?,
      idExpired: fields[16] as String?,
      cityOfBirth: fields[17] as String?,
      jobFamilyId: fields[18] as int?,
      jobId: fields[19] as int?,
      jobNumberId: fields[20] as int?,
      hijriBirthday: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeLocal obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.parentLocalId)
      ..writeByte(2)
      ..write(obj.categoryIds)
      ..writeByte(3)
      ..write(obj.nameAr)
      ..writeByte(4)
      ..write(obj.nameEn)
      ..writeByte(5)
      ..write(obj.birthday)
      ..writeByte(6)
      ..write(obj.identificationId)
      ..writeByte(7)
      ..write(obj.staffRelationType)
      ..writeByte(8)
      ..write(obj.workEmail)
      ..writeByte(9)
      ..write(obj.workPhone)
      ..writeByte(10)
      ..write(obj.classificationId)
      ..writeByte(11)
      ..write(obj.verified)
      ..writeByte(12)
      ..write(obj.gender)
      ..writeByte(13)
      ..write(obj.statusDescAr)
      ..writeByte(14)
      ..write(obj.occupationCode)
      ..writeByte(15)
      ..write(obj.preSamisIssueDate)
      ..writeByte(16)
      ..write(obj.idExpired)
      ..writeByte(17)
      ..write(obj.cityOfBirth)
      ..writeByte(18)
      ..write(obj.jobFamilyId)
      ..writeByte(19)
      ..write(obj.jobId)
      ..writeByte(20)
      ..write(obj.jobNumberId)
      ..writeByte(21)
      ..write(obj.hijriBirthday);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeLocalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
