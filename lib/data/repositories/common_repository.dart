import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/app_version.dart';
import 'package:mosque_management_system/core/models/device_info.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_region.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:sentry_flutter/sentry_flutter.dart';


import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';


class CommonRepository {
  late CustomOdooClient client;
  late UserProfile _userProfile;

  void dispose(){
    client.dio.close();
  }

  CommonRepository(client,{UserProfile? userProfile}){
    this.client = client;
    if(userProfile!=null)
      this._userProfile=userProfile;
  }
  set userProfile(UserProfile user) {
    _userProfile = user;
  }

  // Getter for age
  UserProfile get userProfile => _userProfile;

  //region For User Service

  Future<dynamic> getEmployeeDetail() async {
    // final stopwatch = Stopwatch()..start();  // ✅ define it!

    try {
      final response = await client.post("/moia/get/employee/profile", {});
      // stopwatch.stop();                      // ✅ stop it

      // if (stopwatch.elapsedMilliseconds > 200) {
      //   await Sentry.captureMessage(
      //     'getEmployeeDetail slow response: ${stopwatch.elapsedMilliseconds}ms',
      //   );
      // }

      return response;
    } catch(e){
      throw e;
    }
  }

  // Future<dynamic> getEmployeeDetail() async {
  //   try {
  //     dynamic response = await client.post("/moia/get/employee/profile",{});
  //     return response;
  //   }catch (error, stackTrace) {
  //     // ✅ Log to Sentry
  //     await Sentry.captureException(
  //       error,
  //       stackTrace: stackTrace,
  //       message: SentryMessage('getEmployeeDetail error')
  //
  //     );
  //     rethrow;
  //   }
  // }


  Future<UserProfile> getUserInfoAPI(dynamic language) async {
    print('getUserInfoAPI');
    UserProfile userInfo;
    try {
      dynamic _payload={
        "fields": ["name",
          // "job_title","__last_update","employee_ids","partner_id",
        "company_id", "employee_id","user_app_version"],//,"fcm_token"
        "lang": language
      };
      dynamic response = await client.post("/moia/get/user",_payload);
      // print(response);
      userInfo=UserProfile.fromJson(response[0]);
      return userInfo;
    } catch(e){
      throw e;
    }
  }

