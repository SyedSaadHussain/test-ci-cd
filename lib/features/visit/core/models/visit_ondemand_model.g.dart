// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_ondemand_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitOndemandModelAdapter extends TypeAdapter<VisitOndemandModel> {
  @override
  final int typeId = 12;

  @override
  VisitOndemandModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VisitOndemandModel(
      id: fields[0] as int?,
      mosque: fields[7] as String?,
      stage: fields[5] as String?,
      stageId: fields[6] as int?,
      name: fields[3] as String?,
      employee: fields[4] as String?,
      employeeId: fields[147] as int?,
      state: fields[146] as String?,
      priorityValue: fields[148] as String?,
      deadlineDate: fields[230] as String?,
    )
      ..imamPresent = fields[200] as String?
      ..imamIds = (fields[201] as List?)?.cast<int>()
      ..imamIdsArray = (fields[202] as List?)?.cast<ComboItem>()
      ..imamCommitment = fields[203] as String?
      ..imamOffWork = fields[204] as String?
      ..imamOffWorkDate = fields[205] as String?
      ..imamPermissionPrayer = fields[206] as String?
      ..imamLeaveFromDate = fields[207] as String?
      ..imamLeaveToDate = fields[208] as String?
      ..imamNotes = fields[209] as String?
      ..muezzinPresent = fields[170] as String?
      ..muezzinIds = (fields[171] as List?)?.cast<int>()
      ..muezzinIdsArray = (fields[172] as List?)?.cast<ComboItem>()
      ..muezzinCommitment = fields[173] as String?
      ..muezzinOffWork = fields[174] as String?
      ..muezzinPermissionPrayer = fields[175] as String?
      ..muezzinLeaveFromDate = fields[176] as String?
      ..muezzinLeaveToDate = fields[177] as String?
      ..muezzinOffWorkDate = fields[178] as String?
      ..muezzinNotes = fields[179] as String?
      ..khademPresent = fields[180] as String?
      ..mansoobNotes = fields[181] as String?
      ..khademIds = (fields[182] as List?)?.cast<int>()
      ..khademIdsArray = (fields[183] as List?)?.cast<ComboItem>()
      ..khademNotes = fields[184] as String?
      ..khademLeaveFromDate = fields[185] as String?
      ..khademLeaveToDate = fields[186] as String?
      ..khademPermissionPrayer = fields[187] as String?
      ..khademOffWork = fields[188] as String?
      ..khademOffWorkDate = fields[189] as String?
      ..qualityOfWork = fields[190] as String?
      ..cleanMaintenanceMosque = fields[191] as String?
      ..organizedAndArranged = fields[192] as String?
      ..takecareProperty = fields[193] as String?
      ..serviceTask = fields[194] as String?
      ..latitude = fields[1] as double?
      ..longitude = fields[2] as double?
      ..mosqueId = fields[8] as int?
      ..cityId = fields[9] as int?
      ..isVisitStarted = fields[10] as bool?
      ..dateOfVisit = fields[11] as String?
      ..submitDatetime = fields[12] as String?
      ..startDatetime = fields[13] as String?
      ..prayerName = fields[14] as String?
      ..outerDevices = fields[15] as String?
      ..innerDevices = fields[16] as String?
      ..innerAudioDevices = fields[17] as String?
      ..speakerOnPrayer = fields[18] as String?
      ..outerAudioDevices = fields[19] as String?
      ..lightening = fields[20] as String?
      ..airCondition = fields[21] as String?
      ..electicityPerformance = fields[22] as String?
      ..isEncroachmentBuilding = fields[23] as String?
      ..encroachmentBuildingAttachment = fields[24] as String?
      ..caseEncroachmentBuilding = fields[25] as String?
      ..isEncroachmentVacantLand = fields[26] as String?
      ..encroachmentVacantAttachment = fields[27] as String?
      ..caseEncroachmentVacantLand = fields[28] as String?
      ..violationBuildingAttachment = fields[29] as String?
      ..isViolationBuilding = fields[30] as String?
      ..caseViolationBuilding = fields[31] as String?
      ..buildingNotes = fields[32] as String?
      ..meterNotes = fields[33] as String?
      ..deviceNotes = fields[34] as String?
      ..safteyStandardNotes = fields[35] as String?
      ..cleanMaintenanceNotes = fields[36] as String?
      ..securityViolationNotes = fields[37] as String?
      ..dawahActivitiesNotes = fields[38] as String?
      ..mosqueStatusNotes = fields[39] as String?
      ..quranShelvesStorage = fields[40] as String?
      ..carpetsAndFlooring = fields[41] as String?
      ..mosqueCourtyards = fields[42] as String?
      ..mosqueEntrances = fields[43] as String?
      ..ablutionAreas = fields[44] as String?
      ..windowsDoorsWalls = fields[45] as String?
      ..storageRooms = fields[46] as String?
      ..mosqueCarpetQuality = fields[47] as String?
      ..toilets = fields[48] as String?
      ..maintenanceExecution = fields[49] as String?
      ..maintenanceResponseSpeed = fields[50] as String?
      ..hasMaintenanceContractor = fields[51] as String?
      ..maintenanceContractorIds = (fields[52] as List?)?.cast<int>()
      ..maintenanceContractorIdsArray = (fields[53] as List?)?.cast<ComboItem>()
      ..mosqueAddressStatus = fields[54] as String?
      ..geolocationStatus = fields[55] as String?
      ..mosqueDetailsStatus = fields[56] as String?
      ..mosqueImagesStatus = fields[57] as String?
      ..maintenanceContractStatus = fields[58] as String?
      ..buildingDetailsStatus = fields[59] as String?
      ..imamResidenceStatus = fields[60] as String?
      ..prayerAreaStatus = fields[61] as String?
      ..humanResourcesStatus = fields[62] as String?
      ..hasReligiousActivity = fields[63] as String?
      ..activityType = fields[64] as String?
      ..hasTayseerPermission = fields[65] as String?
      ..tayseerPermissionNumber = fields[66] as String?
      ..activityTitle = fields[67] as String?
      ..activityDetails = fields[68] as String?
      ..yaqeenStatus = fields[69] as String?
      ..preacherIdentificationId = fields[70] as String?
      ..phonePreacher = fields[71] as String?
      ..genderPreacher = fields[72] as String?
      ..dobPreacher = fields[73] as String?
      ..securityViolationType = fields[74] as String?
      ..adminViolationType = fields[75] as String?
      ..operationalViolationType = fields[76] as String?
      ..unauthorizedPublications = fields[77] as String?
      ..publicationSource = fields[78] as String?
      ..religiousSocialViolationType = fields[79] as String?
      ..unauthorizedQuranPresence = fields[80] as String?
      ..architecturalStructure = fields[81] as String?
      ..electricalInstallations = fields[82] as String?
      ..ablutionAndToilets = fields[83] as String?
      ..ventilationAndAirQuality = fields[84] as String?
      ..equipmentAndFurnitureSafety = fields[85] as String?
      ..doorsAndLocks = fields[86] as String?
      ..waterTankCovers = fields[87] as String?
      ..fireExtinguishers = fields[88] as String?
      ..fireAlarms = fields[89] as String?
      ..firstAidKits = fields[90] as String?
      ..emergencyExits = fields[91] as String?
      ..hasElectricMeter = fields[92] as String?
      ..electricMeterDataUpdated = fields[93] as String?
      ..electricMeterIds = (fields[94] as List?)?.cast<int>()
      ..electricMeterIdsArray = (fields[95] as List?)?.cast<ComboItem>()
      ..electricMeterViolation = fields[96] as String?
      ..violationElectricMeterIds = (fields[97] as List?)?.cast<int>()
      ..violationElectricMeterIdsArray =
          (fields[98] as List?)?.cast<ComboItem>()
      ..violationElectricMeterAttachment = fields[99] as dynamic
      ..caseInfringementElecMeter = fields[100] as String?
      ..hasWaterMeter = fields[101] as String?
      ..waterMeterIds = (fields[102] as List?)?.cast<int>()
      ..waterMeterIdsArray = (fields[103] as List?)?.cast<ComboItem>()
      ..waterMeterDataUpdated = fields[104] as String?
      ..caseInfringementWaterMeter = fields[105] as String?
      ..waterMeterViolation = fields[106] as String?
      ..violationWaterMeterAttachment = fields[107] as String?
      ..violationWaterMeterIds = (fields[108] as List?)?.cast<int>()
      ..violationWaterMeterIdsArray = (fields[109] as List?)?.cast<ComboItem>()
      ..mosqueEntrancesSecurity = fields[110] as String?
      ..prayerAreaCleanliness = fields[111] as String?
      ..dobPreacherHijri = fields[144] as String?
      ..btnStart = fields[145] as bool?
      ..readAllowedBook = fields[149] as String?
      ..bookNameId = fields[150] as int?
      ..otherBookName = fields[151] as String?
      ..bookName = fields[152] as String?
      ..dataVerified = fields[153] as bool?
      ..createdAt = fields[250] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, VisitOndemandModel obj) {
    writer
      ..writeByte(159)
      ..writeByte(230)
      ..write(obj.deadlineDate)
      ..writeByte(200)
      ..write(obj.imamPresent)
      ..writeByte(201)
      ..write(obj.imamIds)
      ..writeByte(202)
      ..write(obj.imamIdsArray)
      ..writeByte(203)
      ..write(obj.imamCommitment)
      ..writeByte(204)
      ..write(obj.imamOffWork)
      ..writeByte(205)
      ..write(obj.imamOffWorkDate)
      ..writeByte(206)
      ..write(obj.imamPermissionPrayer)
      ..writeByte(207)
      ..write(obj.imamLeaveFromDate)
      ..writeByte(208)
      ..write(obj.imamLeaveToDate)
      ..writeByte(209)
      ..write(obj.imamNotes)
      ..writeByte(170)
      ..write(obj.muezzinPresent)
      ..writeByte(171)
      ..write(obj.muezzinIds)
      ..writeByte(172)
      ..write(obj.muezzinIdsArray)
      ..writeByte(173)
      ..write(obj.muezzinCommitment)
      ..writeByte(174)
      ..write(obj.muezzinOffWork)
      ..writeByte(175)
      ..write(obj.muezzinPermissionPrayer)
      ..writeByte(176)
      ..write(obj.muezzinLeaveFromDate)
      ..writeByte(177)
      ..write(obj.muezzinLeaveToDate)
      ..writeByte(178)
      ..write(obj.muezzinOffWorkDate)
      ..writeByte(179)
      ..write(obj.muezzinNotes)
      ..writeByte(180)
      ..write(obj.khademPresent)
      ..writeByte(181)
      ..write(obj.mansoobNotes)
      ..writeByte(182)
      ..write(obj.khademIds)
      ..writeByte(183)
      ..write(obj.khademIdsArray)
      ..writeByte(184)
      ..write(obj.khademNotes)
      ..writeByte(185)
      ..write(obj.khademLeaveFromDate)
      ..writeByte(186)
      ..write(obj.khademLeaveToDate)
      ..writeByte(187)
      ..write(obj.khademPermissionPrayer)
      ..writeByte(188)
      ..write(obj.khademOffWork)
      ..writeByte(189)
      ..write(obj.khademOffWorkDate)
      ..writeByte(190)
      ..write(obj.qualityOfWork)
      ..writeByte(191)
      ..write(obj.cleanMaintenanceMosque)
      ..writeByte(192)
      ..write(obj.organizedAndArranged)
      ..writeByte(193)
      ..write(obj.takecareProperty)
      ..writeByte(194)
      ..write(obj.serviceTask)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.stage)
      ..writeByte(6)
      ..write(obj.stageId)
      ..writeByte(7)
      ..write(obj.mosque)
      ..writeByte(8)
      ..write(obj.mosqueId)
      ..writeByte(9)
      ..write(obj.cityId)
      ..writeByte(10)
      ..write(obj.isVisitStarted)
      ..writeByte(11)
      ..write(obj.dateOfVisit)
      ..writeByte(12)
      ..write(obj.submitDatetime)
      ..writeByte(13)
      ..write(obj.startDatetime)
      ..writeByte(14)
      ..write(obj.prayerName)
      ..writeByte(15)
      ..write(obj.outerDevices)
      ..writeByte(16)
      ..write(obj.innerDevices)
      ..writeByte(17)
      ..write(obj.innerAudioDevices)
      ..writeByte(18)
      ..write(obj.speakerOnPrayer)
      ..writeByte(19)
      ..write(obj.outerAudioDevices)
      ..writeByte(20)
      ..write(obj.lightening)
      ..writeByte(21)
      ..write(obj.airCondition)
      ..writeByte(22)
      ..write(obj.electicityPerformance)
      ..writeByte(23)
      ..write(obj.isEncroachmentBuilding)
      ..writeByte(24)
      ..write(obj.encroachmentBuildingAttachment)
      ..writeByte(25)
      ..write(obj.caseEncroachmentBuilding)
      ..writeByte(26)
      ..write(obj.isEncroachmentVacantLand)
      ..writeByte(27)
      ..write(obj.encroachmentVacantAttachment)
      ..writeByte(28)
      ..write(obj.caseEncroachmentVacantLand)
      ..writeByte(29)
      ..write(obj.violationBuildingAttachment)
      ..writeByte(30)
      ..write(obj.isViolationBuilding)
      ..writeByte(31)
      ..write(obj.caseViolationBuilding)
      ..writeByte(32)
      ..write(obj.buildingNotes)
      ..writeByte(33)
      ..write(obj.meterNotes)
      ..writeByte(34)
      ..write(obj.deviceNotes)
      ..writeByte(35)
      ..write(obj.safteyStandardNotes)
      ..writeByte(36)
      ..write(obj.cleanMaintenanceNotes)
      ..writeByte(37)
      ..write(obj.securityViolationNotes)
      ..writeByte(38)
      ..write(obj.dawahActivitiesNotes)
      ..writeByte(39)
      ..write(obj.mosqueStatusNotes)
      ..writeByte(40)
      ..write(obj.quranShelvesStorage)
      ..writeByte(41)
      ..write(obj.carpetsAndFlooring)
      ..writeByte(42)
      ..write(obj.mosqueCourtyards)
      ..writeByte(43)
      ..write(obj.mosqueEntrances)
      ..writeByte(44)
      ..write(obj.ablutionAreas)
      ..writeByte(45)
      ..write(obj.windowsDoorsWalls)
      ..writeByte(46)
      ..write(obj.storageRooms)
      ..writeByte(47)
      ..write(obj.mosqueCarpetQuality)
      ..writeByte(48)
      ..write(obj.toilets)
      ..writeByte(49)
      ..write(obj.maintenanceExecution)
      ..writeByte(50)
      ..write(obj.maintenanceResponseSpeed)
      ..writeByte(51)
      ..write(obj.hasMaintenanceContractor)
      ..writeByte(52)
      ..write(obj.maintenanceContractorIds)
      ..writeByte(53)
      ..write(obj.maintenanceContractorIdsArray)
      ..writeByte(54)
      ..write(obj.mosqueAddressStatus)
      ..writeByte(55)
      ..write(obj.geolocationStatus)
      ..writeByte(56)
      ..write(obj.mosqueDetailsStatus)
      ..writeByte(57)
      ..write(obj.mosqueImagesStatus)
      ..writeByte(58)
      ..write(obj.maintenanceContractStatus)
      ..writeByte(59)
      ..write(obj.buildingDetailsStatus)
      ..writeByte(60)
      ..write(obj.imamResidenceStatus)
      ..writeByte(61)
      ..write(obj.prayerAreaStatus)
      ..writeByte(62)
      ..write(obj.humanResourcesStatus)
      ..writeByte(63)
      ..write(obj.hasReligiousActivity)
      ..writeByte(64)
      ..write(obj.activityType)
      ..writeByte(65)
      ..write(obj.hasTayseerPermission)
      ..writeByte(66)
      ..write(obj.tayseerPermissionNumber)
      ..writeByte(67)
      ..write(obj.activityTitle)
      ..writeByte(68)
      ..write(obj.activityDetails)
      ..writeByte(69)
      ..write(obj.yaqeenStatus)
      ..writeByte(70)
      ..write(obj.preacherIdentificationId)
      ..writeByte(71)
      ..write(obj.phonePreacher)
      ..writeByte(72)
      ..write(obj.genderPreacher)
      ..writeByte(73)
      ..write(obj.dobPreacher)
      ..writeByte(74)
      ..write(obj.securityViolationType)
      ..writeByte(75)
      ..write(obj.adminViolationType)
      ..writeByte(76)
      ..write(obj.operationalViolationType)
      ..writeByte(77)
      ..write(obj.unauthorizedPublications)
      ..writeByte(78)
      ..write(obj.publicationSource)
      ..writeByte(79)
      ..write(obj.religiousSocialViolationType)
      ..writeByte(80)
      ..write(obj.unauthorizedQuranPresence)
      ..writeByte(81)
      ..write(obj.architecturalStructure)
      ..writeByte(82)
      ..write(obj.electricalInstallations)
      ..writeByte(83)
      ..write(obj.ablutionAndToilets)
      ..writeByte(84)
      ..write(obj.ventilationAndAirQuality)
      ..writeByte(85)
      ..write(obj.equipmentAndFurnitureSafety)
      ..writeByte(86)
      ..write(obj.doorsAndLocks)
      ..writeByte(87)
      ..write(obj.waterTankCovers)
      ..writeByte(88)
      ..write(obj.fireExtinguishers)
      ..writeByte(89)
      ..write(obj.fireAlarms)
      ..writeByte(90)
      ..write(obj.firstAidKits)
      ..writeByte(91)
      ..write(obj.emergencyExits)
      ..writeByte(92)
      ..write(obj.hasElectricMeter)
      ..writeByte(93)
      ..write(obj.electricMeterDataUpdated)
      ..writeByte(94)
      ..write(obj.electricMeterIds)
      ..writeByte(95)
      ..write(obj.electricMeterIdsArray)
      ..writeByte(96)
      ..write(obj.electricMeterViolation)
      ..writeByte(97)
      ..write(obj.violationElectricMeterIds)
      ..writeByte(98)
      ..write(obj.violationElectricMeterIdsArray)
      ..writeByte(99)
      ..write(obj.violationElectricMeterAttachment)
      ..writeByte(100)
      ..write(obj.caseInfringementElecMeter)
      ..writeByte(101)
      ..write(obj.hasWaterMeter)
      ..writeByte(102)
      ..write(obj.waterMeterIds)
      ..writeByte(103)
      ..write(obj.waterMeterIdsArray)
      ..writeByte(104)
      ..write(obj.waterMeterDataUpdated)
      ..writeByte(105)
      ..write(obj.caseInfringementWaterMeter)
      ..writeByte(106)
      ..write(obj.waterMeterViolation)
      ..writeByte(107)
      ..write(obj.violationWaterMeterAttachment)
      ..writeByte(108)
      ..write(obj.violationWaterMeterIds)
      ..writeByte(109)
      ..write(obj.violationWaterMeterIdsArray)
      ..writeByte(110)
      ..write(obj.mosqueEntrancesSecurity)
      ..writeByte(111)
      ..write(obj.prayerAreaCleanliness)
      ..writeByte(144)
      ..write(obj.dobPreacherHijri)
      ..writeByte(145)
      ..write(obj.btnStart)
      ..writeByte(146)
      ..write(obj.state)
      ..writeByte(4)
      ..write(obj.employee)
      ..writeByte(147)
      ..write(obj.employeeId)
      ..writeByte(148)
      ..write(obj.priorityValue)
      ..writeByte(149)
      ..write(obj.readAllowedBook)
      ..writeByte(150)
      ..write(obj.bookNameId)
      ..writeByte(151)
      ..write(obj.otherBookName)
      ..writeByte(152)
      ..write(obj.bookName)
      ..writeByte(153)
      ..write(obj.dataVerified)
      ..writeByte(250)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitOndemandModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
