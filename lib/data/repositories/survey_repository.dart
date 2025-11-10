import 'dart:convert';

import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/device_info.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_region.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../core/models/survey_user_input.dart';


class SurveyRepository {
  late CustomOdooClient client;
  late UserProfile _userProfile;

  SurveyRepository(client,{UserProfile? userProfile}){
    this.client = client;
    if(userProfile!=null)
      this._userProfile=userProfile;

  }
  set userProfile(UserProfile user) {
    _userProfile = user;

  }
  // Getter for age
  UserProfile get userProfile => _userProfile;

  Future<dynamic> getSurveyDisclaimer(int surveyId) async {


    try{
      dynamic _payload={
        "args": [
          [],
          {},
          [],
          {
            "text": "",
            "accept_terms": ""
          }
        ],
        "model": "visit.ext.declaration.confirmation.wizard",
        "method": "onchange",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "survey.user_input",
            "active_id": surveyId,
            "active_ids": [
              surveyId
            ],
            "current_id": surveyId
          }
        }
      };

      dynamic response = await client.callKwCustom(_payload);



      return response;
    }catch(e){


      throw e;

    }

  }


  Future<dynamic> acceptSurvey(int visitId) async {
    try {
      final payload = {
        "args": [
          [visitId]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [_userProfile.companyId],
          }
        },
        "method": "action_accept",
        "model": "survey.user_input"
      };

      var response = await client.callKwCustom(payload);
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> acceptTermsSurvey(int id) async {
    try {
      // Step 1: Create the wizard with accept_terms = true
      dynamic payload = {
        "args": [
          {
            "accept_terms": true
          }
        ],
        "model": "visit.ext.declaration.confirmation.wizard",
        "method": "create",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "survey.user_input",
            "active_id": id,
            "active_ids": [id],
            "current_id": id
          }
        }
      };

      var response = await client.callKwCustom(payload);

      // Step 2: Confirm the wizard using the ID returned from create
      dynamic finalPayload = {
        "args": [
          [response]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "survey.user_input",
            "active_id": id,
            "active_ids": [id],
            "current_id": id
          }
        },
        "method": "action_confirm",
        "model": "visit.ext.declaration.confirmation.wizard"
      };

      var responseConfirm = await client.callKwCustom(finalPayload);
      return responseConfirm;

    } catch (e) {
      throw e;
    }
  }
  Future<dynamic> underProgressButton(int visitId) async {
    final payload = {
      "args": [
        [visitId]
      ],
      "model": "survey.user_input",
      "method": "action_underprogress",
      "kwargs": {
        "context": {
          "lang": _userProfile.language,
          "tz": _userProfile.tz,
          "uid": _userProfile.userId,
          "allowed_company_ids": [_userProfile.companyId],
        }
      }
    };

    print("📦 UnderProgress Payload: $payload");

    final result = await client.callKwCustom(payload);
    return result;
  }


  Future<SurveyUserInput> getSurveyUserInputDetail(int id) async {
    try {
      final domain = [
        ['id', '=', id]
      ];

      final fields = [
        'survey_id',
        'mosque_id',
        'employee_id',
        'priority_value',
        'url',
        'print_url',
        'start_datetime',
        'end_datetime',
        'visit_date',
        'latitude',
        'longitude',
        'stage_id',
        'sequence_no',
        'workflow_state',
        'display_button_accept',
        'display_button_underprogress',
        'display_button_action',
        'visit_for'

      ];

      final result = await client.searchReadWithPaging(
        model: 'survey.user_input',
        domain: domain,
        fields: fields,
        pageSize: 1,
        pageIndex: 1,


    );

      if (result.isNotEmpty) {
        return SurveyUserInput.fromJson(result.first);
      } else {
        throw Exception('Survey record not found');
      }
    } catch (e) {
      print('❌ Failed to fetch survey input detail: $e');
      throw e;
    }
  }


  Future<dynamic> actionTakeSurvey(int visitId) async {
    try {
      final payload = {
        "args": [
          [visitId]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [_userProfile.companyId],
          }
        },
        "method": "take_action",
        "model": "survey.user_input"
      };

      var response = await client.callKwCustom(payload);
      return response;
    } catch (e) {
      throw e;
    }
  }

    Future<bool> actionTakenWizard(int id, {required String actionText, required bool acceptTerms}) async {
      print("DEBUG: actionText is ${actionText.runtimeType}"); // Should be String
      print("DEBUG: acceptTerms is ${acceptTerms.runtimeType}"); // Should be bool
      try {

        final takeActionPayload = {
          "args": [
            [id]
          ],
          "model": "survey.user_input",
          "method": "take_action",
          "kwargs": {
            "context": {
              "lang": _userProfile.language,
              "tz": _userProfile.tz,
              "allowed_company_ids": [_userProfile.companyId]
            }
          }
        };
        /// Step 2: Call onchange
        final onchangePayload = {
          "args": [
            [],
            {},
            [],
            {"action_text": actionText,
              "accept_terms": acceptTerms,}
          ],
          "model": "action.taken.visit",
          "method": "onchange",
          "kwargs": {
            "context": {
              "lang": _userProfile.language,
              "tz": _userProfile.tz,
              "uid": _userProfile.userId,
              "allowed_company_ids": [_userProfile.companyId],
              "active_model": "survey.user_input",
              "active_id": id,
              "active_ids": [id],
              "default_user_input_id": id,
              "params": {
                "menu_id": 1034,
                "action": 1215
              }
            }
          }
        };

        print("📦 onchange payload: $onchangePayload");
        await client.callKwCustom(onchangePayload);
        print("DEBUG: actionText is ${actionText.runtimeType}"); // Should be String
        print("DEBUG: acceptTerms is ${acceptTerms.runtimeType}"); // Should be bool


        return true;
      } catch (e) {
        print("❌ actionTakenWizard full flow failed: $e");
        throw Exception("Failed full action taken flow");
      }
    }



  Future<int> createActionTakenWizard(int id, {required String actionText, required bool acceptTerms}) async {
    final createPayload = {
      "args": [
        {
          "action_text": actionText,
          "accept_terms": acceptTerms,
        }
      ],
      "model": "action.taken.visit",
      "method": "create",
      "kwargs": {
        "context": {
          "lang": _userProfile.language,
          "tz": _userProfile.tz,
          "uid": _userProfile.userId,
          "allowed_company_ids": [_userProfile.companyId],
          "active_model": "survey.user_input",
          "active_id": id,
          "active_ids": [id],
          "default_user_input_id": id,
          "default_text": false,
        }
      }
    };

    print("📦 create wizard payload: $createPayload");
    final wizardId = await client.callKwCustom(createPayload);
    print("✅ Wizard created with ID: $wizardId");
    return wizardId;
  }


  Future<void> performActionTaken(int wizardId, int parentId) async {
    final actionTakenPayload = {
      "args": [[wizardId]],
      "model": "action.taken.visit",
      "method": "action_taken",
      "kwargs": {
        "context": {
          "lang": _userProfile.language,
          "tz": _userProfile.tz,
          "uid": _userProfile.userId,
          "allowed_company_ids": [_userProfile.companyId],
          "active_model": "survey.user_input",
          "active_id": parentId,
          "active_ids": [parentId],
          "default_user_input_id": parentId,
          "default_text": false,
        }
      }
    };

    print("📦 action_taken payload: $actionTakenPayload");
    await client.callKwCustom(actionTakenPayload);
    print("✅ action_taken executed successfully");
  }







}