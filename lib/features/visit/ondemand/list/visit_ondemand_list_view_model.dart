import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/ondemand/create/create_ondemand_screen.dart';
import 'package:mosque_management_system/features/visit/ondemand/create/create_ondemand_view_model.dart';
import 'package:mosque_management_system/features/visit/ondemand/form/visit_ondemand_view_model.dart';
import 'package:mosque_management_system/features/visit/ondemand/form/visit_ondemand_form_screen.dart';
import 'package:mosque_management_system/features/visit/ondemand/view/visit_ondemand_view_screen.dart';
import 'package:mosque_management_system/features/visit/ondemand/view/visit_ondemand_view_model.dart';
import 'package:provider/provider.dart';

class VisitOndemandListViewModel extends VisitListViewModel<VisitOndemandModel> {

  bool isOnlyMyVisit=false;
  int? classificationId;
  VisitOndemandListViewModel({
    required this.classificationId,
    required int currentStageId,
  }) : super(currentStageId);

  /// Hive box used for visit data storage
  @override
  HiveBoxHelper<VisitOndemandModel> visitHiveBox=HiveRegistry.ondemandVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String viewPath='assets/data/stages/visit_ondemand.json';

  @override
  Future<void> downloadVisit(context,VisitOndemandModel visit) async{
    startLoading();
    VisitOndemandModel _visit;
    _visit= VisitOndemandModel.shallowCopy(visit);


    await visitRepository.getInitializeOndemandVisit(visit.id!).then((result){
      stopLoading();

      _visit.initializeFields(result);
      saveVisit(_visit,context);
    // visitHiveBox.put(visit.id,_visit).then((res){
    //     loadOfflineVisits();
    //     if(_visit.cityId!=null){
    //       visitRepository.getTodayPrayerTime(_visit.cityId!);
    //     }
    //   });


    }).catchError((e){
    stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  /// Get API to fill the online list
  Future<void> getVisits(bool isReload) async{
    if(isReload)
      paginatedVisits.reset();
    paginatedVisits.init();
    visitRepository.getOndemandVisits(
        stageId: currentStageId==0?VisitDefaults.defaultIdVisitOndemand:currentStageId,//if 0 means click on my draft by supervisor
        employeeId: currentStageId==0?userProfile?.employeeId:null,//if click on my draft stage so pass employee id
        query: query,
        pageIndex: paginatedVisits.pageIndex,
        limit: paginatedVisits.pageSize).then((result){
      paginatedVisits.isLoading=false;
      if(result.isEmpty){
        paginatedVisits.hasMore=false;
      }
      else {
        paginatedVisits.list.addAll(result);
      }
      notifyListeners();

    }).catchError((e){
      paginatedVisits.finish();
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  /// Redirect the page base on rights
  Future<void> onClickVisit(context,VisitOndemandModel visit,int? employeeId) async{
    if(visit.isStartVisitRights(employeeId)){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitFormViewModel<VisitOndemandModel>>(
            create: (ctx) => VisitOndemandFormViewModel(
                visitRepository: visitRepository,
                visitParam: visit,
                visitObj: VisitOndemandModel.shallowCopy(visit),
                onCallback: (){
                  loadOfflineVisits();
                }
            ),
            child: VisitOndemandFormScreen(
              visit: visit,
              onCallback: () => loadOfflineVisits(),
            ),
          ),
        ),
      );

    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitViewModel<VisitOndemandModel>>(
            create: (ctx) => VisitOndemandViewViewModel(
              visitRepository: visitRepository,
              visitParam: visit,
              visitObj: VisitOndemandModel(id: visit.id),
              onCallback: (){
                notifyListeners();
              },
            ),
            child: VisitOndemandViewScreen(
              visit: visit
            ),
          ),
        ),
      );
    }
  }


  /// Create new on Demand visit
  Future<void> onCreateVisit(context) async{
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChangeNotifierProvider<CreateOndemandViewModel>(
              create: (ctx) => CreateOndemandViewModel(
                visit: VisitOndemandModel(),
                onSuccess: (VisitOndemandModel? visit){
                    if(visit!=null){
                      paginatedVisits.list.insert(0, visit);
                      notifyListeners();
                    }
                    Future.delayed(const Duration(seconds: 2), () {
                      //Close Success message
                      Navigator.pop(context);
                      //Close close model
                      Navigator.pop(context);
                    });
                }
              ),
              child: CreateOndemandScreen(),
            ),
      ),
    );
  }

  Future<void> onClickMyVisit() async{
    isOnlyMyVisit=!isOnlyMyVisit;
    notifyListeners();
    getVisits(true);
  }

 @override
  Future<void> loadAPI() async{
    await super.loadAPI();
    print('sssssssssss');
    print(stages);
    if(classificationId==VisitDefaults.supervisorId){
      stages ??= []; // ensure it's not null
      if (stages!.length > 1) {
        stages!.insert(1, TabItem(key: 0, value: VisitMessages.myVisit));
      } else {
        stages!.add(TabItem(key: 0, value: VisitMessages.myVisit));
      }
    }else if(classificationId==VisitDefaults.observerId){
      stages!.removeWhere((tab) => tab.key == VisitDefaults.supervisorVisitIdOndemand);
    }
  }
}