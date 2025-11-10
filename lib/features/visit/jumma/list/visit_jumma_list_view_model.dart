import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_screen.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/view/visit_jumma_view_screen.dart';
import 'package:mosque_management_system/features/visit/jumma/view/visit_jumma_view_model.dart';
import 'package:provider/provider.dart';

class VisitJummaListViewModel extends VisitListViewModel<VisitJummaModel> {

  VisitJummaListViewModel({
    required int currentStageId,
  }) : super(currentStageId);

  /// Hive box used for visit data storage
  @override
  HiveBoxHelper<VisitJummaModel> visitHiveBox=HiveRegistry.jummaVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String viewPath='assets/data/stages/visit_jumma.json';

  @override
  Future<void> downloadVisit(context,VisitJummaModel visit) async{
    startLoading();
    VisitJummaModel _visit;
    _visit= VisitJummaModel.shallowCopy(visit);


    await visitRepository.getInitializeJummaVisit(visit.id!).then((result){
      stopLoading();

      _visit.initializeFields(result);
      saveVisit(_visit,context);
// visitHiveBox.put(visit.id,_visit).then((res){
//         loadOfflineVisits();
//         if(_visit.cityId!=null){
//           visitRepository.getTodayPrayerTime(_visit.cityId!);
//         }
//       });

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
    visitRepository.getJummaVisits(stageId: currentStageId,
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
  Future<void> onClickVisit(context,VisitJummaModel visit,int? employeeId) async{
    if(visit.isStartVisitRights(employeeId)){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitFormViewModel<VisitJummaModel>>(
            create: (ctx) => VisitJummaFormViewModel(
                visitRepository: visitRepository,
                visitParam: visit,
                visitObj: VisitJummaModel.shallowCopy(visit),
                onCallback: (){
                  loadOfflineVisits();
                }
            ),
            child: VisitJummaFormScreen(
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
          builder: (context) => ChangeNotifierProvider<VisitViewModel<VisitJummaModel>>(
            create: (ctx) => VisitJummaViewViewModel(
              visitRepository: visitRepository,
              visitParam: visit,
              visitObj: VisitJummaModel(id: visit.id),
              onCallback: (){
                notifyListeners();
              },
            ),
            child: VisitJummaViewScreen(
              visit: visit
            ),
          ),
        ),
      );

    }
  }



}