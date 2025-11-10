import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/models/combo_list.dart' as combo;
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';

/// Base class for visit form view models (`Regular`, `Jumma`, `Female`, `OnDemand`, `Eid`, `Land`).
abstract  class VisitFormViewModel<T extends VisitModelBase> extends ChangeNotifier {

  //region Fields & dependencies
  late T visitObj;
  late T visitParam;
  final VisitRepository visitRepository;
  TabController? tabController;
  String disclaimerContent="أقر بأنه تم مراجعة جميع البيانات وأتحمل كامل المسؤولية عن صحتها";
  GPSPermission? permission;
  dynamic formDetailKey = GlobalKey<FormState>();
  bool isLoading = false;
  HiveBoxHelper get visitHiveBox;
  List<String> get tabs;
  bool isVisiblePermission=false;
  PrayerTime? prayerTime;
  String get viewPath;
  FieldListData fields=FieldListData();
  final Function? onCallback;
  ///This will be true if the first initlialized API got error, so hide the start button until resolve the error in initialized API
  bool errorInitializedAPI=false;

  ///
  @override
  void dispose() {
    permission?.dispose();             // ✅ dispose GPSPermission’s stream
    tabController?.dispose(); // ✅ Dispose tab controller here
    super.dispose();          // ✅ Always call super.dispose() last
  }

  ///This method use to show alert that are using context
  Function?  showDialogCallback;
  //endregion

  VisitFormViewModel(this.visitRepository,this.visitParam,this.visitObj,this.onCallback);

  //region Abstract methods

  ///This method must be override by inherited class
  submitVisit(context);

  ///This method must be override by inherited class
  locationVerified();

  /// Initializes the visit data if it is not already downloaded in Hive
  Future<void> initializeVisit();

  //endregion

  //region Visit actions
  ///Validate Visit form and show disclaimer, if approve then call th override submitVisit() method of ViewModel
  Future<void> onSubmitVisit(context) async {
    try{
      // await validateMobileClock();
      visitHiveBox.put(visitParam.id,visitObj);
      if (formDetailKey.currentState!.validate()) {
        formDetailKey.currentState!.save();

        showDisclaimerDialog(context,text:(disclaimerContent),onApproved: (){

          isLoading=true;
          notifyListeners();
          visitObj.onSubmitStart();

          submitVisit(context);
        });
      }
    }
    catch(e){
    }
  }

  ///Delete the visit from cahche, this method use for only testing purpose
  Future<void> deleteCache(context) async{
    try{
      await  visitHiveBox.delete(visitParam.id);
    }catch(e){
    }finally{

      onCallback!();
      Navigator.pop(context);
    }
  }

  ///This method is user to save the visit into hive
  Future<void> saveVisit() async{
    await  visitHiveBox.put(visitParam.id,visitObj);
  }

  /// Moves to the previous tab and saves the visit state locally.
  void previousTab(context){
    FocusScope.of(context).unfocus();
    tabController!.animateTo(tabController!.index-1);
    notifyListeners();
  }

  /// Moves to the next tab and saves the visit state locally.
  void nextTab() async{
    if (formDetailKey.currentState!.validate()) {
      formDetailKey.currentState!.save();
      tabController!.animateTo(tabController!.index+1);
      try{
        await visitHiveBox.put(visitParam.id,visitObj);
        notifyListeners();
      }catch(e){
      }
    }
  }

  ///When click onn start button, if locationVerified then for further condition call inherited method
  void startVisit() async{
    try{
      if(visitObj.isDataVerified==false){
        showDialogCallback!(DialogMessage(type: DialogType.errorText,
            message: VisitMessages.mosqueNotVerified));
        return;
      }

      if(Config.disableValidation){
        visitObj.latitude=37.4219983;
        visitObj.longitude=-122.084;
        // visitObj.latitude=25.3481801;
        // visitObj.longitude=49.5716729;
      }

      permission = GPSPermission(
        allowDistance: 100,
        latitude:  visitObj.latitude ?? 0.0,
        longitude: visitObj.longitude ?? 0.0,
      );

      permission!.listner.listen((value) async {
        notifyListeners();
        if (value) {

          isVisiblePermission = false;
          notifyListeners();
          locationVerified();
        }
      });
      isVisiblePermission = true;
      notifyListeners();

      permission!.checkPermission();

    }catch(e){
    }
  }

  //endregion

  //region for methods
  ///Show Loader on screen
  void startLoading(){
    isLoading=true;
    notifyListeners();
  }

  ///Stop Loader on screen
  void stopLoading(){
    isLoading=false;
    notifyListeners();
  }

  void init() async{
    errorInitializedAPI=false;
    await loadView();
    await  visitHiveBox.close();

    dynamic hiveObj  = await  visitHiveBox.get(visitParam.id);

    if(hiveObj==null){
      await initializeVisit();
    }else{
      visitObj=hiveObj;
      notifyListeners();

    }

    getTodayPrayerTime();
  }

  /// Fetches today's prayer time for the visit's city.
  Future<void> getTodayPrayerTime() async {
    try {
      visitRepository.getTodayPrayerTime(visitObj.cityId!).then((result){
        prayerTime=result;
      });
    }catch (e) {
      prayerTime=null;
    }
  }

  /// Loads the form view JSON and populates the fields labes and combo data.
  Future<void> loadView() async {
    fields.list=[];
    if(viewPath!=null){
      final fieldItems = await AssetJsonUtils.loadView<FieldList>(
        path: viewPath!,
        fromKeyValue: (key, value) => FieldList.fromStringJson(key, value),
      );
        fields.list.addAll(fieldItems);

       notifyListeners();
    }
  }

  //endregion

  //region for properties
  /// True if the start button should be disabled due to incomplete GPS check.
  bool get isLoadingStart => permission!=null && (permission!.isCompleted==false);//&& (_visit.isVisitStarted??false);
  /// True if the start button should be shown.
  bool get isShowStartBtn => tabController!.index==0 && AppUtils.isNullOrEmpty(visitObj.startDatetime) && errorInitializedAPI==false;//&& (_visit.isVisitStarted??false);
  /// True if the visit has started and can proceed.
  bool get isProceedVisit => tabController!.index==0 && AppUtils.isNotNullOrEmpty(visitObj.startDatetime);//(_visit.isVisitStarted??false);
  /// True if the back button should be shown.
  bool get isShowBackBtn => tabController!.index>0;
  /// True if the next button should be shown.
  bool get isShowNextBtn =>  tabController!.index>0 && tabController!.index!=tabController!.length-1;
  /// True if the submit button should be shown.
  bool get isShowSubmitBtn => tabController!.index==tabController!.length-1;
  //endregion

}