import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/hive/hive_timestamped.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_workflow.dart';


abstract class VisitModelBase  extends HiveObject with HiveTimestamped {

  int? get id;
  double? get latitude;
  double? get longitude;
  String? get startDatetime;
  String? get actionNotes;
  String? get trasolNumber;
  List<int>? get actionAttachments;
  String? get actionTakenType;
  int? get cityId;
  String? get state;
  int? get stageId;
  String? get stage;
  String? get submitDatetime;
  String? get lastUpdatedFrom;
  int? get employeeId;
  String? get priorityValue;
  bool? displayButtonAccept;
  bool? displayButtonUnderprogress;
  bool? displayButtonAction;
  bool get isShowActionTakenPanel =>AppUtils.isNotNullOrEmpty(actionNotes);
  bool? isLoading;
  List<VisitWorkflow>? get visitWorkFlow;

  String? get listTitle;
  String? get listSubTitle;

  set latitude(double? val);
  set longitude(double? val);
  set state(String? val);
  set stage(String? val);
  set lastUpdatedFrom(String? val);
  set submitDatetime(String? val);
  set stageId(int? val);
  bool? get dataVerified;

  bool get isDataVerified=> (dataVerified??false);
  // bool get isDataVerified=> (dataVerified??false) || Config.disableValidation;

  /// Computed property for priority
  Color get priorityColor {
    switch (priorityValue) {
      case 'low':
        return AppColors.success;
      case 'high':
        return AppColors.danger;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.gray; // fallback
    }
  }

  void onSubmitSuccess(json){
    state=JsonUtils.toText(json['stage']?['state']);

    stageId=JsonUtils.toInt(json['stage']?['id']);
    stage=JsonUtils.toText(json['stage']?['name']);
  }

  void onSubmitStart(){
    lastUpdatedFrom = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
    submitDatetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toUtc());
  }

  void onSubmitFailure(){
    submitDatetime = null;
  }

  void onAccept(json){
    stageId=JsonUtils.toInt(json['stage']?['id']);
    stage=JsonUtils.toText(json['stage']?['name']);
    displayButtonAccept=false;
  }

  void onTakeAction(json){
    stageId=JsonUtils.toInt(json['stage']?['id']);
    stage=JsonUtils.toText(json['stage']?['name']);
    displayButtonAction=false;
    displayButtonUnderprogress=false;
  }

  void onUnderProgress(json){
    stageId=JsonUtils.toInt(json['stage']?['id']);
    stage=JsonUtils.toText(json['stage']?['name']);
    displayButtonUnderprogress=false;
  }

  bool  isStartVisitRights(dynamic loginEmpId){
    return VisitDefaults.draftStateValue==state && loginEmpId==employeeId;
  }
}
