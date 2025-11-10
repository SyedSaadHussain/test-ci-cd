import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:intl/intl.dart';


class SurveyUserInput {
  int? id;
  String? name;
  String? state;
  String? url;
  int? surveyId;
  String? surveyName;
  int? employeeId ;
  String? employeeName;
  int? mosqueId;
  String? mosqueName;
  int? landId;
  String? landName;
  int? cityId;
  String? cityName;
  String? landAddress;
  String? priorityValue;
  String? printUrl;
  DateTime? startDatetime;
  DateTime? visitDate;
  String? endDatetime;
  double? latitude;
  double? longitude;
  int? stageId;
  String? stageName;
  int? regionId;
  String? regionName;
  String? sequenceNo;
  String? workflowState;
  bool? displayButtonAccept;
  bool? displayButtonUnderProgress;
  bool? displayButtonAction;
  String? visitfor;

  Color get priorityColor {
    switch (priorityValue?.toLowerCase()) {
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.yellow;
      case 'low':
        return AppColors.low;
      default:
        return Colors.grey.shade300;
    }
  }

  String get submitToken{
    try{

      Uri uri = Uri.parse(this.url??"");
      print('submitToken..');
      print(uri);
      print(uri.pathSegments[3]);

      String surveyId = uri.pathSegments[3];

      String? answerToken = uri.queryParameters['answer_token'];
      print('submitTokenend..');
      String result = '$surveyId/$answerToken';
      return result;
    }catch(e){
      return "";
    }

  }

  SurveyUserInput({this.url,
    this.id,
    this.name,
    this.state,
    this.surveyId,
    this.surveyName,
    this.regionId,
    this.regionName,
    this.mosqueName,
    this.employeeId,
    this.employeeName,
    this.mosqueId,
    this.landId,
    this.landName,
    this.cityId,
    this.cityName,
    this.landAddress,
    this.priorityValue,
    this.stageId,
    this.endDatetime,
    this.visitDate,
    this.latitude,
    this.longitude,
    this.printUrl,
    this.sequenceNo,
    this.stageName,
    this.startDatetime,
    this.workflowState,
    this.displayButtonAccept,
    this.displayButtonUnderProgress,
    this.displayButtonAction,
    this.visitfor
    
  });

  SurveyUserInput.shallowCopy(SurveyUserInput other)
      : id = other.id,
        name = other.name,
        state = other.state,
        regionId = other.regionId,
        regionName = other.regionName,
        stageId = other.stageId,
        stageName = other.stageName,
        priorityValue = other.priorityValue,
        url = other.url,
        employeeName = other.employeeName,
        printUrl = other.printUrl,
        workflowState = other.workflowState,
        endDatetime = other.endDatetime,
        sequenceNo = other.sequenceNo,
        mosqueName = other.mosqueName,
        startDatetime = other.startDatetime,
        surveyName = other.surveyName,
        landAddress = other.landAddress,
        landName = other.landName,
        visitfor = other.visitfor,
        mosqueId = other.mosqueId,
        cityId = other.cityId,
        cityName = other.cityName,
        latitude = other.latitude,
        longitude = other.longitude

  ;
  bool get isActionButton =>
      (displayButtonAccept ?? false) ||
          (displayButtonUnderProgress ?? false) ||
          (displayButtonAction ?? false);

  String get dateOfVisitGreg {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    return this.visitDate==null?"":dateFormat.format(this.visitDate!);
  }

  factory SurveyUserInput.fromJson(Map<String, dynamic> json) {

    return SurveyUserInput(
      id: JsonUtils.toInt(json['id']),
      name: JsonUtils.toText(json['name']),
      state: JsonUtils.toText(json['state']),
      url: JsonUtils.toText(json['url'])??'',
      surveyId: JsonUtils.getId(json['survey_id']),
      surveyName: JsonUtils.getName(json['survey_id']),
      employeeId: JsonUtils.getId(json['employee_id']),
      employeeName: JsonUtils.getName(json['employee_id']),
      mosqueId: JsonUtils.getId(json['mosque_id']),
      mosqueName: JsonUtils.getName(json['mosque_id']),
      landId: JsonUtils.getId(json['land_id']),
      landName: JsonUtils.getName(json['land_name']),
      landAddress: JsonUtils.toText(json['land_address']),
      priorityValue: JsonUtils.toText(json['priority_value']),
      workflowState: JsonUtils.toText(json['workflow_state']),
      sequenceNo: JsonUtils.toText(json['sequence_no']),
      printUrl: JsonUtils.toText(json['print_url']),
      endDatetime: JsonUtils.toText(json['end_datetime']),
      startDatetime:JsonUtils.toLocalDateTime(json['start_datetime']),
      visitDate: JsonUtils.toDateTime(json['visit_date']),
      latitude: JsonUtils.toDouble(json['latitude']),
      longitude: JsonUtils.toDouble(json['longitude']),
      stageId: JsonUtils.getId(json['stage_id']),
      stageName: JsonUtils.getName(json['stage_id']),
      displayButtonAccept: JsonUtils.toBoolean(json['display_button_accept']),
      displayButtonUnderProgress: JsonUtils.toBoolean(json['display_button_underprogress']),
      displayButtonAction: JsonUtils.toBoolean(json['display_button_action']),
        visitfor: JsonUtils.toText(json['visit_for']),
      cityId: JsonUtils.getId(json['city_id']),
      cityName: JsonUtils.getName(json['city_id'])

        

    );
  }
  void updateFrom(SurveyUserInput other) {
    this.displayButtonAccept = other.displayButtonAccept;
    this.displayButtonUnderProgress = other.displayButtonUnderProgress;
    this.displayButtonAction = other.displayButtonAction;
    // ...update other fields if needed
  }

}


class SurveyUserInputData extends PagedData<SurveyUserInput>{

}
