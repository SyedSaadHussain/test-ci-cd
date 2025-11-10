// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_land_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitLandModelAdapter extends TypeAdapter<VisitLandModel> {
  @override
  final int typeId = 13;

  @override
  VisitLandModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitLandModel(
      id: fields[1] as int?,
      landAddress: fields[13] as String?,
      stage: fields[3] as String?,
      stageId: fields[4] as int?,
      name: fields[6] as String?,
      landId: fields[7] as int?,
      land: fields[8] as String?,
      employeeId: fields[9] as int?,
      employee: fields[10] as String?,
      state: fields[2] as String?,
      priorityValue: fields[12] as String?,
    )
      ..btnStart = fields[5] as bool?
      ..dateOfVisit = fields[11] as String?
      ..regionId = fields[14] as int?
      ..region = fields[15] as String?
      ..cityId = fields[16] as int?
      ..city = fields[17] as String?
      ..moiaCenterId = fields[18] as int?
      ..moiaCenter = fields[19] as String?
      ..latitude = fields[20] as double?
      ..longitude = fields[21] as double?
      ..landType = fields[22] as String?
      ..hasOwnershipSign = fields[23] as String?
      ..ownershipSignPhoto = fields[24] as String?
      ..easyAccess = fields[25] as String?
      ..pavedRoads = fields[26] as String?
      ..hasTemporaryBuildings = fields[27] as String?
      ..temporaryBuildingType = fields[28] as String?
      ..hasEncroachment = fields[29] as String?
      ..encroachmentType = fields[30] as String?
      ..encroachmentPhoto = fields[31] as String?
      ..hasElectricityMeter = fields[32] as String?
      ..electricityMeterNumber = fields[33] as String?
      ..hasMeterEncroachment = fields[34] as String?
      ..meterEncroachmentPhoto = fields[35] as String?
      ..hasTreesGrass = fields[36] as String?
      ..isFenced = fields[37] as String?
      ..hasWaterSwamps = fields[38] as String?
      ..hasSafetyHazards = fields[39] as String?
      ..isWasteFree = fields[40] as String?
      ..safetyHazardDescription = fields[42] as String?
      ..notes = fields[43] as String?
      ..landTypeNotes = fields[44] as String?
      ..tempBuildingNotes = fields[45] as String?
      ..electricityMetersNotes = fields[46] as String?
      ..environmentConditionalNotes = fields[47] as String?
      ..startDatetime = fields[41] as String?
      ..createdAt = fields[250] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, VisitLandModel obj) {
    writer
      ..writeByte(48)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.state)
      ..writeByte(3)
      ..write(obj.stage)
      ..writeByte(4)
      ..write(obj.stageId)
      ..writeByte(5)
      ..write(obj.btnStart)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.landId)
      ..writeByte(8)
      ..write(obj.land)
      ..writeByte(9)
      ..write(obj.employeeId)
      ..writeByte(10)
      ..write(obj.employee)
      ..writeByte(11)
      ..write(obj.dateOfVisit)
      ..writeByte(12)
      ..write(obj.priorityValue)
      ..writeByte(13)
      ..write(obj.landAddress)
      ..writeByte(14)
      ..write(obj.regionId)
      ..writeByte(15)
      ..write(obj.region)
      ..writeByte(16)
      ..write(obj.cityId)
      ..writeByte(17)
      ..write(obj.city)
      ..writeByte(18)
      ..write(obj.moiaCenterId)
      ..writeByte(19)
      ..write(obj.moiaCenter)
      ..writeByte(20)
      ..write(obj.latitude)
      ..writeByte(21)
      ..write(obj.longitude)
      ..writeByte(22)
      ..write(obj.landType)
      ..writeByte(23)
      ..write(obj.hasOwnershipSign)
      ..writeByte(24)
      ..write(obj.ownershipSignPhoto)
      ..writeByte(25)
      ..write(obj.easyAccess)
      ..writeByte(26)
      ..write(obj.pavedRoads)
      ..writeByte(27)
      ..write(obj.hasTemporaryBuildings)
      ..writeByte(28)
      ..write(obj.temporaryBuildingType)
      ..writeByte(29)
      ..write(obj.hasEncroachment)
      ..writeByte(30)
      ..write(obj.encroachmentType)
      ..writeByte(31)
      ..write(obj.encroachmentPhoto)
      ..writeByte(32)
      ..write(obj.hasElectricityMeter)
      ..writeByte(33)
      ..write(obj.electricityMeterNumber)
      ..writeByte(34)
      ..write(obj.hasMeterEncroachment)
      ..writeByte(35)
      ..write(obj.meterEncroachmentPhoto)
      ..writeByte(36)
      ..write(obj.hasTreesGrass)
      ..writeByte(37)
      ..write(obj.isFenced)
      ..writeByte(38)
      ..write(obj.hasWaterSwamps)
      ..writeByte(39)
      ..write(obj.hasSafetyHazards)
      ..writeByte(40)
      ..write(obj.isWasteFree)
      ..writeByte(42)
      ..write(obj.safetyHazardDescription)
      ..writeByte(43)
      ..write(obj.notes)
      ..writeByte(44)
      ..write(obj.landTypeNotes)
      ..writeByte(45)
      ..write(obj.tempBuildingNotes)
      ..writeByte(46)
      ..write(obj.electricityMetersNotes)
      ..writeByte(47)
      ..write(obj.environmentConditionalNotes)
      ..writeByte(41)
      ..write(obj.startDatetime)
      ..writeByte(250)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitLandModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
