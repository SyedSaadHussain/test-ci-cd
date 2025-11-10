// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mosque_edit_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MosqueEditRequestModelAdapter
    extends TypeAdapter<MosqueEditRequestModel> {
  @override
  final int typeId = 15;

  @override
  MosqueEditRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MosqueEditRequestModel(
      localId: fields[0] as String,
      serverId: fields[1] as int?,
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[4] as DateTime?,
      lastError: fields[5] as String?,
      payload: (fields[6] as Map?)?.cast<String, dynamic>(),
      name: fields[10] as String?,
      regionId: fields[108] as int?,
      cityId: fields[110] as int?,
      moiaCenterId: fields[112] as int?,
      districtId: fields[13] as int?,
      latitude: fields[23] as double?,
      longitude: fields[22] as double?,
      classificationId: fields[16] as int?,
      mosqueTypeId: fields[18] as int?,
      supervisorId: fields[130] as int?,
      requester: fields[131] as String?,
      createDate: fields[132] as String?,
      submitDate: fields[133] as String?,
      description: fields[134] as String?,
      supervisorName: fields[135] as String?,
      mosqueName: fields[136] as String?,
      requestId: fields[137] as int?,
    )
      ..number = fields[11] as String?
      ..district = fields[12] as String?
      ..street = fields[14] as String?
      ..classification = fields[15] as String?
      ..mosqueType = fields[17] as String?
      ..lastUpdateDate = fields[19] as String?
      ..observerIds = (fields[20] as List?)?.cast<int>()
      ..completeAddress = fields[21] as String?
      ..placeId = fields[24] as String?
      ..globalCode = fields[25] as String?
      ..compoundCode = fields[26] as String?
      ..mosqueCondition = fields[27] as String?
      ..buildingMaterial = fields[28] as String?
      ..urbanCondition = fields[29] as String?
      ..dateMaintenanceLast = fields[30] as String?
      ..image = fields[31] as String?
      ..outerImage = fields[32] as String?
      ..externalDoorsNumbers = fields[33] as int?
      ..internalDoorsNumber = fields[34] as int?
      ..numMinarets = fields[35] as int?
      ..numFloors = fields[36] as int?
      ..hasBasement = fields[37] as String?
      ..mosqueRooms = fields[38] as int?
      ..fridayPrayerRows = fields[39] as int?
      ..rowMenPrayingNumber = fields[40] as int?
      ..lengthRowMenPraying = fields[41] as double?
      ..capacity = fields[42] as int?
      ..menPrayerAvgAttendance = fields[123] as String?
      ..toiletMenNumber = fields[43] as int?
      ..hasWomenPrayerRoom = fields[44] as String?
      ..rowWomenPrayingNumber = fields[45] as int?
      ..lengthRowWomenPraying = fields[46] as double?
      ..womenPrayerRoomCapacity = fields[47] as int?
      ..toiletWomanNumber = fields[48] as int?
      ..isEmployee = fields[49] as String?
      ..imamIds = (fields[50] as List?)?.cast<int>()
      ..muezzinIds = (fields[51] as List?)?.cast<int>()
      ..khademIds = (fields[52] as List?)?.cast<int>()
      ..khatibIds = (fields[53] as List?)?.cast<int>()
      ..residenceForImam = fields[54] as String?
      ..imamResidenceType = fields[55] as String?
      ..imamResidenceLandArea = fields[56] as double?
      ..residenceForMouadhin = fields[57] as String?
      ..muezzinResidenceType = fields[58] as String?
      ..muezzinResidenceLandArea = fields[59] as double?
      ..carsParking = fields[60] as String?
      ..hasWashingMachine = fields[61] as String?
      ..isOtherAttachment = fields[62] as String?
      ..lecturesHall = fields[63] as String?
      ..libraryExist = fields[64] as String?
      ..ministryAuthorized = fields[65] as String?
      ..isThereInvestmentBuilding = fields[66] as String?
      ..isThereHeadquarters = fields[67] as String?
      ..isThereQuranMemorizationMen = fields[68] as String?
      ..propertyTypeIds = (fields[122] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList()
      ..isThereQuranMemorizationWomen = fields[69] as String?
      ..mosqueLandArea = fields[70] as String?
      ..nonBuildingArea = fields[71] as double?
      ..roofedArea = fields[72] as double?
      ..isFreeArea = fields[73] as String?
      ..freeArea = fields[74] as double?
      ..hasDeed = fields[75] as String?
      ..isThereLandTitle = fields[76] as String?
      ..noPlanned = fields[77] as double?
      ..pieceNumber = fields[78] as double?
      ..mosqueOpeningDate = fields[79] as String?
      ..hasAirConditioners = fields[80] as String?
      ..acType = (fields[81] as List?)?.cast<int>()
      ..numAirConditioners = fields[82] as int?
      ..hasInternalCamera = fields[83] as String?
      ..hasExternalCamera = fields[121] as String?
      ..numLightingInside = fields[84] as int?
      ..internalSpeakerNumber = fields[85] as int?
      ..externalHeadsetNumber = fields[86] as int?
      ..hasFireExtinguishers = fields[87] as String?
      ..hasFireSystemPumps = fields[88] as String?
      ..maintenanceResponsible = fields[89] as String?
      ..maintenancePerson = fields[90] as String?
      ..companyName = fields[91] as String?
      ..contractNumber = fields[92] as String?
      ..meterIds = (fields[93] as List?)?.cast<int>()
      ..waterMeterIds = (fields[94] as List?)?.cast<int>()
      ..electricMetersArray = (fields[117] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList()
      ..waterMetersArray = (fields[118] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList()
      ..maintenanceContractsArray = (fields[119] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList()
      ..declarationsArray = (fields[120] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList()
      ..isQrCodeExist = fields[95] as String?
      ..qrPanelNumbers = fields[96] as int?
      ..isPanelReadable = fields[97] as String?
      ..codeReadable = fields[98] as String?
      ..mosqueDataCorrect = fields[99] as String?
      ..isMosqueNameQr = fields[100] as String?
      ..qrCodeNotes = fields[101] as String?
      ..qrImage = fields[102] as String?
      ..observationText = fields[103] as String?
      ..userPledge = fields[104] as String?
      ..mosqueHistorical = fields[105] as String?
      ..princeProjectHistoricMosque = fields[106] as String?
      ..region = fields[107] as String?
      ..city = fields[109] as String?
      ..moiaCenter = fields[111] as String?
      ..isInsideHaramMakkah = fields[113] as String?
      ..isInPilgrimHousingMakkah = fields[114] as String?
      ..isInsideHaramMadinah = fields[115] as String?
      ..isInVisitorHousingMadinah = fields[116] as String?
      ..isInsidePrison = fields[125] as String?
      ..isInsideHospital = fields[126] as String?
      ..isInsideGovernmentHousing = fields[127] as String?
      ..isInsideRestrictedGovEntity = fields[128] as String?
      ..landOwner = fields[129] as String?;
  }

  @override
  void write(BinaryWriter writer, MosqueEditRequestModel obj) {
    writer
      ..writeByte(133)
      ..writeByte(130)
      ..write(obj.supervisorId)
      ..writeByte(131)
      ..write(obj.requester)
      ..writeByte(132)
      ..write(obj.createDate)
      ..writeByte(133)
      ..write(obj.submitDate)
      ..writeByte(134)
      ..write(obj.description)
      ..writeByte(135)
      ..write(obj.supervisorName)
      ..writeByte(136)
      ..write(obj.mosqueName)
      ..writeByte(137)
      ..write(obj.requestId)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.serverId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.lastError)
      ..writeByte(6)
      ..write(obj.payload)
      ..writeByte(10)
      ..write(obj.name)
      ..writeByte(11)
      ..write(obj.number)
      ..writeByte(12)
      ..write(obj.district)
      ..writeByte(13)
      ..write(obj.districtId)
      ..writeByte(14)
      ..write(obj.street)
      ..writeByte(15)
      ..write(obj.classification)
      ..writeByte(16)
      ..write(obj.classificationId)
      ..writeByte(17)
      ..write(obj.mosqueType)
      ..writeByte(18)
      ..write(obj.mosqueTypeId)
      ..writeByte(19)
      ..write(obj.lastUpdateDate)
      ..writeByte(20)
      ..write(obj.observerIds)
      ..writeByte(21)
      ..write(obj.completeAddress)
      ..writeByte(22)
      ..write(obj.longitude)
      ..writeByte(23)
      ..write(obj.latitude)
      ..writeByte(24)
      ..write(obj.placeId)
      ..writeByte(25)
      ..write(obj.globalCode)
      ..writeByte(26)
      ..write(obj.compoundCode)
      ..writeByte(27)
      ..write(obj.mosqueCondition)
      ..writeByte(28)
      ..write(obj.buildingMaterial)
      ..writeByte(29)
      ..write(obj.urbanCondition)
      ..writeByte(30)
      ..write(obj.dateMaintenanceLast)
      ..writeByte(31)
      ..write(obj.image)
      ..writeByte(32)
      ..write(obj.outerImage)
      ..writeByte(33)
      ..write(obj.externalDoorsNumbers)
      ..writeByte(34)
      ..write(obj.internalDoorsNumber)
      ..writeByte(35)
      ..write(obj.numMinarets)
      ..writeByte(36)
      ..write(obj.numFloors)
      ..writeByte(37)
      ..write(obj.hasBasement)
      ..writeByte(38)
      ..write(obj.mosqueRooms)
      ..writeByte(39)
      ..write(obj.fridayPrayerRows)
      ..writeByte(40)
      ..write(obj.rowMenPrayingNumber)
      ..writeByte(41)
      ..write(obj.lengthRowMenPraying)
      ..writeByte(42)
      ..write(obj.capacity)
      ..writeByte(123)
      ..write(obj.menPrayerAvgAttendance)
      ..writeByte(43)
      ..write(obj.toiletMenNumber)
      ..writeByte(44)
      ..write(obj.hasWomenPrayerRoom)
      ..writeByte(45)
      ..write(obj.rowWomenPrayingNumber)
      ..writeByte(46)
      ..write(obj.lengthRowWomenPraying)
      ..writeByte(47)
      ..write(obj.womenPrayerRoomCapacity)
      ..writeByte(48)
      ..write(obj.toiletWomanNumber)
      ..writeByte(49)
      ..write(obj.isEmployee)
      ..writeByte(50)
      ..write(obj.imamIds)
      ..writeByte(51)
      ..write(obj.muezzinIds)
      ..writeByte(52)
      ..write(obj.khademIds)
      ..writeByte(53)
      ..write(obj.khatibIds)
      ..writeByte(54)
      ..write(obj.residenceForImam)
      ..writeByte(55)
      ..write(obj.imamResidenceType)
      ..writeByte(56)
      ..write(obj.imamResidenceLandArea)
      ..writeByte(57)
      ..write(obj.residenceForMouadhin)
      ..writeByte(58)
      ..write(obj.muezzinResidenceType)
      ..writeByte(59)
      ..write(obj.muezzinResidenceLandArea)
      ..writeByte(60)
      ..write(obj.carsParking)
      ..writeByte(61)
      ..write(obj.hasWashingMachine)
      ..writeByte(62)
      ..write(obj.isOtherAttachment)
      ..writeByte(63)
      ..write(obj.lecturesHall)
      ..writeByte(64)
      ..write(obj.libraryExist)
      ..writeByte(65)
      ..write(obj.ministryAuthorized)
      ..writeByte(66)
      ..write(obj.isThereInvestmentBuilding)
      ..writeByte(67)
      ..write(obj.isThereHeadquarters)
      ..writeByte(68)
      ..write(obj.isThereQuranMemorizationMen)
      ..writeByte(122)
      ..write(obj.propertyTypeIds)
      ..writeByte(69)
      ..write(obj.isThereQuranMemorizationWomen)
      ..writeByte(70)
      ..write(obj.mosqueLandArea)
      ..writeByte(71)
      ..write(obj.nonBuildingArea)
      ..writeByte(72)
      ..write(obj.roofedArea)
      ..writeByte(73)
      ..write(obj.isFreeArea)
      ..writeByte(74)
      ..write(obj.freeArea)
      ..writeByte(75)
      ..write(obj.hasDeed)
      ..writeByte(76)
      ..write(obj.isThereLandTitle)
      ..writeByte(77)
      ..write(obj.noPlanned)
      ..writeByte(78)
      ..write(obj.pieceNumber)
      ..writeByte(79)
      ..write(obj.mosqueOpeningDate)
      ..writeByte(80)
      ..write(obj.hasAirConditioners)
      ..writeByte(81)
      ..write(obj.acType)
      ..writeByte(82)
      ..write(obj.numAirConditioners)
      ..writeByte(83)
      ..write(obj.hasInternalCamera)
      ..writeByte(121)
      ..write(obj.hasExternalCamera)
      ..writeByte(84)
      ..write(obj.numLightingInside)
      ..writeByte(85)
      ..write(obj.internalSpeakerNumber)
      ..writeByte(86)
      ..write(obj.externalHeadsetNumber)
      ..writeByte(87)
      ..write(obj.hasFireExtinguishers)
      ..writeByte(88)
      ..write(obj.hasFireSystemPumps)
      ..writeByte(89)
      ..write(obj.maintenanceResponsible)
      ..writeByte(90)
      ..write(obj.maintenancePerson)
      ..writeByte(91)
      ..write(obj.companyName)
      ..writeByte(92)
      ..write(obj.contractNumber)
      ..writeByte(93)
      ..write(obj.meterIds)
      ..writeByte(94)
      ..write(obj.waterMeterIds)
      ..writeByte(117)
      ..write(obj.electricMetersArray)
      ..writeByte(118)
      ..write(obj.waterMetersArray)
      ..writeByte(119)
      ..write(obj.maintenanceContractsArray)
      ..writeByte(120)
      ..write(obj.declarationsArray)
      ..writeByte(95)
      ..write(obj.isQrCodeExist)
      ..writeByte(96)
      ..write(obj.qrPanelNumbers)
      ..writeByte(97)
      ..write(obj.isPanelReadable)
      ..writeByte(98)
      ..write(obj.codeReadable)
      ..writeByte(99)
      ..write(obj.mosqueDataCorrect)
      ..writeByte(100)
      ..write(obj.isMosqueNameQr)
      ..writeByte(101)
      ..write(obj.qrCodeNotes)
      ..writeByte(102)
      ..write(obj.qrImage)
      ..writeByte(103)
      ..write(obj.observationText)
      ..writeByte(104)
      ..write(obj.userPledge)
      ..writeByte(105)
      ..write(obj.mosqueHistorical)
      ..writeByte(106)
      ..write(obj.princeProjectHistoricMosque)
      ..writeByte(107)
      ..write(obj.region)
      ..writeByte(108)
      ..write(obj.regionId)
      ..writeByte(109)
      ..write(obj.city)
      ..writeByte(110)
      ..write(obj.cityId)
      ..writeByte(111)
      ..write(obj.moiaCenter)
      ..writeByte(112)
      ..write(obj.moiaCenterId)
      ..writeByte(113)
      ..write(obj.isInsideHaramMakkah)
      ..writeByte(114)
      ..write(obj.isInPilgrimHousingMakkah)
      ..writeByte(115)
      ..write(obj.isInsideHaramMadinah)
      ..writeByte(116)
      ..write(obj.isInVisitorHousingMadinah)
      ..writeByte(125)
      ..write(obj.isInsidePrison)
      ..writeByte(126)
      ..write(obj.isInsideHospital)
      ..writeByte(127)
      ..write(obj.isInsideGovernmentHousing)
      ..writeByte(128)
      ..write(obj.isInsideRestrictedGovEntity)
      ..writeByte(129)
      ..write(obj.landOwner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MosqueEditRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
