import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_workflow.dart';
import 'package:intl/intl.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';

//
// @HiveType(typeId: HiveTypeIds.visitModel)
class VisitModel extends VisitModelBase {

  //region for fields
  @HiveField(0)
  final int? id;

  @HiveField(1)
  double? latitude;

  @HiveField(2)
  double? longitude;

  @HiveField(3)
  String? name;



  @HiveField(5)
  String? stage;

  @HiveField(6)
  int? stageId;

  @HiveField(7)
  String? mosque;

  @HiveField(8)
  int? mosqueId;

  @HiveField(9)
  int? cityId;

  @HiveField(10)
  bool? isVisitStarted;

  @HiveField(11)
  String? dateOfVisit;

  @HiveField(12)
  String? submitDatetime;

  @HiveField(13)
  String? startDatetime;

  @HiveField(14)
  String? prayerName;

  @HiveField(15)
  String? outerDevices;

  @HiveField(16)
  String? innerDevices;

  @HiveField(17)
  String? innerAudioDevices;

  @HiveField(18)
  String? speakerOnPrayer;

  @HiveField(19)
  String? outerAudioDevices;

  @HiveField(20)
  String? lightening;

  @HiveField(21)
  String? airCondition;

  @HiveField(22)
  String? electicityPerformance;

  @HiveField(23)
  String? isEncroachmentBuilding;

  @HiveField(24)
  String? encroachmentBuildingAttachment;

  @HiveField(25)
  String? caseEncroachmentBuilding;

  @HiveField(26)
  String? isEncroachmentVacantLand;

  @HiveField(27)
  String? encroachmentVacantAttachment;

  @HiveField(28)
  String? caseEncroachmentVacantLand;

  @HiveField(29)
  String? violationBuildingAttachment;

  @HiveField(30)
  String? isViolationBuilding;

  @HiveField(31)
  String? caseViolationBuilding;

  @HiveField(32)
  String? buildingNotes;

  @HiveField(33)
  String? meterNotes;

  @HiveField(34)
  String? deviceNotes;

  @HiveField(35)
  String? safteyStandardNotes;

  @HiveField(36)
  String? cleanMaintenanceNotes;

  @HiveField(37)
  String? securityViolationNotes;

  @HiveField(38)
  String? dawahActivitiesNotes;

  @HiveField(39)
  String? mosqueStatusNotes;

// Maintenance
  @HiveField(40)
  String? quranShelvesStorage;

  @HiveField(41)
  String? carpetsAndFlooring;

  @HiveField(42)
  String? mosqueCourtyards;

  @HiveField(43)
  String? mosqueEntrances;

  @HiveField(44)
  String? ablutionAreas;

  @HiveField(45)
  String? windowsDoorsWalls;

  @HiveField(46)
  String? storageRooms;

  @HiveField(47)
  String? mosqueCarpetQuality;

  @HiveField(48)
  String? toilets;

  @HiveField(49)
  String? maintenanceExecution;

  @HiveField(50)
  String? maintenanceResponseSpeed;

  @HiveField(51)
  String? hasMaintenanceContractor;

  @HiveField(52)
  List<int>? maintenanceContractorIds;

  @HiveField(53)
  List<ComboItem>? maintenanceContractorIdsArray;

// Mosque Status
  @HiveField(54)
  String? mosqueAddressStatus;

  @HiveField(55)
  String? geolocationStatus;

  @HiveField(56)
  String? mosqueDetailsStatus;

  @HiveField(57)
  String? mosqueImagesStatus;

  @HiveField(58)
  String? maintenanceContractStatus;

  @HiveField(59)
  String? buildingDetailsStatus;

  @HiveField(60)
  String? imamResidenceStatus;

  @HiveField(61)
  String? prayerAreaStatus;

  @HiveField(62)
  String? humanResourcesStatus;

// Dawah Activity
  @HiveField(63)
  String? hasReligiousActivity;

  @HiveField(64)
  String? activityType;

  @HiveField(65)
  String? hasTayseerPermission;

  @HiveField(66)
  String? tayseerPermissionNumber;

  @HiveField(67)
  String? activityTitle;

  @HiveField(68)
  String? activityDetails;

  @HiveField(69)
  String? yaqeenStatus;

  @HiveField(70)
  String? preacherIdentificationId;

  @HiveField(71)
  String? phonePreacher;

  @HiveField(72)
  String? genderPreacher;

  @HiveField(73)
  String? dobPreacher;

// Security
  @HiveField(74)
  String? securityViolationType;

  @HiveField(75)
  String? adminViolationType;

  @HiveField(76)
  String? operationalViolationType;

  @HiveField(77)
  String? unauthorizedPublications;

  @HiveField(78)
  String? publicationSource;

  @HiveField(79)
  String? religiousSocialViolationType;

  @HiveField(80)
  String? unauthorizedQuranPresence;

// Safety
  @HiveField(81)
  String? architecturalStructure;

  @HiveField(82)
  String? electricalInstallations;

  @HiveField(83)
  String? ablutionAndToilets;

  @HiveField(84)
  String? ventilationAndAirQuality;

  @HiveField(85)
  String? equipmentAndFurnitureSafety;

  @HiveField(86)
  String? doorsAndLocks;

  @HiveField(87)
  String? waterTankCovers;

  @HiveField(88)
  String? fireExtinguishers;

  @HiveField(89)
  String? fireAlarms;

  @HiveField(90)
  String? firstAidKits;

  @HiveField(91)
  String? emergencyExits;

// Meter
  @HiveField(92)
  String? hasElectricMeter;

  @HiveField(93)
  String? electricMeterDataUpdated;

  @HiveField(94)
  List<int>? electricMeterIds;

  @HiveField(95)
  List<ComboItem>? electricMeterIdsArray;

  @HiveField(96)
  String? electricMeterViolation;

  @HiveField(97)
  List<int>? violationElectricMeterIds;

  @HiveField(98)
  List<ComboItem>? violationElectricMeterIdsArray;

  @HiveField(99)
  dynamic violationElectricMeterAttachment;

  @HiveField(100)
  String? caseInfringementElecMeter;

  @HiveField(101)
  String? hasWaterMeter;

  @HiveField(102)
  List<int>? waterMeterIds;

  @HiveField(103)
  List<ComboItem>? waterMeterIdsArray;

  @HiveField(104)
  String? waterMeterDataUpdated;

  @HiveField(105)
  String? caseInfringementWaterMeter;

  @HiveField(106)
  String? waterMeterViolation;

  @HiveField(107)
  String? violationWaterMeterAttachment;

