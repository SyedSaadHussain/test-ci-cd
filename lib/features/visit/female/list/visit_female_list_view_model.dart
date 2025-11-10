import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/female/form/visit_female_form_screen.dart';
import 'package:mosque_management_system/features/visit/female/form/visit_female_form_view_model.dart';
import 'package:mosque_management_system/features/visit/female/view/visit_female_view_screen.dart';
import 'package:mosque_management_system/features/visit/female/view/visit_female_view_model.dart';
import 'package:provider/provider.dart';


class VisitFemaleListViewModel extends VisitListViewModel<VisitFemaleModel> {

  VisitFemaleListViewModel({
    required int currentStageId,
  }) : super(currentStageId);

  /// Hive box used for visit data storage
  @override
  HiveBoxHelper<VisitFemaleModel> visitHiveBox=HiveRegistry.femaleVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String viewPath='assets/data/stages/visit_female.json';

  @override
  Future<void> downloadVisit(context,VisitFemaleModel visit) async{
    startLoading();
    VisitFemaleModel _visit;
    _visit= VisitFemaleModel.shallowCopy(visit);


    await visitRepository.getInitializeFemaleVisit(visit.id!).then((result){
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
    visitRepository.getFemaleVisits(stageId: currentStageId,
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
  Future<void> onClickVisit(context,VisitFemaleModel visit,int? employeeId) async{
    if(visit.isStartVisitRights(employeeId)){

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitFormViewModel<VisitFemaleModel>>(
            create: (ctx) => VisitFemaleFormViewModel(
                visitRepository: visitRepository,
                visitParam: visit,
                visitObj: VisitFemaleModel.shallowCopy(visit),
                onCallback: (){
                  loadOfflineVisits();
                }
            ),
            child: VisitFemaleFormScreen(
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
          builder: (context) => ChangeNotifierProvider<VisitViewModel<VisitFemaleModel>>(
            create: (ctx) => VisitFemaleViewViewModel(
              visitRepository: visitRepository,
              visitParam: visit,
              visitObj: VisitFemaleModel(id: visit.id),
              onCallback: (){
                notifyListeners();
              },
            ),
            child: VisitFemaleViewScreen(
              visit: visit
            ),
          ),
        ),
      );
    }
  }



}