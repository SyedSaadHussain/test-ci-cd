import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_sub_view_model.dart';

 class VisitOndemandFormViewModel extends VisitFormSubViewModel<VisitOndemandModel> {

  /// Hive box used for visit data storage
  HiveBoxHelper visitHiveBox = HiveRegistry.ondemandVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_ondemand.json';

  VisitOndemandFormViewModel({
    required VisitRepository visitRepository,
    required VisitOndemandModel visitParam,
    required VisitOndemandModel visitObj,
    required Function? onCallback,
  }) : super(visitRepository,visitParam,visitObj,onCallback); // ✅ pass up to base class

  /// Tabs to be displayed in the visit screen
  @override
  List<String> tabs = [
    'base_info'.tr(),
    'mansoob_mosque'.tr(),
    'meters'.tr(),
    'building'.tr(),
    'devices'.tr(),
    'safety_standards'.tr(),
    'cleanliness_and_maintenance'.tr(),
    'security_violations'.tr(),
    'dawah_activities_and_lectures'.tr(),
    'mosque_status'.tr(),
  ];

  /// Called on Submit after validate form and declaration
  @override
  submitVisit(context){
    visitRepository.submitOndemandVisit(visitObj,disclaimerContent).then((result){
      isLoading=false;
      notifyListeners();
      if(result['success']==true){
        visitObj.onSubmitSuccess(result);
        visitParam.onSubmitSuccess(result);
        visitHiveBox.put(visitParam.id,visitObj);
        notifyListeners();
        if(onCallback!=null){
          onCallback!();
        }
        AppNotifier.showSuccess(context,result['message']).then((e){
          Navigator.pop(context);
        });
      }else{
        visitObj.onSubmitFailure();
        AppNotifier.showError(context,result['message']);
      }
    }).catchError((e){
      visitObj.onSubmitFailure();
      isLoading=false;
      notifyListeners();
      AppNotifier.showExceptionError(context,e);
    });
  }

  /// Called on Start button after location is verified
  @override
  Future<void> locationVerified() async{
    if(visitObj.isDeadlineActive==false){
      showDialogCallback!(DialogMessage(type: DialogType.errorText,
          message: VisitMessages.deadlineExpire));
    }
    else
    if(prayerTime!=null){
      final prayerName = prayerTime?.getPrayerNameByTime();
      if (prayerName!=null) {
        bool isPrayerTimeExist=await  visitRepository.isPrayerTimeExits(prayerName);
        if(isPrayerTimeExist){
          showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.visitStartedError));
        }else{
          visitObj.onVisitStart(prayerName);
        }
        notifyListeners();
      } else {
        showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.invalidPrayerTimeError));
      }
    }else{
      showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.noFoundTimeError));
    }
  }

  /// Loads initial data if visit is not downloaded
  @override
  Future<void> initializeVisit() async{
    isLoading=true;

    notifyListeners();
    await visitRepository.getInitializeOndemandVisit(visitParam.id!).then((result){
      isLoading=false;
      visitObj.initializeFields(result);
      notifyListeners();
      if(visitObj.isDataVerified) {
        visitHiveBox.put(visitParam.id, visitObj).then((res) {
          if (onCallback != null) {
            onCallback!();
          }
        });
      }
    }).catchError((e){
      isLoading=false;
      errorInitializedAPI=true;
      notifyListeners();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

}

