import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/models/mansoob_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_workflow.dart';
part 'visit_land_model.g.dart';
//
@HiveType(typeId: HiveTypeIds.visitLandModel)
class VisitLandModel extends VisitModelBase  {

  //region for hive field
  @HiveField(1)
  int? id;

  @HiveField(2)
  String? state;

  @HiveField(3)
  String? stage; // Could be changed to List<int, String> with custom type

  @HiveField(4)
  int? stageId;

  @HiveField(5)
  bool? btnStart;

  @HiveField(6)
  String? name;

  @HiveField(7)
  int? landId;

  @HiveField(8)
  String? land;

  @HiveField(9)
  int? employeeId;

  @HiveField(10)
  String? employee;

  @HiveField(11)
  String? dateOfVisit;

  @HiveField(12)
  String? priorityValue;

  @HiveField(13)
  String? landAddress;

  @HiveField(14)
  int? regionId;

  @HiveField(15)
  String? region;

  @HiveField(16)
  int? cityId;

  @HiveField(17)
  String? city;

  @HiveField(18)
  int? moiaCenterId;

  @HiveField(19)
  String? moiaCenter;

  @HiveField(20)
  double? latitude;

  @HiveField(21)
  double? longitude;

  @HiveField(22)
  String? landType;

  @HiveField(23)
  String? hasOwnershipSign;

  @HiveField(24)
  String? ownershipSignPhoto;

  @HiveField(25)
  String? easyAccess;

  @HiveField(26)
  String? pavedRoads;

  @HiveField(27)
  String? hasTemporaryBuildings;

  @HiveField(28)
  String? temporaryBuildingType;

  @HiveField(29)
  String? hasEncroachment;

  @HiveField(30)
  String? encroachmentType;

  @HiveField(31)
  String? encroachmentPhoto;

  @HiveField(32)
  String? hasElectricityMeter;

  @HiveField(33)
  String? electricityMeterNumber;

  @HiveField(34)
  String? hasMeterEncroachment;

  @HiveField(35)
  String? meterEncroachmentPhoto;

  @HiveField(36)
  String? hasTreesGrass;

  @HiveField(37)
  String? isFenced;

  @HiveField(38)
  String? hasWaterSwamps;

  @HiveField(39)
  String? hasSafetyHazards;

  @HiveField(40)
  String? isWasteFree;

  @HiveField(42)
  String? safetyHazardDescription;

  @HiveField(43)
  String? notes;

  @HiveField(44)
  String? landTypeNotes;

  @HiveField(45)
  String? tempBuildingNotes;

  @HiveField(46)
  String? electricityMetersNotes;

  @HiveField(47)
  String? environmentConditionalNotes;

  @HiveField(41)
  String? startDatetime;

  bool? dataVerified;

  String? actionNotes;

  // String? actionAttachment;

  String? actionTakenType;
  String? trasolNumber;
  List<int>? actionAttachments;

  String? submitDatetime;
  String? lastUpdatedFrom;
  String? lastUpdate;
  String? displayName;
  bool? displayButtonSend;
  bool? displayButtonAccept;
  bool? displayButtonRefuse;
  bool? displayButtonAction;
  bool? displayButtonUnderprogress;
  bool? underprogress;
  bool? actionTaken;
  bool? displayBtnStart;
  bool? isLoading;
  List<VisitWorkflow>? visitWorkFlow;

  //endregion

  //region for property

  String get uniqueId => submitDatetime.toString();

  String? get startDatetimeLocal => JsonUtils.toLocalDateTimeFormat(startDatetime);
  String? get submitDatetimeLocal => JsonUtils.toLocalDateTimeFormat(submitDatetime);
  String? get coordinates => (latitude==null && longitude==null)?'':'${latitude},${longitude}';

  String  get modelName =>  "land.visit";
  @override
  String? get listTitle => landAddress;
  @override
  String? get listSubTitle => name;
  //endregion

  VisitLandModel({
     this.id,
    this.landAddress,
    this.stage,
    this.stageId,
    this.name,
    this.landId,
    this.land,
    this.employeeId,
    this.employee,
    this.state,
    this.priorityValue,
    this.dataVerified=true
  });


  //region for methods
  bool  isStartVisitRights(dynamic loginEmpId){
    return VisitDefaults.draftStateValue==state && loginEmpId==employeeId;
  }

  VisitLandModel.shallowCopy(VisitLandModel other)
      : id = other.id,
        name = other.name,
        landAddress = other.landAddress,
        stage = other.stage,
        stageId = other.stageId,
        landId = other.landId,
        land = other.land,
        employeeId = other.employeeId,
        employee = other.employee,
        state = other.state,
        priorityValue = other.priorityValue
  ;

