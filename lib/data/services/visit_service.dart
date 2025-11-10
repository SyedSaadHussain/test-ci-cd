import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_region.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/repositories/visit_repository.dart';
import 'package:mosque_management_system/data/services/odoo_service.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/domain_builder.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart';

class VisitService extends OdooService{
  // late CommonRepository _repository;
  late VisitRepository _visitRepository;
  // CommonRepository get repository => _repository;
  VisitRepository get visitRepository => _visitRepository;

  void updateUserProfile(UserProfile userProfile){
    visitRepository.userProfile=userProfile;
    repository.userProfile=userProfile;
  }

  VisitService(CustomOdooClient client,{UserProfile? userProfile}): super(client,userProfile:userProfile) {
    // _repository = CommonRepository(client);
    _visitRepository = VisitRepository(client,userProfile: userProfile);
  }

  //
  Future<dynamic> createOnDemandVisit(Visit newVisit) async {
    try {
      var _pram={
        "mosque_seq_no": newVisit.mosqueSequenceNoId,
        "created_by": newVisit.createdById,
        "observer": newVisit.observerId
      };
      dynamic response = await _visitRepository.createVisit(_pram);
      return response;
    }on Exception catch (e){
      throw e;
    }

  }
    

  Future<List<TabItem>> getVisitStages() async {
    List<TabItem> items=[];
    try {
      dynamic response = await repository.getRequestStage(Model.visit);
      // contacts.count=0;//response["length"];
      items =(response as List).map((item) => TabItem.fromJsonObject(item)).toList();
      return items;
    }catch(e){
      throw e;
    }
  }


  Future<VisitData> getVisits(int pageSize,int pageIndex,String query,{String? filterField,dynamic? filterValue,Visit? filter}) async {
    try {
      VisitData contacts =VisitData();
      var _domain=[
        '|',
        [ "mosque_seq_no",
          "ilike",
          query],
        [
          "name",
          "ilike",
          query
        ]
      ];


      dynamic domainBuilder=DomainBuilder(_domain);
      domainBuilder.add("stage_id",filterValue,'=');
      domainBuilder.add("visit_type",filter!.visitType,'=');
      domainBuilder.add("prayer_name",filter!.prayerName,'=');
      domainBuilder.add("priority_value",filter!.priorityVal,'=');
      domainBuilder.add("imam_off_work",filter!.imamOffWork,'=');
      domainBuilder.add("moazen_off_work",filter!.moazenOffWork,'=');
      domainBuilder.add("electric_meter_violation",filter!.electricMeterViolation,'=');
      domainBuilder.add("water_meter_violation",filter!.waterMeterViolation,'=');
      domainBuilder.add("mosque_violation",filter!.mosqueViolation,'=');
      domainBuilder.add("holy_quran_violation",filter!.holyQuranViolation,'=');
      // print('_domain');
      _domain=domainBuilder.domain;

      // if(filterValue!=null){//AppUtils.isNotNullOrEmpty(filterField) &&
      //   _domain=[
      //     '&',
      //     '|',
      //     [ "mosque_seq_no",
      //       "ilike",
      //       query],
      //     [
      //       "name",
      //       "ilike",
      //       query
      //     ],
      //     [
      //       "stage_id",//change this after API upgrade filterField,
      //       "=",
      //       filterValue
      //     ],
      //
      //
      //   ];
      //
      // }else{
      //   _domain=[
      //     '|',
      //     [ "mosque_seq_no",
      //       "ilike",
      //       query],
      //     [
      //       "name",
      //       "ilike",
      //       query
      //     ]
      //   ];
      // }




      dynamic response = await _visitRepository.getAllVisits(_domain,pageSize,pageIndex);
      contacts.count=0;//response["length"];
      contacts.list=(response as List).map((item) => Visit.fromJson(item)).toList();
      return contacts;
    }catch(e){
      throw e;
    }

  }

