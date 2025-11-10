import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/models/mansoob_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

part 'visit_ondemand_model.g.dart';

@HiveType(typeId: HiveTypeIds.visitOndemandModel)
class VisitOndemandModel extends RegularVisitModel{

  //region for fields
  @HiveField(230)
  String? deadlineDate;
  //endregion

  //region for property
  @override
  String? get modelName =>"visit.ondemand";

  bool get isDeadlineActive {
    if (AppUtils.isNotNullOrEmpty(deadlineDate) ) {
      try {
        final deadline = DateTime.parse(deadlineDate!);
        final now = DateTime.now();

        // Compare only date (ignore time)
        final today = DateTime(now.year, now.month, now.day);
        final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);

        return deadlineDay.isAfter(today) || deadlineDay.isAtSameMomentAs(today);
      } catch (e) {
        return false; // if parsing fails
      }
    }else{
      return false;
    }

  }
  //endregion

  VisitOndemandModel({
    super.id,
    super.mosque,
    super.stage,
    super.stageId,
    super.name,
    super.employee,
    super.employeeId,
    super.state,
    super.priorityValue,
    this.deadlineDate,
  });

  //region for methods

  VisitOndemandModel.shallowCopy(VisitOndemandModel other)
      :  deadlineDate = other.deadlineDate,super(
    id: other.id,
    mosque: other.mosque,
    employeeId: other.employeeId,
    stage: other.stage,
    stageId: other.stageId,
    name: other.name,
    state: other.state,
    priorityValue: other.priorityValue,
  );

  factory VisitOndemandModel.fromJson(Map<String, dynamic> json) {
    return VisitOndemandModel(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      mosque: JsonUtils.getName(json['mosque_id']),
      // mosqueId: JsonUtils.getId(json['mosque_id']),
      stage: JsonUtils.getName(json['stage_id']),
      stageId: JsonUtils.getId(json['stage_id']),
      employee: JsonUtils.getName(json['employee_id']),
      employeeId: JsonUtils.getId(json['employee_id']),
      state: JsonUtils.toText(json['state']),
      priorityValue : JsonUtils.toText(json['priority_value']),
      deadlineDate: JsonUtils.toText(json['deadline_date']),
    );
  }

  factory VisitOndemandModel.fromJsonAfterCreate(Map<String, dynamic> json) {
    return VisitOndemandModel(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      mosque: JsonUtils.getObjectName(json['mosque']),
      stage: JsonUtils.getObjectName(json['stage']),
      stageId: JsonUtils.getObjectId(json['stage']),
      employee: JsonUtils.getObjectName(json['employee']),
      employeeId: JsonUtils.getObjectId(json['employee']),
      state: JsonUtils.toText(json['state']),
      priorityValue : JsonUtils.toText(json['priority_value']),
      deadlineDate: JsonUtils.toText(json['deadline_date']),
    );
  }

  @override
  void mergeJson(dynamic json){
    super.mergeJson(json);
    deadlineDate= JsonUtils.toText(json['deadline_date']) ?? deadlineDate;
  }

  factory VisitOndemandModel.fromInitializeVisitJson(Map<String, dynamic> result) {
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
    VisitOndemandModel visit =VisitOndemandModel();

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


class PaginatedOndemandVisits extends PaginatedList<VisitOndemandModel>{

}