  void mergeJson(dynamic json) {
    visitWorkFlow= ((json['workflow'] ?? []) as List)
        .map((item) => VisitWorkflow.fromJson(item))
        .toList();
    actionNotes= JsonUtils.toText(json['action_notes'])?? actionNotes;
    // actionAttachment= JsonUtils.toText(json['action_attachment'])?? actionAttachment;
    trasolNumber= JsonUtils.toText(json['trasol_number'])?? trasolNumber;
    actionAttachments= JsonUtils.toList(json['action_attachments']).length>0?JsonUtils.toList(json['action_attachments']):actionAttachments;
    actionTakenType= JsonUtils.getName(json['action_taken_type_id'])?? actionTakenType;
    id = JsonUtils.toInt(json['id']) ?? id;
    state = JsonUtils.toText(json['state']) ?? state;
    stage = JsonUtils.getName(json['stage']) ?? stage;
    stageId = JsonUtils.getId(json['stage']) ?? stageId;
    btnStart = JsonUtils.toBoolean(json['btn_start']) ?? btnStart;
    name = JsonUtils.toText(json['name']) ?? name;
    // landId = JsonUtils.getObjectId(json['land_id']) ?? landId;
    land = JsonUtils.toText(json['land_id']) ?? land;
    employeeId = JsonUtils.getObjectId(json['employee_id']) ?? employeeId;
    employee = JsonUtils.getObjectName(json['employee_id']) ?? employee;
    dateOfVisit = JsonUtils.toText(json['date_of_visit']) ?? dateOfVisit;
    priorityValue = JsonUtils.toText(json['priority_value']) ?? priorityValue;
    landAddress = JsonUtils.toText(json['land_address']) ?? landAddress;
    regionId = JsonUtils.getObjectId(json['region_id']) ?? regionId;
    region = JsonUtils.getObjectName(json['region_id']) ?? region;
    cityId = JsonUtils.getObjectId(json['city_id']) ?? cityId;
    city = JsonUtils.getObjectName(json['city_id']) ?? city;
    moiaCenterId = JsonUtils.getObjectId(json['moia_center_id']) ?? moiaCenterId;
    moiaCenter = JsonUtils.getObjectName(json['moia_center_id']) ?? moiaCenter;
    latitude = JsonUtils.toDouble(json['latitude']) ?? latitude;
    longitude = JsonUtils.toDouble(json['longitude']) ?? longitude;
    landType = JsonUtils.toText(json['land_type']) ?? landType;
    hasOwnershipSign = JsonUtils.toText(json['has_ownership_sign']) ?? hasOwnershipSign;
    ownershipSignPhoto = JsonUtils.toText(json['ownership_sign_photo']) ?? ownershipSignPhoto;
    easyAccess = JsonUtils.toText(json['easy_access']) ?? easyAccess;
    pavedRoads = JsonUtils.toText(json['paved_roads']) ?? pavedRoads;
    hasTemporaryBuildings = JsonUtils.toText(json['has_temporary_buildings']) ?? hasTemporaryBuildings;
    temporaryBuildingType = JsonUtils.toText(json['temporary_building_type']) ?? temporaryBuildingType;
    hasEncroachment = JsonUtils.toText(json['has_encroachment']) ?? hasEncroachment;
    encroachmentType = JsonUtils.toText(json['encroachment_type']) ?? encroachmentType;
    encroachmentPhoto = JsonUtils.toText(json['encroachment_photo']) ?? encroachmentPhoto;
    hasElectricityMeter = JsonUtils.toText(json['has_electricity_meter']) ?? hasElectricityMeter;
    electricityMeterNumber = JsonUtils.toText(json['electricity_meter_number']) ?? electricityMeterNumber;
    hasMeterEncroachment = JsonUtils.toText(json['has_meter_encroachment']) ?? hasMeterEncroachment;
    meterEncroachmentPhoto = JsonUtils.toText(json['meter_encroachment_photo']) ?? meterEncroachmentPhoto;
    hasTreesGrass = JsonUtils.toText(json['has_trees_grass']) ?? hasTreesGrass;
    isFenced = JsonUtils.toText(json['is_fenced']) ?? isFenced;
    hasWaterSwamps = JsonUtils.toText(json['has_water_swamps']) ?? hasWaterSwamps;
    hasSafetyHazards = JsonUtils.toText(json['has_safety_hazards']) ?? hasSafetyHazards;
    isWasteFree = JsonUtils.toText(json['is_waste_free']) ?? isWasteFree;
    safetyHazardDescription = JsonUtils.toText(json['safety_hazard_description']) ?? safetyHazardDescription;
    // dataAccuracyPledge = JsonUtils.toText(json['data_accuracy_pledge']) ?? dataAccuracyPledge;
    notes = JsonUtils.toText(json['notes']) ?? notes;
    landTypeNotes = JsonUtils.toText(json['land_type_notes']) ?? landTypeNotes;
    tempBuildingNotes = JsonUtils.toText(json['temp_building_notes']) ?? tempBuildingNotes;
    electricityMetersNotes = JsonUtils.toText(json['electricity_meters_notes']) ?? electricityMetersNotes;
    environmentConditionalNotes = JsonUtils.toText(json['environment_conditional_notes']) ?? environmentConditionalNotes;

    startDatetime = JsonUtils.toText(json['start_datetime']) ?? startDatetime;

    // extra fields (not in Hive)
    submitDatetime = JsonUtils.toText(json['submit_datetime']) ?? submitDatetime;
    lastUpdatedFrom = JsonUtils.toText(json['last_updated_from']) ?? lastUpdatedFrom;
    lastUpdate = JsonUtils.toText(json['last_update']) ?? lastUpdate;
    displayName = JsonUtils.toText(json['display_name']) ?? displayName;
    displayButtonSend = JsonUtils.toBoolean(json['display_button_send']) ?? displayButtonSend;
    displayButtonAccept = JsonUtils.toBoolean(json['display_button_accept']) ?? displayButtonAccept;
    displayButtonRefuse = JsonUtils.toBoolean(json['display_button_refuse']) ?? displayButtonRefuse;
    displayButtonAction = JsonUtils.toBoolean(json['display_button_action']) ?? displayButtonAction;
    displayButtonUnderprogress = JsonUtils.toBoolean(json['display_button_underprogress']) ?? displayButtonUnderprogress;
    underprogress = JsonUtils.toBoolean(json['underprogress']) ?? underprogress;
    actionTaken = JsonUtils.toBoolean(json['action_taken']) ?? actionTaken;
    displayBtnStart = JsonUtils.toBoolean(json['display_btn_start']) ?? displayBtnStart;
  }

