import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';

 class VisitFemaleViewViewModel extends VisitViewModel<VisitFemaleModel> {

  /// Path to JSON file containing translation labels and combo data
  @override
  String get viewPath => 'assets/views/visit_female_view.json';

  VisitFemaleViewViewModel({
    required VisitRepository visitRepository,
    required VisitFemaleModel visitParam,
    required VisitFemaleModel visitObj,
    required Function? onCallback,
  }) : super(visitRepository,visitParam,visitObj,onCallback); // ✅ pass up to base class

  /// Tabs to be displayed in the visit screen
  @override
  List<String> tabs=[
    'base_info'.tr(),
    'women_prayer_hall'.tr(),
    'meters'.tr(),
    'building'.tr(),
    'devices'.tr(),
    'safety_standards'.tr(),
    'cleanliness_and_maintenance'.tr(),
    'security_violations'.tr(),
    'dawah_activities_and_lectures'.tr(),
    'mosque_status'.tr(),
  ];

  /// Setup configuration for each tabs
  @override
  loadTabs(){
    tabsData.add(TabModel(name: 'mansoob',url: '/female/prayerhall/data',response: 'visit',isLoaded: false));
    tabsData.add(TabModel(name: 'meter',url: '/female/visit/meter/data',response: 'visit_meters',isLoaded: false));
    tabsData.add(TabModel(name: 'building',url: '/get/female/visit/building/data',response: 'visit_building',isLoaded: false));
    tabsData.add(TabModel(name: 'device',url: '/female/electronicDeviceStatus',response: '',isLoaded: false));
    tabsData.add(TabModel(name: 'safety',url: '/female/visit/safety/standards',response: 'data',isLoaded: false));
    tabsData.add(TabModel(name: 'maintenance',url: '/female/visit/cleanliness/maintenance',response: 'cleanliness_maintenance',isLoaded: false));
    tabsData.add(TabModel(name: 'security',url: '/female/visit/security/violation',response: 'security_violation',isLoaded: false));
    tabsData.add(TabModel(name: 'dawah',url: '/female/visit/dawah/lecture',response: 'dawah_lecture',isLoaded: false));
    tabsData.add(TabModel(name: 'status',url: '/female/visit/mosque/status',response: 'mosque_status',isLoaded: false));

  }

  /// Get Method when you swipe tabs, it will call API if you first time come on that tab
  @override
  getViewData(TabModel tab){
    if(tab.isLoaded)
      return;

    startLoading();
    visitRepository.getFemaleVisitDetail(visitPram.id!,tab.url,tab.name,visitObj).then((result){
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
    visitRepository.acceptFemaleVisit(visitPram,terms).then((result){
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
    visitRepository.takeActionFemaleVisit(visitPram,action).then((result){
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
    visitRepository.onUnderProgressFemaleVisit(visitPram).then((result){
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

