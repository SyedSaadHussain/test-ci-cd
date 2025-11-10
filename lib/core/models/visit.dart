import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:intl/intl.dart';

class Visit {
  int? id;
  String? name;
  bool? isFriday;
  int? khateebId;
  String? khateeb;
  String? khateebPresent;
  String? khateebAbsentGomaa;
  String? khateebNotes;
  String? lastUpdatedFrom ;
  String? lastLocation;
  int? totalLocation;
  int? matchingLocation ;
  double? latitude;
  double? longitude;
  String? state;
  int? stageId;
  String? stage;
  String? prayerName;
  DateTime? dateOfVisit;
  int? mosqueSequenceNoId;
  String? mosqueSequenceNo;
  int? imamEmpId;
  String? imamEmp;
  int? muazzinEmpId;
  String? muazzinEmp;
  List<int>? servantId;

  String? imamOnLeaveFrom;
  String? imamOnLeaveTo;
  String? moazenOnLeaveFrom;
  String? moazenOnLeaveTo;

  int? createdById;
  String? createdBy;
  String? imamPresent;
  String? imamOffWork;
  String? imamOffWorkDate;
  String? moazenOffWorkDate;
  String? imamOffPrayersIds;
  String? imamOffPrayersId;
  String? imamNotes;
  String? moazenPresent;
  //String? moazenExist;
  String? moazenOffWork;
  String? moazenOffPrayersIds;
  String? moazenOffPrayersId;
  String? moazenNotes;
  String? workerPresent;
  //String? workerExist;
  String? workerRate;
  String? workerNotes;

  int? priority;
  String? priorityVal;
  String? mosqueClean;
  String? mosqueCleanNotes;
  String? carpetQuality;
  String? carpetQualityNotes;
  String? wcClean;
  String? wcCleanNotes;
  String? airCondition;
  String? airConditionNotes;
  String? soundSystem;
  String? soundSystemNotes;
  String? closeOutsideHorn;
  String? insideHorn;
  String? outsideHorn;
  String? wcMaintenance;
  String? wcMaintenanceNotes;
  String? ablutionWash;
  String? ablutionWashNotes;

  String? observer;
  int? observerId;
  String? visitType;

  String? electricMeterViolation;
  String? electricMeterViolationNote;
  String? electricMeterViolationAttachment;
  String? waterMeterViolation;
  String? waterMeterViolationNote;
  String? waterMeterViolationAttachment;
  String? mosqueViolation;
  String? mosqueViolationNote;
  String? mosqueViolationAttachment;
  String? cleaningMaterial;
  String? holyQuranViolation;
  String? holyQuranViolationNote;
  String? holyQuranViolationAttachment;
  String? description;
  String? uniqueId;

  bool? displayButtonSend;
  bool? displayButtonAccept;
  bool? displayButtonRefuse;
  bool? displayButtonSetToDraft;
  bool? btnStart;

  // int get priorityLevel => this.priority!>20?3:this.priority!>=10?2:1;
  // String get priorityValue => priorityLevel==3?"high":priorityLevel==2?"medium":"low";
  // Color? get priorityColor => priorityLevel==3?AppColors.danger:priorityLevel==2?AppColors.yellow: AppColors.low;
  String get priorityValue => (this.priorityVal ?? 'low');
  Color? get priorityColor => priorityValue == 'high' ? AppColors.danger :
  priorityValue == 'medium' ? AppColors.yellow :
  AppColors.low;

  bool get isActionButton => (this.displayButtonSetToDraft??false) || (this.displayButtonAccept??false) || (this.displayButtonRefuse??false);

