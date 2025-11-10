import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/app_version.dart';
import 'package:mosque_management_system/core/models/center.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/device_info.dart';
import 'package:mosque_management_system/core/models/distract.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/employee_category.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/models/menuRights.dart';
import 'package:mosque_management_system/core/models/meter.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_region.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/core/models/prayer_time_clock.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/models/res_partner.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/user_notification.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/odoo_service.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/device_detail.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/hive/hive_registry.dart';

class UserService extends OdooService{
  // late CommonRepository _repository;
  //CommonRepository get repository => _repository;

  UserService(CustomOdooClient client,{UserProfile? userProfile}): super(client,userProfile:userProfile ) {
    //_repository = CommonRepository(client);
  }

  void updateUserProfile(UserProfile userProfile){
    repository.userProfile=userProfile;
  }
  Future<Employee> createEmployee(Employee mosque,int mousqueId) async {
    try {
      var _domain=[];

      dynamic response = await repository.createEmployee(mosque,mousqueId);
      mosque.id=response;

      return mosque;
    }on Exception catch (e){
      throw e;
    }

  }

  //region for

  //region for notification
  Future<UserNotificationData> getNotifications(int pageSize,int pageIndex) async {
    try {
      dynamic _domain={
        "pageSize": pageSize,
        "pageIndex": pageIndex-1
      };
      UserNotificationData obj =UserNotificationData();
      dynamic response = await repository.callAPI(apiUrl: "/moia/get/all_notifications",domain: _domain);
      obj.list=(response["notifications"] as List).map((item) => UserNotification.fromJson(item)).toList();
      return obj;
    }catch(e){
      throw e;
    }



  }

  Future<int> getNotificationCountAPI() async {
    int totalCount=0;
    try {
      dynamic response = await repository.getNotificationCount();
      totalCount=JsonUtils.toInt(response["unread_count"])??0;
      return totalCount;
    }catch(e){
      return 0;
      throw e;
    }

  }

  Future<bool> unreadNotificationAPI(int id) async {
    try {
      dynamic _dynamic={
        "notif_id" : id
      };
      dynamic response = await repository.callAPI(apiUrl: "/moia/mark/notification_read",domain: _dynamic);
      return true;
    }catch(e){
      throw e;
    }
  }

  //endregion

  //#region for khutbas
  Future<KhutbaManagementData> getAllKhutbas(int pageSize,int pageIndex,String query) async {
    try {
      KhutbaManagementData data =KhutbaManagementData();
      var _domain=[];
      dynamic response = await repository.searchReadWithPaging(model: Model.khutbaManagement,
          fields: ["name","khutba_date","description"],
          domain: [],
          pageIndex: pageIndex,
          pageSize: pageSize,orderBy: "khutba_date desc"
      );
      data.list=(response as List).map((item) => KhutbaManagement.fromJson(item)).toList();
      return data;
    }catch(e){
      throw e;
    }

  }

  Future<KhutbaManagement?> getKhutbaDetail(int id) async {
    try {
      KhutbaManagement obj =KhutbaManagement();
      dynamic response = await repository.read(model: Model.khutbaManagement,domain: [id],fields: ["name","khutba_date","description","guideline_1","guideline_2","guideline_3"
        ,"guideline_4","guideline_5","write_date","is_khutba_eid","attachment"]);

      if(response.length>0)
        obj = KhutbaManagement.fromJson(response[0]);
      else
        return null;
      return obj;
    }catch(e){
      throw e;
    }

  }


  Future<List<FieldList>> loadKhutbaView() async {
    try {
      List<FieldList> data=[];
      dynamic response = await repository.loadView(model: Model.khutbaManagement);
      FieldList itemData=FieldList(field: "");
      (response as Map<String, dynamic>).forEach((key, value) {
        itemData=FieldList();
        itemData=FieldList.fromStringJson(key,value);
        data.add(itemData);

      });
      return data;
    }catch(e){
      throw Response("error", 408);
    }

  }

  //endregion

