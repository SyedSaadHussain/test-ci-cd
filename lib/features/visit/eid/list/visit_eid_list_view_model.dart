import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_screen.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/view/visit_eid_view_screen.dart';
import 'package:mosque_management_system/features/visit/eid/view/visit_eid_view_model.dart';
import 'package:provider/provider.dart';

class VisitEidListViewModel extends VisitListViewModel<VisitEidModel> {

  VisitEidListViewModel({
    required int currentStageId,
  }) : super(currentStageId);

  /// Hive box used for visit data storage
  @override
  HiveBoxHelper<VisitEidModel> visitHiveBox=HiveRegistry.eidVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String viewPath='assets/data/stages/visit_eid.json';

  @override
  Future<void> downloadVisit(context,VisitEidModel visit) async{
    startLoading();
    VisitEidModel _visit;
    _visit= VisitEidModel.shallowCopy(visit);


    await visitRepository.getInitializeEidVisit(visit.id!).then((result){
      stopLoading();

      _visit.initializeFields(result);
      saveVisit(_visit,context);
      // visitHiveBox.put(visit.id,_visit).then((res){
      //   loadOfflineVisits();
      //   if(_visit.cityId!=null){
      //     visitRepository.getTodayPrayerTime(_visit.cityId!);
      //   }
      // });

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
    visitRepository.getEidVisits(stageId: currentStageId,
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
  Future<void> onClickVisit(context,VisitEidModel visit,int? employeeId) async{
    if(visit.isStartVisitRights(employeeId)){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitFormViewModel<VisitEidModel>>(
            create: (ctx) => VisitEidFormViewModel(
                visitRepository: visitRepository,
                visitParam: visit,
                visitObj: VisitEidModel.shallowCopy(visit),
                onCallback: (){
                  loadOfflineVisits();
                }
            ),
            child: VisitEidFormScreen(
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
          builder: (context) => ChangeNotifierProvider<VisitViewModel<VisitEidModel>>(
            create: (ctx) => VisitEidViewViewModel(
              visitRepository: visitRepository,
              visitParam: visit,
              visitObj: VisitEidModel(id: visit.id),
              onCallback: (){
                notifyListeners();
              },
            ),
            child: VisitEidViewScreen(
              visit: visit
            ),
          ),
        ),
      );
    }
  }



}


