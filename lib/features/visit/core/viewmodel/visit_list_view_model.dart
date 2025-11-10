import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/core/hive/extensions/visit_model_hive_extensions.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';

/// Base class for visit List view models for all visit types
abstract  class VisitListViewModel<T extends VisitModelBase> extends ChangeNotifier {
  /// Hive box helper for storing and retrieving visit data.
  HiveBoxHelper<T> get visitHiveBox;

  Function?  showDialogCallback;

  VisitListViewModel(this.currentStageId):
  visitRepository=VisitRepository();

  UserProfile? userProfile;

  /// Loads all offline visits from Hive and updates the UI.
  Future<void>  loadOfflineVisits() async{
    offlineVisits= await visitHiveBox.getAll();
    notifyListeners();

  }

  final PaginatedList<T> paginatedVisits =PaginatedList<T>();

  /// List of visits loaded from local Hive storage.
  List<T> offlineVisits=[];

  late VisitRepository visitRepository;

  /// Currently selected stage ID for filtering or display.
  int? currentStageId;

  /// Value in search box
  dynamic query='';

  /// Loads view configuration, deletes yesterday records, and loads offline visits.
  Future<void> loadAPI() async{

    await loadView();
    await deleteOldRecord();
    await loadOfflineVisits();
  }

  /// Deletes outdated yesterday visit records from Hive storage.
  Future<void>  deleteOldRecord() async{
    await visitHiveBox.deleteOldRecords();
  }

  /// Checks if a visit can be downloaded based on offline availability and user rights.
  bool canDownload({required VisitModelBase visit,required int? loginId}){
    return offlineVisits.where((a)=>a.id==visit.id).isEmpty
        && visit.isStartVisitRights(loginId)
    ;
  }

  // load offline visit again and load in grid if enable
  onToggleOffilne(val){
    isOfflineView = val;
    if (isOfflineView) {
      loadOfflineVisits();
    }
    notifyListeners();
  }
  bool isOfflineView=false;

  String? get viewPath;

  List<TabItem>? stages;

  /// Loads the stages/tabs configuration from a JSON view file.
  Future<void> loadView() async {
    stages=[];

    if(viewPath!=null){
      stages = await AssetJsonUtils.loadList<TabItem>(
        path: viewPath!,
        fromJson: (json) => TabItem.fromJsonObject(json),
      );
      notifyListeners();
    }
  }

  updateStage(int? stage){
    currentStageId=stage;
    notifyListeners();
    getVisits(true);
  }

  saveVisit(T visit,context){
    if(visit.isDataVerified){
      visitHiveBox.put(visit.id,visit).then((res){
        loadOfflineVisits();
        if(visit.cityId!=null){
          visitRepository.getTodayPrayerTime(visit.cityId!);
        }
      });
    }else{
        AppNotifier.showDialog(context, DialogMessage(type: DialogType.errorText, message: VisitMessages.mosqueNotVerified));
    }
  }

  bool isLoading=false;

  Future<void> downloadVisit(context,T visit);

  Future<void> getVisits(bool isReload);

  Future<void> onClickVisit(context,T visit,int? employeeId);

  void startLoading(){
    isLoading=true;
    notifyListeners();
  }

  void stopLoading(){
    isLoading=false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }


}