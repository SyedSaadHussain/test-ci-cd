import 'dart:convert';

import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/survey.dart';
import 'package:mosque_management_system/core/models/survey_user_input.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/survey_repository.dart';
import 'package:mosque_management_system/data/services/odoo_service.dart';
import 'package:mosque_management_system/shared/widgets/modal/survey_configuration.dart';
import 'package:mosque_management_system/features/screens/survey_detail.dart';
import 'package:mosque_management_system/core/utils/domain_builder.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

import '../../shared/widgets/app_form_field.dart';
import '../../core/models/combo_list.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/features/screens/surveylist_screen.dart';
import 'package:mosque_management_system/core/constants/config.dart';

import '../../core/models/visit_type.dart';



class SurveyService extends OdooService{
  // late CustomOdooClient client;
  // late CommonRepository repository;
  final Map<int, String> _viewUrlCache = {}; // ✅ cache for view URLs
  Map<String, dynamic> visitorInfo = {};
  late SurveyRepository _surveyRepository;
  // CommonRepository get repository => _repository;
  SurveyRepository get surveyRepository => _surveyRepository;



  SurveyService(CustomOdooClient client,{UserProfile? userProfile}): super(client,userProfile:userProfile) {
    // surveyRepository = CommonRepository(client);
    _surveyRepository = SurveyRepository(client,userProfile: userProfile);
    // client = client;
    // repository = CommonRepository(client);
  }
  // SurveyService(this.client) : repository = CommonRepository(client);

  //SurveyService(this.client);


  // /// ✅ **Get Session Headers (Used in SurveyVisitScreen)**
  // Future<dynamic> getHeadersMap() async {
  //   try {
  //     final response = await _surveyRepository.client.post('/web/session/get', {});
  //
  //     if (response['result'] != null) {
  //       print("✅ Session is Active, Headers Retrieved");
  //       return {"Cookie": "session_id=${_surveyRepository.client.sessionId}"};
  //     } else {
  //       print("❌ Session Expired");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("❌ Error Fetching Headers: $e");
  //     return null;
  //   }
  // }

  /// 🔄 **Fetch Visit Types from Custom Odoo API**
  Future<List<Map<String, dynamic>>> fetchVisitTypes() async {
    try {
      final response = await _surveyRepository.client.post('/api/survey/get/', {});
      print("🟢 Raw API Response_custom_api: $response");

      final visitTypeList = response["body"]?["visitRequest"]?["visit_type_info"];

      if (visitTypeList != null && visitTypeList is List) {
        print("✅ visit_type_info loaded: ${visitTypeList.length} items");

        return List<Map<String, dynamic>>.from(visitTypeList);
      } else {
        throw Exception('visit_type_info not found or not a list');
      }
    } catch (e) {
      print("❌ Error in fetchVisitTypes: $e");
      return [];
    }
  }

  Future<List<VisitType>> getAllVisitTypes() async {
    try {
      List<VisitType> types=[];
      final response = await _surveyRepository.client.post('/api/survey/get/', {});
      print("🟢 Raw API Response_customAPI: $response");


      final visitTypeList = response["body"]?["visitRequest"]?["visit_type_info"];

      if (visitTypeList != null && visitTypeList is List) {
        types=(visitTypeList as List).map((item) => VisitType.fromJson(item)).toList();
        return types;
        // return List<Map<String, dynamic>>.from(visitTypeList);
      } else {
        throw Exception('visit_type_info not found or not a list');
      }
    } catch (e) {
      print("❌ Error in fetchVisitTypes: $e");
      return [];
    }
  }

