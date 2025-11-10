import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_workflow.dart';

part 'visit_eid_model.g.dart';

/// Hive field ranges: → 1–50
@HiveType(typeId: HiveTypeIds.visitEidModel)
class VisitEidModel extends VisitModelBase  {

  @HiveField(0)
  int? id;

  @HiveField(1)
  String? state;

  @HiveField(2)
  double? latitude;

  @HiveField(3)
  double? longitude;

  @HiveField(4)
  int? cityId;

  @HiveField(5)
  String? city;

  @HiveField(6)
  int? stageId;

  @HiveField(7)
  String? stage;

  @HiveField(8)
  String? requestTypeName;

  @HiveField(9)
  String? isLock;

  @HiveField(10)
  bool? btnStart;

  @HiveField(11)
  String? name;

  @HiveField(12)
  int? mosqueId;

  @HiveField(13)
  String? mosque;

  @HiveField(14)
  String? priorityValue;

  @HiveField(15)
  int? employeeId;

  @HiveField(16)
  String? employee;

  @HiveField(17)
  String? actionNotes;

  // @HiveField(18)
  // String? actionAttachment;

  @HiveField(19)
  String? actionTakenType;

  @HiveField(20)
  String? eidPrayerBoard;

  @HiveField(21)
  String? eidPrayerComment;

  @HiveField(22)
  String? tempBuildingPrayer;



  @HiveField(24)
  String? typeTempBuilding;

  @HiveField(25)
  String? typeTempBuildingComment;

  @HiveField(26)
  String? encroachmentOnPrayerArea;



  @HiveField(28)
  String? typeOfViolation;

  @HiveField(29)
  String? violationComment;

  @HiveField(30)
  String? isElectricityMeter;

  @HiveField(31)
  String? electricityMeterComment;

  @HiveField(32)
  String? violationOnElectricity;



  @HiveField(34)
  List<int>? chooseElectricityMeter;

  @HiveField(35)
  List<ComboItem>? chooseElectricityMeterArray;

  @HiveField(36)
  String? landFenced;

  @HiveField(37)
  String? landFencedComment;

  @HiveField(38)
  String? treeTallGrass;

  @HiveField(39)
  String? treeTallGrassComment;

  @HiveField(40)
  String? thereAnySwamps;

  @HiveField(41)
  String? commentSwamps;

  @HiveField(42)
  String? publicSafetyHazard;

  @HiveField(43)
  String? commentOnSafetyHazard;

  @HiveField(44)
  String? warningInfoPanel;

  @HiveField(45)
  String? warningPanelComment;

  @HiveField(46)
  String? prayerHallFree;

  @HiveField(47)
  String? prayerHallComment;

  @HiveField(48)
  String? pollutionNearHall;

  @HiveField(49)
  String? pollutionHallComment;

  @HiveField(50)
  String? startDatetime;

  @HiveField(51)
  bool? dataVerified;

  // @HiveField(27)
  // String? encroachmentComment;

  // @HiveField(23)
  // String? tempBuildingPrayerComment;

  // @HiveField(33)
  // String? violationOnElectricityComment;


  String? trasolNumber;
  List<int>? actionAttachments;

  bool? displayButtonAction;

  bool? displayButtonUnderprogress;
  String? underprogress;
  String? actionTaken;
  String? displayBtnStart;
  String? displayButtonSend;
  bool? displayButtonAccept;
  String? displayButtonRefuse;
  String? submitDatetime;
  String? createDate;
  String? lastUpdatedFrom;
  bool? isLoading;
  List<VisitWorkflow>? visitWorkFlow;

  //endregion

  //region for property
  String  get modelName =>  "eid.visit";

  String get uniqueId => submitDatetime.toString();

  String? get startDatetimeLocal => JsonUtils.toLocalDateTimeFormat(startDatetime);
  String? get submitDatetimeLocal => JsonUtils.toLocalDateTimeFormat(submitDatetime);

  @override
  String? get listTitle => mosque;
  @override
  String? get listSubTitle => name;

  //endregion

  VisitEidModel({
     this.id,
    this.stage,
    this.stageId,
    this.name,
    this.employeeId,
    this.employee,
    this.mosque,
    this.mosqueId,
    this.state,
    this.priorityValue,
  });


  //region for methods


  VisitEidModel.shallowCopy(VisitEidModel other)
      : id = other.id,
        name = other.name,
        stage = other.stage,
        stageId = other.stageId,
        mosqueId = other.mosqueId,
        mosque = other.mosque,
        employeeId = other.employeeId,
        employee = other.employee,
        state = other.state,
        priorityValue = other.priorityValue;