  @HiveField(108)
  List<int>? violationWaterMeterIds;

  @HiveField(109)
  List<ComboItem>? violationWaterMeterIdsArray;

  @HiveField(110)
  String? mosqueEntrancesSecurity;

  @HiveField(111)
  String? prayerAreaCleanliness;




  @HiveField(144)
  String? dobPreacherHijri;

  @HiveField(145)
  bool? btnStart;

  @HiveField(146)
  String? state;

  @HiveField(4)
  String? employee;

  @HiveField(147)
  int? employeeId;

  @HiveField(148)
  String? priorityValue;

  @HiveField(149)
  String? readAllowedBook;

  @HiveField(150)
  int? bookNameId;

  @HiveField(151)
  String? otherBookName;

  @HiveField(152)
  String? bookName;

  @HiveField(153)
  bool? dataVerified;



  String? actionNotes;
  String? actionAttachment;
  String? actionTakenType;
  String? trasolNumber;
  List<int>? actionAttachments;

  String? lastUpdatedFrom;
  bool? isLoading;
  bool? displayButtonAccept;
  bool? displayButtonUnderprogress;
  bool? displayButtonAction;


  List<VisitWorkflow>? visitWorkFlow;

  //endregion

  //region for property
  String get uniqueId => submitDatetime.toString();
  String? get startDatetimeLocal => JsonUtils.toLocalDateTimeFormat(startDatetime);
  String? get submitDatetimeLocal => JsonUtils.toLocalDateTimeFormat(submitDatetime);
  String? get modelName =>"";

  @override
  String? get listTitle => mosque;
  @override
  String? get listSubTitle => name;

  //endregion

  //region for data
  final Map<String, bool> noRequiredField={
    "imam_notes":true,
    "muezzin_notes":true,
    "khadem_notes":true,
    "mansoob_notes":true,
    "khatib_notes":true,
    "khutba_notes":true,
    "meter_notes":true,
    "female_section_notes":true,
    "building_notes":true,
    "device_notes": true,
    "saftey_standard_notes": true,
    "clean_maintenance_notes": true,
    "security_violation_notes": true,
    "dawah_activities_notes": true,
    "mosque_status_notes": true,
  };

  final dynamic escalatingConfig = {
    "imam_present": {
      "include": ["notpresent", "permission", "leave"]
    },
    "imam_commitment": {
      "include": "late"
    },
    "muezzin_present": {
      "include": ["notpresent", "permission", "leave"]
    },
    "muezzin_commitment": {
      "include": "late"
    },
    "khadem_present": {
      "include": ["notpresent", "permission", "leave"]
    },
    "electric_meter_violation": {
      "include": "yes"
    },
    "water_meter_violation": {
      "include": "yes"
    },
    "is_encroachment_building": {
      "include": "yes"
    },
    "is_encroachment_vacant_land": {
      "include": "yes"
    },
    "is_violation_building": {
      "include": "yes"
    },
    "speaker_on_prayer": {
      "include": "no"
    },
    "architectural_structure": {
      "include": "danger"
    },
    "electrical_installations": {
      "include": "danger"
    },
    "ablution_and_toilets": {
      "include": "danger"
    },
    "ventilation_and_air_quality": {
      "include": "danger"
    },
    "equipment_and_furniture_safety": {
      "include": "danger"
    },
    "security_violation_type": {
      "exclude": "none"
    },
    "admin_violation_type": {
      "exclude": "none"
    },
    "operational_violation_type": {
      "exclude": "none"
    },
    "unauthorized_publications": {
      "include": "yes"
    },
    "religious_social_violation_type": {
      "exclude": "none"
    },
    "unauthorized_quran_presence": {
      "exclude": "none"
    },
    "has_religious_activity": {
      "include": "yes"
    },
  };

  //endregion

  VisitModel({
    this.id,
    // this.createdAt,
    this.name,
    this.latitude,
    this.longitude,
    this.stage,
    this.stageId,
    this.state,
    this.priorityValue,
    this.mosque,
    this.mosqueId,
    this.employee,
    this.employeeId,
    this.cityId,
    this.dateOfVisit,
    this.btnStart,
    this.startDatetime,
    this.submitDatetime,
    this.lastUpdatedFrom,
    this.prayerName,
    this.outerDevices,
    this.innerDevices,
    this.innerAudioDevices,
    this.speakerOnPrayer,
    this.outerAudioDevices,
    this.lightening,
    this.airCondition,
    this.electicityPerformance,
    this.isEncroachmentBuilding,
    this.encroachmentBuildingAttachment,
    this.caseEncroachmentBuilding,
    this.isEncroachmentVacantLand,
    this.encroachmentVacantAttachment,
    this.caseEncroachmentVacantLand,
    this.violationBuildingAttachment,
    this.isViolationBuilding,
    this.caseViolationBuilding,
    this.buildingNotes,
    this.meterNotes,
    this.deviceNotes,
    this.safteyStandardNotes,
    this.cleanMaintenanceNotes,
    this.securityViolationNotes,
    this.dawahActivitiesNotes,
    this.mosqueStatusNotes,
    this.quranShelvesStorage,
    this.carpetsAndFlooring,
    this.prayerAreaCleanliness,
    this.mosqueCourtyards,
    this.mosqueEntrances,
    this.ablutionAreas,
    this.windowsDoorsWalls,
    this.storageRooms,
    this.mosqueCarpetQuality,
    this.toilets,
    this.maintenanceExecution,
    this.maintenanceResponseSpeed,
    this.hasMaintenanceContractor,
    this.maintenanceContractorIds,
    this.maintenanceContractorIdsArray,
    this.mosqueAddressStatus,
    this.geolocationStatus,
    this.mosqueDetailsStatus,
    this.mosqueImagesStatus,
    this.maintenanceContractStatus,
    this.buildingDetailsStatus,
    this.imamResidenceStatus,
    this.prayerAreaStatus,
    this.humanResourcesStatus,
    this.hasReligiousActivity,
    this.activityType,
    this.hasTayseerPermission,
    this.tayseerPermissionNumber,
    this.activityTitle,
    this.activityDetails,
    this.yaqeenStatus,
    this.preacherIdentificationId,
    this.phonePreacher,
    this.genderPreacher,
    this.dobPreacher,
    this.securityViolationType,
    this.adminViolationType,
    this.operationalViolationType,
    this.unauthorizedPublications,
    this.publicationSource,
    this.religiousSocialViolationType,
    this.unauthorizedQuranPresence,
    this.architecturalStructure,
    this.electricalInstallations,
    this.ablutionAndToilets,
    this.ventilationAndAirQuality,
    this.equipmentAndFurnitureSafety,
    this.doorsAndLocks,
    this.waterTankCovers,
    this.mosqueEntrancesSecurity,
    this.fireExtinguishers,
    this.fireAlarms,
    this.firstAidKits,
    this.emergencyExits,
    this.hasElectricMeter,
    this.electricMeterDataUpdated,
    this.electricMeterIds,
    this.electricMeterIdsArray,
    this.electricMeterViolation,
    this.violationElectricMeterIds,
    this.violationElectricMeterIdsArray,
    this.violationElectricMeterAttachment,
    this.caseInfringementElecMeter,
    this.hasWaterMeter,
    this.waterMeterIds,
    this.waterMeterIdsArray,
    this.waterMeterDataUpdated,
    this.caseInfringementWaterMeter,
    this.waterMeterViolation,
    this.violationWaterMeterAttachment,
    this.violationWaterMeterIds,
    this.violationWaterMeterIdsArray,
    this.readAllowedBook,
    this.bookNameId,
    this.otherBookName,
    // this.imamPresent,
    // this.imamIds,
    // this.imamIdsArray,
    // this.imamCommitment,
    // this.imamOffWork,
    // this.imamOffWorkDate,
    // this.imamPermissionPrayer,
    // this.imamLeaveFromDate,
    // this.imamLeaveToDate,
    // this.imamNotes,
    // this.muezzinPresent,
    // this.muezzinIds,
    // this.muezzinIdsArray,
    // this.muezzinCommitment,
    // this.muezzinOffWork,
    // this.muezzinPermissionPrayer,
    // this.muezzinLeaveFromDate,
    // this.muezzinLeaveToDate,
    // this.muezzinOffWorkDate,
    // this.muezzinNotes,
    // this.khademPresent,
    // this.mansoobNotes,
    // this.khademNotes,
    // this.khademIds,
    // this.khademIdsArray,
    // this.qualityOfWork,
    // this.cleanMaintenanceMosque,
    // this.organizedAndArranged,
    // this.takecareProperty,
    // this.khademLeaveFromDate,
    // this.khademLeaveToDate,
    // this.khademPermissionPrayer,
    // this.khademOffWork,
    // this.khademOffWorkDate,
    this.displayButtonAccept,
    this.displayButtonAction,
    this.displayButtonUnderprogress,

  });

