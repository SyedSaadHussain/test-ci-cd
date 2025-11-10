import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mosque_management_system/core/hive/extensions/visit_model_hive_extensions.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';

import '../../core/models/visit_jumma_model.dart';

class VisitRepository {
  final VisitService service;

  // Optional service parameter, defaults to a new VisitService using singleton client
  VisitRepository([VisitService? service])
      : service = service ?? VisitService();

  Future<dynamic> getHeadersMap()  async{

    final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    String sessionId = await _secureStorage.read(key: "sessionId") ?? "";
    return {
      'Cookie':  'session_id=${sessionId}',
    };
  }

  Future<List<ComboItem>> getActionTypes() async {
    try{
      final data = await service.getActionTypes();
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<RegularVisitModel>> getVisits({int? stageId,dynamic query,int? pageIndex,int? limit}) async {
    List<RegularVisitModel> data=[];
    try{
      final queryParams = {
        'query': query,
        'stage_id': stageId,
        'page': pageIndex,
        'limit': limit,
      };
      final response = await service.getVisits(queryParams);
      if(response['status']==200){
        data=(response['visits'] as List).map((item) => RegularVisitModel.fromJson(item)).toList();

      }else{
          throw response['message'];
      }
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<VisitFemaleModel>> getFemaleVisits({int? stageId,dynamic query,int? pageIndex,int? limit}) async {
    List<VisitFemaleModel> data=[];
    try{
      final queryParams = {
        'query': query,
        'stage_id': stageId,
        'page': pageIndex,
        'limit': limit,
      };
final response = await service.getFemaleVisits(queryParams);
if(response['status']==200){
        data=(response['visits'] as List).map((item) => VisitFemaleModel.fromJson(item)).toList();

      }else{
        throw response['message'];
      }
return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<VisitJummaModel>> getJummaVisits({int? stageId,dynamic query,int? pageIndex,int? limit}) async {
    List<VisitJummaModel> data=[];
    try{
      final queryParams = {
        'query': query,
        'stage_id': stageId,
        'page': pageIndex,
        'limit': limit,
      };
final response = await service.getJummaVisits(queryParams);
if(response['status']==200){
         data=(response['visits'] as List).map((item) => VisitJummaModel.fromJson(item)).toList();

       }else{
        throw response['message'];
      }
return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<VisitOndemandModel>> getOndemandVisits({int? stageId,dynamic employeeId,dynamic query,int? pageIndex,int? limit}) async {
    List<VisitOndemandModel> data=[];
    try{
      final queryParams = {
        'query': query,
        'employee_id': employeeId,
        'stage_id': stageId,
        'page': pageIndex,
        'limit': limit,
      };
final response = await service.getOndemandVisits(queryParams);
if(response['status']==200){
        data=(response['visits'] as List).map((item) => VisitOndemandModel.fromJson(item)).toList();

      }else{
        throw response['message'];
      }
return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<VisitLandModel>> getLandVisits({int? stageId,dynamic query,int? pageIndex,int? limit}) async {
    List<VisitLandModel> data=[];
    try{
      final queryParams = {
        'query': query,
        'stage_id': stageId,
        'page': pageIndex,
        'limit': limit,
      };
final response = await service.getLandVisit(queryParams);
if(response['status']==200){
        data=(response['visits'] as List).map((item) => VisitLandModel.fromJson(item)).toList();

      }else{
        throw response['message'];
      }
return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<VisitEidModel>> getEidVisits({int? stageId,dynamic query,int? pageIndex,int? limit}) async {
    List<VisitEidModel> data=[];
    try{
      final queryParams = {
        'query': query,
        'stage_id': stageId,
        'page': pageIndex,
        'limit': limit,
      };
    final response = await service.getEidVisit(queryParams);
    if(response['status']==200){
        data=(response['visits'] as List).map((item) => VisitEidModel.fromJson(item)).toList();
      }else{
        throw response['message'];
      }
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<RegularVisitModel> getInitializeRegularVisit(int visitId) async {
    try{
      RegularVisitModel visit;
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getInitializeVisit(queryParams);
      visit=RegularVisitModel.fromInitializeVisitJson(response['result']);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitOndemandModel> getInitializeOndemandVisit(int visitId) async {
    try{
      VisitOndemandModel visit;
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getInitializeOndemandVisit(queryParams);
      visit=VisitOndemandModel.fromInitializeVisitJson(response['result']);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitFemaleModel> getInitializeFemaleVisit(int visitId) async {
    try{
      VisitFemaleModel visit;
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getInitializeFemaleVisit(queryParams);
visit=VisitFemaleModel.fromInitializeVisitJson(response['result']);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitJummaModel> getInitializeJummaVisit(int visitId) async {
    try{
      VisitJummaModel visit;
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getInitializeJummaVisit(queryParams);
      visit=VisitJummaModel.fromInitializeVisitJson(response['result']);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitLandModel> getInitializeLandVisit(int visitId) async {
    try{
      VisitLandModel visit;
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getInitializeLandVisit(queryParams);
      visit=VisitLandModel.fromInitializeVisitJson(response['result']);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitEidModel> getInitializeEidVisit(int visitId) async {
    try{
      VisitEidModel visit;
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getInitializeEidVisit(queryParams);
      visit=VisitEidModel.fromInitializeVisitJson(response['result']);
      return visit;
    }catch(e){
      throw e;
    }
  }


  Future<bool> isPrayerTimeExits(String prayerName) async {
    try{
     bool isOndemandExits=await  HiveRegistry.ondemandVisit.isPrayerTimeExist(prayerName);
     bool isFemaleExits=await  HiveRegistry.femaleVisit.isPrayerTimeExist(prayerName);
     bool isRegularExits=await  HiveRegistry.regularVisit.isPrayerTimeExist(prayerName);
     bool isJummaExits=await  HiveRegistry.jummaVisit.isPrayerTimeExist(prayerName);
      return (isOndemandExits || isFemaleExits || isRegularExits || isJummaExits);
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitVisit(VisitModel visit,String acceptTerms) async {
    try{
      dynamic vals=visit.toJson()..removeWhere((key, value) => value == null);
    final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitFemaleVisit(VisitModel visit,String acceptTerms) async {
    try{
      dynamic vals=visit.toJson()..removeWhere((key, value) => value == null);
    final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitFemaleVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitRegularVisit(RegularVisitModel visit,String acceptTerms) async {
    try{
      dynamic vals=visit.toJson()..removeWhere((key, value) => value == null);
     final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitOndemandVisit(RegularVisitModel visit,String acceptTerms) async {
    try{
      dynamic vals=visit.toJson()..removeWhere((key, value) =>  value == null || key == "khatib_present");
    final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitOndemandVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitJummaVisit(int? visitId,VisitJummaModel visit,String acceptTerms) async {
    try{
      dynamic vals = visit.toJson()
        ..removeWhere((key, value) => value == null);

      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitJummaVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitLandVisit(VisitLandModel visit,String acceptTerms) async {
    try{
      dynamic vals=visit.toJson()..removeWhere((key, value) =>  value == null);
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitLandVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> submitEidVisit(VisitEidModel visit,String acceptTerms) async {
    try{
      dynamic vals=visit.toJson()..removeWhere((key, value) =>  value == null);
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {"visit_id": visit.id,
          "visit_vals": vals,
          "accept_terms":acceptTerms
        }
      };
    final response = await service.submitEidVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  
  //region for action taken
  Future<dynamic> acceptRegularVisit(VisitModelBase visit,String acceptTerms) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "accept_terms":acceptTerms,
          "stage_name":visit.stage,
        }
      };
    final response = await service.acceptVisit(pram);

    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> takeActionRegularVisit(VisitModelBase visit,TakeVisitActionModel action) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "action_taken": true,
          "action_notes": action.notes,
          "action_attachments": action.actionAttachments.map((item) => {  "name": item.name,"data":item.base64} ).toList(),
          "trasol_number": action.trasolNumber,
          "action_taken_type_id": action.actionTakenTypeId,
          "action_granted": action.actionGranted,
          "accept_terms": action.disclaimer,

          "stage_name": visit.stage
        }
      };
      print(pram);
      final response = await service.actionTakenRegularVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> onUnderProgressRegularVisit(VisitModelBase visit) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "visit_vals": {"underprogress": true}
        }
      };
      final response = await service.underProgressRegularVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> acceptOndemandVisit(VisitModelBase visit,String acceptTerms) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "accept_terms":acceptTerms,
          "stage_name":visit.stage,
        }
      };
    final response = await service.acceptOndemandVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> takeActionOndemandVisit(VisitModelBase visit,TakeVisitActionModel action) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "action_taken": true,
          "action_notes": action.notes,
          "action_attachments": action.actionAttachments.map((item) => {  "name": item.name,"data":item.base64} ).toList(),
          "trasol_number": action.trasolNumber,
          "action_taken_type_id": action.actionTakenTypeId,
          "action_granted": action.actionGranted,
          "accept_terms": action.disclaimer,
          "stage_name": visit.stage
        }
      };
      final response = await service.actionTakenOndemandVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> onUnderProgressOndemandVisit(VisitModelBase visit) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "visit_vals": {"underprogress": true}
        }
      };
      final response = await service.underProgressOndemandVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> acceptJummaVisit(VisitModelBase visit,String acceptTerms) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "accept_terms":acceptTerms,
          "stage_name":visit.stage,
        }
      };
    final response = await service.acceptJummaVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> takeActionJummaVisit(VisitModelBase visit,TakeVisitActionModel action) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "action_taken": true,
          "action_notes": action.notes,
          "action_attachments": action.actionAttachments.map((item) => {  "name": item.name,"data":item.base64} ).toList(),
          "trasol_number": action.trasolNumber,
          "action_taken_type_id": action.actionTakenTypeId,
          "action_granted": action.actionGranted,
          "accept_terms": action.disclaimer,
          "stage_name": visit.stage
        }
      };
      final response = await service.actionTakenJummaVisit(pram);
      return response['result'];
    }catch(e){
      throw e;

    }
  }

  Future<dynamic> onUnderProgressJummaVisit(VisitModelBase visit) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "visit_vals": {"underprogress": true}
        }
      };
      final response = await service.underProgressJummaVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> acceptFemaleVisit(VisitModelBase visit,String acceptTerms) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "accept_terms":acceptTerms,
          "stage_name":visit.stage,
        }
      };
    final response = await service.acceptFemaleVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> takeActionFemaleVisit(VisitModelBase visit,TakeVisitActionModel action) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "action_taken": true,
          "action_notes": action.notes,
          "action_attachments": action.actionAttachments.map((item) => {  "name": item.name,"data":item.base64} ).toList(),
          "trasol_number": action.trasolNumber,
          "action_taken_type_id": action.actionTakenTypeId,
          "action_granted": action.actionGranted,
          "accept_terms": action.disclaimer,
          "stage_name": visit.stage
        }
      };
      final response = await service.actionTakenFemaleVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> onUnderProgressFemaleVisit(VisitModelBase visit) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "visit_vals": {"underprogress": true}
        }
      };
      final response = await service.underProgressFemaleVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> acceptEidVisit(VisitModelBase visit,String acceptTerms) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "accept_terms":acceptTerms,
          "stage_name":visit.stage,
        }
      };
    final response = await service.acceptEidVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> takeActionEidVisit(VisitModelBase visit,TakeVisitActionModel action) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "action_taken": true,
          "action_notes": action.notes,
          "action_attachments": action.actionAttachments.map((item) => {  "name": item.name,"data":item.base64} ).toList(),
          "trasol_number": action.trasolNumber,
          "action_taken_type_id": action.actionTakenTypeId,
          "action_granted": action.actionGranted,
          "accept_terms": action.disclaimer,
          "stage_name": visit.stage
        }
      };
      final response = await service.actionTakenEidVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> onUnderProgressEidVisit(VisitModelBase visit) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "visit_vals": {"underprogress": true}
        }
      };
      final response = await service.underProgressEidVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> acceptLandVisit(VisitModelBase visit,String acceptTerms) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "accept_terms":acceptTerms,
          "stage_name":visit.stage,
        }
      };
    final response = await service.acceptLandVisit(pram);
    return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> takeActionLandVisit(VisitModelBase visit,TakeVisitActionModel action) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "action_taken": true,
          "action_notes": action.notes,
          "action_attachments": action.actionAttachments.map((item) => {  "name": item.name,"data":item.base64} ).toList(),
          "trasol_number": action.trasolNumber,
          "action_taken_type_id": action.actionTakenTypeId,
          "action_granted": action.actionGranted,
          "accept_terms": action.disclaimer,
          "stage_name": visit.stage
        }
      };
      final response = await service.actionTakenLandVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }


  Future<dynamic> onUnderProgressLandVisit(VisitModelBase visit) async {
    try{
      final pram = {
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "visit_id": visit.id,
          "visit_vals": {"underprogress": true}
        }
      };
      final response = await service.underProgressLandVisit(pram);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  //endregion

  Future<RegularVisitModel> getRegularVisitDetail(int visitId,String url,String name,RegularVisitModel visit) async {
    try{
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getVisitDetail(queryParams,url);
      visit.mergeJson(response["result"]);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitFemaleModel> getFemaleVisitDetail(int visitId,String url,String name,VisitFemaleModel visit) async {
    try{
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getVisitDetail(queryParams,url);
      visit.mergeJson(response["result"]);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitJummaModel> getJummaVisitDetail(int visitId,String url,String name,VisitJummaModel visit) async {
    try{
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getVisitDetail(queryParams,url);
      visit.mergeJson(response["result"]);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitOndemandModel> getOndemandVisitDetail(int visitId,String url,String name,VisitOndemandModel visit) async {
    try{
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getVisitDetail(queryParams,url);
      visit.mergeJson(response["result"]);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitLandModel> getLandVisitDetail(int visitId,String url,String name,VisitLandModel visit) async {
    try{
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getVisitDetail(queryParams,url);
      visit.mergeJson(response["data"]);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<VisitEidModel> getEidVisitDetail(int visitId,String url,String name,VisitEidModel visit) async {
    try{
      final queryParams = {
        'visit_id': visitId
      };
      final response = await service.getVisitDetail(queryParams,url);
      visit.mergeJson(response["data"]);
      return visit;
    }catch(e){
      throw e;
    }
  }

  Future<PrayerTime?> getTodayPrayerTime(int cityId) async {
    try{
       PrayerTime? currentPrayerTime;
      //warning commit this line
      // await HiveRegistry.prayerTime.clear();
      currentPrayerTime = await HiveRegistry.prayerTime.get(PrayerTime.getCurrentDateHiveId(cityId));
      if(currentPrayerTime==null){
        List<PrayerTime>? data;
        await HiveRegistry.prayerTime.clear();
        final response = await service.getTodayPrayerTime();
        data=(response['data']['prayer_data'] as List).map((item) => PrayerTime.fromJsonFile(item)).toList();
        String? id=JsonUtils.toText(response['data']);
        for (var prayer in data) {
          await HiveRegistry.prayerTime.put(prayer.getHiveId(id),prayer);
        }
        currentPrayerTime = data.where((a)=>a.cityId==cityId).firstOrNull;
      }
      return currentPrayerTime;
    }catch(e){
      throw e;
    }
  }

  Future<List<ComboItem>> getOndemandMosques(int pageIndex,int limit,String query) async{
    List<ComboItem> data=[];
    try{
      final queryParams = {
        'query': query,
        'page': pageIndex,
        'limit': limit,
      };
      final response = await service.getOndemandMosques(queryParams);

      if(response['status']==200){
        data=(response['mosques'] as List).map((item) => ComboItem.fromJsonObject(item)).toList();
      }else{
        throw response['message'];
      }
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<ComboItem>> getOndemandObservers(int pageIndex,int limit,String query) async{
    List<ComboItem> data=[];
    try{

      final queryParams = {
        'query': query,
        'page': pageIndex,
        'limit': limit,
      };
      final response = await service.getOndemandObservers(queryParams);
      if(response['status']==200){
        data=(response['data'] as List).map((item) => ComboItem.fromJsonObject(item)).toList();
      }else{
        throw response['message'];
      }

      return data;
    }catch(e){
      throw e;
    }
  }

  Future<VisitResponse?> createVisit(VisitOndemandModel visit) async{
    VisitResponse? res;
    try{
      final json = {
        "visit_vals": {
          'employee_id': visit.employeeId,
          'mosque_id': visit.mosqueId,
          'prayer_name': visit.prayerName,
          'deadline_date': visit.deadlineDate,
        }
      };
      final response = await service.createVisit(json);
      if(response['success']==true){
        res=VisitResponse.fromJson(response);
        return res;
      }else{
        throw response['message'];
      }
    }catch(e){
      throw e;
    }
  }


}


class VisitResponse{
  String? message;
  VisitOndemandModel visit;

  VisitResponse({this.message,required this.visit});

  factory VisitResponse.fromJson(Map<String, dynamic> json) {
    final result =json  ?? {};
    return VisitResponse(
      message: result['message'],
      visit: VisitOndemandModel.fromJsonAfterCreate(result['visit']??{}),
    );
  }
}