  void mergeJson(dynamic json) {
    visitWorkFlow= ((json['workflow'] ?? []) as List)
        .map((item) => VisitWorkflow.fromJson(item))
        .toList();
    actionNotes= JsonUtils.toText(json['action_notes'])?? actionNotes;
    // actionAttachment= JsonUtils.toText(json['action_attachment'])?? actionAttachment;
    trasolNumber= JsonUtils.toText(json['trasol_number'])?? trasolNumber;
    actionAttachments= JsonUtils.toList(json['action_attachments']).length>0?JsonUtils.toList(json['action_attachments']):actionAttachments;
    actionTakenType= JsonUtils.getName(json['action_taken_type_id'])?? actionTakenType;
    displayButtonUnderprogress = JsonUtils.toBoolean(json['display_button_underprogress']) ?? displayButtonUnderprogress;
    displayButtonAccept = JsonUtils.toBoolean(json['display_button_accept']) ?? displayButtonAccept;
    displayButtonAction = JsonUtils.toBoolean(json['display_button_action']) ?? displayButtonAction;
    stageId= JsonUtils.getId(json['stage'])??stageId;
    stage= JsonUtils.getName(json['stage'])??stage;
    name= JsonUtils.toText(json['name'])??name;
    priorityValue= JsonUtils.toText(json['priority_value'])??priorityValue;
    mosqueId= JsonUtils.getObjectId(json['mosque_id'])??mosqueId;
    mosque= JsonUtils.getObjectName(json['mosque_id'])??mosque;
    employeeId= JsonUtils.getObjectId(json['employee_id'])??employeeId;
    employee = JsonUtils.getObjectName(json['employee_id'])??employee;

    actionNotes = JsonUtils.toText(json['action_notes']) ?? actionNotes;
    // actionAttachment = JsonUtils.toText(json['action_attachment']) ?? actionAttachment;
    btnStart = JsonUtils.toBoolean(json['btn_start']) ?? btnStart;
    startDatetime = JsonUtils.toText(json['start_datetime']) ?? startDatetime;
    submitDatetime = JsonUtils.toText(json['submit_datetime']) ?? submitDatetime;

    eidPrayerBoard = JsonUtils.toText(json['eid_prayer_board']) ?? eidPrayerBoard;
    eidPrayerComment = JsonUtils.toText(json['eid_prayer_comment']) ?? eidPrayerComment;

    tempBuildingPrayer = JsonUtils.toText(json['temp_building_prayer']) ?? tempBuildingPrayer;
    // tempBuildingPrayerComment = JsonUtils.toText(json['temp_building_prayer_comment']) ?? tempBuildingPrayerComment;

    typeTempBuilding = JsonUtils.toText(json['type_temp_building']) ?? typeTempBuilding;
    typeTempBuildingComment = JsonUtils.toText(json['type_temp_building_comment']) ?? typeTempBuildingComment;

    encroachmentOnPrayerArea = JsonUtils.toText(json['encroachment_on_prayer_area']) ?? encroachmentOnPrayerArea;
    // encroachmentComment = JsonUtils.toText(json['encroachment_comment']) ?? encroachmentComment;

    typeOfViolation = JsonUtils.toText(json['type_of_violation']) ?? typeOfViolation;
    violationComment = JsonUtils.toText(json['violation_comment']) ?? violationComment;

    isElectricityMeter = JsonUtils.toText(json['is_electricity_meter']) ?? isElectricityMeter;
    electricityMeterComment = JsonUtils.toText(json['electricity_meter_comment']) ?? electricityMeterComment;

    violationOnElectricity = JsonUtils.toText(json['violation_on_electricity']) ?? violationOnElectricity;
    // violationOnElectricityComment = JsonUtils.toText(json['violation_on_electricity_comment']) ?? violationOnElectricityComment;

    // if (json['choose_electricity_meter'] != null) {
    //   chooseElectricityMeter = (json['choose_electricity_meter'] as List)
    //       .map((e) => JsonUtils.toInt(e) ?? 0)
    //       .toList();
    // }

    landFenced = JsonUtils.toText(json['land_fenced']) ?? landFenced;
    landFencedComment = JsonUtils.toText(json['land_fenced_comment']) ?? landFencedComment;

    treeTallGrass = JsonUtils.toText(json['tree_tall_grass']) ?? treeTallGrass;
    treeTallGrassComment = JsonUtils.toText(json['tree_tall_grass_comment']) ?? treeTallGrassComment;

    thereAnySwamps = JsonUtils.toText(json['there_any_swamps']) ?? thereAnySwamps;
    commentSwamps = JsonUtils.toText(json['comment_swamps']) ?? commentSwamps;

    publicSafetyHazard = JsonUtils.toText(json['public_safety_hazard']) ?? publicSafetyHazard;
    commentOnSafetyHazard = JsonUtils.toText(json['comment_on_safety_hazard']) ?? commentOnSafetyHazard;

    warningInfoPanel = JsonUtils.toText(json['warning_info_panel']) ?? warningInfoPanel;
    warningPanelComment = JsonUtils.toText(json['warning_panel_comment']) ?? warningPanelComment;

    prayerHallFree = JsonUtils.toText(json['prayer_hall_free']) ?? prayerHallFree;
    prayerHallComment = JsonUtils.toText(json['prayer_hall_comment']) ?? prayerHallComment;

    pollutionNearHall = JsonUtils.toText(json['pollution_near_hall']) ?? pollutionNearHall;
    pollutionHallComment = JsonUtils.toText(json['pollution_hall_comment']) ?? pollutionHallComment;
  }

