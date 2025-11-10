import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';

 class VisitLandViewViewModel extends VisitViewModel<VisitLandModel> {

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_land.json';

  VisitLandViewViewModel({
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

  /// Setup configuration for each tabs
  @override
  loadTabs() {
    tabsData.add(TabModel(name: 'type', url: '/land/visit/land/type/info', response: 'visit', isLoaded: false));
    tabsData.add(TabModel(name: 'encroachment', url: '/land/visit/temporary/encroachment/info', response: 'visit_meters', isLoaded: false));
    tabsData.add(TabModel(name: 'meter', url: '/land/visit/electricity/meter/info', response: 'visit_building', isLoaded: false));
    tabsData.add(TabModel(name: 'safety', url: '/land/visit/safety/info', response: '', isLoaded: false));
    tabsData.add(TabModel(name: 'accuracy', url: '/land/visit/data/accuracy/info', response: 'data', isLoaded: false));
  }

  /// Get Method when you swipe tabs, it will call API if you first time come on that tab
  @override
  getViewData(TabModel tab){
    if(tab.isLoaded)
      return;

    startLoading();
    visitRepository.getLandVisitDetail(visitPram.id!,tab.url,tab.name,visitObj).then((result){
      visitObj=result;
      stopLoading();
      tab.isLoaded=true;
    }).catchError((e){
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  ///Click on Accept Visit Button
  @override
  void onAccept(terms){
    startLoading();
    visitRepository.acceptLandVisit(visitPram,terms).then((result){
      visitPram.onAccept(result);
      // visitObj.onAccept(result);
      onCallback!();
      reloadFirstTab();
    }).catchError((e){
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  ///Click on Action taken Visit Button
  @override
  void onTakeAction(TakeVisitActionModel action){
    startLoading();
    visitRepository.takeActionLandVisit(visitPram,action).then((result){
      visitPram.onTakeAction(result);
      // visitObj.onTakeAction(result);

      onCallback!();
      reloadFirstTab();

    }).catchError((e){
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  ///Click on Underprogress
  @override
  void onUnderProgress(){
    startLoading();
    visitRepository.onUnderProgressLandVisit(visitPram).then((result){
      visitPram.onUnderProgress(result);
      // visitObj.onUnderProgress(result);
      reloadFirstTab();
      stopLoading();
    }).catchError((e){
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

}

