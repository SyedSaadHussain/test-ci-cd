import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/data/services/yakeen_service.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_sub_view_model.dart';

class VisitJummaFormViewModel extends VisitFormSubViewModel<VisitJummaModel> {

  /// Hive box used for visit data storage
  HiveBoxHelper visitHiveBox = HiveRegistry.jummaVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_jumma_view.json';

  VisitJummaFormViewModel({
    required VisitRepository visitRepository,
    required VisitJummaModel visitParam,
    required VisitJummaModel visitObj,
    required Function? onCallback,
  }) : super(visitRepository,visitParam,visitObj,onCallback); // ✅ pass up to base class

  /// Tabs to be displayed in the visit screen
  @override
  List<String> tabs = [
    'base_info'.tr(),
    'mansoob_mosque'.tr(),
    'khutba_section'.tr(),
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
    visitRepository.submitJummaVisit(visitParam.id, visitObj,disclaimerContent).then((result){
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
    // visitObj.onVisitStart(null);
    // notifyListeners();
    // return;
    if(prayerTime!=null){
      final prayerName = prayerTime?.getPrayerNameByTime();
      if (prayerName!=null) {
        bool isPrayerTimeExist=await  visitRepository.isPrayerTimeExits(prayerName);
        if(prayerTime!.isJumma(prayerName)==false){
          showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.isJummaTimeError));
        }
        else
          if(isPrayerTimeExist){
          showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.visitStartedError));
        }else{
          visitObj.onVisitStart(null);//because jumma is already set
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
    await visitRepository.getInitializeJummaVisit(visitParam.id!).then((result){
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

  Future<void> khateebVerification() async{
    isLoading=true;
    notifyListeners();
    final yakeenService = YakeenService();
    try {
      final name = await yakeenService.getUserName(
        visitObj.khatibIdentificationId ?? "",
        visitObj.dobKhatibHijri ?? "",
      );
      if(AppUtils.isNotNullOrEmpty(name)){
        visitObj.khateebNameYakeen=name;
      }else{
        showDialogCallback!(DialogMessage(type: DialogType.errorText, message: VisitMessages.yakeenNotVerifiedError));
      }
      notifyListeners();

    } catch (e) {
      showDialogCallback!(DialogMessage(type: DialogType.errorText, message: e.toString()));
    } finally{
      isLoading=false;
      notifyListeners();
    }
  }
}