  factory VisitEidModel.fromJson(Map<String, dynamic> json) {

   return VisitEidModel(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      stage: JsonUtils.getName(json['stage_id']),
      stageId: JsonUtils.getId(json['stage_id']),
      mosqueId: JsonUtils.getId(json['mosque_id']),
      mosque: JsonUtils.getName(json['mosque_id']),
      employeeId: JsonUtils.getId(json['employee_id']),
      employee : JsonUtils.getName(json['employee_id']),
      state : JsonUtils.toText(json['state']),
      priorityValue : JsonUtils.toText(json['priority_value']),
    );
  }

  final Map<String, bool> noRequiredField={
    "notes":true,
    "type_temp_building_comment":true,
    "electricity_meter_comment":true,
  };

  bool isRequired(field){
    return  (noRequiredField[field] == true)==false;
    // return false ;
  }


  void onVisitStart(){
    startDatetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
    btnStart = true; //  Save the mapped value directly+
  }



  factory VisitEidModel.fromInitializeVisitJson(Map<String, dynamic> result) {

    final waterMeterIdsLocal = ((result['choose_electricity_meter'] ?? []) as List)
        .map((item) => ComboItem.fromJsonForMeters(item))
        .toList();

    VisitEidModel visit =VisitEidModel();
    visit.dataVerified = JsonUtils.toBoolean(result['data_verified']);
    visit.latitude=JsonUtils.toDouble(result['mosque_latitude']);
    visit.longitude=JsonUtils.toDouble(result['mosque_longitude']);
    visit.cityId=JsonUtils.toInt(result['city_id']);
    visit.chooseElectricityMeterArray=waterMeterIdsLocal;
    visit.isElectricityMeter = waterMeterIdsLocal.isEmpty ? 'notapplicable' : 'applicable';

    return visit;
  }

  void initializeFields(VisitEidModel base) {
        latitude=base.latitude;
        longitude=base.longitude;
        cityId=base.cityId;
        isElectricityMeter=base.isElectricityMeter;
        chooseElectricityMeterArray=base.chooseElectricityMeterArray;
        dataVerified = base.dataVerified;
  }

  Map<String, dynamic> toJson() {
    return {
      'action_notes': actionNotes,
      // 'action_attachment': actionAttachment,
      'action_taken_type': actionTakenType,
      'btn_start': btnStart,
      'start_datetime': startDatetime,
      'submit_datetime': submitDatetime,

      'eid_prayer_board': eidPrayerBoard,
      'eid_prayer_comment': eidPrayerComment,
      'temp_building_prayer': tempBuildingPrayer,
      // 'temp_building_prayer_comment': tempBuildingPrayerComment,
      'type_temp_building': typeTempBuilding,
      'type_temp_building_comment': typeTempBuildingComment,
      'encroachment_on_prayer_area': encroachmentOnPrayerArea,
      // 'encroachment_comment': encroachmentComment,
      'type_of_violation': typeOfViolation,
      'violation_comment': violationComment,
      'is_electricity_meter': isElectricityMeter,
      'electricity_meter_comment': electricityMeterComment,
      'violation_on_electricity': violationOnElectricity,
      // 'violation_on_electricity_comment': violationOnElectricityComment,
      'choose_electricity_meter': chooseElectricityMeter,
      'land_fenced': landFenced,
      'land_fenced_comment': landFencedComment,
      'tree_tall_grass': treeTallGrass,
      'tree_tall_grass_comment': treeTallGrassComment,
      'there_any_swamps': thereAnySwamps,
      'comment_swamps': commentSwamps,
      'public_safety_hazard': publicSafetyHazard,
      'comment_on_safety_hazard': commentOnSafetyHazard,
      'warning_info_panel': warningInfoPanel,
      'warning_panel_comment': warningPanelComment,
      'prayer_hall_free': prayerHallFree,
      'prayer_hall_comment': prayerHallComment,
      'pollution_near_hall': pollutionNearHall,
      'pollution_hall_comment': pollutionHallComment,
    };
  }


  void onChangeIsElectricityMeter(){
    violationOnElectricity=null;
    chooseElectricityMeter=null;
  }

  //endregion



}


class PaginatedEidVisits extends PaginatedList<VisitEidModel>{

}