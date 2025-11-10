import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
part 'visit_female_model.g.dart';

@HiveType(typeId: HiveTypeIds.visitFemaleModel)
class VisitFemaleModel extends VisitModel{

  //region for fields
  @HiveField(201)
  String? womenPrayerSignboard;

  @HiveField(202)
  String? cleanFreeBlock;

  @HiveField(203)
  String? doorWorkFine;

  @HiveField(204)
  String? privacyWomenArea;

  @HiveField(205)
  String? womanPrayerAreaSize;

  @HiveField(206)
  String? femaleSectionNotes;

  @override
  String? get modelName =>"visit.female";

  //endregion

  VisitFemaleModel({
    super.id,
    super.mosque,
    super.mosqueId,
    super.employee,
    super.employeeId,
    super.state,
    super.priorityValue,
    super.stage,
    super.stageId,
    super.name,
    this.womenPrayerSignboard,
    this.cleanFreeBlock,
    this.doorWorkFine,
    this.privacyWomenArea,
    this.womanPrayerAreaSize,
    this.femaleSectionNotes,
  });

  //region for methods

  VisitFemaleModel.shallowCopy(VisitFemaleModel other)
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

  factory VisitFemaleModel.fromJson(Map<String, dynamic> json) {
    return VisitFemaleModel(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      mosque: JsonUtils.getName(json['mosque_id']),
      mosqueId: JsonUtils.getId(json['mosque_id']),
      stage: JsonUtils.getName(json['stage_id']),
      stageId: JsonUtils.getId(json['stage_id']),
      state: JsonUtils.toText(json['state']),
      priorityValue : JsonUtils.toText(json['priority_value']),
      employee: JsonUtils.getName(json['employee_id']),
      employeeId : JsonUtils.getId(json['employee_id']),

    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'women_prayer_signboard': womenPrayerSignboard,
      'clean_free_block': cleanFreeBlock,
      'door_work_fine': doorWorkFine,
      'privacy_women_area': privacyWomenArea,
      'woman_prayer_area_size': womanPrayerAreaSize,
      'female_section_notes': femaleSectionNotes,
      ...super.toJson(),
    };
  }

  @override
  void mergeJson(dynamic json) {
    super.mergeJson(json);
    womenPrayerSignboard = JsonUtils.toText(json['women_prayer_signboard']) ?? womenPrayerSignboard;
    cleanFreeBlock = JsonUtils.toText(json['clean_free_block']) ?? cleanFreeBlock;
    doorWorkFine = JsonUtils.toText(json['door_work_fine']) ?? doorWorkFine;
    privacyWomenArea = JsonUtils.toText(json['privacy_women_area']) ?? privacyWomenArea;
    womanPrayerAreaSize = JsonUtils.toText(json['woman_prayer_area_size']) ?? womanPrayerAreaSize;
    femaleSectionNotes = JsonUtils.toText(json['female_section_notes']) ?? femaleSectionNotes;
  }

  factory VisitFemaleModel.fromInitializeVisitJson(Map<String, dynamic> result) {

    final waterMeterIdsLocal = ((result['mosque_water_meter_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    final electricMeterIdsLocal = ((result['mosque_electric_meter_ids'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    final maintenanceContractorIdsLocal = ((result['mosque_maintenance_contract'] ?? []) as List)
        .map((item) => ComboItem.fromJsonContractor(item))
        .toList();
    VisitFemaleModel visit =VisitFemaleModel();

    visit.dataVerified = JsonUtils.toBoolean(result['data_verified']);
    visit.waterMeterIdsArray = waterMeterIdsLocal;
    visit.electricMeterIdsArray = electricMeterIdsLocal;
    visit.maintenanceContractorIdsArray = maintenanceContractorIdsLocal;
    visit.latitude = JsonUtils.toDouble(result['mosque_latitude']);
    visit.longitude = JsonUtils.toDouble(result['mosque_longitude']);
    visit.cityId = JsonUtils.toInt(result['city_id']);
    visit.hasWaterMeter = waterMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';
    visit.hasElectricMeter = electricMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';
    visit.hasMaintenanceContractor = maintenanceContractorIdsLocal.isEmpty ? 'notapplicable' : 'applicable';

    return visit;
  }
  //endregion

}

class PaginatedFemaleVisit extends PaginatedList<VisitFemaleModel>{

}