  Future<List<FieldList>> loadEmployeeView() async {
    try {
      List<FieldList> data=[];
      dynamic response = await repository.loadView(model: Model.employee);
      FieldList itemData=FieldList(field: "");
      (response as Map<String, dynamic>).forEach((key, value) {
        itemData=FieldList();
        itemData=FieldList.fromStringJson(key,value);
        data.add(itemData);

      });
      return data;
    }catch(e){
      throw Response("error", 408);
    }

  }

  Future<bool> authenticate(String dbName, String username, String password) async {
    return true;
  }

  Future<dynamic> getEmployeeDetail() async {
    try {
      dynamic response = await repository.getEmployeeDetail();
     
      return response;
    }catch(e){
      throw Response("error", 408);
    }

  }
  Future<List<Employee>> getEmployeesByIds(List<int> ids) async {
    List<Employee> partners=[];
    try {

      dynamic response = await repository.getEmployeeByIds(ids);
      partners=(response as List).map((item) => Employee.fromJson(item)).toList();
      return partners;
    }catch(e){
      throw e;
    }

  }
  Future<List<Employee>> getEmpPublicByIds(List<int> ids) async {
    List<Employee> partners=[];
    try {
      dynamic response = await repository.getEmpPublicByIds(ids);
      partners=(response as List).map((item) => Employee.fromJson(item)).toList();
      return partners;
    }catch(e){
      throw e;
    }
  }
  // Future<List<Employee>> getEmployeesByIds(List<int> ids) async {
  //   List<Meter> list=[];
  //   try {
  //     dynamic response = await repository.getDashboardAPI();
  //
  //     return response;
  //   }catch(e){
  //     throw e;
  //   }
  //
  // }
  Future<List<ResPartner>> getPartnerByIds(List<int> ids) async {
    List<ResPartner> partners=[];
    try {

      dynamic response = await repository.getPartnerByIds(ids);
      partners=(response as List).map((item) => ResPartner.fromJson(item)).toList();
      return partners;
    }catch(e){
      throw Response("error", 408);
    }

  }


  Future<List<MoiCenter>> getCenter(int pageSize,int pageIndex,int cityId,String query) async {
    List<MoiCenter> regions=[];
    try {
      dynamic response = await repository.getCenter(pageSize,pageIndex,cityId,query);
      regions=(response as List).map((item) => MoiCenter.fromJson(item)).toList();
      return regions;
    }catch(e){
      throw Response("error", 408);
    }

  }

  Future<List<Region>> getRegions(int pageSize,int pageIndex,String query,int countryId) async {
    List<Region> regions=[];
    try {
      dynamic response = await repository.getRegions(pageSize,pageIndex,query,countryId);
      regions=(response as List).map((item) => Region.fromJson(item)).toList();
      return regions;
    }catch(e){
      throw e;
    }

  }

  Future<List<City>> getCities(int pageSize,int pageIndex,int? regionId,String query) async {
    List<City> items=[];
    try {
      dynamic response = await repository.getCities(pageSize,pageIndex,regionId,query);
      items=(response as List).map((item) => City.fromJson(item)).toList();
      return items;
    }catch(e){
      throw e;
    }

  }

  Future<List<Distract>> getDistracts(int pageSize,int pageIndex,String query) async {
    List<Distract> items=[];
    try {
      dynamic response = await repository.getDistracts(pageSize,pageIndex,query);
      items=(response as List).map((item) => Distract.fromJson(item)).toList();
      return items;
    }catch(e){
      throw Response("error", 408);
    }

  }

