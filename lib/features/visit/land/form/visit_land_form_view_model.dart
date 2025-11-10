import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';


 class VisitLandFormViewModel extends VisitFormViewModel<VisitLandModel> {

  /// Hive box used for visit data storage
  HiveBoxHelper visitHiveBox = HiveRegistry.landVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_land.json';

  VisitLandFormViewModel({
    required VisitRepository visitRepository,
    required VisitLandModel visitParam,
    required VisitLandModel visitObj,
    required Function? onCallback,
  }) : super(visitRepository,visitParam,visitObj,onCallback); // ✅ pass up to base class

  /// Tabs to be displayed in the visit screen
  @override
  List<String> tabs = [
    'visit_info'.tr(),
    'land_type_ownership'.tr(),
    'buildings_infrastructure'.tr(),
    'utilities'.tr(),
    'environmental_conditions'.tr(),
    'completion_notes'.tr()
  ];

  /// Called on Submit after validate form and declaration
  @override
  submitVisit(context){
    visitRepository.submitLandVisit(visitObj,disclaimerContent).then((result){
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
    await visitRepository.getInitializeLandVisit(visitParam.id!).then((result){
      isLoading=false;
      visitObj.initializeFields(result);
      notifyListeners();

      visitHiveBox.put(visitParam.id,visitObj).then((res){
        if(onCallback!=null){
          onCallback!();
        }
      });
    }).catchError((e){
      errorInitializedAPI=true;
      isLoading=false;
      notifyListeners();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  //region Visit Object Updates
  void updateHasEncroachment(val){
    visitObj.hasEncroachment=val;
    visitObj.encroachmentType=null;
    visitObj.encroachmentPhoto=null;
    notifyListeners();
  }

  void updateHasTemporaryBuildings(val){
    visitObj.hasTemporaryBuildings=val;
    visitObj.temporaryBuildingType=null;
    notifyListeners();
  }

  void updateHasElectricityMeter(val){
    visitObj.hasElectricityMeter=val;
    visitObj.electricityMeterNumber=null;
    visitObj.hasMeterEncroachment=null;
    visitObj.meterEncroachmentPhoto=null;
    notifyListeners();
  }

  void updateMeterEncroachment(val){
    visitObj.hasMeterEncroachment=val;
    visitObj.meterEncroachmentPhoto = null;
    notifyListeners();
  }

  void updateHasSafetyHazards(val){
    visitObj.hasSafetyHazards=val;
    visitObj.safetyHazardDescription=null;
    notifyListeners();
  }
  //endregion

}