  //region for methods
  void onChangeElectricMeterViolation(){
    if(electricMeterViolation=='no'){
        violationElectricMeterIds=null;
        violationElectricMeterAttachment=null;
        caseInfringementElecMeter=null;
    }
  }

  void onChangeWaterMeterViolation(){
    if(waterMeterViolation=='no'){
       violationWaterMeterIds=null;
       violationWaterMeterAttachment=null;
       caseInfringementWaterMeter=null;
    }
  }

  void onChangeViolationWaterMeterIds(ComboItem val, bool isNew) {
    if (isNew) {
      violationWaterMeterIds ??= [];
      if (!violationWaterMeterIds!.contains(val.key)) {
        violationWaterMeterIds!.add(val.key);
      }
    } else {
      violationWaterMeterIds?.removeWhere((key) => key == val.key);
    }
  }

  void onChangeIsEncroachmentBuilding(String val) {
    isEncroachmentBuilding = val;

    if (val == 'no') {
      encroachmentBuildingAttachment = null;
      caseEncroachmentBuilding = null;
    }
  }

  void onChangeIsEncroachmentVacantLand(String val) {
    isEncroachmentVacantLand = val;

    if (val == 'no') {
      encroachmentVacantAttachment = null;
      caseEncroachmentVacantLand = null;
    }
  }

  void onChangeIsViolationBuilding(String val) {
    isViolationBuilding = val;

    if (val == 'no') {
      caseViolationBuilding = null;
      violationBuildingAttachment = null;
    }
  }

  void onChangeHasReligiousActivity(){
    hasTayseerPermission = null;
    activityTitle = null;
    activityDetails = null;
    onChangeReadAllowedBook(null);
    onChangeHasTayseerPermission();
  }
  void onChangeReadAllowedBook(val){
    readAllowedBook = val;
    otherBookName = null;
    bookNameId = null;
  }

  void onChangeHasTayseerPermission(){
    tayseerPermissionNumber = null;
    dobPreacher = null;
    genderPreacher = null;
    phonePreacher = null;
    preacherIdentificationId = null;
    yaqeenStatus = null;
  }


  bool isRequired(String field) {
    return  (noRequiredField[field] == true)==false;
    // return false ;//|| (noRequiredField[field] == true)==false;
  }
  bool isEscalationField(String field) {
    try{
      final value = toJson()[field];
      if (value == null) return false;

      final config = escalatingConfig[field];
      if (config == null) return false;

      if (config is Map<String, dynamic>) {
        if (config.containsKey("include")) {
          final inc = config["include"];
          if (inc is List) return inc.contains(value);
          return inc == value;
        }
        if (config.containsKey("exclude")) {
          final exc = config["exclude"];
          if (exc is List) return !exc.contains(value);
          return value != exc;
        }
      }

      // fallback: simple equality check (for backward compatibility)
      return config == value;
    }catch(e){
      return false;
    }

  }