  Future<List<VisitType>> fetchVisitTypesWithStages() async {
    try {
      dynamic _payload={
        "lang": repository.userProfile.language
      };
      final response = await _surveyRepository.client.post('/api/survey/get/', _payload);
      final visitTypeList = response["body"]["visitRequest"]["visit_type_info"];

      // Debugging (optional)
      print("📥 Raw visit_type_info: $visitTypeList");

      return (visitTypeList as List).map((visitTypeJson) {
        // Extract stages safely
        final stages = (visitTypeJson['stages'] as List<dynamic>).map((stageJson) {
          return Stage(
            label: stageJson['label'],
            value: stageJson['value'],
            sequence: stageJson['sequence'],
            stageId: stageJson['stage_id'], // make sure this is an int
          );
        }).toList();

        return VisitType(
          label: visitTypeJson['label'],
          value: visitTypeJson['value'],
          surveyId: visitTypeJson['survey_id'], // this is the key fix
          stages: stages,
        );
      }).toList();
    } catch (e) {
      print("❌ Error loading visit types: $e");
      return [];
    }
  }


  Future<String?> getSurveyUrl(int employeeId) async {
    final response = await _surveyRepository.client.callKwCustom({
      'model': 'survey.user_input', // Odoo model name
      'method': 'search_read', // Fetch data from survey_user_input
      'args': [
        [['employee_id', '=', employeeId]] // Filter by logged-in employee ID
      ],
      'kwargs': {
        'fields': ['url'], // Fetch only 'url' field directly
        'limit': 1, // Only get one matching record
      }
    });

    if (response is List && response.isNotEmpty) {
      return response[0]['url']; // Return URL if found
    }
    return null;
  }

  // Future<bool> startSurveyVisit(Map<String, dynamic> visit) async {
  //   try {
  //     final surveyId = visit['survey_id'];
  //     final mosqueId = visit['mosque_id'];
  //
  //     print("🧪 Parsed survey_id: $surveyId, mosque_id: $mosqueId");
  //
  //     if (surveyId is! int || mosqueId is! int) {
  //       print("❌ Missing or invalid survey_id or mosque_id. Cannot start visit.");
  //       return false;
  //     }
  //
  //     final response = await client.callKwCustom({
  //       'model': 'survey.user_input',
  //       'method': 'create',
  //       'args': [],
  //       'kwargs': {
  //         'values': {
  //           'survey_id': surveyId,
  //           'mosque_id': mosqueId,
  //           'platform_source': 'Mobile',
  //         }
  //       }
  //     });
  //
  //     print("✅ Survey started with response: \$response");
  //     return true;
  //   } catch (e) {
  //     print("❌ Failed to start survey visit: \$e");
  //     return false;
  //   }
  // }

  Future<String?> getSurveyViewUrl(Map<String, dynamic> visit) async {
    final stageRaw = visit['stage_id'];
    final printUrl = visit['print_url'];
    int? stageId;
    final surveyId = visit['survey_id'];

    if (_viewUrlCache.containsKey(surveyId)) {
      return _viewUrlCache[surveyId];
    }

    if (stageRaw is Map && stageRaw.containsKey('id')) {
      stageId = stageRaw['id'];
    }

    if (stageId != 263 && printUrl is String && printUrl.isNotEmpty) {
      _viewUrlCache[surveyId] = printUrl;
      return printUrl;
    }
    return null;
  }




