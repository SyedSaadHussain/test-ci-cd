import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';

 class VisitEidFormViewModel extends VisitFormViewModel<VisitEidModel> {

  /// Hive box used for visit data storage
  HiveBoxHelper visitHiveBox = HiveRegistry.eidVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_eid.json';

  VisitEidFormViewModel({
    required VisitRepository visitRepository,
    required VisitEidModel visitParam,
    required VisitEidModel visitObj,
    required Function? onCallback,
  }) : super(visitRepository,visitParam,visitObj,onCallback); // ✅ pass up to base class

  /// Tabs to be displayed in the visit screen
  @override
  List<String> tabs = [
    'visit_info'.tr(),
    'eid_mosque_info'.tr(),
    'encroachments_info'.tr(),
    'land_info'.tr(),
    'public_safety_info'.tr()
  ];

  /// Called on Submit after validate form and declaration
  @override
  submitVisit(context){
    visitRepository.submitEidVisit(visitObj,disclaimerContent).then((result){
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
    visitObj.onVisitStart();
    notifyListeners();
  }

  /// Loads initial data if visit is not downloaded
  @override
  Future<void> initializeVisit() async{
    isLoading=true;
    notifyListeners();
    await visitRepository.getInitializeEidVisit(visitParam.id!).then((result){

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

  //region Visit Object Updates
   updateEidPrayerBoard(val){
     visitObj.eidPrayerBoard=val;
     visitObj.eidPrayerComment=null;
     notifyListeners();
   }
   updateTempBuildingPrayer(val){
     visitObj.tempBuildingPrayer=val;
     visitObj.typeTempBuilding=null;
     notifyListeners();
   }
   updateEncroachmentOnPrayerArea(val){
     visitObj.encroachmentOnPrayerArea=val;
     visitObj.typeOfViolation=null;
     visitObj.violationComment=null;
     notifyListeners();
   }
   updateElectricityMeter(val){
     visitObj.isElectricityMeter=val;
     visitObj.onChangeIsElectricityMeter();
     notifyListeners();
   }
   updateChooseElectricityMeter(val,isNew){
     if(isNew){
       if(visitObj.chooseElectricityMeter==null){
         visitObj.chooseElectricityMeter=[];
       }
       if (!visitObj.chooseElectricityMeter!.contains(val.key)) {
         visitObj.chooseElectricityMeter!.add(val.key);
       }
     }else{
       visitObj.chooseElectricityMeter!.removeWhere((key) => key == val.key);
     }
     notifyListeners();
   }
   //For Land Info
   updateLandFenced(val){
     visitObj.landFenced=val;
     visitObj.landFencedComment=null;
     notifyListeners();
   }
   updateTreeTallGrass(val){
     visitObj.treeTallGrass=val;
     visitObj.treeTallGrassComment=null;
     notifyListeners();
   }
   updateThereAnySwamps(val){
     visitObj.thereAnySwamps=val;
     visitObj.commentSwamps=null;
     notifyListeners();
   }
   //For safety
   updatePublicSafetyHazard(val){
     visitObj.publicSafetyHazard=val;
     visitObj.commentOnSafetyHazard=null;
     notifyListeners();
   }
   updateWarningInfoPanel(val){
     visitObj.warningInfoPanel=val;
     visitObj.warningPanelComment=null;
     notifyListeners();
   }
   updatePrayerHallFree(val){
     visitObj.prayerHallFree=val;
     visitObj.prayerHallComment=null;
     notifyListeners();
   }
   updatePollutionNearHall(val){
     visitObj.pollutionNearHall=val;
     visitObj.pollutionHallComment=null;
     notifyListeners();
   }
 //endregion

}