  Future<UserProfile> getUserInfo(dynamic userId) async {

    UserProfile userInfo;
    try{
      dynamic _payload={
        'model': 'res.users',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          "context":{"allowed_company_ids":[1]},
          'domain': [['id','=',userId]],
          'fields': ['name','job_title','__last_update','employee_id','partner_id','company_id'],
          'limit': 1,
        },
      };

      dynamic response = await client.callKwCustom(_payload);



      userInfo=UserProfile.fromJson(response[0]);
      return userInfo;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> updateAppVersion(dynamic appVersion) async {

    try{
      dynamic _payload={
        "args": [
          [
            _userProfile.userId
          ],
          {
            "user_app_version": appVersion
          }
        ],
        "model": "res.users",
        "method": "write",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
          }
        }
      };

      dynamic response = await client.callKwCustom(_payload);
      return response;
    }catch(e){
      throw e;
    }
  }

  //
  // Future<List<dynamic>> getEmployeeByIds(List<int> ids) async {
  //
  //   try{
  //
  //     dynamic pram={
  //       "args": [
  //         ids,
  //         [
  //           "display_name"
  //         ]
  //       ],
  //       "model": "hr.employee",
  //       "method": "read",
  //       "kwargs": {
  //         "context": {
  //           "lang": _userProfile.language,
  //           "tz": "Asia/Riyadh",
  //           // "uid": _userProfile.userId,
  //           "allowed_company_ids": [
  //             _userProfile.companyId
  //           ],
  //         }
  //       }
  //     };
  //
  //     dynamic response = await client.callKwCustom(pram);
  //
  //     return response;
  //   }on OdooSessionExpiredException {
  //     throw Response("error", 408);
  //   }catch(e){
  //
  //     throw Response("error", 408);
  //
  //   }
  //
  // }

  Future<dynamic> getEmployeeByIds(List<int> ids) async {
    try {
      dynamic _payload={
        "id":ids
      } ;
      dynamic response = await client.post("/moia/get/employee",_payload);
      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }
  Future<dynamic> getEmpPublicByIds(List<int> ids) async {

    try{
      dynamic _payload={
        'model': 'hr.employee.public',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "allowed_company_ids": [
              _userProfile.companyId,
            ],
            "bin_size": true
          },
          'domain':[["id","in",ids]],
          'fields': ['id', 'display_name'],
          'limit': 99,
          "offset" :  0
        },
      };
      dynamic response = await client.callKwCustom(_payload);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<List<dynamic>> getPartnerByIds(List<int> ids) async {

    try{
      dynamic response = await client.callKwCustom({
        "args": [
          ids,
          [
            "id",
            "name",
            "title",
          ]
        ],
        "model": "res.partner",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
          }
        }
      });
   
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
    
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getAllPartners(int pageSize,int pageIndex,dynamic? domain) async {
    
    try{
     
      dynamic _payload={
        'model': 'res.partner',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId,
            ],
            "bin_size": true
          },

          'domain':domain,
          'fields': ['id', 'display_name'],
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          "order":"display_name"
        },
      };
   
      dynamic response = await client.callKwCustom(_payload);
   
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
   
      throw e;

    }

  }

  Future<List<dynamic>> getRegions(int pageSize,int pageIndex,String? query,int countryId) async {

    try{
   
      dynamic _payload={
        'model': 'res.country.state',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId,
            ],
            "bin_size": true
          },
          'domain': [
            "&",
            "&",
            [
              "country_id",
              "=",
              countryId
            ],
            [
              "branch_id",
              "!=",
              false
            ],
            [
              "name",
              "ilike",
              query??""
            ]
          ],
          'fields': ["name", "code", "country_id"],
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          "order":"name"

        },
        "sort":""
      };

      dynamic response = await client.callKwCustom(_payload);

      return response;
    }on OdooException catch (e) {


      throw e;
    } catch (e) {

      throw e;
    }

  }

  Future<List<dynamic>> getCenter(int pageSize,int pageIndex,int cityId,String? query) async {

    try{
    
      dynamic _payload={
        'model': 'moia.center',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
          'domain': [
            "&",
            ["city_id", "=", cityId],
            [
              "name",
              "ilike",
              query??""
            ]
          ],
          'fields': [
            "name",
             // "country_state_id",
            // "city_id",
             "center_code"
          ],
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          "order":"name"
        },
      };
     
      dynamic response = await client.callKwCustom(_payload);
     
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
     
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getDistracts(int pageSize,int pageIndex,String? query) async {
    
    try{
   
      dynamic _payload={
        'model': 'res.distracts',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
          'domain': [
            [
              "name",
              "ilike",
              query??""
            ]
          ],
          'fields': [
            "code",
            "distract_code",
            "name",
            // "city_id"
          ],
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          "order":"name"

        },
        "sort":""
      };
 
      dynamic response = await client.callKwCustom(_payload);
     
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
   
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getCities(int pageSize,int pageIndex,int? regionId,String? query) async {
   
    try{
 
      dynamic _payload={
        'model': 'res.city',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
          'domain': [
            "&",
            [
              "state_id",
              "=",
              regionId
            ],
            [
              "name",
              "ilike",
              query??""
            ]
          ],
          'fields': [
            "name",
            "zipcode",
            "country_id",
            "state_id"
          ],
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          "order":"name"

        },
        "sort":""
      };

    
      dynamic response = await client.callKwCustom(_payload);
    
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
     
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getMosqueUser(int pageSize,int pageIndex,dynamic domain) async {
  
    try{
     
      dynamic _payload={
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': domain,
          'fields': ['id', 'name','identification_id',"__last_update"],
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          "order":"name"
        },
      };


      dynamic response = await client.callKwCustom(_payload);
   
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
   
      throw e;

    }

  }

  Future<List<dynamic>> getComboList(dynamic payload) async {
    try{
      dynamic response = await client.callKwCustom(payload);
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
  
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getEmployeeCategory() async {
 
    try{

      dynamic _payload={
        'model': 'hr.employee.category',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [

          ],
          'fields': ['display_name','id','color','type'],
          'limit': 100,
          // "offset" :  ((pageIndex-1)*pageSize),
          "order":"name"
        },
      };


      dynamic response = await client.callKwCustom(_payload);
  
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
     
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getEmployeeCategoryByIds(List<int> ids) async {

    try{

      dynamic _payload={
        "args": [
          ids,
          [
            "display_name",
            "type",
            "color"
          ]
        ],
        "model": "hr.employee.category",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "chat_icon": true
          }
        }
      };

      dynamic response = await client.callKwCustom(_payload);

      return response;
    }catch(e){

      throw e;

    }

  }
  //endregion

  //region for security

  // Future<List<dynamic>> getUserImei(int employeeId) async {
  //
  //   try{
  //
  //     dynamic _payload={
  //       'model': 'employee.app.device',
  //       'method': 'search_read',
  //       'args': [],
  //       'kwargs': {
  //         'context': {'bin_size': true},
  //         //'domain': ["|",["employee_id",_userProfile.employeeId,],["imei","=",imei]],
  //         'domain': [["employee_id","=",employeeId]],
  //         'fields': [
  //           "id",
  //           "device_name",
  //           "device_os",
  //           "os_version",
  //           "status",
  //           "imei"
  //         ],
  //       },
  //     };
  //
  //     dynamic response = await client.callKwCustom(_payload);
  //
  //     return response;
  //   }catch(e){
  //
  //     throw e;
  //
  //   }
  //
  // }

  Future<dynamic> getUserImei(int userId) async {
    try{
      final response = await client.get('/get/crm/imei/info',{"user_id": userId});
      if(response['success']==true){
        return response['result'];
      }else{
        throw response['message'];
      }
    }catch(e){
      throw e;

    }


  }

  Future<dynamic> saveImei(DeviceInformation device) async {

    try{

      dynamic _payload={
        "args": [
          {
            "status": device.status,
            "employee_id": _userProfile.employeeId,
            "device_name": device.name,
            "device_os": device.os,
            "os_version": device.osVersion,
            "make": device.make,
            "model": device.model,
            "imei": device.imei
          }
        ],
        "model": "employee.app.device",
        "method": "create",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };
      dynamic response = await client.callKwCustom(_payload);
      return response;
    }catch(e){
      print('yajpppppppp');
      print(e);

      throw e;

    }

  }

  //endregion

  //region For App Methods

  Future<bool> ischeckSessionExpire() async{
    var result=false;
    try{
      result=await client.checkSessionCustom().then((value){

        return false;
      });
    }
    on OdooSessionExpiredException{

      return true;
    }
    catch(e){

      (e);
      return false;
    }
    return result;


  }

  Future<dynamic> getAppVersion(String platform) async {
    try {
      
      dynamic payload={
        'model': 'app.version',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang":  _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
          'domain':[
                ["platform","=",platform]
            ],
          'fields': [
            "id",
            "name",
            "status",
            "platform",
            "release_date",
            "force_update",
            "minimum_requirements",
            "description"
          ],
          "limit":1,
          "order":"id desc"
        },
      };
      var response = await client.callKwCustom(payload);
     
      return response.toList();
    } catch (e) {

      throw e;
    }
  }

  //endregion



  Future<Map<String, dynamic>> authenticate(String url,String dbName, String username, String password) async {
    var result;
    try {
//http://172.20.21.161:8085
//       OdooSession response=await client.authenticateCustom(dbName, username, password).
//       timeout( Duration(seconds: 30));


      //OdooSession response=await client.authenticate(dbName, username, password).
      dynamic user=await client.authenticate(dbName, username, password).
      timeout( Duration(seconds: 30));
     
      //User authUser = User(userId: response.userId,session: response,userName:response.userName );
      SessionManager.instance.login(user);


      result = {'statusCode':'','status': true, 'message': 'Successful'};

    } on OdooException catch (e) {
  
      result = {
        'status': false,
        'message': 'Invalid_credential'
      };

      // client.close();
    }on Exception catch (_) {   

      result = {
        'status': false,
        'message': _
      };
    }
    return result;
  }

  Future<List<dynamic>> getAllAttachment(List<int> ids) async {
    try {
      var response = await client.callKwCustom({
        "args": [
          ids,
          [
            "name",
            "mimetype"
          ]
        ],
        "model": "ir.attachment",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      });
      return response.toList();
    } catch (e) {

      throw e;
    }
  }

  //region for  Employee

  // Future<dynamic> loadEmployeeView() async {
  //   try {
  //
  //     dynamic payload={
  //       "model": "hr.employee",
  //       "method": "load_views",
  //       "args": [],
  //       "kwargs": {
  //         "views": [
  //           // [
  //           //   false,
  //           //   "kanban"
  //           // ],
  //           // [
  //           //   false,
  //           //   "list"
  //           // ],
  //           [
  //             false,
  //             "form"
  //           ],
  //           // [
  //           //   false,
  //           //   "activity"
  //           // ],
  //           // [
  //           //   802,
  //           //   "search"
  //           // ]
  //         ],
  //         "context": {
  //           "lang": _userProfile.language,
  //           "tz": _userProfile.tz,
  //           // "uid":  _userProfile.userId,
  //           "allowed_company_ids": [
  //             _userProfile.companyId
  //           ],
  //         }
  //       }
  //     };
  //     var response = await client.callKwCustom(payload);
  //     return response['fields'];
  //   }on Exception catch (e) {
  //     throw e;
  //   } catch (e) {
  //
  //     throw e;
  //   }
  // }

  Future<dynamic?> getClassificationIdByCode(String code) async {
    try {
      dynamic payload={
    'model': 'employee.classification',
    'method': 'search_read',
    'args': [],
    'kwargs': {

        'context': {
          "lang": _userProfile.language,
          "tz": _userProfile.tz,
          // "uid": _userProfile.userId,
          "allowed_company_ids": [
            _userProfile.companyId
          ],
          "bin_size": true
        },
        'domain':[
          ["code", "=", code]
        ],
        'fields': ['name','code'],
        },

    };
      var response = await client.callKwCustom(payload).timeout(Duration(seconds: 3));
      if(response.length>0)
        return response[0]['id'];
      else
        return null;

    }on Exception catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> createEmployee(Employee newEmployee,int mosqueId) async {
   
    try {
      dynamic payload={
        "args": [
          {
            "name": newEmployee.name,
            // "number": newEmployee.jobNumber,
            "category_ids": [
              [
                6,
                false,
                newEmployee.categoryIds??[]
              ]
            ],
            "associated_mosque_ids": [
              [
                6,
                false,
                [
                  mosqueId
                ]
              ]
            ],
            "birthday": newEmployee.birthday,
            "identification_id": (newEmployee.identificationId??""),
            "work_phone": (newEmployee.workPhone??""),
            "staff_relation_type": newEmployee.staffRelationType,
            "company_id": _userProfile.companyId,
            "classification_id": newEmployee.classificationId??false,
          },
        ],
        "kwargs":{
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "chat_icon": true
          }
        },
        "model": "hr.employee",
        "method": "create",

      };
      print('payload');
      print(payload);
      var response = await client.callKwCustom(payload);
      return response;
    }on Exception catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> validateYakeenAPI(Employee newEmployee,String dob) async {
    try {

      dynamic payload={
        "kwargs":{
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "chat_icon": true
          }
        },
        'args': ["identity", "birth_date"],
        "model": "yakeen.verification.method",
        "method": "verify_employee",
        //'args': ["", "2561253747","1993-06"],
        'args': ["", newEmployee.identificationId,dob],

      };
      

      var response = await client.callKwCustom(payload);


   
      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {
  
      throw e;
    }
  }

  Future<dynamic> validateNationalId(Employee newEmployee) async {
    try {

      dynamic payload={
        "args": [
          [
            newEmployee.id
          ]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid":  _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        },
        "method": "action_validate_national_id",
        "model": "hr.employee"
      };
     
      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {
 
      throw e;
    } catch (e) {
     
      throw e;
    }
  }

  //endregion



  //region For Cusomt API
  Future<dynamic> getPrayerTime() async {
    try {


      dynamic payload={};
      dynamic response = await client.post("/prayer/time/crm",{
        "lang" : _userProfile.language
      });


      if(response["body"]["status"]==200){
        return response["body"];
      }else{
        throw response["body"]["message"];
      }
      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> getTodayPrayerTime() async {
    try {
      final response = await client.get('/prayer/time/crm/2');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getDashboardAPI() async {
    try {
 

      dynamic payload={};
      dynamic response = await client.post("/getDashboarKPI",{
        "lang" : _userProfile.language
      });


      if(response["body"]["status"]==200){
        return response["body"];
      }else{
        throw response["body"]["message"];
      }
      return response;
    }on Exception catch (e) {
    
      throw e;
    } catch (e) {
    
      throw e;
    }
  }

  Future<dynamic> getMasjidSummaryAPI() async {
    try {


      dynamic payload={};

      // dynamic response = await client.post("/api/mosque/get",{
      dynamic response = await client.post("/call/mosque/overall/stats",{
        "lang" : _userProfile.language
      });

      print('response');
      print(response);



      if(response["status"]==200){
        print(response["mosqueRequest"]);
        return response["mosqueRequest"];
      }else{
        throw response["message"];
      }
      return response;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> getMenuRights() async {
    try {
      

      dynamic payload={};
   
      dynamic response = await client.post("/getMenuRights",{});
      if(response["body"]["status"]==200){
        return response["body"];
      }else{
        throw response["body"]["message"];
      }
      return response;
    }on Exception catch (e) {
  
     
      throw e;
    } catch (e) {
     
      throw e;
    }
  }

  //endregion

  //region for Common Methods
  Future<List<dynamic>> getRequestStage(String model) async {

    try {
      dynamic _payload={
        'model': 'request.stage',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'limit': 50,
          'context': {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
          'domain': [['res_model', '=',model]],
          'fields': ["name"],
        },

      };
      print(_payload);
      var response = await client.callKwCustom(_payload);

      return response.toList();
    }catch (e) {
      (e);
      throw e;
    }
  }

  // Future<dynamic> getPrayerTime(dynamic payload) async {
  //
  //   try {
  //     dynamic _payload={
  //       "model": "prayer.time",
  //       "domain": payload,
  //       "fields": [
  //         "name",
  //         "date",
  //         "month",
  //         "year",
  //         "fajar_time",
  //         "dhuhr_time",
  //         "asr_time",
  //         "maghrib_time",
  //         "isha_time"
  //       ],
  //       "limit": 1,
  //       "sort": "",
  //       "context": {
  //         "lang": _userProfile.language,
  //         "tz": _userProfile.tz,
  //         // "uid": _userProfile.userId,
  //         "allowed_company_ids": [
  //           _userProfile.companyId
  //         ],
  //         "bin_size": true
  //       }
  //     };
  //     var response = await client.callKwCustom(_payload);
  //
  //     return response.toList();
  //   }catch (e) {
  //     (e);
  //     throw e;
  //   }
  // }
//endregion

  //region for User Notifications
  Future<dynamic> getAllUserNotifications(dynamic domain,int pageSize,int pageIndex) async {
    try {

      dynamic _domain={
        "pageSize": pageSize,
        "pageIndex": pageIndex-1
      };
      dynamic response = await client.post("/moia/get/notifications",_domain);
      return response;
    }catch (e) {

      throw e;
    }
  }

  Future<dynamic> getNotificationCount() async {
    try {
      print('getNotificationCount');
      dynamic response = await client.post("/moia/get/notification_count",{
        "lang" : _userProfile.language
      });

      return response;
    }catch (e) {
      print('getNotificationCount');
      print(e);
      throw e;
    }
  }

 //endregion

  //region for General Odoo Method
  Future<dynamic> callAPI({required String apiUrl,dynamic domain}) async {
    try {

      dynamic response = await client.post(apiUrl,domain??{});
      return response;
    }catch (e) {

      throw e;
    }
  }
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();


  Future<dynamic> callgetAPI({
    required String apiUrl,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(client.baseURL + apiUrl).replace(queryParameters: queryParams);
      print("🌍 Final GET URL: $uri");

      final headers = {
        'Cookie': 'session_id=' + (await SessionManager.instance.getSessionId() ?? ""),
        'APIAccessToken': Config.discoveryApiToken,
      };
      print("🟢 HEADERS: $headers");

      final response = await http.get(uri, headers: headers);

      print("📨 Raw response.statusCode = ${response.statusCode}");
      print("📨 Raw response.body = ${response.body}");

      final decoded = json.decode(response.body);
      print("✅ Decoded response from client.get(): $decoded");

      return decoded; // ✅ Do NOT return decoded['result']
    } catch (e, stacktrace) {
      print("❌ callgetAPI error: $e");
      print("❌ stacktrace: $stacktrace");
      rethrow;
    }
  }






  Future<dynamic> create(dynamic pram,String model) async {
    try {
      dynamic payload={
        "args": [
          pram
        ],
        "model": model,
        "method": "create",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };

      var response = await client.callKwCustom(payload);
      return response;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> callMethod({dynamic pram,required String model,required String method,dynamic context}) async {
    try {
      dynamic payload={
        "args": pram,
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId,
            ],
            if (context != null) ...context,
          }
        },
        "method": method,
        "model": model
      };



      var response = await client.callKwCustom(payload);

      return response;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> searchReadWithPaging({required model,required domain,required fields,required pageSize,required pageIndex,String? orderBy}) async {
    try {
      dynamic payload={
        'model': model,
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {
            "lang": _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
            'domain': domain,
            'fields': fields,
            'limit': pageSize,
            "offset" :  ((pageIndex-1)*pageSize),
            "order":orderBy??""

        },
        "sort":""
      };

      print('aaaaaa');
      print(payload);

      var response = await client.callKwCustom(payload);
      return response;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> read({required model,required domain,required fields}) async {
    try {
      dynamic payload={
        "args": [
          domain,
          fields
        ],
        "model": model,
        "method": "read",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          }
        }
      };


      var response = await client.callKwCustom(payload);
      return response;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> loadView({required model,bool? isOnlyFields=false}) async {
    try {

      // dynamic payload={
      //   "model": model,
      //   "method": "load_views",
      //   "args": [],
      //   "kwargs": {
      //     "views": [
      //       [
      //         false,
      //         "form"
      //       ]
      //     ],
      //     "context": {
      //       "lang": _userProfile.language,
      //       "allowed_company_ids": [
      //         _userProfile.companyId
      //       ]
      //     }
      //   }
      // };
      // var response = await client.callKwCustom(payload);
      // try{
      //   if(isOnlyFields??false){
      //     return response['fields'];;
      //   }else{
      //     return response['fields_views']["form"]["fields"];
      //   }
      // }catch(e){
      //   return response['fields'];
      // }


      dynamic payload={
        "model": model,
        "views": [[false, "form"]],
        "options": {

        }
      };
      dynamic response = await client.post("/custom/load_views",payload??{});
      return response['fields_views']['form']['fields'];
    }catch (e) {
      print(e);

      throw e;
    }
  }

  Future<dynamic> getFilter({required String model,required String field,dynamic domain}) async {
    try {

      dynamic payload={
        "context": {
          "lang":_userProfile.language,
          "allowed_company_ids": [
            _userProfile.companyId
          ]
        },
        "args": [
          field
        ],
        "model": model,
        "method": "search_panel_select_range",
        "kwargs": {
          "category_domain": [],
          "enable_counters": false,
          "expand": false,
          "filter_domain": [],
          "hierarchize": true,
          "limit": 200,
          "search_domain": domain??[],
          "context": {
            "lang":_userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };
      var response = await client.callKwCustom(payload);
      try{
        return response['values'];
      }catch(e){
        return [];
      }
    } catch (e) {

      throw e;
    }
  }

//endregion

  /// Get CRM User Info for address pickers
  Future<Map<String, dynamic>> getCrmUserInfo() async {
    try {
      print('response...');
      final response = await client.get('/get/crm/user/info');

      print(response);
      // Extract the first user info from the userInfo array to match user_info_model.dart
      if (response['userInfo'] != null && response['userInfo'] is List && response['userInfo'].isNotEmpty) {
        final userInfo = response['userInfo'][0];
        return Map<String, dynamic>.from(userInfo);
      } else {
        throw Exception('Invalid API response: userInfo is null or empty');
      }
    } catch (e, stacktrace) {
      rethrow;
    }
  }

}