  factory VisitLandModel.fromJson(Map<String, dynamic> json) {
return VisitLandModel(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      landAddress: JsonUtils.toText(json['land_address']),
      stage: JsonUtils.getName(json['stage_id']),
      stageId: JsonUtils.getId(json['stage_id']),
      landId: JsonUtils.getId(json['land_id']),
      land: JsonUtils.getName(json['land_id']),
      employeeId: JsonUtils.getId(json['employee_id']),
      employee : JsonUtils.getName(json['employee_id']),
      state : JsonUtils.toText(json['state']),
      priorityValue : JsonUtils.toText(json['priority_value']),
       dataVerified : true
    );
  }

  final Map<String, bool> noRequiredField={
    "notes":true,
    "land_type_notes":true,
    "temp_building_notes":true,
    "electricity_meters_notes":true,
    "environment_conditional_notes":true,
  };

  bool isRequired(field){
    return  (noRequiredField[field] == true)==false;
    // return false ;
  }




  void onVisitStart(){
    startDatetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
    btnStart = true; //  Save the mapped value directly+
    dateOfVisit = DateFormat('yyyy-MM-dd').format(DateTime.now()); //
  }

  factory VisitLandModel.fromInitializeVisitJson(Map<String, dynamic> result) {
 
    VisitLandModel visit =VisitLandModel();
    visit.dataVerified = true;//make it hard coded true because no required this field in land visit
    visit.latitude=JsonUtils.toDouble(result['latitude']);
    visit.longitude=JsonUtils.toDouble(result['longitude']);
    visit.cityId=JsonUtils.getObjectId(result['city_id']);
    visit.city=JsonUtils.getObjectName(result['city_id']);
    visit.moiaCenterId=JsonUtils.getObjectId(result['moia_center_id']);
    visit.moiaCenter=JsonUtils.getObjectName(result['moia_center_id']);
    visit.regionId=JsonUtils.getObjectId(result['region_id']);
    visit.region=JsonUtils.getObjectName(result['region_id']);

    return visit;
  }

  void initializeFields(VisitLandModel base) {
        latitude=base.latitude;
        longitude=base.longitude;
        cityId=base.cityId;
        city=base.city;
        moiaCenterId=base.moiaCenterId;
        moiaCenter=base.moiaCenter;
        regionId=base.regionId;
        region=base.region;
        dataVerified=base.dataVerified;
  }

  Map<String, dynamic> toJson() {
    return {
      'land_type': landType,
      'has_ownership_sign': hasOwnershipSign,
      'ownership_sign_photo': ownershipSignPhoto,
      'easy_access': easyAccess,
      'paved_roads': pavedRoads,
      'has_temporary_buildings': hasTemporaryBuildings,
      'temporary_building_type': temporaryBuildingType,
      'has_encroachment': hasEncroachment,
      'encroachment_type': encroachmentType,
      'encroachment_photo': encroachmentPhoto,
      'has_electricity_meter': hasElectricityMeter,
      'electricity_meter_number': electricityMeterNumber,
      'has_meter_encroachment': hasMeterEncroachment,
      'meter_encroachment_photo': meterEncroachmentPhoto,
      'has_trees_grass': hasTreesGrass,
      'is_fenced': isFenced,
      'has_water_swamps': hasWaterSwamps,
      'has_safety_hazards': hasSafetyHazards,
      'is_waste_free': isWasteFree,
      'safety_hazard_description': safetyHazardDescription,
      // 'data_accuracy_pledge': dataAccuracyPledge,
      'notes': notes,
      'land_type_notes': landTypeNotes,
      'temp_building_notes': tempBuildingNotes,
      'electricity_meters_notes': electricityMetersNotes,
      'environment_conditional_notes': environmentConditionalNotes,
      'start_datetime': startDatetime,
      'submit_datetime': submitDatetime,
      'btn_start': btnStart,
      // 'submit_datetime': lastUpdatedFrom,
    };
  }

  //endregion



}


class PaginatedLandVisits extends PaginatedList<VisitLandModel>{

}