  Visit.shallowCopy(Visit other)
      : id = other.id,
        name = other.name,
        isFriday = other.isFriday,
        khateebPresent = other.khateebPresent,
        khateebId = other.khateebId,
        khateeb = other.khateeb,
        khateebAbsentGomaa = other.khateebAbsentGomaa,
        khateebNotes = other.khateebNotes,
        lastLocation = other.lastLocation,
        lastUpdatedFrom = other.lastUpdatedFrom,
        totalLocation = other.totalLocation,
        matchingLocation = other.matchingLocation,
        latitude = other.latitude,
        longitude = other.longitude,
        state=other.state,
        stage=other.stage,
        stageId=other.stageId,
        prayerName=other.prayerName,
        dateOfVisit=other.dateOfVisit,
        mosqueSequenceNoId = other.mosqueSequenceNoId,
        mosqueSequenceNo = other.mosqueSequenceNo,
        imamEmpId = other.imamEmpId,
        imamEmp = other.imamEmp,
        muazzinEmpId = other.muazzinEmpId,
        muazzinEmp = other.muazzinEmp,
        servantId = other.servantId,
        createdById = other.createdById,
        createdBy = other.createdBy,
        imamPresent = other.imamPresent,
        imamOffWork = other.imamOffWork,
        imamOnLeaveFrom = other.imamOnLeaveFrom,
        imamOnLeaveTo = other.imamOnLeaveTo,
        moazenOnLeaveFrom = other.moazenOnLeaveFrom,
        moazenOnLeaveTo = other.moazenOnLeaveTo,
        imamOffWorkDate = other.imamOffWorkDate,
        moazenOffWorkDate = other.moazenOffWorkDate,
        imamOffPrayersIds = other.imamOffPrayersIds,
        imamOffPrayersId = other.imamOffPrayersId,
        imamNotes = other.imamNotes,
        moazenPresent = other.moazenPresent,
  // moazenExist = other.moazenExist,
        moazenOffWork = other.moazenOffWork,
        moazenOffPrayersIds = other.moazenOffPrayersIds,
        moazenOffPrayersId = other.moazenOffPrayersId,
        moazenNotes = other.moazenNotes,
        workerPresent = other.workerPresent,
  //workerExist = other.workerExist,
        workerRate = other.workerRate,
        workerNotes = other.workerNotes,
        priority = other.priority,
        priorityVal = other.priorityVal,
        mosqueClean = other.mosqueClean,
        mosqueCleanNotes = other.mosqueCleanNotes,
        carpetQuality = other.carpetQuality,
        carpetQualityNotes = other.carpetQualityNotes,
        wcClean = other.wcClean,
        wcCleanNotes = other.wcCleanNotes,
        airCondition = other.airCondition,
        airConditionNotes = other.airConditionNotes,
        soundSystem = other.soundSystem,
        soundSystemNotes = other.soundSystemNotes,
        closeOutsideHorn = other.closeOutsideHorn,
        insideHorn = other.insideHorn,
        outsideHorn = other.outsideHorn,
        wcMaintenance = other.wcMaintenance,
        wcMaintenanceNotes = other.wcMaintenanceNotes,
        ablutionWash = other.ablutionWash,
        ablutionWashNotes = other.ablutionWashNotes,
        observer = other.observer,
        observerId = other.observerId,
        visitType = other.visitType,
        electricMeterViolation = other.electricMeterViolation,
        electricMeterViolationNote = other.electricMeterViolationNote,
        electricMeterViolationAttachment = other.electricMeterViolationAttachment,
        waterMeterViolation = other.waterMeterViolation,
        waterMeterViolationNote = other.waterMeterViolationNote,
        waterMeterViolationAttachment = other.waterMeterViolationAttachment,
        mosqueViolation = other.mosqueViolation,
        mosqueViolationNote = other.mosqueViolationNote,
        mosqueViolationAttachment = other.mosqueViolationAttachment,
        cleaningMaterial = other.cleaningMaterial,
        holyQuranViolation = other.holyQuranViolation,
        holyQuranViolationNote = other.holyQuranViolationNote,
        holyQuranViolationAttachment = other.holyQuranViolationAttachment,
        description = other.description;

