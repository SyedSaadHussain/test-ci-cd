// lib/core/models/mosque_local.dart
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import '../../../../core/hive/hive_typeIds.dart';
import '../../mosqueTabs/logic/condition_rules.dart';

part 'mosque_local.g.dart';

// @HiveType(typeId: HiveTypeIds.mosqueModel)
// enum SyncStatus {
//   @HiveField(0) pending,
//   @HiveField(1) queued,
//   @HiveField(2) syncing,
//   @HiveField(3) synced,
//   @HiveField(4) failed,
// }

@HiveType(typeId: HiveTypeIds.mosqueModel) // ← choose a free ID (or keep your existing)
class MosqueLocal extends HiveObject {
  // ---------- Meta / sync ----------
  @HiveField(0)  String localId;           // your Hive key (uuid/string)
  @HiveField(1)  int?   serverId;            // maps to Mosque.id
  // @HiveField(2)  SyncStatus status;
  @HiveField(3)  DateTime createdAt;
  @HiveField(4)  DateTime updatedAt;
  @HiveField(5)  String? lastError;

  /// Optional carry-all for legacy/extra values (e.g., 'stage')
  @HiveField(6)  Map<String, dynamic>? payload;

  // ---------- Fields mirrored from Mosque ----------
  @HiveField(10) String? name;
  @HiveField(11) String? number;
  @HiveField(12) String? district;
  @HiveField(13) int?    districtId;
  @HiveField(14) String? street;

  @HiveField(15) String? classification;
  @HiveField(16) int?    classificationId;
  @HiveField(17) String? mosqueType;
  @HiveField(18) int?    mosqueTypeId;

  @HiveField(19) String? lastUpdateDate;
  @HiveField(20) List<int>? observerIds;
  @HiveField(21) String? completeAddress;
  @HiveField(22) double? longitude;
  @HiveField(23) double? latitude;
  @HiveField(24) String? placeId;
  @HiveField(25) String? globalCode;
  @HiveField(26) String? compoundCode;

  @HiveField(27) String? mosqueCondition;
  @HiveField(28) String? buildingMaterial;
  @HiveField(29) String? urbanCondition;
  @HiveField(30) String? dateMaintenanceLast;
  @HiveField(31) String? image;
  @HiveField(32) String? outerImage;

  @HiveField(33) int? externalDoorsNumbers;
  @HiveField(34) int? internalDoorsNumber;
  @HiveField(35) int? numMinarets;
  @HiveField(36) int? numFloors;
  @HiveField(37) String? hasBasement;
  @HiveField(38) int? mosqueRooms;
  @HiveField(39) int? fridayPrayerRows;
  @HiveField(40) int? rowMenPrayingNumber;
  @HiveField(41) double? lengthRowMenPraying;
  @HiveField(42) int? capacity;
  @HiveField(123) String? menPrayerAvgAttendance;  // Selection field: '1_25', 'less_3', etc.
  // COMMENTED OUT: mosque_in_military_zone field
  // @HiveField(124) String? mosqueInMilitaryZone;   // Selection field: 'yes', 'no'
  @HiveField(43) int? toiletMenNumber;
  @HiveField(44) String? hasWomenPrayerRoom;
  @HiveField(45) int? rowWomenPrayingNumber;
  @HiveField(46) double? lengthRowWomenPraying;
  @HiveField(47) int? womenPrayerRoomCapacity;
  @HiveField(48) int? toiletWomanNumber;
  @HiveField(49) String? isEmployee;

  @HiveField(50) List<int>? imamIds;
  @HiveField(51) List<int>? muezzinIds;
  @HiveField(52) List<int>? khademIds;
  @HiveField(53) List<int>? khatibIds;

  @HiveField(54) String? residenceForImam;
  @HiveField(55) String? imamResidenceType;
  @HiveField(56) double? imamResidenceLandArea;
  @HiveField(57) String? residenceForMouadhin;
  @HiveField(58) String? muezzinResidenceType;
  @HiveField(59) double? muezzinResidenceLandArea;

  @HiveField(60) String? carsParking;
  @HiveField(61) String? hasWashingMachine;
  @HiveField(62) String? isOtherAttachment;
  @HiveField(63) String? lecturesHall;
  @HiveField(64) String? libraryExist;

  @HiveField(65) String? ministryAuthorized;
  @HiveField(66) String? isThereInvestmentBuilding;
  @HiveField(67) String? isThereHeadquarters;
  @HiveField(68) String? isThereQuranMemorizationMen;
  @HiveField(122) List<Map<String, dynamic>>? propertyTypeIds;
  @HiveField(69) String? isThereQuranMemorizationWomen;

  @HiveField(70) String? mosqueLandArea;
  @HiveField(71) double? nonBuildingArea;
  @HiveField(72) double? roofedArea;
  @HiveField(73) String? isFreeArea;
  @HiveField(74) double? freeArea;
  @HiveField(75) String? hasDeed;
  @HiveField(76) String? isThereLandTitle;
  @HiveField(77) double? noPlanned;
  @HiveField(78) double? pieceNumber;
  @HiveField(79) String? mosqueOpeningDate;  // Selection field: 'after_1441', 'prophet', etc.

