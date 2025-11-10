import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/view/visit_regular_view_screen.dart';
import 'package:mosque_management_system/features/visit/regular/view/visit_regular_view_model.dart';
import 'package:provider/provider.dart';

class VisitRegularListViewModel extends VisitListViewModel<RegularVisitModel> {

  VisitRegularListViewModel({
    required int currentStageId,
  }) : super(currentStageId);

  /// Hive box used for visit data storage
  @override
  HiveBoxHelper<RegularVisitModel> visitHiveBox=HiveRegistry.regularVisit;

  /// Path to JSON file containing translation labels and combo data
  @override
  String viewPath='assets/data/stages/visit_regular.json';

  @override
  Future<void> downloadVisit(context,RegularVisitModel visit) async{
    startLoading();
    RegularVisitModel _visit;
    _visit= RegularVisitModel.shallowCopy(visit);


    await visitRepository.getInitializeRegularVisit(visit.id!).then((result){
      stopLoading();
      _visit.initializeFields(result);
       saveVisit(_visit,context);
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
    visitRepository.getVisits(stageId: currentStageId,
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
  Future<void> onClickVisit(context,RegularVisitModel visit,int? employeeId) async{
    if(visit.isStartVisitRights(employeeId)){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitFormViewModel<RegularVisitModel>>(
            create: (ctx) => VisitRegularFormViewModel(
                visitRepository: visitRepository,
                visitParam: visit,
                visitObj: RegularVisitModel.shallowCopy(visit),
                onCallback: (){
                  loadOfflineVisits();
                }
            ),
            child: VisitRegularFormScreen(
                visit: visit
            ),
          ),
        ),
      );

    }else{

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<VisitViewModel<RegularVisitModel>>(
            create: (ctx) => VisitRegularViewViewModel(
              visitRepository: visitRepository,
              visitParam: visit,
              visitObj: RegularVisitModel(id: visit.id),
              onCallback: (){
                notifyListeners();
              },
            ),
            child: VisitRegularViewScreen(
                visit: visit
            ),
          ),
        ),
      );
    }
  }



}