  Future<List<FieldList>> loadVisitView() async {
    try {
      var _domain=[];
      List<FieldList> data=[];
      Mosque mosque =Mosque(id: 0);
      dynamic response = await repository.loadView(model: Model.visit);
      FieldList itemData=FieldList(field: "");
      (response as Map<String, dynamic>).forEach((key, value) {
        itemData=FieldList();
        itemData=FieldList.fromStringJson(key,value);
        data.add(itemData);

      });
      return data;
    }catch(e){
      throw e;
    }

  }

  Future<List<ComboItem>> getVisitFilter(String filter,{dynamic domain}) async {
    try {
      List<ComboItem> data=[];
      dynamic response = await _visitRepository.getVisitFilter(filter,domain: domain);
      data=(response as List).map((item) => ComboItem.fromJsonFilter(item)).toList();
      return data;
    }catch(e){
      throw e;
    }

  }

  Future<List<int>> loadCreateVisit() async {
    try {
      List<int> _employees=[];

      dynamic response = await _visitRepository.onChange();
      try{
        _employees=JsonUtils.toList((response['domain']['observer'][0][2]).toList())??[];
      }catch(e) {
        _employees=[];
      }
      print(_employees);
      return _employees;
    }catch(e){
      throw e;
    }

  }

  // Future<Visit> onChangeMoazenOffWork(Visit visit) async {
  //   try {
  //     var _domain=[];
  //
  //     dynamic response = await _visitRepository.onChange(visit,"moazen_off_work");
  //     visit.moazenOffPrayersId=JsonUtils.toText(response['value']['moazen_off_prayers_id']);
  //
  //     return visit;
  //   }catch(e){
  //     throw e;
  //   }
  //
  // }
  //
  // Future<Visit> onChangeImamOffWork(Visit visit) async {
  //   try {
  //     var _domain=[];
  //
  //     dynamic response = await _visitRepository.onChange(visit,"imam_off_work");
  //     visit.imamOffPrayersId=JsonUtils.toText(response['value']['imam_off_prayers_id']);
  //
  //     return visit;
  //   }catch(e){
  //     throw e;
  //   }
  //
  // }

  Future<Visit> getVisitDetail(int id) async {
    try {
      Visit mosque =Visit(id: 0);
      var _domain=[];

      dynamic response = await _visitRepository.getVisitDetail(id);
      mosque = Visit.fromJson(response[0]);
      return mosque;
    }catch(e){
      throw e;
    }

  }

