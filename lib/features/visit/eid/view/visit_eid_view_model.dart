import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';

 class VisitEidViewViewModel extends VisitViewModel<VisitEidModel> {

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_eid.json';

  VisitEidViewViewModel({
    required VisitRepository visitRepository,
    required VisitEidModel visitParam,
    required VisitEidModel visitObj,
    required Function? onCallback,
  }) : super(visitRepository,visitParam,visitObj,onCallback); // ✅ pass up to base class

  /// Tabs to be displayed in the visit screen
  @override
  List<String> tabs=[
    'visit_info'.tr(),
    'eid_mosque_info'.tr(),
    'encroachments_info'.tr(),
    'land_info'.tr(),
    'public_safety_info'.tr()
  ];

  /// Setup configuration for each tabs
  @override
  @override
  loadTabs() {
    tabsData.add(TabModel(name: 'type', url: '/eid/visit/eid/prayer/info', response: 'visit', isLoaded: false));
    tabsData.add(TabModel(name: 'encroachment', url: '/eid/visit/encroachment/info', response: 'visit_meters', isLoaded: false));
    tabsData.add(TabModel(name: 'meter', url: '/eid/visit/land/info', response: 'visit_building', isLoaded: false));
    tabsData.add(TabModel(name: 'safety', url: '/eid/visit/public/safety', response: '', isLoaded: false));
  }

  /// Get Method when you swipe tabs, it will call API if you first time come on that tab
  @override
  getViewData(TabModel tab){
    if(tab.isLoaded)
      return;

    startLoading();
    visitRepository.getEidVisitDetail(visitPram.id!,tab.url,tab.name,visitObj).then((result){
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
    visitRepository.acceptEidVisit(visitPram,terms).then((result){
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
    visitRepository.takeActionEidVisit(visitPram,action).then((result){
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
    visitRepository.onUnderProgressEidVisit(visitPram).then((result){
      visitPram.onUnderProgress(result);
      // visitObj.onUnderProgress(result);
      onCallback!();
      reloadFirstTab();
    }).catchError((e){
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

}

