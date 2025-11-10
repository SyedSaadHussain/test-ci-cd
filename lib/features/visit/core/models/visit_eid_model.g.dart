// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_eid_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitEidModelAdapter extends TypeAdapter<VisitEidModel> {
  @override
  final int typeId = 14;

  @override
  VisitEidModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitEidModel(
      id: fields[0] as int?,
      stage: fields[7] as String?,
      stageId: fields[6] as int?,
      name: fields[11] as String?,
      employeeId: fields[15] as int?,
      employee: fields[16] as String?,
      mosque: fields[13] as String?,
      mosqueId: fields[12] as int?,
      state: fields[1] as String?,
      priorityValue: fields[14] as String?,
    )
      ..latitude = fields[2] as double?
      ..longitude = fields[3] as double?
      ..cityId = fields[4] as int?
      ..city = fields[5] as String?
      ..requestTypeName = fields[8] as String?
      ..isLock = fields[9] as String?
      ..btnStart = fields[10] as bool?
      ..actionNotes = fields[17] as String?
      ..actionTakenType = fields[19] as String?
      ..eidPrayerBoard = fields[20] as String?
      ..eidPrayerComment = fields[21] as String?
      ..tempBuildingPrayer = fields[22] as String?
      ..typeTempBuilding = fields[24] as String?
      ..typeTempBuildingComment = fields[25] as String?
      ..encroachmentOnPrayerArea = fields[26] as String?
      ..typeOfViolation = fields[28] as String?
      ..violationComment = fields[29] as String?
      ..isElectricityMeter = fields[30] as String?
      ..electricityMeterComment = fields[31] as String?
      ..violationOnElectricity = fields[32] as String?
      ..chooseElectricityMeter = (fields[34] as List?)?.cast<int>()
      ..chooseElectricityMeterArray = (fields[35] as List?)?.cast<ComboItem>()
      ..landFenced = fields[36] as String?
      ..landFencedComment = fields[37] as String?
      ..treeTallGrass = fields[38] as String?
      ..treeTallGrassComment = fields[39] as String?
      ..thereAnySwamps = fields[40] as String?
      ..commentSwamps = fields[41] as String?
      ..publicSafetyHazard = fields[42] as String?
      ..commentOnSafetyHazard = fields[43] as String?
      ..warningInfoPanel = fields[44] as String?
      ..warningPanelComment = fields[45] as String?
      ..prayerHallFree = fields[46] as String?
      ..prayerHallComment = fields[47] as String?
      ..pollutionNearHall = fields[48] as String?
      ..pollutionHallComment = fields[49] as String?
      ..startDatetime = fields[50] as String?
      ..dataVerified = fields[51] as bool?
      ..createdAt = fields[250] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, VisitEidModel obj) {
    writer
      ..writeByte(49)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.cityId)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.stageId)
      ..writeByte(7)
      ..write(obj.stage)
      ..writeByte(8)
      ..write(obj.requestTypeName)
      ..writeByte(9)
      ..write(obj.isLock)
      ..writeByte(10)
      ..write(obj.btnStart)
      ..writeByte(11)
      ..write(obj.name)
      ..writeByte(12)
      ..write(obj.mosqueId)
      ..writeByte(13)
      ..write(obj.mosque)
      ..writeByte(14)
      ..write(obj.priorityValue)
      ..writeByte(15)
      ..write(obj.employeeId)
      ..writeByte(16)
      ..write(obj.employee)
      ..writeByte(17)
      ..write(obj.actionNotes)
      ..writeByte(19)
      ..write(obj.actionTakenType)
      ..writeByte(20)
      ..write(obj.eidPrayerBoard)
      ..writeByte(21)
      ..write(obj.eidPrayerComment)
      ..writeByte(22)
      ..write(obj.tempBuildingPrayer)
      ..writeByte(24)
      ..write(obj.typeTempBuilding)
      ..writeByte(25)
      ..write(obj.typeTempBuildingComment)
      ..writeByte(26)
      ..write(obj.encroachmentOnPrayerArea)
      ..writeByte(28)
      ..write(obj.typeOfViolation)
      ..writeByte(29)
      ..write(obj.violationComment)
      ..writeByte(30)
      ..write(obj.isElectricityMeter)
      ..writeByte(31)
      ..write(obj.electricityMeterComment)
      ..writeByte(32)
      ..write(obj.violationOnElectricity)
      ..writeByte(34)
      ..write(obj.chooseElectricityMeter)
      ..writeByte(35)
      ..write(obj.chooseElectricityMeterArray)
      ..writeByte(36)
      ..write(obj.landFenced)
      ..writeByte(37)
      ..write(obj.landFencedComment)
      ..writeByte(38)
      ..write(obj.treeTallGrass)
      ..writeByte(39)
      ..write(obj.treeTallGrassComment)
      ..writeByte(40)
      ..write(obj.thereAnySwamps)
      ..writeByte(41)
      ..write(obj.commentSwamps)
      ..writeByte(42)
      ..write(obj.publicSafetyHazard)
      ..writeByte(43)
      ..write(obj.commentOnSafetyHazard)
      ..writeByte(44)
      ..write(obj.warningInfoPanel)
      ..writeByte(45)
      ..write(obj.warningPanelComment)
      ..writeByte(46)
      ..write(obj.prayerHallFree)
      ..writeByte(47)
      ..write(obj.prayerHallComment)
      ..writeByte(48)
      ..write(obj.pollutionNearHall)
      ..writeByte(49)
      ..write(obj.pollutionHallComment)
      ..writeByte(50)
      ..write(obj.startDatetime)
      ..writeByte(51)
      ..write(obj.dataVerified)
      ..writeByte(250)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitEidModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
