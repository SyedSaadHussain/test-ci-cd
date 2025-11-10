import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/models/mansoob_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
part 'visit_jumma_model.g.dart';

@HiveType(typeId: HiveTypeIds.visitJummaModel)
class VisitJummaModel extends MansoobVisitModel{

  //region for fields

  @HiveField(201)
  String? khatibPresent;

  @HiveField(202)
  String? khatibPunctuality;

  @HiveField(203)
  List<int>? khatibIds;

  @HiveField(204)
  List<ComboItem>? khatibIdsArray;

  @HiveField(205)
  String? khatibOffWork;

  @HiveField(206)
  String? khatibOffWorkDate;

  @HiveField(207)
  String? khatibLeaveFromDate;

  @HiveField(208)
  String? khatibLeaveToDate;

  @HiveField(209)
  String? khatibPermissionPrayer;

  @HiveField(210)
  String? khatibRelationship;

  @HiveField(211)
  String? khatibIdentificationId;

  @HiveField(212)
  String? dobKhatib;

  @HiveField(213)
  String? khutbahCommitment;

  @HiveField(214)
  String? khatibNotes;



  @HiveField(215)
  String? sermonDuration;

  @HiveField(216)
  String? sermonDeliveryFeedback;

  @HiveField(217)
  String? sermonDeliveryFeedbackNotes;

  @HiveField(218)
  String? contentFeedback;

  @HiveField(219)
  String? sermoinContentNotes;

  @HiveField(220)
  String? includedPrayersForRulers;

  @HiveField(221)
  String? khateebNameYakeen;

  @HiveField(222)
  String? dobKhatibHijri;

  @HiveField(223)
  int? jummaKhutbaId;

  @HiveField(224)
  String? jummaKhutbaName;

  @HiveField(225)
  String? jummaKhutbaDescription;

  @HiveField(226)
  String? jummaKhutbaGuideline_1;

  @HiveField(227)
  String? jummaKhutbaGuideline_2;

  @HiveField(228)
  String? jummaKhutbaGuideline_3;

  @HiveField(229)
  String? jummaKhutbaGuideline_4;

  @HiveField(230)
  String? khutbaNotes;

  @HiveField(231)
  String? occupancy;

  @override
  String? get modelName =>"visit.jumma";

  //endregion

  //region for property
  bool get showKhatibDetail => AppUtils.isNotNullOrEmpty(khatibPresent) && (khatibPresent  == 'notapplicable' || khatibPresent  != 'present');
  bool get khatibApplicable => AppUtils.isNotNullOrEmpty(khatibPresent)  && khatibPresent != 'notapplicable';
 //endregion

  //region for methods

  VisitJummaModel.shallowCopy(VisitJummaModel other)

      :super(
      id: other.id,
      mosque: other.mosque,
      employeeId: other.employeeId,
      stage: other.stage,
      stageId: other.stageId,
      name: other.name,
      priorityValue: other.priorityValue,
      state: other.state,
      prayerName: other.prayerName,
  )
  ;

  factory VisitJummaModel.fromJson(Map<String, dynamic> json) {
    return VisitJummaModel(
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
      'khatib_present': khatibPresent,
      'khatib_punctuality': khatibPunctuality,
      'khatib_ids': khatibIds,
      'khatib_off_work': khatibOffWork,
      'khatib_off_work_date': khatibOffWorkDate,
      'khatib_leave_from_date': khatibLeaveFromDate,
      'khatib_leave_to_date': khatibLeaveToDate,
      'khatib_permission_prayer': khatibPermissionPrayer,
      'khatib_relationship': khatibRelationship,
      'khatib_identification_id': khatibIdentificationId,
      'dob_khatib': dobKhatib,
      'khutbah_commitment': khutbahCommitment,
      'sermon_duration': sermonDuration,
      'sermon_delivery_feedback': sermonDeliveryFeedback,
      'sermon_delivery_feedback_notes': sermonDeliveryFeedbackNotes,
      'content_feedback': contentFeedback,
      'sermoin_content_notes': sermoinContentNotes,
      'included_prayers_for_rulers': includedPrayersForRulers,
      'khateeb_name_yakeen': khateebNameYakeen,
      'khatib_notes': khatibNotes,
      'khutba_notes': khutbaNotes,
      'occupancy': occupancy,
      ...super.toJson(),
    };
  }