  factory VisitModel.fromInitializeVisitJson(Map<String, dynamic> result) {

    final waterMeterIdsLocal = ((result['mosque_water_meter_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    final electricMeterIdsLocal = ((result['mosque_electric_meter_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    final maintenanceContractorIdsLocal = ((result['mosque_maintenance_contract'] ?? []) as List)
        .map((item) => ComboItem.fromJsonContractor(item))
        .toList();
    return VisitModel(
      waterMeterIdsArray: waterMeterIdsLocal,
      electricMeterIdsArray: electricMeterIdsLocal,
      maintenanceContractorIdsArray: maintenanceContractorIdsLocal,
      latitude: JsonUtils.toDouble(result['mosque_latitude']),
      longitude: JsonUtils.toDouble(result['mosque_longitude']),
      cityId: JsonUtils.toInt(result['city_id']),
      hasWaterMeter: waterMeterIdsLocal.isEmpty?'notapplicable':'applicable',
      hasElectricMeter: electricMeterIdsLocal.isEmpty?'notapplicable':'applicable',
      hasMaintenanceContractor: maintenanceContractorIdsLocal.isEmpty?'notapplicable':'applicable',
    );
  }

  void initializeFields(covariant VisitModel base) {
    waterMeterIdsArray = base.waterMeterIdsArray;
    electricMeterIdsArray = base.electricMeterIdsArray;
    maintenanceContractorIdsArray = base.maintenanceContractorIdsArray;
    latitude = base.latitude;
    longitude = base.longitude;
    cityId = base.cityId;
    hasWaterMeter = base.hasWaterMeter;
    hasElectricMeter = base.hasElectricMeter;
    hasMaintenanceContractor = base.hasMaintenanceContractor;
    dataVerified = base.dataVerified;
  }

  void mergeJson(dynamic json){
    visitWorkFlow= ((json['workflow'] ?? []) as List)
        .map((item) => VisitWorkflow.fromJson(item))
        .toList();
    actionNotes= JsonUtils.toText(json['action_notes'])?? actionNotes;
    actionAttachment= JsonUtils.toText(json['action_attachment'])?? actionAttachment;
    actionTakenType= JsonUtils.getName(json['action_taken_type_id'])?? actionTakenType;
    trasolNumber= JsonUtils.toText(json['trasol_number'])?? trasolNumber;
    actionAttachments= JsonUtils.toList(json['action_attachments']).length>0?JsonUtils.toList(json['action_attachments']):actionAttachments;
    displayButtonUnderprogress = JsonUtils.toBoolean(json['display_button_underprogress']) ?? displayButtonUnderprogress;
    displayButtonAccept = JsonUtils.toBoolean(json['display_button_accept']) ?? displayButtonAccept;
    displayButtonAction = JsonUtils.toBoolean(json['display_button_action']) ?? displayButtonAction;
    stage = JsonUtils.getName(json['stage']) ?? stage;
    stageId = JsonUtils.getId(json['stage']) ?? stageId;
    priorityValue = JsonUtils.toText(json['priority_value']) ?? priorityValue;
    readAllowedBook = JsonUtils.toText(json['read_allowed_books']) ?? readAllowedBook;
    bookNameId = JsonUtils.getObjectId(json['book_name_id']) ?? bookNameId;
    bookName = JsonUtils.getObjectName(json['book_name_id']) ?? bookName;
    otherBookName = JsonUtils.toText(json['other_book_name']) ?? otherBookName;
    mosque = JsonUtils.toText(json['mosque_id']) ?? mosque;
    name = JsonUtils.toText(json['visit_id']) ?? name;
    employeeId = JsonUtils.getObjectId(json['employee_id']) ?? employeeId;
    employee = JsonUtils.getObjectName(json['employee_id']) ?? employee;
    dateOfVisit = JsonUtils.toText(json['date_of_visit']) ?? dateOfVisit;
    btnStart = JsonUtils.toBoolean(json['btn_start']) ?? btnStart;
    startDatetime = JsonUtils.toText(json['start_datetime']) ?? startDatetime;
    submitDatetime = JsonUtils.toText(json['submit_datetime']) ?? submitDatetime;
    prayerName = JsonUtils.toText(json['prayer_name']) ?? prayerName;
    outerDevices = JsonUtils.toText(json['outer_devices']) ?? outerDevices;
    innerDevices = JsonUtils.toText(json['inner_devices']) ?? innerDevices;
    innerAudioDevices = JsonUtils.toText(json['inner_audio_devices']) ?? innerAudioDevices;
    speakerOnPrayer = JsonUtils.toText(json['speaker_on_prayer']) ?? speakerOnPrayer;
    outerAudioDevices = JsonUtils.toText(json['outer_audio_devices']) ?? outerAudioDevices;
    lightening = JsonUtils.toText(json['lightening']) ?? lightening;
    airCondition = JsonUtils.toText(json['air_condition']) ?? airCondition;
    electicityPerformance = JsonUtils.toText(json['electicity_performance']) ?? electicityPerformance;
    isEncroachmentBuilding = JsonUtils.toText(json['is_encroachment_building']) ?? isEncroachmentBuilding;
    encroachmentBuildingAttachment = JsonUtils.toText(json['encroachment_building_attachment']) ?? encroachmentBuildingAttachment;
    caseEncroachmentBuilding = JsonUtils.toText(json['case_encroachment_building']) ?? caseEncroachmentBuilding;
    isEncroachmentVacantLand = JsonUtils.toText(json['is_encroachment_vacant_land']) ?? isEncroachmentVacantLand;
    encroachmentVacantAttachment = JsonUtils.toText(json['encroachment_vacant_attachment']) ?? encroachmentVacantAttachment;
    caseEncroachmentVacantLand = JsonUtils.toText(json['case_encroachment_vacant_land']) ?? caseEncroachmentVacantLand;
    violationBuildingAttachment = JsonUtils.toText(json['violation_building_attachment']) ?? violationBuildingAttachment;
    isViolationBuilding = JsonUtils.toText(json['is_violation_building']) ?? isViolationBuilding;
    caseViolationBuilding = JsonUtils.toText(json['case_violation_building']) ?? caseViolationBuilding;
    buildingNotes = JsonUtils.toText(json['building_notes']) ?? buildingNotes;
    meterNotes = JsonUtils.toText(json['meter_notes']) ?? meterNotes;
    deviceNotes = JsonUtils.toText(json['device_notes']) ?? deviceNotes;
    safteyStandardNotes = JsonUtils.toText(json['saftey_standard_notes']) ?? safteyStandardNotes;
    cleanMaintenanceNotes = JsonUtils.toText(json['clean_maintenance_notes']) ?? cleanMaintenanceNotes;
    securityViolationNotes = JsonUtils.toText(json['security_violation_notes']) ?? securityViolationNotes;
    dawahActivitiesNotes = JsonUtils.toText(json['dawah_activities_notes']) ?? dawahActivitiesNotes;
    mosqueStatusNotes = JsonUtils.toText(json['mosque_status_notes']) ?? mosqueStatusNotes;
    quranShelvesStorage = JsonUtils.toText(json['quran_shelves_storage']) ?? quranShelvesStorage;
    carpetsAndFlooring = JsonUtils.toText(json['carpets_and_flooring']) ?? carpetsAndFlooring;
    prayerAreaCleanliness = JsonUtils.toText(json['prayer_area_cleanliness']) ?? prayerAreaCleanliness;
    mosqueCourtyards = JsonUtils.toText(json['mosque_courtyards']) ?? mosqueCourtyards;
    mosqueEntrances = JsonUtils.toText(json['mosque_entrances']) ?? mosqueEntrances;
    ablutionAreas = JsonUtils.toText(json['ablution_areas']) ?? ablutionAreas;
    windowsDoorsWalls = JsonUtils.toText(json['windows_doors_walls']) ?? windowsDoorsWalls;
    storageRooms = JsonUtils.toText(json['storage_rooms']) ?? storageRooms;
    mosqueCarpetQuality = JsonUtils.toText(json['mosque_carpet_quality']) ?? mosqueCarpetQuality;
    toilets = JsonUtils.toText(json['toilets']) ?? toilets;
    maintenanceExecution = JsonUtils.toText(json['maintenance_execution']) ?? maintenanceExecution;
    maintenanceResponseSpeed = JsonUtils.toText(json['maintenance_response_speed']) ?? maintenanceResponseSpeed;
    hasMaintenanceContractor = JsonUtils.toText(json['has_maintenance_contractor']) ?? hasMaintenanceContractor;
    maintenanceContractorIdsArray = json['maintenance_contractor_ids'] == null
        ? maintenanceContractorIdsArray
        : (json['maintenance_contractor_ids'] as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();
    mosqueAddressStatus = JsonUtils.toText(json['mosque_address_status']) ?? mosqueAddressStatus;
    geolocationStatus = JsonUtils.toText(json['geolocation_status']) ?? geolocationStatus;
    mosqueDetailsStatus = JsonUtils.toText(json['mosque_details_status']) ?? mosqueDetailsStatus;
    mosqueImagesStatus = JsonUtils.toText(json['mosque_images_status']) ?? mosqueImagesStatus;
    maintenanceContractStatus = JsonUtils.toText(json['maintenance_contract_status']) ?? maintenanceContractStatus;
    buildingDetailsStatus = JsonUtils.toText(json['building_details_status']) ?? buildingDetailsStatus;
    imamResidenceStatus = JsonUtils.toText(json['imam_residence_status']) ?? imamResidenceStatus;
    prayerAreaStatus = JsonUtils.toText(json['prayer_area_status']) ?? prayerAreaStatus;
    humanResourcesStatus = JsonUtils.toText(json['human_resources_status']) ?? humanResourcesStatus;
    hasReligiousActivity = JsonUtils.toText(json['has_religious_activity']) ?? hasReligiousActivity;
    activityType = JsonUtils.toText(json['activity_type']) ?? activityType;
    hasTayseerPermission = JsonUtils.toText(json['has_tayseer_permission']) ?? hasTayseerPermission;
    tayseerPermissionNumber = JsonUtils.toText(json['tayseer_permission_number']) ?? tayseerPermissionNumber;
    activityTitle = JsonUtils.toText(json['activity_title']) ?? activityTitle;
    activityDetails = JsonUtils.toText(json['activity_details']) ?? activityDetails;
    yaqeenStatus = JsonUtils.toText(json['yaqeen_status']) ?? yaqeenStatus;
    preacherIdentificationId = JsonUtils.toText(json['preacher_identification_id']) ?? preacherIdentificationId;
    phonePreacher = JsonUtils.toText(json['phone_preacher']) ?? phonePreacher;
    genderPreacher = JsonUtils.toText(json['gender_preacher']) ?? genderPreacher;
    dobPreacher = JsonUtils.toText(json['dob_preacher']) ?? dobPreacher;
    securityViolationType = JsonUtils.toText(json['security_violation_type']) ?? securityViolationType;
    adminViolationType = JsonUtils.toText(json['admin_violation_type']) ?? adminViolationType;
    operationalViolationType = JsonUtils.toText(json['operational_violation_type']) ?? operationalViolationType;
    unauthorizedPublications = JsonUtils.toText(json['unauthorized_publications']) ?? unauthorizedPublications;
    publicationSource = JsonUtils.toText(json['publication_source']) ?? publicationSource;
    religiousSocialViolationType = JsonUtils.toText(json['religious_social_violation_type']) ?? religiousSocialViolationType;
    unauthorizedQuranPresence = JsonUtils.toText(json['unauthorized_quran_presence']) ?? unauthorizedQuranPresence;
    architecturalStructure = JsonUtils.toText(json['architectural_structure']) ?? architecturalStructure;
    electricalInstallations = JsonUtils.toText(json['electrical_installations']) ?? electricalInstallations;
    ablutionAndToilets = JsonUtils.toText(json['ablution_and_toilets']) ?? ablutionAndToilets;
    ventilationAndAirQuality = JsonUtils.toText(json['ventilation_and_air_quality']) ?? ventilationAndAirQuality;
    equipmentAndFurnitureSafety = JsonUtils.toText(json['equipment_and_furniture_safety']) ?? equipmentAndFurnitureSafety;
    doorsAndLocks = JsonUtils.toText(json['doors_and_locks']) ?? doorsAndLocks;
    waterTankCovers = JsonUtils.toText(json['water_tank_covers']) ?? waterTankCovers;
    mosqueEntrancesSecurity = JsonUtils.toText(json['mosque_entrances_security']) ?? mosqueEntrancesSecurity;
    fireExtinguishers = JsonUtils.toText(json['fire_extinguishers']) ?? fireExtinguishers;
    fireAlarms = JsonUtils.toText(json['fire_alarms']) ?? fireAlarms;
    firstAidKits = JsonUtils.toText(json['first_aid_kits']) ?? firstAidKits;
    emergencyExits = JsonUtils.toText(json['emergency_exits']) ?? emergencyExits;
    hasElectricMeter = JsonUtils.toText(json['has_electric_meter']) ?? hasElectricMeter;
    electricMeterDataUpdated = JsonUtils.toText(json['electric_meter_data_updated']) ?? electricMeterDataUpdated;
    electricMeterIdsArray = json['mosque_electric_meter_ids'] == null
        ? electricMeterIdsArray
        : (json['mosque_electric_meter_ids'] as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();
    electricMeterViolation = JsonUtils.toText(json['electric_meter_violation']) ?? electricMeterViolation;
    violationElectricMeterIdsArray = json['violation_electric_meter_ids'] == null
        ? violationElectricMeterIdsArray
        : (json['violation_electric_meter_ids'] as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();
    violationElectricMeterAttachment = JsonUtils.toText(json['violation_electric_meter_attachment']) ?? violationElectricMeterAttachment;
    caseInfringementElecMeter = JsonUtils.toText(json['case_infringement_elec_meter']) ?? caseInfringementElecMeter;
    hasWaterMeter = JsonUtils.toText(json['has_water_meter']) ?? hasWaterMeter;
    waterMeterIdsArray = json['mosque_water_meter_ids'] == null
        ? waterMeterIdsArray
        : (json['mosque_water_meter_ids'] as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();
    waterMeterDataUpdated = JsonUtils.toText(json['water_meter_data_updated']) ?? waterMeterDataUpdated;
    caseInfringementWaterMeter = JsonUtils.toText(json['case_infringement_water_meter']) ?? caseInfringementWaterMeter;
    waterMeterViolation = JsonUtils.toText(json['water_meter_violation']) ?? waterMeterViolation;
    violationWaterMeterAttachment = JsonUtils.toText(json['violation_water_meter_attachment']) ?? violationWaterMeterAttachment;
    violationWaterMeterIdsArray = json['violation_water_meter_ids'] == null
        ? violationWaterMeterIdsArray
        : (json['violation_water_meter_ids'] as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();

  }

  // factory VisitModel.fromJsonReadMerge(VisitModel existing, dynamic json) {
  //   return VisitModel(
  //     name: JsonUtils.toText(json['name']) ?? existing.name,
  //     employee:json['employee_id']==null? existing.employee:ComboItem.fromJsonObject(json['employee_id']),
  //     dateOfVisit: JsonUtils.toText(json['date_of_visit']) ?? existing.dateOfVisit,
  //     btnStart: JsonUtils.toBoolean(json['btn_start']) ?? existing.btnStart,
  //     startDatetime: JsonUtils.toText(json['start_datetime']) ?? existing.startDatetime,
  //     submitDatetime: JsonUtils.toText(json['submit_datetime']) ?? existing.submitDatetime,
  //     prayerName: JsonUtils.toText(json['prayer_name']) ?? existing.prayerName,
  //     outerDevices: JsonUtils.toText(json['outer_devices']) ?? existing.outerDevices,
  //     innerDevices: JsonUtils.toText(json['inner_devices']) ?? existing.innerDevices,
  //     innerAudioDevices: JsonUtils.toText(json['inner_audio_devices']) ?? existing.innerAudioDevices,
  //     speakerOnPrayer: JsonUtils.toText(json['speaker_on_prayer']) ?? existing.speakerOnPrayer,
  //     outerAudioDevices: JsonUtils.toText(json['outer_audio_devices']) ?? existing.outerAudioDevices,
  //     lightening: JsonUtils.toText(json['lightening']) ?? existing.lightening,
  //     airCondition: JsonUtils.toText(json['air_condition']) ?? existing.airCondition,
  //     electicityPerformance: JsonUtils.toText(json['electicity_performance']) ?? existing.electicityPerformance,
  //     isEncroachmentBuilding: JsonUtils.toText(json['is_encroachment_building']) ?? existing.isEncroachmentBuilding,
  //     encroachmentBuildingAttachment: JsonUtils.toText(json['encroachment_building_attachment']) ?? existing.encroachmentBuildingAttachment,
  //     caseEncroachmentBuilding: JsonUtils.toText(json['case_encroachment_building']) ?? existing.caseEncroachmentBuilding,
  //     isEncroachmentVacantLand: JsonUtils.toText(json['is_encroachment_vacant_land']) ?? existing.isEncroachmentVacantLand,
  //     encroachmentVacantAttachment: JsonUtils.toText(json['encroachment_vacant_attachment']) ?? existing.encroachmentVacantAttachment,
  //     caseEncroachmentVacantLand: JsonUtils.toText(json['case_encroachment_vacant_land']) ?? existing.caseEncroachmentVacantLand,
  //     violationBuildingAttachment: JsonUtils.toText(json['violation_building_attachment']) ?? existing.violationBuildingAttachment,
  //     isViolationBuilding: JsonUtils.toText(json['is_violation_building']) ?? existing.isViolationBuilding,
  //     caseViolationBuilding: JsonUtils.toText(json['case_violation_building']) ?? existing.caseViolationBuilding,
  //     buildingNotes: JsonUtils.toText(json['building_notes']) ?? existing.buildingNotes,
  //     meterNotes: JsonUtils.toText(json['meter_notes']) ?? existing.meterNotes,
  //     deviceNotes: JsonUtils.toText(json['device_notes']) ?? existing.deviceNotes,
  //     safteyStandardNotes: JsonUtils.toText(json['saftey_standard_notes']) ?? existing.safteyStandardNotes,
  //     cleanMaintenanceNotes: JsonUtils.toText(json['clean_maintenance_notes']) ?? existing.cleanMaintenanceNotes,
  //     securityViolationNotes: JsonUtils.toText(json['security_violation_notes']) ?? existing.securityViolationNotes,
  //     dawahActivitiesNotes: JsonUtils.toText(json['dawah_activities_notes']) ?? existing.dawahActivitiesNotes,
  //     mosqueStatusNotes: JsonUtils.toText(json['mosque_status_notes']) ?? existing.mosqueStatusNotes,
  //     // buildingNotes: JsonUtils.toText(json['building_notes']) ?? existing.buildingNotes,
  //     quranShelvesStorage: JsonUtils.toText(json['quran_shelves_storage']) ?? existing.quranShelvesStorage,
  //     carpetsAndFlooring: JsonUtils.toText(json['carpets_and_flooring']) ?? existing.carpetsAndFlooring,
  //     prayerAreaCleanliness: JsonUtils.toText(json['prayer_area_cleanliness']) ?? existing.prayerAreaCleanliness,
  //     mosqueCourtyards: JsonUtils.toText(json['mosque_courtyards']) ?? existing.mosqueCourtyards,
  //     mosqueEntrances: JsonUtils.toText(json['mosque_entrances']) ?? existing.mosqueEntrances,
  //     ablutionAreas: JsonUtils.toText(json['ablution_areas']) ?? existing.ablutionAreas,
  //     windowsDoorsWalls: JsonUtils.toText(json['windows_doors_walls']) ?? existing.windowsDoorsWalls,
  //     storageRooms: JsonUtils.toText(json['storage_rooms']) ?? existing.storageRooms,
  //     mosqueCarpetQuality: JsonUtils.toText(json['mosque_carpet_quality']) ?? existing.mosqueCarpetQuality,
  //     toilets: JsonUtils.toText(json['toilets']) ?? existing.toilets,
  //     maintenanceExecution: JsonUtils.toText(json['maintenance_execution']) ?? existing.maintenanceExecution,
  //     maintenanceResponseSpeed: JsonUtils.toText(json['maintenance_response_speed']) ?? existing.maintenanceResponseSpeed,
  //     hasMaintenanceContractor: JsonUtils.toText(json['has_maintenance_contractor']) ?? existing.hasMaintenanceContractor,
  //     //maintenanceContractorIds: JsonUtils.toList(json['maintenance_contractor_ids']) ?? existing.maintenanceContractorIds,
  //     maintenanceContractorIdsArray:json['maintenance_contractor_ids']==null? existing.maintenanceContractorIdsArray : (json['maintenance_contractor_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList() ,
  //     mosqueAddressStatus: JsonUtils.toText(json['mosque_address_status']) ?? existing.mosqueAddressStatus,
  //     geolocationStatus: JsonUtils.toText(json['geolocation_status']) ?? existing.geolocationStatus,
  //     mosqueDetailsStatus: JsonUtils.toText(json['mosque_details_status']) ?? existing.mosqueDetailsStatus,
  //     mosqueImagesStatus: JsonUtils.toText(json['mosque_images_status']) ?? existing.mosqueImagesStatus,
  //     maintenanceContractStatus: JsonUtils.toText(json['maintenance_contract_status']) ?? existing.maintenanceContractStatus,
  //     buildingDetailsStatus: JsonUtils.toText(json['building_details_status']) ?? existing.buildingDetailsStatus,
  //     imamResidenceStatus: JsonUtils.toText(json['imam_residence_status']) ?? existing.imamResidenceStatus,
  //     prayerAreaStatus: JsonUtils.toText(json['prayer_area_status']) ?? existing.prayerAreaStatus,
  //     humanResourcesStatus: JsonUtils.toText(json['human_resources_status']) ?? existing.humanResourcesStatus,
  //     hasReligiousActivity: JsonUtils.toText(json['has_religious_activity']) ?? existing.hasReligiousActivity,
  //     activityType: JsonUtils.toText(json['activity_type']) ?? existing.activityType,
  //     hasTayseerPermission: JsonUtils.toText(json['has_tayseer_permission']) ?? existing.hasTayseerPermission,
  //     tayseerPermissionNumber: JsonUtils.toText(json['tayseer_permission_number']) ?? existing.tayseerPermissionNumber,
  //     activityTitle: JsonUtils.toText(json['activity_title']) ?? existing.activityTitle,
  //     activityDetails: JsonUtils.toText(json['activity_details']) ?? existing.activityDetails,
  //     yaqeenStatus: JsonUtils.toText(json['yaqeen_status']) ?? existing.yaqeenStatus,
  //     preacherIdentificationId: JsonUtils.toText(json['preacher_identification_id']) ?? existing.preacherIdentificationId,
  //     phonePreacher: JsonUtils.toText(json['phone_preacher'])?? existing.phonePreacher,
  //     genderPreacher: JsonUtils.toText(json['gender_preacher'])?? existing.genderPreacher,
  //     dobPreacher: JsonUtils.toText(json['dob_preacher'])?? existing.dobPreacher,
  //     securityViolationType: JsonUtils.toText(json['security_violation_type']) ?? existing.securityViolationType,
  //     adminViolationType: JsonUtils.toText(json['admin_violation_type']) ?? existing.adminViolationType,
  //     operationalViolationType: JsonUtils.toText(json['operational_violation_type']) ?? existing.operationalViolationType,
  //     unauthorizedPublications: JsonUtils.toText(json['unauthorized_publications']) ?? existing.unauthorizedPublications,
  //     publicationSource: JsonUtils.toText(json['publication_source']) ?? existing.publicationSource,
  //     religiousSocialViolationType: JsonUtils.toText(json['religious_social_violation_type']) ?? existing.religiousSocialViolationType,
  //     unauthorizedQuranPresence: JsonUtils.toText(json['unauthorized_quran_presence']) ?? existing.unauthorizedQuranPresence,
  //     architecturalStructure: JsonUtils.toText(json['architectural_structure']) ?? existing.architecturalStructure,
  //     electricalInstallations: JsonUtils.toText(json['electrical_installations']) ?? existing.electricalInstallations,
  //     ablutionAndToilets: JsonUtils.toText(json['ablution_and_toilets']) ?? existing.ablutionAndToilets,
  //     ventilationAndAirQuality: JsonUtils.toText(json['ventilation_and_air_quality']) ?? existing.ventilationAndAirQuality,
  //     equipmentAndFurnitureSafety: JsonUtils.toText(json['equipment_and_furniture_safety']) ?? existing.equipmentAndFurnitureSafety,
  //     doorsAndLocks: JsonUtils.toText(json['doors_and_locks']) ?? existing.doorsAndLocks,
  //     waterTankCovers: JsonUtils.toText(json['water_tank_covers']) ?? existing.waterTankCovers,
  //     mosqueEntrancesSecurity: JsonUtils.toText(json['mosque_entrances_security']) ?? existing.mosqueEntrancesSecurity,
  //     fireExtinguishers: JsonUtils.toText(json['fire_extinguishers']) ?? existing.fireExtinguishers,
  //     fireAlarms: JsonUtils.toText(json['fire_alarms']) ?? existing.fireAlarms,
  //     firstAidKits: JsonUtils.toText(json['first_aid_kits']) ?? existing.firstAidKits,
  //     emergencyExits: JsonUtils.toText(json['emergency_exits']) ?? existing.emergencyExits,
  //     hasElectricMeter: JsonUtils.toText(json['has_electric_meter']) ?? existing.hasElectricMeter,
  //     electricMeterDataUpdated: JsonUtils.toText(json['electric_meter_data_updated']) ?? existing.electricMeterDataUpdated,
  //     // electricMeterIds: JsonUtils.toList(json['electric_meter_ids']) ?? existing.electricMeterIds,
  //     // : JsonUtils.toList(json['']) ?? existing.electricMeterIds,
  //     electricMeterIdsArray:json['mosque_electric_meter_ids']==null? existing.electricMeterIdsArray : (json['mosque_electric_meter_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList() ,
  //     electricMeterViolation: JsonUtils.toText(json['electric_meter_violation']) ?? existing.electricMeterViolation,
  //     // violationElectricMeterIds: JsonUtils.toList(json['violation_electric_meter_ids']) ?? existing.violationElectricMeterIds,
  //     violationElectricMeterIdsArray:json['violation_electric_meter_ids']==null? existing.violationElectricMeterIdsArray : (json['violation_electric_meter_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList() ,
  //     violationElectricMeterAttachment: JsonUtils.toText(json['violation_electric_meter_attachment']) ?? existing.violationElectricMeterAttachment,
  //     caseInfringementElecMeter: JsonUtils.toText(json['case_infringement_elec_meter']) ?? existing.caseInfringementElecMeter,
  //     hasWaterMeter: JsonUtils.toText(json['has_water_meter']) ?? existing.hasWaterMeter,
  //     // waterMeterIds: JsonUtils.toText(json['water_meter_ids']) ?? existing.waterMeterIds,
  //     waterMeterIdsArray:json['mosque_water_meter_ids']==null? existing.waterMeterIdsArray : (json['mosque_water_meter_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList() ,
  //     waterMeterDataUpdated: JsonUtils.toText(json['water_meter_data_updated']) ?? existing.waterMeterDataUpdated,
  //     caseInfringementWaterMeter: JsonUtils.toText(json['case_infringement_water_meter']) ?? existing.caseInfringementWaterMeter,
  //     waterMeterViolation: JsonUtils.toText(json['water_meter_violation']) ?? existing.waterMeterViolation,
  //     violationWaterMeterAttachment: JsonUtils.toText(json['violation_water_meter_attachment']) ?? existing.violationWaterMeterAttachment,
  //     // violationWaterMeterIds: JsonUtils.toList(json['violation_water_meter_ids']) ?? existing.violationWaterMeterIds,
  //     violationWaterMeterIdsArray:json['violation_water_meter_ids']==null? existing.violationWaterMeterIdsArray : (json['violation_water_meter_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList() ,
  //
  //
  //
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {

      'btn_start': btnStart,
      'date_of_visit': dateOfVisit,
      'start_datetime': startDatetime,
      'submit_datetime': submitDatetime,
      // 'last_updated_from': lastUpdatedFrom,
      'prayer_name': prayerName,
      'outer_devices': outerDevices,
      'inner_devices': innerDevices,
      'inner_audio_devices': innerAudioDevices,
      'speaker_on_prayer': speakerOnPrayer,
      'outer_audio_devices': outerAudioDevices,
      'lightening': lightening,
      'air_condition': airCondition,
      'electicity_performance': electicityPerformance,
      'is_encroachment_building': isEncroachmentBuilding,
      'encroachment_building_attachment': encroachmentBuildingAttachment,
      'case_encroachment_building': caseEncroachmentBuilding,
      'is_encroachment_vacant_land': isEncroachmentVacantLand,
      'encroachment_vacant_attachment': encroachmentVacantAttachment,
      'case_encroachment_vacant_land': caseEncroachmentVacantLand,
      'violation_building_attachment': violationBuildingAttachment,
      'is_violation_building': isViolationBuilding,
      'case_violation_building': caseViolationBuilding,
      'building_notes': buildingNotes,
      'meter_notes': meterNotes,
      'device_notes': deviceNotes,
      'saftey_standard_notes': safteyStandardNotes,
      'clean_maintenance_notes': cleanMaintenanceNotes,
      'security_violation_notes': securityViolationNotes,
      'dawah_activities_notes': dawahActivitiesNotes,
      'mosque_status_notes': mosqueStatusNotes,

      // Maintenance
      'quran_shelves_storage': quranShelvesStorage,
      'carpets_and_flooring': carpetsAndFlooring,
      'prayer_area_cleanliness': prayerAreaCleanliness,
      'mosque_courtyards': mosqueCourtyards,
      'mosque_entrances': mosqueEntrances,
      'ablution_areas': ablutionAreas,
      'windows_doors_walls': windowsDoorsWalls,
      'storage_rooms': storageRooms,
      'mosque_carpet_quality': mosqueCarpetQuality,
      'toilets': toilets,
      'maintenance_execution': maintenanceExecution,
      'maintenance_response_speed': maintenanceResponseSpeed,
      'has_maintenance_contractor': hasMaintenanceContractor,
      'maintenance_contractor_ids': maintenanceContractorIds,

      // Mosque Status
      'mosque_address_status': mosqueAddressStatus,
      'geolocation_status': geolocationStatus,
      'mosque_details_status': mosqueDetailsStatus,
      'mosque_images_status': mosqueImagesStatus,
      'maintenance_contract_status': maintenanceContractStatus,
      'building_details_status': buildingDetailsStatus,
      'imam_residence_status': imamResidenceStatus,
      'prayer_area_status': prayerAreaStatus,
      'human_resources_status': humanResourcesStatus,

      // Dawah Activity
      'has_religious_activity': hasReligiousActivity,
      'activity_type': activityType,
      'read_allowed_books': readAllowedBook,
      'book_name_id': bookNameId,
      'other_book_name': otherBookName,
      'has_tayseer_permission': hasTayseerPermission,
      'tayseer_permission_number': tayseerPermissionNumber,
      'activity_title': activityTitle,
      'activity_details': activityDetails,
      'yaqeen_status': yaqeenStatus,
      'preacher_identification_id': preacherIdentificationId,
      'phone_preacher': phonePreacher,
      'gender_preacher': genderPreacher,
      'dob_preacher': dobPreacher,
      // Security
      'security_violation_type': securityViolationType,
      'admin_violation_type': adminViolationType,
      'operational_violation_type': operationalViolationType,
      'unauthorized_publications': unauthorizedPublications,
      'publication_source': publicationSource,
      'religious_social_violation_type': religiousSocialViolationType,
      'unauthorized_quran_presence': unauthorizedQuranPresence,

      // Safety
      'architectural_structure': architecturalStructure,
      'electrical_installations': electricalInstallations,
      'ablution_and_toilets': ablutionAndToilets,
      'ventilation_and_air_quality': ventilationAndAirQuality,
      'equipment_and_furniture_safety': equipmentAndFurnitureSafety,
      'doors_and_locks': doorsAndLocks,
      'water_tank_covers': waterTankCovers,
      'mosque_entrances_security': mosqueEntrancesSecurity,
      'fire_extinguishers': fireExtinguishers,
      'fire_alarms': fireAlarms,
      'first_aid_kits': firstAidKits,
      'emergency_exits': emergencyExits,

      // Meter
      'has_electric_meter': hasElectricMeter,
      'electric_meter_data_updated': electricMeterDataUpdated,
      'electric_meter_ids': electricMeterIds,
      'electric_meter_violation': electricMeterViolation,
      'violation_electric_meter_ids': violationElectricMeterIds,
      'violation_electric_meter_attachment': violationElectricMeterAttachment,
      'case_infringement_elec_meter': caseInfringementElecMeter,
      'has_water_meter': hasWaterMeter,
      'water_meter_data_updated': waterMeterDataUpdated,
      'case_infringement_water_meter': caseInfringementWaterMeter,
      'water_meter_violation': waterMeterViolation,
      'violation_water_meter_attachment': violationWaterMeterAttachment,
      'violation_water_meter_ids': violationWaterMeterIds,

      // // Mansoob

      //



    };


  }

  void onVisitStart(dynamic pramPrayerName){
    startDatetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
    prayerName = pramPrayerName??prayerName;
    btnStart = true;
    dateOfVisit = DateFormat('yyyy-MM-dd').format(DateTime.now()); //
  }

 //endregion

}