  // Default constructor
  Visit({
    this.id,
    this.name,
    this.khateebId,
    this.khateeb,
    this.khateebNotes,
    this.khateebAbsentGomaa,
    this.khateebPresent,
    this.isFriday,
    this.matchingLocation,
    this.totalLocation,
    this.lastUpdatedFrom,
    this.lastLocation,
    this.latitude,
    this.longitude,
    this.state,
    this.stageId,
    this.stage,
    this.prayerName,
    this.dateOfVisit,
    this.mosqueSequenceNo,
    this.mosqueSequenceNoId,
    this.imamEmpId,
    this.imamEmp,
    this.muazzinEmpId,
    this.muazzinEmp,
    this.servantId,
    this.createdById,
    this.createdBy,
    this.imamPresent,
    this.imamOffWork,
    this.imamOnLeaveTo,
    this.imamOnLeaveFrom,
    this.moazenOnLeaveTo,
    this.moazenOnLeaveFrom,
    this.imamOffWorkDate,
    this.moazenOffWorkDate,
    this.imamOffPrayersIds,
    this.imamOffPrayersId,
    this.imamNotes,
    this.moazenPresent,
    // this.moazenExist,
    this.moazenOffWork,
    this.moazenOffPrayersIds,
    this.moazenOffPrayersId,
    this.moazenNotes,
    this.workerPresent,
    //this.workerExist,
    this.workerRate,
    this.workerNotes,
    this.priority,
    this.priorityVal,
    this.mosqueClean,
    this.mosqueCleanNotes,
    this.carpetQuality,
    this.carpetQualityNotes,
    this.wcClean,
    this.wcCleanNotes,
    this.airCondition,
    this.airConditionNotes,
    this.soundSystem,
    this.soundSystemNotes,
    this.closeOutsideHorn,
    this.insideHorn,
    this.outsideHorn,
    this.wcMaintenance,
    this.wcMaintenanceNotes,
    this.ablutionWash,
    this.ablutionWashNotes,
    this.observer,
    this.observerId,
    this.visitType,
    this.electricMeterViolation,
    this.electricMeterViolationAttachment,
    this.electricMeterViolationNote,
    this.waterMeterViolation,
    this.waterMeterViolationAttachment,
    this.waterMeterViolationNote,
    this.mosqueViolation,
    this.mosqueViolationAttachment,
    this.mosqueViolationNote,
    this.cleaningMaterial,
    this.holyQuranViolation,
    this.holyQuranViolationAttachment,
    this.holyQuranViolationNote,
    this.description,
    this.uniqueId,
    this.btnStart,
    this.displayButtonAccept=false,
    this.displayButtonSetToDraft=false,
    this.displayButtonRefuse=false,
    this.displayButtonSend=false
  });
  String get dateOfVisitGreg {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return this.dateOfVisit==null?"":dateFormat.format(this.dateOfVisit!);
  }
  factory Visit.fromJson(Map<String, dynamic> json) {

    return Visit(
      id: JsonUtils.toInt(json['id']),
      name: JsonUtils.toText(json['name']),
      khateebPresent: JsonUtils.toText(json['khateeb_present']),
      khateebAbsentGomaa: JsonUtils.toText(json['khateeb_absent_gomaa']),
      khateebNotes: JsonUtils.toText(json['khateeb_notes']),
      khateebId: JsonUtils.getId(json['khateeb_id']),
      khateeb: JsonUtils.getName(json['khateeb_id']),
      isFriday : JsonUtils.toBoolean(json['is_friday']),
      lastLocation: JsonUtils.toText(json['last_location']),
      lastUpdatedFrom: JsonUtils.toText(json['last_updated_from']),
      totalLocation: JsonUtils.toInt(json['total_location']),
      matchingLocation: JsonUtils.toInt(json['matching_location']),
      latitude: JsonUtils.toDouble(json['mosque_latitude']),
      longitude: JsonUtils.toDouble(json['mosque_longitude']),
      state: JsonUtils.toText(json['state']),
      stage: JsonUtils.getName(json['stage_id']),
      stageId: JsonUtils.getId(json['stage_id']),
      prayerName: JsonUtils.toText(json['prayer_name']),
      dateOfVisit: JsonUtils.toDateTime(json['date_of_visit']),
      mosqueSequenceNoId: JsonUtils.getId(json['mosque_seq_no']),
      mosqueSequenceNo: JsonUtils.getName(json['mosque_seq_no']),
      imamEmpId: JsonUtils.getId(json['imam_emp_id']),
      imamEmp: JsonUtils.getName(json['imam_emp_id']),
      muazzinEmpId: JsonUtils.getId(json['muazzin_emp_id']),
      muazzinEmp: JsonUtils.getName(json['muazzin_emp_id']),
      servantId: JsonUtils.toList(json['khadem_ids']),
      // servantId: JsonUtils.toList(json['servant_id']),
      createdById: JsonUtils.getId(json['created_by']),
      createdBy: JsonUtils.getName(json['created_by']),
      imamPresent: JsonUtils.toText(json['imam_present']),
      imamOffWork: JsonUtils.toText(json['imam_off_work']),
      imamOnLeaveFrom: JsonUtils.toText(json['imam_on_leave_from']),
      imamOnLeaveTo: JsonUtils.toText(json['imam_on_leave_to']),
      moazenOnLeaveFrom: JsonUtils.toText(json['moazen_on_leave_from']),
      moazenOnLeaveTo: JsonUtils.toText(json['moazen_on_leave_to']),
      imamOffWorkDate: JsonUtils.toText(json['imam_off_work_date']),
      moazenOffWorkDate: JsonUtils.toText(json['moazen_off_work_date']),
      imamOffPrayersIds: JsonUtils.toText(json['imam_off_prayers_ids']),
      imamOffPrayersId: JsonUtils.toText(json['imam_off_prayers_id']),
      imamNotes: JsonUtils.toText(json['imam_notes']),
      moazenPresent: JsonUtils.toText(json['moazen_present']),
      //moazenExist: JsonUtils.toText(json['moazen_exist']),
      moazenOffWork: JsonUtils.toText(json['moazen_off_work']),
      moazenOffPrayersIds: JsonUtils.toText(json['moazen_off_prayers_ids']),
      moazenOffPrayersId: JsonUtils.toText(json['moazen_off_prayers_id']),
      moazenNotes: JsonUtils.toText(json['moazen_notes']),
      workerPresent: JsonUtils.toText(json['worker_present']),
      // workerExist: JsonUtils.toText(json['worker_exist']),
      workerRate: JsonUtils.toText(json['worker_rate']),
      workerNotes: JsonUtils.toText(json['worker_notes']),
      priority: JsonUtils.toInt(json['priority']),
      priorityVal: JsonUtils.toText(json['priority_value']),
      mosqueClean: JsonUtils.toText(json['mosque_clean']),
      mosqueCleanNotes: JsonUtils.toText(json['mosque_clean_notes']),
      carpetQuality: JsonUtils.toText(json['carpet_quality']),
      carpetQualityNotes: JsonUtils.toText(json['carpet_quality_notes']),
      wcClean: JsonUtils.toText(json['wc_clean']),
      wcCleanNotes: JsonUtils.toText(json['wc_clean_notes']),
      airCondition: JsonUtils.toText(json['air_condition']),
      airConditionNotes: JsonUtils.toText(json['air_condition_notes']),
      soundSystem: JsonUtils.toText(json['sound_system']),
      soundSystemNotes: JsonUtils.toText(json['sound_system_notes']),
      closeOutsideHorn: JsonUtils.toText(json['close_outside_horn']),
      insideHorn: JsonUtils.toText(json['inside_horn']),
      outsideHorn: JsonUtils.toText(json['outside_horn']),
      wcMaintenance: JsonUtils.toText(json['wc_maintenance']),
      wcMaintenanceNotes: JsonUtils.toText(json['wc_maintenance_notes']),
      ablutionWash: JsonUtils.toText(json['ablution_wash']),
      ablutionWashNotes: JsonUtils.toText(json['ablution_wash_notes']),
      observer: JsonUtils.getName(json['observer']),
      observerId: JsonUtils.getId(json['observer']),
      visitType: JsonUtils.toText(json['visit_type']),
      electricMeterViolation: JsonUtils.toText(json['electric_meter_violation']),
      electricMeterViolationAttachment: JsonUtils.toText(json['electric_meter_violation_attachment']),
      electricMeterViolationNote: JsonUtils.toText(json['electric_meter_violation_note']),
      waterMeterViolation: JsonUtils.toText(json['water_meter_violation']),
      waterMeterViolationAttachment: JsonUtils.toText(json['water_meter_violation_attachment']),
      waterMeterViolationNote: JsonUtils.toText(json['water_meter_violation_note']),
      mosqueViolation: JsonUtils.toText(json['mosque_violation']),
      mosqueViolationAttachment: JsonUtils.toText(json['mosque_violation_attachment']),
      mosqueViolationNote: JsonUtils.toText(json['mosque_violation_note']),
      cleaningMaterial: JsonUtils.toText(json['cleaning_material']),
      holyQuranViolation: JsonUtils.toText(json['holy_quran_violation']),
      holyQuranViolationAttachment: JsonUtils.toText(json['binary_holy_quran_violation_attachment']),
      holyQuranViolationNote: JsonUtils.toText(json['holy_quran_violation_note']),
      description: JsonUtils.toText(json['description']),
      uniqueId:(json['__last_update']??false)==false?"":json['__last_update'].replaceAll(RegExp(r'[^0-9]'), ''),
      displayButtonSend: JsonUtils.toBoolean(json['display_button_send']),
      displayButtonRefuse: JsonUtils.toBoolean(json['display_button_refuse']),
      displayButtonAccept: JsonUtils.toBoolean(json['display_button_accept']),
      displayButtonSetToDraft: JsonUtils.toBoolean(json['display_button_set_to_draft']),
      btnStart: JsonUtils.toBoolean(json['btn_start']),
    );
  }
}
//
class VisitData extends PagedData<Visit>{

}

