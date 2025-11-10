import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

class MansoobVisitModel extends VisitModel{

  //region for fields
// Mansoob - Muezzin
  @HiveField(170)
  String? muezzinPresent;

  @HiveField(171)
  List<int>? muezzinIds;

  @HiveField(172)
  List<ComboItem>? muezzinIdsArray;

  @HiveField(173)
  String? muezzinCommitment;

  @HiveField(174)
  String? muezzinOffWork;

  @HiveField(175)
  String? muezzinPermissionPrayer;

  @HiveField(176)
  String? muezzinLeaveFromDate;

  @HiveField(177)
  String? muezzinLeaveToDate;

  @HiveField(178)
  String? muezzinOffWorkDate;

  @HiveField(179)
  String? muezzinNotes;

// Mansoob - Khadem
  @HiveField(180)
  String? khademPresent;

  @HiveField(181)
  String? mansoobNotes;

  @HiveField(182)
  List<int>? khademIds;

  @HiveField(183)
  List<ComboItem>? khademIdsArray;

  @HiveField(184)
  String? khademNotes;

  @HiveField(185)
  String? khademLeaveFromDate;

  @HiveField(186)
  String? khademLeaveToDate;

  @HiveField(187)
  String? khademPermissionPrayer;

  @HiveField(188)
  String? khademOffWork;

  @HiveField(189)
  String? khademOffWorkDate;

  @HiveField(190)
  String? qualityOfWork;

  @HiveField(191)
  String? cleanMaintenanceMosque;

  @HiveField(192)
  String? organizedAndArranged;

  @HiveField(193)
  String? takecareProperty;

  @HiveField(194)
  String? serviceTask;

  //endregion

  //region for property
  bool get khadimApplicable =>
      AppUtils.isNotNullOrEmpty(khademPresent) && khademPresent != 'notapplicable';
  //endregion

  MansoobVisitModel({
    super.id,
    super.mosque,
    super.mosqueId,
    super.stage,
    super.stageId,
    super.name,
    super.employee,
    super.employeeId,
    super.state,
    super.priorityValue,
    super.prayerName,
  });

  //region for fields
  @override
  void initializeFields(covariant MansoobVisitModel base) {
    super.initializeFields(base);
    muezzinIdsArray =base.muezzinIdsArray;
    khademIdsArray = base.khademIdsArray;
    muezzinPresent = base.muezzinPresent;
    khademPresent = base.khademPresent;
  }

  @override
  void mergeJson(dynamic json){
    super.mergeJson(json);
    muezzinPresent = JsonUtils.toText(json['muezzin_present']) ?? muezzinPresent;
    muezzinIdsArray = json['muezzin_ids'] == null ? muezzinIdsArray : (json['muezzin_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList();
    muezzinCommitment = JsonUtils.toText(json['muezzin_commitment']) ?? muezzinCommitment;
    muezzinOffWork = JsonUtils.toText(json['muezzin_off_work']) ?? muezzinOffWork;
    muezzinPermissionPrayer = JsonUtils.toText(json['muezzin_permission_prayer']) ?? muezzinPermissionPrayer;
    muezzinLeaveFromDate = JsonUtils.toText(json['muezzin_leave_from_date']) ?? muezzinLeaveFromDate;
    muezzinLeaveToDate = JsonUtils.toText(json['muezzin_leave_to_date']) ?? muezzinLeaveToDate;
    muezzinOffWorkDate = JsonUtils.toText(json['muezzin_off_work_date']) ?? muezzinOffWorkDate;
    muezzinNotes = JsonUtils.toText(json['muezzin_notes']) ?? muezzinNotes;

    khademPresent = JsonUtils.toText(json['khadem_present']) ?? khademPresent;
    mansoobNotes = JsonUtils.toText(json['mansoob_notes']) ?? mansoobNotes;
    khademIdsArray = json['khadem_ids'] == null ? khademIdsArray : (json['khadem_ids'] as List).map((item) => ComboItem.fromJsonObject(item)).toList();
    khademNotes = JsonUtils.toText(json['khadem_notes']) ?? khademNotes;
    khademLeaveFromDate = JsonUtils.toText(json['khadem_leave_from_date']) ?? khademLeaveFromDate;
    khademLeaveToDate = JsonUtils.toText(json['khadem_leave_to_date']) ?? khademLeaveToDate;
    khademPermissionPrayer = JsonUtils.toText(json['khadem_permission_prayer']) ?? khademPermissionPrayer;
    khademOffWork = JsonUtils.toText(json['khadem_off_work']) ?? khademOffWork;
    khademOffWorkDate = JsonUtils.toText(json['khadem_off_work_date']) ?? khademOffWorkDate;
    qualityOfWork= JsonUtils.toText(json['quality_of_work']) ?? qualityOfWork;
    cleanMaintenanceMosque= JsonUtils.toText(json['clean_maintenance_mosque']) ?? cleanMaintenanceMosque;
    organizedAndArranged= JsonUtils.toText(json['organized_and_arranged']) ?? organizedAndArranged;
    takecareProperty= JsonUtils.toText(json['takecare_property']) ?? takecareProperty;
    serviceTask= JsonUtils.toText(json['service_task']) ?? serviceTask;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'muezzin_present': muezzinPresent,
      'muezzin_ids': muezzinIds,
      'muezzin_commitment': muezzinCommitment,
      'muezzin_off_work': muezzinOffWork,
      'muezzin_permission_prayer': muezzinPermissionPrayer,
      'muezzin_leave_from_date': muezzinLeaveFromDate,
      'muezzin_leave_to_date': muezzinLeaveToDate,
      'muezzin_off_work_date': muezzinOffWorkDate,
      'muezzin_notes': muezzinNotes,

      'khadem_present': khademPresent,
      'khadem_ids': khademIds,
      'khadem_leave_from_date': khademLeaveFromDate,
      'khadem_leave_to_date': khademLeaveToDate,
      'khadem_permission_prayer': khademPermissionPrayer,
      'khadem_off_work': khademOffWork,
      'khadem_off_work_date': khademOffWorkDate,
      'khadem_notes': khademNotes,

      'quality_of_work': qualityOfWork,
      'clean_maintenance_mosque': cleanMaintenanceMosque,
      'organized_and_arranged': organizedAndArranged,
      'takecare_property': takecareProperty,
      'service_task': serviceTask,

      'mansoob_notes': mansoobNotes,
      ...super.toJson(),
    };
  }

  void onChangeMuezzinPresent(){
    muezzinCommitment = null;
    muezzinOffWork = null;
    muezzinOffWorkDate = null;
    muezzinPermissionPrayer = null;
    muezzinLeaveFromDate = null;
    muezzinLeaveToDate = null;
  }

  void onChangeKhademPresent(){
    khademOffWork = null;
    khademOffWork = null;
    khademPermissionPrayer = null;
    khademLeaveFromDate = null;
    khademLeaveToDate = null;
    khademLeaveToDate = null;
  }

  //endregion

}