  VisitJummaModel({
    super.id,
    super.mosque,
    super.mosqueId,
    super.stage,
    super.stageId,
    super.state,
    super.priorityValue,
    super.employee,
    super.employeeId,
    super.name
  }) {
    prayerName = "jumma";
  }

  @override
  void mergeJson(dynamic json) {

    super.mergeJson(json);
    khatibPresent = JsonUtils.toText(json['khatib_present']) ?? khatibPresent;
    khatibPunctuality = JsonUtils.toText(json['khatib_punctuality']) ?? khatibPunctuality;
    // khatibIds = json['khatib_ids'] == null
    //     ? khatibIds
    //     : (json['khatib_ids'] as List).map((e) => JsonUtils.toInt(e)).toList();
    khatibIdsArray = json['khatib_ids'] == null ? khatibIdsArray : (json['khatib_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList();

    khatibOffWork = JsonUtils.toText(json['khatib_off_work']) ?? khatibOffWork;
    khatibOffWorkDate = JsonUtils.toText(json['khatib_off_work_date']) ?? khatibOffWorkDate;
    khatibLeaveFromDate = JsonUtils.toText(json['khatib_leave_from_date']) ?? khatibLeaveFromDate;
    khatibLeaveToDate = JsonUtils.toText(json['khatib_leave_to_date']) ?? khatibLeaveToDate;
    khatibPermissionPrayer = JsonUtils.toText(json['khatib_permission_prayer']) ?? khatibPermissionPrayer;
    khatibRelationship = JsonUtils.toText(json['khatib_relationship']) ?? khatibRelationship;
    khatibIdentificationId = JsonUtils.toText(json['khatib_identification_id']) ?? khatibIdentificationId;
    dobKhatib = JsonUtils.toText(json['dob_khatib']) ?? dobKhatib;
    khutbahCommitment = JsonUtils.toText(json['khutbah_commitment']) ?? khutbahCommitment;
    khatibNotes = JsonUtils.toText(json['khatib_notes']) ?? khatibNotes;
    khutbaNotes = JsonUtils.toText(json['khutba_notes']) ?? khutbaNotes;
    occupancy = JsonUtils.toText(json['occupancy']) ?? occupancy;
    sermonDuration = JsonUtils.toText(json['sermon_duration']) ?? sermonDuration;
    sermonDeliveryFeedback = JsonUtils.toText(json['sermon_delivery_feedback']) ?? sermonDeliveryFeedback;
    sermonDeliveryFeedbackNotes = JsonUtils.toText(json['sermon_delivery_feedback_notes']) ?? sermonDeliveryFeedbackNotes;
    contentFeedback = JsonUtils.toText(json['content_feedback']) ?? contentFeedback;
    sermoinContentNotes = JsonUtils.toText(json['sermoin_content_notes']) ?? sermoinContentNotes;
    includedPrayersForRulers = JsonUtils.toText(json['included_prayers_for_rulers']) ?? includedPrayersForRulers;
    khateebNameYakeen = JsonUtils.toText(json['khateeb_name_yakeen']) ?? khateebNameYakeen;
    dobKhatibHijri = JsonUtils.toText(json['dob_khatib_hijri']) ?? dobKhatibHijri;
    //
    jummaKhutbaId = JsonUtils.toInt(json['jumma_khutba_id']?['id']) ?? jummaKhutbaId;
    jummaKhutbaName = JsonUtils.toText(json['jumma_khutba_id']?['description']) ?? jummaKhutbaName;
    jummaKhutbaDescription = JsonUtils.toText(json['jumma_khutba_id']?['name']) ?? jummaKhutbaDescription;
    jummaKhutbaGuideline_1 = JsonUtils.toText(json['jumma_khutba_id']?['guideline_1']) ?? jummaKhutbaGuideline_1;
    jummaKhutbaGuideline_2 = JsonUtils.toText(json['jumma_khutba_id']?['guideline_2']) ?? jummaKhutbaGuideline_2;
    jummaKhutbaGuideline_3 = JsonUtils.toText(json['jumma_khutba_id']?['guideline_3']) ?? jummaKhutbaGuideline_3;
    jummaKhutbaGuideline_4 = JsonUtils.toText(json['jumma_khutba_id']?['guideline_4']) ?? jummaKhutbaGuideline_4;
    // jummaKhutbaGuideline_5 = JsonUtils.toText(json['jumma_khutba_id']?['guideline_4']) ?? jummaKhutbaGuideline_4;
  }

  factory VisitJummaModel.fromInitializeVisitJson(Map<String, dynamic> result) {
    final khatibIdsLocal = ((result['mosque_khatib_ids'] ?? []) as List)
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
    VisitJummaModel visit =VisitJummaModel();

    visit.dataVerified = JsonUtils.toBoolean(result['data_verified']);
    visit.jummaKhutbaId = JsonUtils.toInt(result['jumma_khutba_id']?['id']);
    visit.jummaKhutbaName = JsonUtils.toText(result['jumma_khutba_id']?['name']);
    visit.jummaKhutbaDescription = JsonUtils.toText(result['jumma_khutba_id']?['description']);
    visit.jummaKhutbaGuideline_1 = JsonUtils.toText(result['jumma_khutba_id']?['guideline_1']);
    visit.jummaKhutbaGuideline_2 = JsonUtils.toText(result['jumma_khutba_id']?['guideline_2']);
    visit.jummaKhutbaGuideline_3 = JsonUtils.toText(result['jumma_khutba_id']?['guideline_3']);
    visit.jummaKhutbaGuideline_4 = JsonUtils.toText(result['jumma_khutba_id']?['iguideline_4']);
visit.khatibIdsArray = khatibIdsLocal;
    visit.muezzinIdsArray = muezzinIdsLocal;
    visit.khademIdsArray = khademIdsLocal;
    visit.waterMeterIdsArray = waterMeterIdsLocal;
    visit.electricMeterIdsArray = electricMeterIdsLocal;
    visit.maintenanceContractorIdsArray = maintenanceContractorIdsLocal;
    visit.latitude = JsonUtils.toDouble(result['mosque_latitude']);
    visit.longitude = JsonUtils.toDouble(result['mosque_longitude']);
    visit.cityId = JsonUtils.toInt(result['city_id']);
    visit.khatibPresent = khatibIdsLocal.isEmpty ? 'notapplicable' : null;
    visit.muezzinPresent = muezzinIdsLocal.isEmpty ? 'notapplicable' : null;
    visit.khademPresent = khademIdsLocal.isEmpty ? 'notapplicable' : null;
    visit.hasWaterMeter = waterMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';
    visit.hasElectricMeter = electricMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';
    visit.hasMaintenanceContractor = maintenanceContractorIdsLocal.isEmpty ? 'notapplicable' : 'applicable';

    return visit;
  }

  @override
  void initializeFields(VisitJummaModel base) {
    super.initializeFields(base);
    jummaKhutbaId = base.jummaKhutbaId;
    jummaKhutbaName = base.jummaKhutbaName;
    jummaKhutbaDescription = base.jummaKhutbaDescription;
    jummaKhutbaGuideline_1 = base.jummaKhutbaGuideline_1;
    jummaKhutbaGuideline_2 = base.jummaKhutbaGuideline_2;
    jummaKhutbaGuideline_3 = base.jummaKhutbaGuideline_3;
    jummaKhutbaGuideline_4 =base.jummaKhutbaGuideline_4;
    khatibIdsArray =base.khatibIdsArray;
    // muezzinIdsArray =base.muezzinIdsArray;
    // khademIdsArray = base.khademIdsArray;
    // waterMeterIdsArray = base.waterMeterIdsArray;
    // electricMeterIdsArray = base.electricMeterIdsArray;
    // maintenanceContractorIdsArray = base.maintenanceContractorIdsArray;
    // latitude = base.latitude;
    // longitude = base.longitude;
    // cityId = base.cityId;
    khatibPresent = base.khatibPresent;
    // muezzinPresent = base.muezzinPresent;
    // khademPresent = base.khademPresent;
    // hasWaterMeter = base.hasWaterMeter;
    // hasElectricMeter = base.hasElectricMeter;
    // hasMaintenanceContractor = base.hasMaintenanceContractor;
  }

  void onChangekhatibPresent(){
    khatibPunctuality=null;
    khatibOffWork=null;
    khatibOffWorkDate=null;
    khatibPermissionPrayer=null;
    khatibLeaveFromDate=null;
    khatibLeaveToDate=null;
    khatibRelationship=null;
    khatibIdentificationId=null;
    dobKhatib=null;
    khateebNameYakeen=null;
  }

  //endregion
}

class PaginatedVisitJumma extends PaginatedList<VisitJummaModel>{

}