  Future<bool> updatePrayerTime(Visit visit) async {
    try {
      var _pram={
        "prayer_name": visit.prayerName
      };



      dynamic response = await _visitRepository.updateVisit(visit,_pram);

      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> updateVisit(Visit oldVisit,Visit visit) async {
    try {
      visit.lastUpdatedFrom="mobile";
      var _pram={
        "prayer_name": visit.prayerName,
        "last_updated_from": visit.lastUpdatedFrom,
        // "last_location": visit.lastLocation,
        "matching_location": visit.matchingLocation,
        "total_location": visit.totalLocation,

        "khateeb_present": visit.khateebPresent,
        "khateeb_absent_gomaa": visit.khateebAbsentGomaa,
        "khateeb_notes": visit.khateebNotes,
        //"imam_off_prayers_id": visit.prayerName,
        //"moazen_off_prayers_id": visit.prayerName,

        "imam_present": visit.imamPresent,
        "imam_off_work": visit.imamOffWork,
        "imam_notes": visit.imamNotes,
        "imam_off_prayers_id": visit.imamOffPrayersId,
        "imam_off_work_date": visit.imamOffWorkDate,
        "imam_on_leave_from": visit.imamOnLeaveFrom,
        "imam_on_leave_to": visit.imamOnLeaveTo,


        "moazen_off_work_date": visit.moazenOffWorkDate,
        "moazen_on_leave_from": visit.moazenOnLeaveFrom,
        "moazen_on_leave_to": visit.moazenOnLeaveTo,

        "moazen_present": visit.moazenPresent,
        // "moazen_exist": visit.moazenExist,
        "moazen_off_work": visit.moazenOffWork,
        "moazen_notes": visit.moazenNotes,
        "moazen_off_prayers_id": visit.moazenOffPrayersId,

        "worker_present": visit.workerPresent,
        // "worker_exist": visit.workerExist,
        "worker_rate": visit.workerRate,
        "worker_notes": visit.workerNotes,


        "moazen_present":visit.moazenPresent,
        "mosque_clean":visit.mosqueClean,
        "mosque_clean_notes":visit.mosqueCleanNotes,
        "carpet_quality":visit.carpetQuality,
        "carpet_quality_notes":visit.carpetQualityNotes,
        "wc_clean":visit.wcClean,
        "wc_clean_notes":visit.wcCleanNotes,
        "air_condition":visit.airCondition,
        "air_condition_notes":visit.airConditionNotes,
        "sound_system":visit.soundSystem,
        "sound_system_notes":visit.soundSystemNotes,
        "close_outside_horn":visit.closeOutsideHorn,
        "inside_horn":visit.insideHorn,
        "outside_horn":visit.outsideHorn,
        "wc_maintenance":visit.wcMaintenance,
        "wc_maintenance_notes":visit.wcMaintenanceNotes,
        "ablution_wash":visit.ablutionWash,
        "ablution_wash_notes":visit.ablutionWashNotes,
        "electric_meter_violation":visit.electricMeterViolation,
        "electric_meter_violation_note":visit.electricMeterViolationNote,
        //"electric_meter_violation_attachment":visit.electricMeterViolationAttachment,
        "water_meter_violation":visit.waterMeterViolation,
        "water_meter_violation_note":visit.waterMeterViolationNote,
        //"water_meter_violation_attachment":visit.waterMeterViolationAttachment,
        "mosque_violation":visit.mosqueViolation,
        "mosque_violation_note":visit.mosqueViolationNote,
        //"mosque_violation_attachment":visit.mosqueViolationAttachment,
        "cleaning_material":visit.cleaningMaterial,
        "holy_quran_violation":visit.holyQuranViolation,
        "holy_quran_violation_note":visit.holyQuranViolationNote,
        //"binary_holy_quran_violation_attachment":visit.holyQuranViolationAttachment,
        "description":visit.description,
      };

      if(oldVisit.waterMeterViolationAttachment!=visit.waterMeterViolationAttachment)
        _pram['water_meter_violation_attachment']=visit.waterMeterViolationAttachment;

      if(oldVisit.holyQuranViolationAttachment!=visit.holyQuranViolationAttachment)
        _pram['binary_holy_quran_violation_attachment']=visit.holyQuranViolationAttachment;

      if(oldVisit.mosqueViolationAttachment!=visit.mosqueViolationAttachment)
        _pram['mosque_violation_attachment']=visit.mosqueViolationAttachment;

      if(oldVisit.electricMeterViolationAttachment!=visit.electricMeterViolationAttachment)
        _pram['electric_meter_violation_attachment']=visit.electricMeterViolationAttachment;

      dynamic response = await _visitRepository.updateVisit(visit,_pram);

      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> startVisit(int id) async {
    try {
      dynamic response = await _visitRepository.startVisit(id);

      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<dynamic> getVisitDisclaimer(int visitId) async {
    try {
      dynamic response = await _visitRepository.getVisitDisclaimer(visitId);

      return response;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> sendVisit(int id) async {
    try {
      dynamic response = await _visitRepository.sendVisit(id);


      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> acceptTermsVisit(int id) async {
    try {
      dynamic response = await _visitRepository.acceptTermsVisit(id);


      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> acceptVisit(int id) async {
    try {
      dynamic response = await _visitRepository.acceptVisit(id);


      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> refuseVisit(int id) async {
    try {
      dynamic response = await _visitRepository.refuseVisit(id);

      return true;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<bool> setDraftVisit(int id) async {
    try {
      dynamic response = await _visitRepository.setDraftVisit(id);

      return true;
    }on Exception catch (e){
      throw e;
    }

  }

}