  Future<List<Employee>> getMosqueObservors(int pageSize,int pageIndex,String query,String type) async {
    List<Employee> items=[];
    try {
      dynamic domain=[];

      if(type=='obs'){
        domain=[
          '&',
          '&',
          ["classification_id.code",
            "=",
            type
          ],
          [
            "parent_id",
            "=",
            false
          ],
          [
            "name",
            "ilike",
            query??""
          ]
        ];
      }else{
        domain=[
          '&',
          [
            "category_ids.type",
            "=",
            type
          ],
          [
            "name",
            "ilike",
            query??""
          ]
        ];
      }

      dynamic response = await repository.getMosqueUser(pageSize,pageIndex,domain);
      items=(response as List).map((item) => Employee.fromJsonSearch(item)).toList();
      return items;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<List<Employee>> getMosqueUser(int pageSize,int pageIndex,String query,String type,int? supervisorId,{List<int>? ids}) async {
    List<Employee> items=[];
    try {
      dynamic domain=[];

      if(ids!=null) {
        domain=[
          '&',
          '|',
          [
            "name",
            "ilike",
            query??""
          ],
          [
            "identification_id",
            "ilike",
            query??""
          ],
          [
            "id",
            "in",
            ids
          ],

        ];
      }
      else if(type=='obs'){
        domain=[
          '&',
          '&',
          '|',
          [
            "name",
            "ilike",
            query??""
          ],
          [
            "identification_id",
            "ilike",
            query??""
          ],
           ["classification_id.code",
            "=",
            type
          ],
          [
            "parent_id",
            "=",
            supervisorId??false
          ],
        ];
      }else if(type=='employee'){
        domain=[
          '&',
          '|',
          [
            "name",
            "ilike",
            query??""
          ],
          [
            "identification_id",
            "ilike",
            query??""
          ],
          ["user_id", "!=", false]
        ];
      }else{
        domain=[
          '&',
          '|',
          [
            "name",
            "ilike",
            query??""
          ],
          [
            "identification_id",
            "ilike",
            query??""
          ],
          [
            "category_ids.type",
            "=",
            type
          ],

        ];
      }


      dynamic response = await repository.getMosqueUser(pageSize,pageIndex,domain);
      items=(response as List).map((item) => Employee.fromJsonSearch(item)).toList();
      return items;
    }on Exception catch (e){
      throw e;
    }

  }

  Future<List<ComboItem>> getClassification() async {
    List<ComboItem> items=[];
    try {
      dynamic _payload={
        "args": [],
        "model": "mosque.classification",
        "method": "name_search",
        "kwargs": {
          "name": "",
          "args": [],
          "operator": "ilike",
          "limit": 8,
          "context": {
            "lang": "en_US",
            "tz": "Asia/Riyadh",
            "uid": 2,
            "allowed_company_ids": [
              1
            ]
          }
        }
      };
      dynamic response = await repository.getComboList(_payload);
      items=(response as List).map((item) => ComboItem.fromJson(item)).toList();
      return items;
    }catch(e){
      throw Response("error", 408);
    }

  }

  Future<List<ComboItem>> getMosqueType() async {
    List<ComboItem> items = [];
    try {
      dynamic _payload = {
        "args": [],
        "model": "mosque.type", // ✅ Your model name for mosque type
        "method": "name_search",
        "kwargs": {
          "name": "",
          "args": [],
          "operator": "ilike",
          "limit": 8,
          "context": {
            "lang": "en_US",
            "tz": "Asia/Riyadh",
            "uid": 2,
            "allowed_company_ids": [1]
          }
        }
      };

      dynamic response = await repository.getComboList(_payload);

      items = (response as List).map((item) => ComboItem.fromJson(item)).toList();

      return items;
    } catch (e) {
      throw Response("error", 408);
    }
  }

  Future<List<EmployeeCategory>> getEmployeeCategory() async {

    List<EmployeeCategory> items=[];
    try {
      dynamic response = await repository.getEmployeeCategory();
      items=(response as List).map((item) => EmployeeCategory.fromJson(item)).toList();
      return items;
    }catch(e){
      throw Response("error", 408);
    }

  }

  Future<List<EmployeeCategory>> getEmployeeCategoryIds({List<int>? ids}) async {

    List<EmployeeCategory> items=[];
    try {

      dynamic response = await repository.getEmployeeCategoryByIds(ids??[]);
      items=(response as List).map((item) => EmployeeCategory.fromJson(item)).toList();
      return items;
    }catch(e){
      throw e;
    }

  }

  Future<List<ResPartner>> getPartner(int pageSize,int pageIndex,String? query) async {
    List<ResPartner> items=[];
    try {
      dynamic _domain=[];
      if(query!='' && query!.isNotEmpty)
        _domain=[
          [
            "display_name",
            "ilike",
            query
          ]
        ];
      dynamic response = await repository.getAllPartners(pageSize,pageIndex,_domain);
      items=(response as List).map((item) => ResPartner.fromJson(item)).toList();
      return items;
    }on Exception catch (e){
      throw e;
    }

  }

  // Future<PrayerTime?> getCurrentPrayer(int cityId) async {
  //   PrayerTime? time;
  //   try {
  //     dynamic _domain=[];
  //
  //     dynamic response = await repository.getPrayerTime(_domain);
  //
  //     if(response.length>0)
  //       time=PrayerTime.fromJson(response[0]);
  //
  //     return time;
  //   }on Exception catch (e){
  //     throw e;
  //   }
  //
  // }
  //

  // Future<PrayerTimeClock> getPrayerTime() async {
  //   PrayerTimeClock time;
  //   try {
  //     dynamic response = await repository.getPrayerTime();
  //
  //     time=PrayerTimeClock.fromJson(response['prayer_data'],response['prayer_date']);
  //     return time;
  //   }catch(e){
  //     throw e;
  //   }
  //
  // }

  Future<PrayerTimeClock?> getPrayerTime() async {
    PrayerTimeClock? time;
    try {
      // dynamic response = await repository.getPrayerTime();
      //
      // time=PrayerTimeClock.fromJson(response['prayer_data'],response['prayer_date']);
      return time;
    }catch(e){
      throw e;
    }
  }

  Future<List<PrayerTime>> getTodayPrayerTime() async {
    List<PrayerTime>? data;
    try {
      dynamic response = await repository.getTodayPrayerTime();
      data=(response['data']['prayer_data'] as List).map((item) => PrayerTime.fromJsonFile(item)).toList();
      String? id=response['data']['prayer_date'];
      await HiveRegistry.prayerTime.clear();
      for (var prayer in data) {
        await HiveRegistry.prayerTime.put(prayer.getHiveId(id),prayer);
      }
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> getDashboardAPI() async {
    List<Meter> list=[];
    try {
      dynamic response = await repository.getDashboardAPI();

      return response;
    }catch(e){
      throw e;
    }

  }

  Future<dynamic> getMasjidSummaryAPI() async {
    List<Meter> list=[];
    try {

      dynamic response = await repository.getMasjidSummaryAPI();

      return response;
    }catch(e){
      throw e;
    }

  }


  Future<dynamic> getVisitSummaryAPI() async {
    List<Meter> list=[];
    try {

      dynamic response = await repository.callAPI(apiUrl: "/overall/old_visits");
      if(response["status"]==200){
        return response["oldVisitRequest"];
      }else{
        throw response["message"];
      }
    }catch(e){
      throw e;
    }

  }

  Future<dynamic> getVisitMonthlySummaryAPI() async {
    List<Meter> list=[];
    try {

      dynamic response = await repository.callAPI(apiUrl: "/oldvisit/monthly/view");
      if(response["status"]==200){
        return response["oldVisitRequest"];
      }else{
        throw response["message"];
      }
    }catch(e){
      throw e;
    }

  }

  Future<List<DeviceInformation>> getUserImei(int userId) async {
    List<DeviceInformation> items=[];
    try {

      dynamic response = await repository.getUserImei(userId);
      items=(response as List).map((item) => DeviceInformation.fromJson(item)).toList();
      return items;
    }catch(e){
      throw e;
    }

  }

  // Future<bool> saveImei(DeviceInformation device) async {
  //   List<DeviceInformation> items=[];
  //   try {
  //
  //     dynamic response = await repository.saveImei(device);
  //     return true;
  //   }on Exception catch (e){
  //     throw e;
  //   }
  //
  // }
  Future<void> saveImei(DeviceInformation device) async {
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);

    final Map<String, dynamic> params = {
      "status": device.status,
      "employee_id": device.employeeId,
      "device_name": device.name,
      "device_os": device.os,
      "os_version": device.osVersion,
      "make": device.make,
      "model": device.model,
      "imei": device.imei,
    };

    try {
      final response = await client.post(
        '/post/app/device/info',
        params, // 🟢 THIS IS THE KEY: wrap inside "params"
      );


      if (response == null) throw Exception('No response from server');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Unknown error');
      }

    } catch (e) {
      rethrow;
    }

  }

  Future<bool> updateToken(String? token) async {

    try{
      dynamic _payload={
        "data": {
          "token": token??"",
        }
      };
      dynamic response = await repository.callAPI(apiUrl: "/api/update_fcm_token",domain: _payload);
      return response['result'];
    }catch(e){
      throw e;
    }
  }

  Future<MenuRights> getMenuRightsAPI() async {
    MenuRights object;
    try {

      dynamic response = await repository.getMenuRights();
      response['mosqueRequest'];
      object=MenuRights.fromJson(response['mosqueRequest']);

      return object;
    }catch(e){
      throw Response("error", 408);
    }

  }

  Future<Attachment?> uploadAttachment(String path) async {

    File file = File(path);
    Attachment? attachment;
    var urlToOpen="${repository.client.baseURL}/web/binary/upload_attachment";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(urlToOpen),
    );
    //request.headers.addAll(headersMap);
    request.fields['model'] = 'hr.leave';
    request.fields['csrf_token'] = csrfToken;
    request.fields['id'] = "0";
    request.fields['ufile'] = "";
    request.files.add(
      await http.MultipartFile.fromPath(
        'ufile',
        path,
      ),
    );
    var response = await request.send();
    if (response.statusCode == 200) {
      var result=await response.stream.bytesToString();

      attachment=Attachment.fromJson(json.decode(result)[0]);

      return attachment;

    } else {

      String error=await response.stream.bytesToString();

      throw error;
      return attachment;
    }

  }

  Future<List<Attachment>> getAllAttachment(List<int> ids) async {
    List<Attachment> list=[];
    try {
      dynamic response = await repository.getAllAttachment(ids);
      list=(response as List).map((item) => Attachment.fromJson(item)).toList();
      return list;
    }catch(e){

      throw e;
    }

  }

  Future<AppVersion?> getAppVersion() async {
    AppVersion? version;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    List<Attachment> list=[];
    try {

      dynamic response = await repository.getAppVersion(Platform.isIOS?"ios":"android");
   

      version=AppVersion.fromJson(response[0]);

      //version.localVersion ="2.0.2";
      version.localVersion =packageInfo.version;
     return version;
    }catch(e){
      
      throw e;
    }
  }

  Future<void> updateAppVersion(dynamic currentVersion) async {

    try{
      await PackageInfo.fromPlatform().then((value) async{

        if(AppUtils.isNotNullOrEmpty(value.version) ){

          await  DeviceDetail().getImei().then((deviceDetail) async{
            if(currentVersion!=(value.version)){
              dynamic response =  await repository.updateAppVersion(value.version);
              //dynamic response =  repository.updateAppVersion((deviceDetail!.name??"")+' | '+value.version);
            }
          });
        }
      });
    }catch(e){
      throw e;
    }
  }

  /// Get cached CRM user info
  Future<UserProfile?> getCachedCrmUserInfo() async {
    try {
      int? userId = repository.userProfile.userId;

      final cacheKey = 'crmUserInfo_user_$userId';
      print(cacheKey);

      UserProfile? userProfile = await HiveRegistry.crmUserInfo.get(userId);
      print('userProfile');
      print(userProfile?.name);
      if (userProfile != null) {
        return userProfile;
      }
    } catch (e) {
        print(e);
    }
    return null;
  }

  /// Fetch and cache CRM user info (regions, cities, centers) - called on login
  Future<UserProfile> fetchAndCacheCrmUserInfo(bool? isDeviceRegistered) async {
    try {
      final response = await repository.getCrmUserInfo();
      final userInfo = UserProfile.fromJson(response);
      userInfo.isDeviceVerify=isDeviceRegistered;
      await HiveRegistry.crmUserInfo.put(userInfo.userId, userInfo);

      print('userProfile3');
      print(userInfo.name);

      return userInfo;
    }
    catch (e) {
      rethrow;
    }
  }
}