  Future<SurveyUserInputData> getAllSurveyVisits(
      int? employeeId, {
        int pageSize = 10,
        int pageIndex = 1,
        String query = '',
        String? filterField,
        dynamic filterValue,
        int? surveyId,
        SurveyUserInput? filter,
      }) async {
    //print("Calling Odoo API for Employee ID: $employeeId");
    print('saad');
    SurveyUserInputData visits =SurveyUserInputData();


    var _domain = [
      '|',
      '|',
      ["sequence_no", "ilike", query],
      ["name", "ilike", query],
      ["city_id", "ilike", query]
    ];



    //   ];
    // }
    // if (surveyId != null) {
    //   domain = [
    //     ['survey_id', '=', surveyId],
    //     ...domain // ✅ merge instead of nesting
    //   ];
    // }

    dynamic domainBuilder=DomainBuilder(_domain);
    domainBuilder.add("survey_id",surveyId??2,'=');
    domainBuilder.add("stage_id",filterValue,'=');
    if(filter!=null){
      domainBuilder.add("region_id",filter!.regionId,'=');
      domainBuilder.add("priority_value",filter!.priorityValue,'=');
    }

    _domain=domainBuilder.domain;
    print("Search Query: $query");

    print("domain$_domain");


    final fields=[
      'name',
      'state',
      'survey_id',
      'mosque_id',
      'employee_id',
      'land_id',
      'land_address',
      'city_id',
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

    print(fields);
    final response = await repository.searchReadWithPaging(model: Model.survey, domain: _domain, fields: fields, pageSize: pageSize, pageIndex: pageIndex);
    print('getAllSurveyVisits..');
    print(response);
    print("API Raw Response: $response");
    visits.list=(response as List).map((item) => SurveyUserInput.fromJson(item)).toList();
    return visits;
  }

  Future<SurveyUserInput> getSurveyUserInputDetail(int id) async {
    return await _surveyRepository.getSurveyUserInputDetail(id);
  }

  Future<bool> markUnderProgress(int visitId) async {
    try {
      await _surveyRepository.underProgressButton(visitId);
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<List<ComboItem>> getVisitStages() async {
    try {
      dynamic response = await repository.getRequestStage(Model.survey);

      List<ComboItem> items = (response as List)
          .map((item) => ComboItem.fromJsonObject(item))
          .toList();

      return items;
    } catch (e) {
      print("❌ Error in getVisitStages: $e");
      throw e;
    }
  }


  Future<List<ComboItem>> getVisitTypes(int pageSize,int pageIndex,dynamic domain,String query) async {
    List<ComboItem> items=[];
    try {

      List<dynamic> _domain=domain??[];

      dynamic domainBuilder=DomainBuilder(_domain);
      domainBuilder.add("title",query,'like');
      _domain=domainBuilder.domain;

      dynamic response = await repository.searchReadWithPaging(model: Model.surveySurvey,
      domain:_domain,fields: ["title"],pageIndex:pageIndex,pageSize:pageSize);

      items=(response as List).map((item) => ComboItem.fromJsonTitle(item)).toList();
      return items;
    }on Exception catch (e){
      throw e;
    }
  }

  Future<dynamic> createUserSurvey(UserSurvey userSurvey) async {
    try {
      var _pram={
        "visit_form_id": userSurvey.visitFormId,
        "employee_id": userSurvey.employeeId,
        "on_date": userSurvey.onDate,
        "mosque_id": userSurvey.mosqueId
      };

      dynamic createResponse = await repository.create(_pram,Model.assignVisit);
      var _assignVisitPram=[[createResponse]];
      dynamic callMethodResponse = await repository.callMethod(
          model: Model.assignVisit,
          method: "assign_visit",
          pram:_assignVisitPram );

      return callMethodResponse;
    }on Exception catch (e){
      throw e;
    }

  }


  Future<dynamic> getSurveyDisclaimer(int surveyId) async {
    try {
      dynamic response = await _surveyRepository.getSurveyDisclaimer(surveyId);

      return response;
    }on Exception catch (e){
      throw e;
    }

  }
  Future<bool> acceptTermsSurvey(int id) async {
    try {
      dynamic response = await _surveyRepository.acceptTermsSurvey(id);


      return true;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<bool> acceptSurvey(int visitId) async {
    try {
      await _surveyRepository.acceptSurvey(visitId);
      return true;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> actionTakenWizard(int id, {required String actionText, required bool acceptTerms}) async {
    try {
      await _surveyRepository.actionTakenWizard(id, actionText: actionText,acceptTerms: acceptTerms);
      return true;
    } catch (e) {
      throw e;
    }
  }
  Future<int> createWizard(int surveyInputId, String actionText, bool acceptTerms) {
    return _surveyRepository.createActionTakenWizard(
      surveyInputId,
      actionText: actionText,
      acceptTerms: acceptTerms,
    );
  }

  Future<void> performWizardAction(int wizardId, int parentId) {
    return _surveyRepository.performActionTaken(wizardId, parentId);
  }


  // Future<bool> createActionTaken(int id, String actionText) async {
  //   try {
  //     final result = await _surveyRepository.createActionTaken(id, actionText);
  //     return result != null;
  //   } catch (e) {
  //     throw e;
  //   }
  // }



  Future<List<FieldList>> loadAssignVisitView() async {
    try {
      List<FieldList> data=[];
      dynamic response = await repository.loadView(model: Model.assignVisit);
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

  Future<dynamic> onChangeMosqueOnAssignSurvey(int mosqueId) async {
    try {
      dynamic _pram=[
        [],
        {
          "mosque_id": mosqueId,
          "visit_form_id": false,
          "employee_id": false,
          "on_date": false
        },
        "mosque_id",
        {
          "mosque_id": "1",
          "visit_form_id": "",
          "employee_id": "",
          "on_date": ""
        }
      ];

      dynamic response = await repository.callMethod(model: Model.assignVisit,method: "onchange",pram: _pram);

      dynamic pram=response['domain']['visit_form_id'];
      return pram;
    }on Exception catch (e){
      throw e;
    }
  }

  Future<List<ComboItem>> getVisitFilter(String field,{dynamic domain}) async {
    try {
      List<ComboItem> data=[];
      dynamic response = await repository.getFilter(model: Model.survey,field: field,domain: domain);
      data=(response as List).map((item) => ComboItem.fromJsonFilter(item)).toList();
      return data;
    }catch(e){
      throw e;
    }
  }

  Future<List<FieldList>> loadSurveyInputView() async {
    try {
      List<FieldList> data=[];
      dynamic response = await repository.loadView(model: Model.survey,isOnlyFields: true);
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


  // 🧠 Tagged: Improved parser for Dart-style pseudo-JSON



  // Map<String, dynamic> manuallyParseYakeen(String raw) {
  //   raw = raw.trim();
  //
  //   // Remove outer braces if present
  //   if (raw.startsWith('{') && raw.endsWith('}')) {
  //     raw = raw.substring(1, raw.length - 1);
  //   }
  //
  //   final result = <String, dynamic>{};
  //   int index = 0;
  //
  //   while (index < raw.length) {
  //     // Match key: value pairs
  //     final keyMatch = RegExp(r'\s*([\w]+)\s*:').matchAsPrefix(raw, index);
  //     if (keyMatch == null) break;
  //
  //     final key = keyMatch.group(1)!;
  //     index = keyMatch.end;
  //
  //     // Check for nested object
  //     if (raw[index] == '{') {
  //       int braceCount = 1;
  //       int start = index + 1;
  //       int end = start;
  //
  //       while (end < raw.length && braceCount > 0) {
  //         if (raw[end] == '{') braceCount++;
  //         if (raw[end] == '}') braceCount--;
  //         end++;
  //       }
  //
  //       final nestedRaw = raw.substring(index, end); // includes braces
  //       result[key] = manuallyParseYakeen(nestedRaw); // 🔁 Recursive
  //       index = end;
  //
  //       // Skip comma and whitespace
  //       if (index < raw.length && raw[index] == ',') index++;
  //
  //     } else {
  //       // Handle simple value
  //       int end = index;
  //       while (end < raw.length && raw[end] != ',') end++;
  //
  //       String value = raw.substring(index, end).trim();
  //       value = value.replaceAll(RegExp(r'^"|"$'), '').trim();
  //
  //       if (value == 'null') {
  //         result[key] = null;
  //       } else if (value == 'true') {
  //         result[key] = true;
  //       } else if (value == 'false') {
  //         result[key] = false;
  //       } else if (double.tryParse(value) != null) {
  //         result[key] = double.parse(value);
  //       } else if (value.startsWith('{') && value.endsWith('}')) {
  //         // 🔁 Recurse nested map string
  //         result[key] = manuallyParseYakeen(value);
  //       } else {
  //         result[key] = value;
  //       }
  //
  //       index = end + 1; // skip comma
  //     }
  //   }
  //
  //   return result;
  // }


// survey_service.dart
  String extractSimpleChoiceAnswer(Map<String, dynamic> data, List<dynamic>? options) {
    final answers = data['user_answer'];
    if (answers is! List) return '';

    final list = List<Map<String, dynamic>>.from(answers);

    final choice = list.firstWhere(
          (e) => e['answer_type'] == 'suggestion',
      orElse: () => {},
    );

    final charBox = list.firstWhere(
          (e) => e['answer_type'] == 'char_box',
      orElse: () => {},
    );

    final choiceLabel = JsonUtils.getNameFromKey(options, choice['suggested_answer_id']) ?? '';
    final charBoxText = (charBox['value_char_box'] ?? '').toString();

    return charBoxText.isNotEmpty
        ? '$choiceLabel\n$charBoxText'
        : choiceLabel;
  }












  dynamic _extractUserAnswer(Map<String, dynamic> question) {
    final userAnswers = question['user_answer'];
    final questionType = question['question_type'];
    print(" userAnswer: ${userAnswers}");


    if (userAnswers is! List || userAnswers.isEmpty) {
      return null;
    }

    if (questionType == 'char_box') {
      final suggestion = userAnswers.firstWhere(
            (e) => e['answer_type'] == 'char_box',
        orElse: () => null,
      );

      if (suggestion != null && suggestion['value_char_box'] != null) {
        try {
          final raw = suggestion['value_char_box'];

          // 🆕 🔧 [TAGGED] Check and decode with debug logging
          Map<String, dynamic>? decoded;

          print("🔍 Yakeen raw type: ${raw.runtimeType}");
          print("📦 Yakeen raw content: $raw");

          if (raw is String) {
            decoded = manuallyParseYakeen(raw);
            print("📥 Parsed Yakeen from String: $decoded");
          } else if (raw is Map<String, dynamic>) {
            decoded = raw;
            print("📥 Parsed Yakeen from Map directly");
          } else {
            print("❌ Unsupported format in value_char_box: $raw");
            return null;
          }

          final personRaw = decoded['personBasicInfo'];

          if (personRaw != null) {
            try {
              // 🔧 [TAGGED FIX] Re-parse if it's a nested string like "{firstName: عادل, ...}"
              dynamic personParsed = personRaw;

              if (personRaw is String && personRaw.trim().startsWith('{')) {
                personParsed = manuallyParseYakeen(personRaw);
              }

              // 🔧 [TAGGED FIX] Ensure it's a usable map
              if (personParsed is Map) {
                final name = Map<String, dynamic>.from(personParsed);
                print("✅ Found personBasicInfo: $name");

                return {
                  "nameArabic":
                  "${name['firstName'] ?? ''} ${name['fatherName'] ??
                      ''} ${name['grandFatherName'] ??
                      ''} ${name['familyName'] ?? ''}",
                  "nameEnglish":
                  "${name['firstNameT'] ?? ''} ${name['fatherNameT'] ??
                      ''} ${name['grandFatherNameT'] ??
                      ''} ${name['familyNameT'] ?? ''}",
                  "json": decoded
                };
              } else {
                print(
                    "❌ personBasicInfo is not a Map after parsing: $personParsed");
              }
            } catch (e) {
              print("❌ personBasicInfo cast failed: $e");
            }
          } else {
            print("❌ decoded['personBasicInfo'] is null");
          }


          // if (person != null && person is Map) {
          //   final name = Map<String, dynamic>.from(person);
          //   print("✅ Found personBasicInfo: $name");
          //
          //   return {
          //     "nameArabic":
          //     "${name['firstName'] ?? ''} ${name['fatherName'] ?? ''} ${name['grandFatherName'] ?? ''} ${name['familyName'] ?? ''}",
          //     "nameEnglish":
          //     "${name['firstNameT'] ?? ''} ${name['fatherNameT'] ?? ''} ${name['grandFatherNameT'] ?? ''} ${name['familyNameT'] ?? ''}",
          //     "json": decoded
          //   };
          // }
          //
          // else {
          //   print("❌ decoded['personBasicInfo'] is missing or invalid");
          // }
        } catch (e, stack) {
          print("❌ Exception during char_box parsing: $e");
          print(stack);
        }
      }
    }


    // ✅ Matrix: return list of [rowId, columnId]
    if (questionType == 'matrix') {
      return userAnswers
          .where((entry) =>
      entry['matrix_row_id'] is List &&
          entry['suggested_answer_id'] is List)
          .map((entry) =>
      [
        JsonUtils.getId(entry['matrix_row_id']),
        JsonUtils.getId(entry['suggested_answer_id']),
      ])
          .where((pair) => pair[0] != null && pair[1] != null)
          .toList();
    }



    // if (questionType == 'simple_choice') {
    //   final userAnswers = question['user_answer'];
    //   if (userAnswers is List && userAnswers.isNotEmpty) {
    //     final suggestion = userAnswers.firstWhere(
    //           (e) => e['answer_type'] == 'suggestion',
    //       orElse: () => null,
    //     );
    //
    //     if (suggestion != null) {
    //       // ✅ Case 1: custom answer (e.g., imam name)
    //       if (suggestion['custom_answer_ids'] is List &&
    //           suggestion['custom_answer_ids'].isNotEmpty) {
    //         final custom = suggestion['custom_answer_ids'][0];
    //         return (custom is List && custom.length > 1) ? custom[1] : custom.toString();
    //       }
    //
    //       // ✅ Case 2: suggested answer with label (e.g., ينطبق)
    //       if (suggestion['suggested_answer_id'] is List &&
    //           suggestion['suggested_answer_id'].length > 1) {
    //         return suggestion['suggested_answer_id'][1].toString(); // ✅ use label
    //       }
    //     }
    //   }
    // }





























    // ✅ Multi-select / Checkbox: return list of selected IDs
    if (questionType == 'multi_select' || questionType == 'checkbox') {
      return userAnswers
          .where((entry) => entry['answer_type'] == 'suggestion')
          .map((entry) => JsonUtils.getKey(entry['suggested_answer_id']))
          .toList();
    }

    // ✅ Multiple Choice with custom_answer_ids
    if (questionType == 'multiple_choice') {
      return userAnswers
          .where((entry) => entry['custom_answer_ids'] is List)
          .expand((entry) => entry['custom_answer_ids'])
          .map((pair) => pair.length > 1 ? pair[1] : pair[0]) // extract display name
          .toList();
    }


    // ✅ Text / Date / Single Suggestion
    final answer = userAnswers[0];
    if (answer['answer_type'] == 'date') {
      return {
        "gregorian": answer['value_date']?.toString(),
        "hijri": answer['value_hijri']?.toString(),
      };
    }
    if (answer['answer_type'] == 'text_box') {
      return answer['value_text_box']?.toString();
    }



    if (answer['answer_type'] == 'suggestion') {
      return JsonUtils.getKey(answer['suggested_answer_id']);
    }








    if (questionType == 'upload_file') {
      final uploadEntry = userAnswers.firstWhere(
            (e) => e['answer_type'] == 'upload_file',
        orElse: () => null,
      );

      if (uploadEntry != null) {
        final urls = uploadEntry['download_urls'];
        final ids = uploadEntry['value_file_data_ids'];

        if (urls is List && urls.isNotEmpty) {
          final sanitizedUrl = (urls.first as String).replaceAll(RegExp(r'(?<!:)//'), '/');
          return {
            'download_url': sanitizedUrl,
            'file_ids': ids
          };
        }
      }
    }


    return null;
  }



  Future<List<VisitConfigurationData>> getSurveyAnswers(int visitId) async {
    try {
      final response = await repository.callgetAPI(
        apiUrl: "/api/get/visit/answers",
        queryParams: {
          "visit_id": visitId.toString(),
         "lang": repository.userProfile.language,
        },
      );



      print("🔍 Full API_surveyview_response: $response");

      final answers = response['answers'];
      visitorInfo = response['visitor_info'] ?? {}; // visitor_info


      print("🧾 Raw decoded response: $response");
      print("📬 response['answers']: ${response['answers']} (${response['answers']?.runtimeType})");


      final state = response['state'];

      if (answers is! List) {
        print("❌ 'answers' is not a List! Type: ${answers.runtimeType}");
        print("❌ Actual value: $answers");
        throw Exception("API returned non-list 'answers'. Check server response.");
      }

      print("📦 getSurveyAnswers - state: $state");
      print("📦 getSurveyAnswers - answers count: ${answers.length}");

      List<VisitConfigurationData> parsedSections = [];

      for (var section in answers) {
        final VisitConfigurationData tab = VisitConfigurationData();
        tab.sectionName = JsonUtils.getName(section[0]) ?? "Unnamed Section";
        tab.pageId = JsonUtils.getId(section[0]);
        tab.list = [];

        // ✅ Parse questions only if present
        if (section.length >= 2 && section[1] is List) {
          for (var question in section[1]) {
            final Map<String, dynamic> questionMap = Map<String, dynamic>.from(question);
            final item = VisitConfiguration.fromJson(questionMap);
            item.originalAnswers = questionMap['user_answer'] != null
                ? List<Map<String, dynamic>>.from(questionMap['user_answer'])
                : null;
            item.value = _extractUserAnswer(questionMap);
            tab.list!.add(item);
          }
        }

        print("✅ Added tab: ${tab.sectionName} with ${tab.list?.length ?? 0} questions");
        parsedSections.add(tab);
      }



      return parsedSections;
    } catch (e) {
      print("❌ getSurveyAnswers error: $e");
      rethrow;
    }
  }







  Future<dynamic> getSurveyDetail(int surveyId) async {
    try {
      List<VisitConfigurationData> data=[];
      dynamic _dynamic={
        "lang" : repository.userProfile.language,
        "visit_id": surveyId,
        // "access_token": "9bec2039-b847-49be-8577-cbaa50ae9e84"
      };
      print('_dynamic');
      print(_dynamic);
      dynamic response = await repository.callAPI(apiUrl: "/api/get/visit/questions",domain: _dynamic);
      print('getSurveyDetail');
      print(response['body']['visitRequest']['qestions']);
      data=(response['body']['visitRequest']['qestions'] as List).map((item) => VisitConfigurationData.fromJson(item)).toList();
      String state=JsonUtils.toText(response['body']['visitRequest']['state'])??"new";
      dynamic result ={"tabs":data,"state":state};
      return result;
    }on Exception catch (e){
      print('getSurveyDetail errror');
      print(e);
      throw e;
    }

  }

  Future<dynamic> getSurveyDetailByPageId(int surveyId,String? pageId) async {
    try {
      VisitConfigurationData? data;
      dynamic _dynamic={
        "lang" : repository.userProfile.language,
        "visit_id": surveyId,
        "page_id": pageId
      };
      dynamic response = await repository.callAPI(apiUrl: "/api/get/visit/questions",domain: _dynamic);
      data= VisitConfigurationData.fromJson(response['body']['visitRequest']['qestions'][0]);
      return data;
    }on Exception catch (e){
      print('getSurveyDetail errror');
      print(e);
      throw e;
    }

  }

  Future<List<VisitConfigurationData>> getSurveyViewByPageId(int visitId, String? pageId) async {
    try {
      final response = await repository.callgetAPI(
        apiUrl: "/api/get/visit/answers",
        queryParams: {
          "visit_id": visitId.toString(),
          "page_id": pageId.toString(),
          // "lang": repository.userProfile.language, // Optional if needed
        },
      );

      print("🔍 API response (single page): $response");

      final answers = response['answers'];
      final state = response['state'];

      if (answers is! List) {
        print("❌ 'answers' is not a List! Type: ${answers.runtimeType}");
        throw Exception("API returned non-list 'answers'.");
      }

      print("📦 getSurveyAnswersByPageId - state: $state");
      print("📦 getSurveyAnswersByPageId - answers count: ${answers.length}");

      List<VisitConfigurationData> parsedSections = [];

      for (var section in answers) {
        final VisitConfigurationData tab = VisitConfigurationData();
        tab.sectionName = JsonUtils.getName(section[0]) ?? "Unnamed Section";
        tab.pageId = JsonUtils.getId(section[0]);
        tab.list = [];

        if (section.length >= 2 && section[1] is List) {
          for (var question in section[1]) {
            final Map<String, dynamic> questionMap = Map<String, dynamic>.from(question);


            final item = VisitConfiguration.fromJson(questionMap);
            item.originalAnswers = questionMap['user_answer'] != null
                ? List<Map<String, dynamic>>.from(questionMap['user_answer'])
                : null;

            item.value = _extractUserAnswer(questionMap);
            print("🟢 Parsed value for: ${item.name} → ${item.value}");



// ✅ Ensure proper structure for matrix
            if (item.fieldType == FieldType.matrix) {
              // Matrix answers should be List<List<int>> like: [[rowId, colId]]
              if (item.value is List &&
                  item.value.every((e) => e is Map &&
                      e.containsKey('matrix_row_id') &&
                      e.containsKey('suggested_answer_id'))) {
                // Parse from matrix_row_id and suggested_answer_id using JsonUtils.getId
                item.value = item.value.map((e) {
                  final rowId = JsonUtils.getId(e['matrix_row_id']);
                  final colId = JsonUtils.getId(e['suggested_answer_id']);
                  return [rowId, colId];
                }).where((pair) => pair[0] != null && pair[1] != null).toList();
              } else if (item.value is List &&
                  item.value.every((e) => e is List && e.length == 2)) {
                // Already valid list of pairs
              } else {
                print("⚠️ Matrix value malformed: ${item.value}");
                item.value = []; // Fallback
              }
            }


            // ✅ same logic
            tab.list!.add(item);
          }
        }

        print("✅ Parsed tab: ${tab.sectionName}, Questions: ${tab.list?.length ?? 0}");
        parsedSections.add(tab);
      }

      return parsedSections;
    } catch (e) {
      print("❌ getSurveyAnswersByPageId error: $e");
      rethrow;
    }
  }



  Future<SurveyResponse> submitSurvey(Map<String, dynamic> payload,String token) async {
    try {
      SurveyResponse res=SurveyResponse();
      dynamic _dynamic=payload;
      print('submitSurvey');
      print(payload);
      dynamic response = await repository.callAPI(apiUrl: "/survey/submit/"+token,domain: _dynamic);
      print(response);
      if (response.containsKey('error')) {
          res.isSuccess=false;
         if(response['error']=='validation'){
           print(response['fields']);
           final Map<String, dynamic> fields = Map<String, dynamic>.from(response['fields']);
           print(fields.entries);
           res.errors = fields.entries
               .map((entry) => ComboItem(key: entry.key, value: (JsonUtils.toText(entry.value)??"")==""?'Invalid value':(JsonUtils.toText(entry.value)??"") ))
               .toList();
         }
         else{
            res.message=response['error'];
         }
      }else{
        res.isSuccess=true;
      }
      // res.isSuccess=true;

      return res;
    }on Exception catch (e){
      print('submitSurvey errror');
      print(e);
      throw e;
    }

  }

  Future<dynamic> startSurvey(String token) async {
    try {
      dynamic _dynamic= {
        'mobile':"mobile"
      };
      dynamic response = await repository.callAPI(apiUrl: "/survey/begin/"+token,domain: _dynamic);
      print('startSurvey');
      print(response);
      return response;
    }on Exception catch (e){
      print('submitSurvey errror');
      print(e);
      throw e;
    }

  }


}
