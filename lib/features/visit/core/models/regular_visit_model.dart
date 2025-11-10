import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/models/mansoob_visit_model.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

part 'regular_visit_model.g.dart';

@HiveType(typeId: HiveTypeIds.regularVisitModel)
class RegularVisitModel extends MansoobVisitModel{

  //region for fields
  // Mansoob - Imam
  @HiveField(200)
  String? imamPresent;

  @HiveField(201)
  List<int>? imamIds;

  @HiveField(202)
  List<ComboItem>? imamIdsArray;

  @HiveField(203)
  String? imamCommitment;

  @HiveField(204)
  String? imamOffWork;

  @HiveField(205)
  String? imamOffWorkDate;

  @HiveField(206)
  String? imamPermissionPrayer;

  @HiveField(207)
  String? imamLeaveFromDate;

  @HiveField(208)
  String? imamLeaveToDate;

  @HiveField(209)
  String? imamNotes;

  @override
  String? get modelName =>"visit.regular";

  //endregion

  RegularVisitModel({
    super.id,
    super.mosque,
    super.stage,
    super.stageId,
    super.name,
    super.employee,
    super.employeeId,
    super.state,
    super.priorityValue,
    this.imamPresent,
    this.imamIds,
    this.imamIdsArray,
    this.imamCommitment,
    this.imamOffWork,
    this.imamOffWorkDate,
    this.imamPermissionPrayer,
    this.imamLeaveFromDate,
    this.imamLeaveToDate,
    this.imamNotes,
  });

  //region for methods

  factory RegularVisitModel.fromJson(Map<String, dynamic> json) {
    return RegularVisitModel(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      mosque: JsonUtils.getName(json['mosque_id']),
      stage: JsonUtils.getName(json['stage_id']),
      stageId: JsonUtils.getId(json['stage_id']),
      state: JsonUtils.toText(json['state']),
      employee: JsonUtils.getName(json['employee_id']),
      employeeId : JsonUtils.getId(json['employee_id']),
      priorityValue : JsonUtils.toText(json['priority_value']),

    );
  }

  RegularVisitModel.shallowCopy(RegularVisitModel other)
      :super(
        id: other.id,
        mosque: other.mosque,
        employeeId: other.employeeId,
        stage: other.stage,
        stageId: other.stageId,
        name: other.name,
        priorityValue: other.priorityValue,
        state: other.state
      )
  ;

  @override
  void mergeJson(dynamic json){
    super.mergeJson(json);
    imamPresent= JsonUtils.toText(json['imam_present']) ?? imamPresent;
    imamIdsArray=json['imam_ids']==null? imamIdsArray : (json['imam_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList() ;
    imamCommitment= JsonUtils.toText(json['imam_commitment']) ?? imamCommitment;
    imamOffWork=JsonUtils.toText(json['imam_off_work']) ?? imamOffWork;
    imamOffWorkDate= JsonUtils.toText(json['imam_off_work_date']) ?? imamOffWorkDate;
    imamPermissionPrayer= JsonUtils.toText(json['imam_permission_prayer']) ?? imamPermissionPrayer;
    imamLeaveFromDate= JsonUtils.toText(json['imam_leave_from_date']) ?? imamLeaveFromDate;
    imamLeaveToDate= JsonUtils.toText(json['imam_leave_to_date']) ?? imamLeaveToDate;
    imamNotes= JsonUtils.toText(json['imam_notes']) ?? imamNotes;
  }

  factory RegularVisitModel.fromInitializeVisitJson(Map<String, dynamic> result) {
    final imamIdsLocal = ((result['imam_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();

    final muezzinIdsLocal = ((result['muezzin_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();

    final khademIdsLocal = ((result['khadem_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonObject(item))
        .toList();

    final waterMeterIdsLocal = ((result['mosque_water_meter_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    final electricMeterIdsLocal = ((result['mosque_electric_meter_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    final maintenanceContractorIdsLocal = ((result['mosque_maintenance_contract'] ?? []) as List)
        .map((item) => ComboItem.fromJsonContractor(item))
        .toList();
    RegularVisitModel visit =RegularVisitModel();

    visit.dataVerified = JsonUtils.toBoolean(result['data_verified']);
    visit.imamIdsArray = imamIdsLocal;
    visit.muezzinIdsArray = muezzinIdsLocal;
    visit.khademIdsArray = khademIdsLocal;
    visit.waterMeterIdsArray = waterMeterIdsLocal;
    visit.electricMeterIdsArray = electricMeterIdsLocal;
    visit.maintenanceContractorIdsArray = maintenanceContractorIdsLocal;
    visit.latitude = JsonUtils.toDouble(result['mosque_latitude']);
    visit.longitude = JsonUtils.toDouble(result['mosque_longitude']);
    visit.cityId = JsonUtils.toInt(result['city_id']);
    visit.imamPresent = imamIdsLocal.isEmpty ? 'notapplicable' : null;
    visit.muezzinPresent = muezzinIdsLocal.isEmpty ? 'notapplicable' : null;
    visit.khademPresent = khademIdsLocal.isEmpty ? 'notapplicable' : null;
    visit.hasWaterMeter = waterMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';
    visit.hasElectricMeter = electricMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';
    visit.hasMaintenanceContractor = maintenanceContractorIdsLocal.isEmpty ? 'notapplicable' : 'applicable';

    return visit;
  }

  @override
  void initializeFields(RegularVisitModel base) {
    super.initializeFields(base);
    imamIdsArray = base.imamIdsArray;
    imamPresent = base.imamPresent;
  }

  void onChangeImamPresent(){
    imamCommitment = null;
    imamOffWork = null;
    imamOffWorkDate = null;
    imamPermissionPrayer = null;
    imamLeaveFromDate = null;
    imamLeaveToDate = null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'imam_present': imamPresent,
      'imam_ids': imamIds,
      'imam_commitment': imamCommitment,
      'imam_off_work': imamOffWork,
      'imam_off_work_date': imamOffWorkDate,
      'imam_permission_prayer': imamPermissionPrayer,
      'imam_leave_from_date': imamLeaveFromDate,
      'imam_leave_to_date': imamLeaveToDate,
      'imam_notes': imamNotes,
      ...super.toJson(),
    };
  }

  //endregion

}

class PaginatedRegularVisits extends PaginatedList<RegularVisitModel>{

}