  @HiveField(80) String? hasAirConditioners;
  @HiveField(81) List<int>? acType;
  @HiveField(82) int?    numAirConditioners;
  @HiveField(83) String? hasInternalCamera;
  @HiveField(121) String? hasExternalCamera;
  @HiveField(84) int?    numLightingInside;
  @HiveField(85) int?    internalSpeakerNumber;
  @HiveField(86) int?    externalHeadsetNumber;
  @HiveField(87) String? hasFireExtinguishers;
  @HiveField(88) String? hasFireSystemPumps;

  @HiveField(89) String? maintenanceResponsible;
  @HiveField(90) String? maintenancePerson;
  @HiveField(91) String? companyName;
  @HiveField(92) String? contractNumber;

  @HiveField(93) List<int>? meterIds;
  @HiveField(94) List<int>? waterMeterIds;

  // Meter data arrays from API payload
  @HiveField(117) List<Map<String, dynamic>>? electricMetersArray;
  @HiveField(118) List<Map<String, dynamic>>? waterMetersArray;

  // Contract and declarations arrays from API payload

  @HiveField(119) List<Map<String, dynamic>>? maintenanceContractsArray;
  @HiveField(120) List<Map<String, dynamic>>? declarationsArray;

  @HiveField(95) String? isQrCodeExist;
  @HiveField(96) int?    qrPanelNumbers;
  @HiveField(97) String? isPanelReadable;
  @HiveField(98) String? codeReadable;
  @HiveField(99) String? mosqueDataCorrect;
  @HiveField(100) String? isMosqueNameQr;
  @HiveField(101) String? qrCodeNotes;
  @HiveField(102) String? qrImage;
  @HiveField(103) String? observationText;
  @HiveField(104) String? userPledge;
  @HiveField(105) String? mosqueHistorical;
  @HiveField(106) String? princeProjectHistoricMosque;
  @HiveField(107) String? region;
  @HiveField(108) int?    regionId;
  @HiveField(109) String? city;
  @HiveField(110) int?    cityId;
  @HiveField(111) String? moiaCenter;
  @HiveField(112) int?    moiaCenterId;
  
  // Haram location fields
  @HiveField(113) String? isInsideHaramMakkah;
  @HiveField(114) String? isInPilgrimHousingMakkah;
  @HiveField(115) String? isInsideHaramMadinah;
  @HiveField(116) String? isInVisitorHousingMadinah;
  
  // New location fields
  @HiveField(125) String? isInsidePrison;           // Selection field: 'yes', 'no'
  @HiveField(126) String? isInsideHospital;         // Selection field: 'yes', 'no'
  @HiveField(127) String? isInsideGovernmentHousing; // Selection field: 'yes', 'no'
  @HiveField(128) String? isInsideRestrictedGovEntity; // Selection field: 'yes', 'no'
  
  // Land owner field
  @HiveField(129) String? landOwner; // Selection field: 'governmental', 'private'

  // Employee arrays for display (like visit service) - added at the end
  List<UserProfile>? imamIdsArray;
  List<UserProfile>? muezzinIdsArray;
  List<UserProfile>? khademIdsArray;
  List<UserProfile>? khatibIdsArray;
  
  List<ComboItem>? observerIdsArray;

  // Workflow timeline for mosque creation process
  List<Map<String, dynamic>>? workflow;

  bool? displayButtonAccept;

  bool? displayButtonRefuse;

  bool? displayButtonSend;

  bool? displayButtonSetToDraft;

  String? refuseReason;

  String? mosqueName;
  int? companyContractId;

  String? companyContractName;
  String? stageName;



  String get uniqueId => JsonUtils.toUniqueId(updatedAt)?? "";

