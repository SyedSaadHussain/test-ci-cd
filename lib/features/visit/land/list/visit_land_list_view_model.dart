import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/land/form/visit_land_form_screen.dart';
import 'package:mosque_management_system/features/visit/land/form/visit_land_form_view_model.dart';
import 'package:mosque_management_system/features/visit/land/view/visit_land_view_screen.dart';
import 'package:mosque_management_system/features/visit/land/view/visit_land_view_model.dart';
import 'package:provider/provider.dart';

class VisitLandListViewModel extends VisitListViewModel<VisitLandModel> {

  VisitLandListViewModel({
    required int currentStageId,
  }) : super(currentStageId);

  /// Hive box used for visit data storage
  @override
  HiveBoxHelper<VisitLandModel> visitHiveBox=HiveRegistry.landVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String viewPath='assets/data/stages/visit_land.json';

  @override
  Future<void> downloadVisit(context,VisitLandModel visit) async{
    startLoading();
    VisitLandModel _visit;
    _visit= VisitLandModel.shallowCopy(visit);


    await visitRepository.getInitializeLandVisit(visit.id!).then((result){
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
    visitRepository.getLandVisits(stageId: currentStageId,
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
  Future<void> onClickVisit(context,VisitLandModel visit,int? employeeId) async{
    if(visit.isStartVisitRights(employeeId)){


      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitFormViewModel<VisitLandModel>>(
            create: (ctx) => VisitLandFormViewModel(
                visitRepository: visitRepository,
                visitParam: visit,
                visitObj: VisitLandModel.shallowCopy(visit),
                onCallback: (){
                  loadOfflineVisits();
                }
            ),
            child: VisitLandFormScreen(
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
          builder: (context) => ChangeNotifierProvider<VisitViewModel<VisitLandModel>>(
            create: (ctx) => VisitLandViewViewModel(
              visitRepository: visitRepository,
              visitParam: visit,
              visitObj: VisitLandModel(id: visit.id),
              onCallback: (){
                notifyListeners();
              },
            ),
            child: VisitLandViewScreen(
              visit: visit,
            ),
          ),
        ),
      );
    }
  }



}