  MosqueLocal({
    required this.localId,
    this.serverId,
    // this.status = SyncStatus.synced,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastError,
    this.payload,
    // mirrored fields (all optional)
    this.name,
    this.number,
    this.region,
    this.regionId,
    this.city,
    this.cityId,
    this.moiaCenter,
    this.moiaCenterId,
    this.district,
    this.districtId,
    this.street,
    this.classification,
    this.classificationId,
    this.mosqueType,
    this.mosqueTypeId,
    this.lastUpdateDate,
    this.observerIds,
    this.completeAddress,
    this.longitude,
    this.latitude,
    this.placeId,
    this.globalCode,
    this.compoundCode,
    this.mosqueCondition,
    this.buildingMaterial,
    this.urbanCondition,
    this.dateMaintenanceLast,
    this.image,
    this.outerImage,
    this.externalDoorsNumbers,
    this.internalDoorsNumber,
    this.numMinarets,
    this.numFloors,
    this.hasBasement,
    this.mosqueRooms,
    this.fridayPrayerRows,
    this.rowMenPrayingNumber,
    this.lengthRowMenPraying,
    this.capacity,
    this.menPrayerAvgAttendance,
    // COMMENTED OUT: mosque_in_military_zone field
    // this.mosqueInMilitaryZone,
    this.toiletMenNumber,
    this.hasWomenPrayerRoom,
    this.rowWomenPrayingNumber,
    this.lengthRowWomenPraying,
    this.womenPrayerRoomCapacity,
    this.toiletWomanNumber,
    this.isEmployee,
    this.imamIds,
    this.muezzinIds,
    this.khademIds,
    this.khatibIds,
    this.residenceForImam,
    this.imamResidenceType,
    this.imamResidenceLandArea,
    this.residenceForMouadhin,
    this.muezzinResidenceType,
    this.muezzinResidenceLandArea,
    this.carsParking,
    this.hasWashingMachine,
    this.isOtherAttachment,
    this.lecturesHall,
    this.libraryExist,
    this.ministryAuthorized,
    this.isThereInvestmentBuilding,
    this.isThereHeadquarters,
    this.isThereQuranMemorizationMen,
    this.propertyTypeIds,
    this.isThereQuranMemorizationWomen,
    this.mosqueLandArea,
    this.nonBuildingArea,
    this.roofedArea,
    this.isFreeArea,
    this.freeArea,
    this.hasDeed,
    this.isThereLandTitle,
    this.noPlanned,
    this.pieceNumber,
    this.mosqueOpeningDate,
    this.hasAirConditioners,
    this.acType,
    this.numAirConditioners,
    this.hasInternalCamera,
    this.hasExternalCamera,
    this.numLightingInside,
    this.internalSpeakerNumber,
    this.externalHeadsetNumber,
    this.hasFireExtinguishers,
    this.hasFireSystemPumps,
    this.maintenanceResponsible,
    this.maintenancePerson,
    this.companyName,
    this.contractNumber,
    this.meterIds,
    this.waterMeterIds,
    this.electricMetersArray,
    this.waterMetersArray,
    this.isQrCodeExist,
    this.qrPanelNumbers,
    this.isPanelReadable,
    this.codeReadable,
    this.mosqueDataCorrect,
    this.isMosqueNameQr,
    this.qrCodeNotes,
    this.qrImage,
    this.observationText,
    this.userPledge,
    this.mosqueHistorical,
    this.princeProjectHistoricMosque,
    this.maintenanceContractsArray,
    this.declarationsArray,
    
    // Haram location fields
    this.isInsideHaramMakkah,
    this.isInPilgrimHousingMakkah,
    this.isInsideHaramMadinah,
    this.isInVisitorHousingMadinah,
    
    // New location fields
    this.isInsidePrison,
    this.isInsideHospital,
    this.isInsideGovernmentHousing,
    this.isInsideRestrictedGovEntity,
    this.landOwner,

    // Employee arrays for display
    this.imamIdsArray,
    this.muezzinIdsArray,
    this.khademIdsArray,
    this.khatibIdsArray,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // -------- Converters --------

  void mergeJson(dynamic json) {
    // =========================
    // [BASIC INFO]
    // =========================
    serverId     = JsonUtils.toInt(json['id']) ?? serverId;
    name   = JsonUtils.toText(json['name']) ?? name;
    number = JsonUtils.toText(json['number']) ?? number;
    //number = JsonUtils.toText(json['mosque_number']) ?? number;     // alt key
    //name   = JsonUtils.toText(json['mosque_name']) ?? name;


    // classification - handle false values like visit models
    final classificationData = json['classification_id'];
    if (classificationData != null && classificationData != false) {
      classificationId   = JsonUtils.getObjectId(classificationData) ?? classificationId;
      classification = JsonUtils.getObjectName(classificationData) ?? classification;
    }

    // mosque type - handle false values like visit models
    final mosqueTypeData = json['mosque_type_id'];
    if (mosqueTypeData != null && mosqueTypeData != false) {
      mosqueTypeId = JsonUtils.getObjectId(mosqueTypeData) ?? mosqueTypeId;
      mosqueType   = JsonUtils.getObjectName(mosqueTypeData) ?? mosqueType;
    }


    // stage
    // stageId   = JsonUtils.getObjectId(json['stage']) ?? stageId;
    // stageId   = JsonUtils.toInt(json['stage_id']) ?? stageId;
    // stageId   = JsonUtils.getId(json['stage']) ?? stageId;                                     // optional
    // stageName = JsonUtils.getObjectName(json['stage']) ?? stageName;
    // stageName = JsonUtils.toText(json['stage_name']) ?? stageName;
    stageName = JsonUtils.getName(json['stage']) ?? stageName;                                 // optional

    // dates
    //mosqueLastUpdate = JsonUtils.toDateTime(json['mosque_last_update']) ?? mosqueLastUpdate;

    // observers - handle false values like visit models
    final observerIdsData = json['observer_ids'];
    if (observerIdsData != null && observerIdsData != false && observerIdsData is List) {
      observerIdsArray = (observerIdsData as List).map((item) => ComboItem.fromJsonObject(item)).toList();
    }
    //observerNames = JsonUtils.toStringList(json['observer_names']) ?? observerNames;

    // texts
    // observationText = JsonUtils.toText(json['observation_text']) ?? observationText;
    // refuseReason    = JsonUtils.toText(json['refuse_reason']) ?? refuseReason;
    mosqueName    = JsonUtils.toText(json['mosque_name']) ?? mosqueName;

    observationText = JsonUtils.toText(json['observation_text']) ?? observationText;
    refuseReason    = JsonUtils.toText(json['refuse_reason']) ?? refuseReason;

    // display buttons
    displayButtonAccept     = JsonUtils.toBoolean(json['display_button_accept']) ?? displayButtonAccept;
    displayButtonRefuse     = JsonUtils.toBoolean(json['display_button_refuse']) ?? displayButtonRefuse;
    displayButtonSend       = JsonUtils.toBoolean(json['display_button_send']) ?? displayButtonSend;
    displayButtonSetToDraft = JsonUtils.toBoolean(json['display_button_set_to_draft']) ?? displayButtonSetToDraft;




    // extras
    compoundCode = JsonUtils.toText(json['compound_code']) ?? compoundCode;

    // =========================
    // [ADDRESS]
    // =========================
    // Region
    regionId   = JsonUtils.getObjectId(json['region_id']) ?? regionId;
                                    // optional
    region = JsonUtils.getObjectName(json['region_id']) ?? region;
                            // optional

    // City
    cityId   = JsonUtils.getObjectId(json['city_id']) ?? cityId;
                                        // optional
    city = JsonUtils.getObjectName(json['city_id']) ?? city;
                                 // optional

    // MOIA Center
    moiaCenterId   = JsonUtils.getObjectId(json['moia_center_id']) ?? moiaCenterId;
    // moiaCenterId   = JsonUtils.getId(json['moia_center']) ?? moiaCenterId;                     // optional
    moiaCenter = JsonUtils.getObjectName(json['moia_center_id']) ?? moiaCenter;
                   // optional

    // District
    districtId   = JsonUtils.getObjectId(json['district']) ?? districtId;
    // districtId   = JsonUtils.toInt(json['district_id']) ?? districtId;
    // districtId   = JsonUtils.getId(json['district']) ?? districtId;                            // optional
    district = JsonUtils.getObjectName(json['district']) ?? district;
                       // optional

    street          = JsonUtils.toText(json['street']) ?? street;
    completeAddress = JsonUtils.toText(json['complete_address']) ?? completeAddress;
    completeAddress = JsonUtils.toText(json['address']) ?? completeAddress;                    // alt key
    latitude        = JsonUtils.toDouble(json['latitude']) ?? latitude;
    longitude       = JsonUtils.toDouble(json['longitude']) ?? longitude;
    
    // Haram location fields
    isInsideHaramMakkah = JsonUtils.toText(json['is_inside_haram_makkah']) ?? isInsideHaramMakkah;
    isInPilgrimHousingMakkah = JsonUtils.toText(json['is_in_pilgrim_housing_makkah']) ?? isInPilgrimHousingMakkah;
    isInsideHaramMadinah = JsonUtils.toText(json['is_inside_haram_madinah']) ?? isInsideHaramMadinah;
    isInVisitorHousingMadinah = JsonUtils.toText(json['is_in_visitor_housing_madinah']) ?? isInVisitorHousingMadinah;
    
    // New location fields - handle false values as null
    isInsidePrison = JsonUtils.toText(json['is_inside_prison']) ?? isInsidePrison;
    isInsideHospital = JsonUtils.toText(json['is_inside_hospital']) ?? isInsideHospital;
    isInsideGovernmentHousing = JsonUtils.toText(json['is_inside_government_housing']) ?? isInsideGovernmentHousing;
    isInsideRestrictedGovEntity = JsonUtils.toText(json['is_inside_restricted_gov_entity']) ?? isInsideRestrictedGovEntity;
    landOwner = JsonUtils.toText(json['land_owner']) ?? landOwner;

    // =========================
    // [CONDITION]
    // =========================
    mosqueCondition     = JsonUtils.toText(json['mosque_condition']) ?? mosqueCondition;
    buildingMaterial    = JsonUtils.toText(json['building_material']) ?? buildingMaterial;
    urbanCondition      = JsonUtils.toText(json['urban_condition']) ?? urbanCondition;
    dateMaintenanceLast = JsonUtils.toText(json['date_maintenance_last']) ?? dateMaintenanceLast;
    // image               = JsonUtils.toText(json['image']) ?? image;

    // =========================
    // [STRUCTURE]
    // =========================
    externalDoorsNumbers = JsonUtils.toInt(json['external_doors_numbers']) ?? externalDoorsNumbers;
    internalDoorsNumber  = JsonUtils.toInt(json['internal_doors_number']) ?? internalDoorsNumber;
    numMinarets          = JsonUtils.toInt(json['num_minarets']) ?? numMinarets;
    numFloors            = JsonUtils.toInt(json['num_floors']) ?? numFloors;
    hasBasement          = JsonUtils.toText(json['has_basement']) ?? hasBasement; // 'yes'/'no'
    mosqueRooms          = JsonUtils.toInt(json['mosque_rooms']) ?? mosqueRooms;

    // =========================
    // [MEN'S PRAYER]
    // =========================
    fridayPrayerRows    = JsonUtils.toInt(json['friday_prayer_rows']) ?? fridayPrayerRows;
    rowMenPrayingNumber = JsonUtils.toInt(json['row_men_praying_number']) ?? rowMenPrayingNumber;
    lengthRowMenPraying = JsonUtils.toDouble(json['length_row_men_praying']) ?? lengthRowMenPraying;
    capacity         = JsonUtils.toInt(json['capacity']) ?? capacity;
    menPrayerAvgAttendance = JsonUtils.toText(json['men_prayer_avg_attendance']) ?? menPrayerAvgAttendance;
    // COMMENTED OUT: mosque_in_military_zone field
    // mosqueInMilitaryZone = JsonUtils.toText(json['mosque_in_military_zone']) ?? mosqueInMilitaryZone;
    toiletMenNumber     = JsonUtils.toInt(json['toilet_men_number']) ?? toiletMenNumber;

    // =========================
    // [WOMEN'S PRAYER]
    // =========================
    hasWomenPrayerRoom      = JsonUtils.toText(json['has_women_prayer_room']) ?? hasWomenPrayerRoom; // 'yes'/'no'
    rowWomenPrayingNumber   = JsonUtils.toInt(json['row_women_praying_number']) ?? rowWomenPrayingNumber;
    lengthRowWomenPraying   = JsonUtils.toDouble(json['length_row_women_praying']) ?? lengthRowWomenPraying;
    womenPrayerRoomCapacity = JsonUtils.toInt(json['women_prayer_room_capacity']) ?? womenPrayerRoomCapacity;
    toiletWomanNumber       = JsonUtils.toInt(json['toilet_woman_number']) ?? toiletWomanNumber;

    // =========================
    // [EMPLOYEE INFO]
    // =========================
    isEmployee = JsonUtils.toText(json['is_employee']) ?? isEmployee;
    
    // Employee IDs - convert from API format to List<int>
    // imamIds = json['imam_ids'] == null ? imamIds : (json['imam_ids'] as List).map((item) => JsonUtils.toInt(item is Map ? item['id'] : item)).where((id) => id != null).cast<int>().toList();
    // muezzinIds = json['muezzin_ids'] == null ? muezzinIds : (json['muezzin_ids'] as List).map((item) => JsonUtils.toInt(item is Map ? item['id'] : item)).where((id) => id != null).cast<int>().toList();
    // khademIds = json['khadem_ids'] == null ? khademIds : (json['khadem_ids'] as List).map((item) => JsonUtils.toInt(item is Map ? item['id'] : item)).where((id) => id != null).cast<int>().toList();
    // khatibIds = json['khatib_ids'] == null ? khatibIds : (json['khatib_ids'] as List).map((item) => JsonUtils.toInt(item is Map ? item['id'] : item)).where((id) => id != null).cast<int>().toList();
    //
    // Employee Arrays - convert from API format to List<ComboItem> for display
    imamIdsArray = json['imam_ids'] == null ?imamIdsArray:JsonUtils.toListObject(json['imam_ids']).map((item) => UserProfile.fromMansoobJson(item)).toList();
    muezzinIdsArray = json['muezzin_ids'] == null ?muezzinIdsArray:JsonUtils.toListObject(json['muezzin_ids']).map((item) => UserProfile.fromMansoobJson(item)).toList();
    khademIdsArray = json['khadem_ids'] == null ?khademIdsArray:JsonUtils.toListObject(json['khadem_ids']).map((item) => UserProfile.fromMansoobJson(item)).toList();
    khatibIdsArray = json['khatib_ids'] == null ?khatibIdsArray:JsonUtils.toListObject(json['khatib_ids']).map((item) => UserProfile.fromMansoobJson(item)).toList();
    // imamIdsArray = json['imam_ids'] == null ? imamIdsArray : (json['imam_ids'] as List).where((item) => item != null && item is Map<String, dynamic>).map((item) => ComboItem.fromJsonObject(item)).toList();
    // muezzinIdsArray = json['muezzin_ids'] == null ? muezzinIdsArray : (json['muezzin_ids'] as List).where((item) => item != null && item is Map<String, dynamic>).map((item) => ComboItem.fromJsonObject(item)).toList();
    // khademIdsArray = json['khadem_ids'] == null ? khademIdsArray : (json['khadem_ids'] as List).where((item) => item != null && item is Map<String, dynamic>).map((item) => ComboItem.fromJsonObject(item)).toList();
    // khatibIdsArray = json['khatib_ids'] == null ? khatibIdsArray : (json['khatib_ids'] as List).where((item) => item != null && item is Map<String, dynamic>).map((item) => ComboItem.fromJsonObject(item)).toList();

    // =========================
    // [RESIDENCE INFO]
    // =========================
    residenceForImam = JsonUtils.toText(json['residence_for_imam']) ?? residenceForImam;
    imamResidenceType = JsonUtils.toText(json['imam_residence_type']) ?? imamResidenceType;
    imamResidenceLandArea = JsonUtils.toDouble(json['imam_residence_land_area']) ?? imamResidenceLandArea;
    residenceForMouadhin = JsonUtils.toText(json['residence_for_mouadhin']) ?? residenceForMouadhin;
    muezzinResidenceType = JsonUtils.toText(json['muezzin_residence_type']) ?? muezzinResidenceType;
    muezzinResidenceLandArea = JsonUtils.toDouble(json['muezzin_residence_land_area']) ?? muezzinResidenceLandArea;

    // =========================
    // [FACILITIES INFO]
    // =========================
    isOtherAttachment = JsonUtils.toText(json['is_other_attachment']) ?? isOtherAttachment;
    lecturesHall = JsonUtils.toText(json['lectures_hall']) ?? lecturesHall;
    libraryExist = JsonUtils.toText(json['library_exist']) ?? libraryExist;
    isThereInvestmentBuilding = JsonUtils.toText(json['is_there_investment_building']) ?? isThereInvestmentBuilding;
    isThereHeadquarters = JsonUtils.toText(json['is_there_headquarters']) ?? isThereHeadquarters;
    isThereQuranMemorizationMen = JsonUtils.toText(json['is_there_quran_memorization_men']) ?? isThereQuranMemorizationMen;
    isThereQuranMemorizationWomen = JsonUtils.toText(json['is_there_quran_memorization_women']) ?? isThereQuranMemorizationWomen;
    hasWashingMachine = JsonUtils.toText(json['has_washing_machine']) ?? hasWashingMachine;
    carsParking = JsonUtils.toText(json['cars_parking']) ?? carsParking;
    ministryAuthorized = JsonUtils.toText(json['ministry_authorized']) ?? ministryAuthorized;

    // Parse property_type_ids (one2many field - list of questions)
    if (json['property_type_ids'] is List) {
      debugPrint('📦 [property_type_ids] Parsing ${(json['property_type_ids'] as List).length} raw records from API...');
      
      final rawList = (json['property_type_ids'] as List)
          .map((item) {
            if (item is! Map) return null;
            final map = Map<String, dynamic>.from(item);
            
            // Preserve the record 'id' field (e.g., 248, 249, etc.) - needed for updates
            // This is the database record ID, different from question_id
            
            // Normalize question_id: if it's an object {id, name}, keep both for UI
            if (map['question_id'] is Map) {
              final qIdObj = map['question_id'];
              map['question_id'] = [qIdObj['id'], qIdObj['name']];
              map['question_name'] = qIdObj['name']; // Keep name accessible
            }
            return map;
          })
          .whereType<Map<String, dynamic>>()
          .toList();
      
      // Deduplicate: keep only the LATEST occurrence of each question_id
      // (API sometimes returns duplicates, we want the most recent answer)
      final seen = <dynamic>{};
      final deduplicated = <Map<String, dynamic>>[];
      
      // Iterate in reverse to keep the last occurrence (highest ID = most recent)
      for (var item in rawList.reversed) {
        final questionId = item['question_id'] is List 
            ? item['question_id'][0] 
            : item['question_id'];
        
        if (!seen.contains(questionId)) {
          seen.add(questionId);
          deduplicated.insert(0, item); // Insert at beginning to maintain order
        }
      }
      
      propertyTypeIds = deduplicated;
      
      // Debug output
      if (rawList.length != deduplicated.length) {
        debugPrint('🔄 [property_type_ids] Deduplicated ${rawList.length} → ${deduplicated.length} records');
        debugPrint('   Latest record IDs: ${deduplicated.map((e) => e['id']).join(', ')}');
      } else {
        debugPrint('✅ [property_type_ids] No duplicates found, kept all ${deduplicated.length} records');
      }
    }

    // =========================
    // [LAND INFO]
    // =========================
    mosqueLandArea = JsonUtils.toText(json['land_area']) ?? mosqueLandArea;
    nonBuildingArea = JsonUtils.toDouble(json['non_building_area']) ?? nonBuildingArea;
    roofedArea = JsonUtils.toDouble(json['roofed_area']) ?? roofedArea;
    isFreeArea = JsonUtils.toText(json['is_free_area']) ?? isFreeArea;
    freeArea = JsonUtils.toDouble(json['free_area']) ?? freeArea;
    hasDeed = JsonUtils.toText(json['has_deed']) ?? hasDeed;
    isThereLandTitle = JsonUtils.toText(json['is_there_land_title']) ?? isThereLandTitle;
    noPlanned = JsonUtils.toDouble(json['no_planned']) ?? noPlanned;
    pieceNumber = JsonUtils.toDouble(json['piece_number']) ?? pieceNumber;
    mosqueOpeningDate = JsonUtils.toText(json['mosque_opening_date']) ?? mosqueOpeningDate;

    // =========================
    // [AUDIO ELECTRONICS INFO]
    // =========================
    hasAirConditioners = JsonUtils.toText(json['has_air_conditioners']) ?? hasAirConditioners;
    numAirConditioners = JsonUtils.toDouble(json['num_air_conditioners'])?.toInt() ?? numAirConditioners;
    
    // Parse ac_type: API may return [{id, name}, ...] or [1, 2, 3, ...]
    if (json['ac_type'] is List) {
      final acTypeRaw = json['ac_type'] as List;
      if (acTypeRaw.isNotEmpty && acTypeRaw.first is Map) {
        // Extract IDs from [{id, name}, ...] format
        acType = acTypeRaw.map((item) => item['id'] as int).toList();
      } else if (acTypeRaw.isNotEmpty && acTypeRaw.first is int) {
        // Already in [1, 2, 3] format
        acType = List<int>.from(acTypeRaw);
      }
    }
    
    hasInternalCamera = JsonUtils.toText(json['has_internal_camera']) ?? hasInternalCamera;
    hasExternalCamera = JsonUtils.toText(json['has_external_camera']) ?? hasExternalCamera;
    numLightingInside = JsonUtils.toInt(json['num_lighting_inside']) ?? numLightingInside;
    internalSpeakerNumber = JsonUtils.toInt(json['internal_speaker_number']) ?? internalSpeakerNumber;
    externalHeadsetNumber = JsonUtils.toInt(json['external_headset_number']) ?? externalHeadsetNumber;

    // =========================
    // [SAFETY INFO]
    // =========================
    hasFireExtinguishers = JsonUtils.toText(json['has_fire_extinguishers']) ?? hasFireExtinguishers;
    hasFireSystemPumps = JsonUtils.toText(json['has_fire_system_pumps']) ?? hasFireSystemPumps;

    // =========================
    // [MAINTENANCE INFO]
    // =========================
    maintenanceResponsible = JsonUtils.toText(json['maintenance_responsible']) ?? maintenanceResponsible;
    //maintenancePerson = JsonUtils.toText(json['maintenance_person']) ?? maintenancePerson;
    //companyName = JsonUtils.toText(json['company_name']) ?? companyName;
    //contractNumber = JsonUtils.toText(json['contract_number']) ?? contractNumber;

    // =========================
    // [METERS INFO]
    // =========================
    if (json['meter_ids'] is List) {
      electricMetersArray = (json['meter_ids'] as List)
          .where((item) => item != null && item is Map<String, dynamic>)
          .cast<Map<String, dynamic>>()
          .toList();
    }
    
    if (json['water_meter_ids'] is List) {
      waterMetersArray = (json['water_meter_ids'] as List)
          .where((item) => item != null && item is Map<String, dynamic>)
          .cast<Map<String, dynamic>>()
          .toList();
    }

    int? _toInt(dynamic v) => JsonUtils.toInt(v) ?? JsonUtils.toDouble(v)?.round();

    if (json['meter_ids'] is List) {
      final list = List.from(json['meter_ids'] as List);
      if (list.isNotEmpty && list.first is Map) {
        (payload ??= {})['meter_ids'] = list;
      } else {
        meterIds = list.map((e) => _toInt(e)).whereType<int>().toList();
      }
    }
    if (json['water_meter_ids'] is List) {
      final list = List.from(json['water_meter_ids'] as List);
      if (list.isNotEmpty && list.first is Map) {
        (payload ??= {})['water_meter_ids'] = list;
      } else {
        waterMeterIds = list.map((e) => _toInt(e)).whereType<int>().toList();
      }
    }

    // =========================
    // [CONTRACTS INFO]
    // =========================

    if (json['maintenance_contracts'] is List) {
      maintenanceContractsArray = (json['maintenance_contracts'] as List)
          .where((item) => item != null && item is Map)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } else if (json['data'] is List && (json['data'] as List).isNotEmpty) {
      // Only update if data looks like contracts (has contract-specific fields)
      final firstItem = (json['data'] as List).first;
      if (firstItem is Map && (firstItem.containsKey('company_contractor_id') || 
          firstItem.containsKey('purchase_order_no') || 
          firstItem.containsKey('contract_state'))) {
        maintenanceContractsArray = (json['data'] as List)
            .where((item) => item != null && item is Map)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    }

    // =========================
    // [DECLARATIONS INFO]
    // =========================
    if (json['data'] is List && (json['data'] as List).isNotEmpty) {
      // Only update if data looks like declarations (has declaration-specific fields)
      final firstItem = (json['data'] as List).first;
      if (firstItem is Map && (firstItem.containsKey('approver_id') || 
          firstItem.containsKey('accept_terms') || 
          firstItem.containsKey('record_name'))) {
        declarationsArray = (json['data'] as List)
            .where((item) => item != null && item is Map)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      }
    }



    // =========================
    // [HISTORICAL INFO]
    // =========================
    mosqueHistorical = JsonUtils.toText(json['mosque_historical']) ?? mosqueHistorical;
    princeProjectHistoricMosque = JsonUtils.toText(json['prince_project_historic_mosque']) ?? princeProjectHistoricMosque;

    // =========================
    // [QR CODE INFO]
    // =========================
    isQrCodeExist = JsonUtils.toText(json['is_qr_code_exist']) ?? isQrCodeExist;
    qrPanelNumbers = JsonUtils.toInt(json['qr_panel_numbers']) ?? qrPanelNumbers;
    isPanelReadable = JsonUtils.toText(json['is_panel_readable']) ?? isPanelReadable;
    mosqueDataCorrect = JsonUtils.toText(json['mosque_data_correct']) ?? mosqueDataCorrect;
    isMosqueNameQr = JsonUtils.toText(json['is_mosque_name_qr']) ?? isMosqueNameQr;
    qrCodeNotes = JsonUtils.toText(json['qr_code_notes']) ?? qrCodeNotes;
    qrImage = JsonUtils.toText(json['qr_image']) ?? qrImage;

    // Company contractor info (single object, not array)
    companyContractId = JsonUtils.getObjectId(json['company_contractor_id']) ?? companyContractId;
    companyContractName = JsonUtils.getObjectName(json['company_contractor_id']) ?? companyContractName;
  }


  List<String> missingMinimumFields({bool requireIds = false}) {
    bool _empty(String? s) => s == null || s.trim().isEmpty;

    final missing = <String>[];

    // name (must have a non-empty string)
    if (_empty(name)) missing.add('name');

    // region (ok if either label or id is set)
    final hasRegion = (!_empty(region)) || (regionId != null);
    if (!hasRegion) missing.add('region');

    // city
    final hasCity = (!_empty(city)) || (cityId != null);
    if (!hasCity) missing.add('city');

    // MOIA center
    final hasMoia = (!_empty(moiaCenter)) || (moiaCenterId != null);
    if (!hasMoia) missing.add('moia_center');

    // classification
    final hasClassification = (!_empty(classification)) || (classificationId != null);
    if (!hasClassification) missing.add('classification');

    // If your flow *requires* ids (not just labels), enforce it:
    if (requireIds) {
      if (regionId == null && !missing.contains('region')) missing.add('region');
      if (cityId == null && !missing.contains('city')) missing.add('city');
      if (moiaCenterId == null && !missing.contains('moia_center')) missing.add('moia_center');
      if (classificationId == null && !missing.contains('classification')) missing.add('classification');
    }

    return missing;
  }

  /// Convenience getter
  bool get hasMinimumFields => missingMinimumFields().isEmpty;



  void onChangeResidenceForImam(){
    imamResidenceType=null;
    imamResidenceLandArea=null;
  }
  void onChangeResidenceForMuezzin(){
    muezzinResidenceType=null;
    muezzinResidenceLandArea=null;
  }

  // Nullifying data from all fields if mosque condition changed to under-constructions of under-renovation

  void clearDependentData() {
    // Mosque Condition
    buildingMaterial = null;
    urbanCondition = null;
    dateMaintenanceLast = null;
    image = null;
    outerImage = null;

    // Architectural Structure
    externalDoorsNumbers = null;
    internalDoorsNumber = null;
    numMinarets = null;
    numFloors = null;
    mosqueRooms = null;
    hasBasement = null;

    // Men Prayer Section
    fridayPrayerRows = null;
    rowMenPrayingNumber = null;
    lengthRowMenPraying = null;
    capacity = null;
    menPrayerAvgAttendance = null;
    toiletMenNumber = null;

    // Women Prayer Section
    hasWomenPrayerRoom = null;
    rowWomenPrayingNumber = null;
    lengthRowWomenPraying = null;
    womenPrayerRoomCapacity = null;
    toiletWomanNumber = null;

    // Employees Section

    isEmployee = null;

    // Imams Muezzins Details
    residenceForImam = null;
    imamResidenceType = null;
    imamResidenceLandArea = null;
    residenceForMouadhin = null;
    muezzinResidenceType = null;
    muezzinResidenceLandArea = null;

    // Mosque Facilities
    isOtherAttachment = null;
    libraryExist = null;
    lecturesHall = null;
    isThereInvestmentBuilding = null;
    isThereHeadquarters = null;
    isThereQuranMemorizationMen = null;
    isThereQuranMemorizationWomen = null;
    hasWashingMachine = null;
    carsParking = null;
    ministryAuthorized = null;

    // Mosque Land
    mosqueLandArea = null;
    nonBuildingArea = null;
    roofedArea = null;
    isFreeArea = null;
    freeArea = null;
    mosqueOpeningDate = null;

    // Audio and Electronics
    hasAirConditioners = null;
    acType = null;
    numAirConditioners = null;
    hasInternalCamera = null;
    hasExternalCamera = null;
    numLightingInside = null;
    internalSpeakerNumber = null;
    externalHeadsetNumber = null;

    // Safety Equipment
    hasFireExtinguishers = null;
    hasFireSystemPumps = null;

    // Maintenance Operation
    maintenanceResponsible = null;
    maintenancePerson = null;

    // Historical Mosques
    mosqueHistorical = null;
    princeProjectHistoricMosque = null;

    // QR Code Panel
    isQrCodeExist = null;
    qrPanelNumbers = null;
    isPanelReadable = null;
    mosqueDataCorrect = null;
    isMosqueNameQr = null;
    qrCodeNotes = null;
    qrImage = null;

    // Payload data for meters
    if (payload != null) {
      payload!.remove('meter_ids');
      payload!.remove('water_meter_ids');
      payload!.remove('is_employee');
    }
  }
  //endregion
}




// Normalizes label→code for mosqueCondition
extension MosqueLocalNormalize on MosqueLocal {
  void normalizeForRules() {
    mosqueCondition = MosqueConditionData.normalizeToCode(mosqueCondition);
  }
}

// Required-fields validation
extension MosqueLocalValidation on MosqueLocal {
  List<String> missingMinimumFields({bool requireIds = true}) {
    bool _empty(String? s) => s == null || s.trim().isEmpty;
    final missing = <String>[];

    if (_empty(name)) missing.add('name');

    final hasRegion = (!_empty(region)) || regionId != null;
    if (!hasRegion || (requireIds && regionId == null)) missing.add('region');

    final hasCity = (!_empty(city)) || cityId != null;
    if (!hasCity || (requireIds && cityId == null)) missing.add('city');

    final hasMoia = (!_empty(moiaCenter)) || moiaCenterId != null;
    if (!hasMoia || (requireIds && moiaCenterId == null)) missing.add('moia_center');

    final hasClass = (!_empty(classification)) || classificationId != null;
    if (!hasClass || (requireIds && classificationId == null)) missing.add('classification');

    return missing;
  }

  bool get hasMinimumFields => missingMinimumFields().isEmpty;
}

// API payload mapping for legacy_forms
extension MosqueLocalApi on MosqueLocal {
  Map<String, dynamic> toCreatePayload() {
    return {
      'name': name,
      'number': number,
      'district': districtId,
      'street': street,
      'classification_id': classificationId,
      'mosque_type_id': mosqueTypeId,
      'region_id': regionId,
      'city_id': cityId,
      'moia_center_id': moiaCenterId,
      'mosque_condition': MosqueConditionData.normalizeToCode(mosqueCondition),
      'building_material': buildingMaterial,
      'urban_condition': urbanCondition,
      'date_maintenance_last': dateMaintenanceLast,
      'longitude': longitude,
      'latitude': latitude,
      'place_id': placeId,
      'global_code': globalCode,
      'compound_code': compoundCode,
      'is_inside_haram_makkah': isInsideHaramMakkah,
      'is_in_pilgrim_housing_makkah': isInPilgrimHousingMakkah,
      'is_inside_haram_madinah': isInsideHaramMadinah,
      'is_in_visitor_housing_madinah': isInVisitorHousingMadinah,
    }..removeWhere((_, v) => v == null);
  }
}
