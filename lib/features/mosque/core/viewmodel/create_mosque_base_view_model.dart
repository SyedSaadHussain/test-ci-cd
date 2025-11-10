import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/data/repositories/reference_repository.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';

abstract class CreateMosqueBaseViewModel<T extends MosqueLocal> with ChangeNotifier {
  String kAcceptTermsText =
      'أقر بأنه تم مراجعة جميع البيانات وأتحمل كامل المسؤولية عن صحتها';
  late T mosqueObj;
  late MosqueRepository repository;
  late ReferenceRepository refRepository;
  TabController? tabController;
  Function? onChangeTabs;
  bool isLoading=false;
  final Set<String> loadedTabs = <String>{};
  dynamic formDetailKey = GlobalKey<FormState>();
  FormMode get mode;
  dynamic headerMap;
  String? get modelName;
  List<String> tabs=['basic_info'.tr(),'mosque_address'.tr(),'mosque_condition'.tr()];
  CreateMosqueBaseViewModel(this.mosqueObj,this.repository,{required UserProfile profile}){
    refRepository=ReferenceRepository(profile);
    AppUtils.getHeadersMap().then((header){
      headerMap=header;
    });
  }

  int? get id ;
  ///This method use to show alert that are using context
  Function?  showDialogCallback;



    bool get showDependentTabs=>
      mosqueObj.mosqueCondition == 'existing_mosque' || mosqueObj.mosqueCondition == 'abandoned_mosque';
  FieldListData fields=FieldListData();
  @override
  void dispose() {
    tabController?.dispose();             // <— very important
    super.dispose();
  }
  Future<void> loadView() async {
    fields.list=[];
    final fieldItems = await AssetJsonUtils.loadView<FieldList>(
      path: 'assets/views/mosque_view.json',
      fromKeyValue: (key, value) => FieldList.fromStringJson(key, value),
    );
    fields.list=fieldItems;
    notifyListeners();
  }

  bool get hideEmployeeInfoTab {
    final int? st =
         (mosqueObj.payload is Map ? (mosqueObj.payload?['stage_id'] as int?) : null);
    return (mosqueObj.serverId != null) && (st == 189);
  }
  Future<void> init() async{
    await loadView();
    // reloadTabs();
    await loadMosque();
  }
  VoidCallback? _tabListener;
  dynamic tabKeys=[];
  void addTabController(){
    print('addTabController');
    // Remove old listener if exists
    if (_tabListener != null) {
      tabController?.removeListener(_tabListener!);
    }
    // Create new listener
    _tabListener = () {
      if (tabController!.indexIsChanging) return;
      loadTab(tabKeys[tabController!.index]);
    };
    // tabController!.addListener(() {
    //   if (tabController!.indexIsChanging) return;
    //   loadTab(tabKeys[tabController!.index]);
    // });
    // Attach listener
    tabController!.addListener(_tabListener!);
  }
  loadTab(index);
  reloadTabs(){
    tabs=['basic_info'.tr(),'mosque_address'.tr(),'mosque_condition'.tr()];
    if(showDependentTabs){
      tabs.add('architectural_structure'.tr());
      tabs.add('men_prayer_section'.tr());
      tabs.add('women_prayer_section'.tr());
      if (mode == FormMode.create && !hideEmployeeInfoTab) {
        tabs.add('employee_info'.tr());
      }
      tabs.add('imams_muezzins_details_tab'.tr());
      tabs.add('mosque_facilities'.tr());
      tabs.add('mosque_land_tab'.tr());
      tabs.add('audio_and_electronics'.tr());
      tabs.add('safety_equipment'.tr());
      tabs.add('maintenance_operation'.tr());
      tabs.add('meters'.tr());
      tabs.add('historical_mosques'.tr());
      tabs.add('QR code panel'.tr());


    }
    if(onChangeTabs!=null){
      onChangeTabs!();
    }

  }

  void onMosqueCoreMerged(String tabKey) { // NEW
    if (tabKey == 'basic_info' || tabKey == 'mosque_condition') {
      reloadTabs(); // <- uses your existing method & showDependentTabs
    }
  }


  Future<void> loadMosque();

  void onNext(){
    if (formDetailKey.currentState!.validate()) {
      formDetailKey.currentState!.save();
      print(tabController?.length);
      tabController!.animateTo(tabController!.index+1);
      notifyListeners();
      onNextSuccess();
    }
  }


  void onBack(context){
    FocusScope.of(context).unfocus();
    tabController!.animateTo(tabController!.index-1);
    notifyListeners();
  }

  void onSubmit(context);

  @protected
  void onNextSuccess(){

  }

  bool get isShowBackBtn => tabController!=null &&  (tabController?.index??0)>0;
  /// True if the next button should be shown.
  bool get isShowNextBtn =>  tabController!=null && (tabController?.index??0)>=0 && tabController!.index!=tabController!.length-1;
  /// True if the submit button should be shown.
  bool get isShowSubmitBtn => tabController!=null &&  tabController!.index==tabController!.length-1;


  bool get isShowSendButton => false;


  final Map<String, bool> _agreeField = {};        // key → checked?
  bool getAgree(String key) => _agreeField[key] ?? false;
  void agreeField(String key){
    if(mode == FormMode.editRequest && getAgree(key)==false){
      _agreeField[key] = true;
      notifyListeners();
    }
  }
  Future<List<ComboItem>>  getMosqueTypes() async{
    List<ComboItem>? items=[];
    items = await refRepository.getMosqueTypes();
    return items??[];
  }
  Future<List<ComboItem>>  getClassification() async{
    List<ComboItem>? items=[];
    items = await refRepository.getClassification();
    return items;
  }
  Future<List<ComboItem>>  getRegion() async{
    List<ComboItem>? items=[];
    items = await  refRepository.getRegion();
    return items;
  }
  Future<List<ComboItem>>  getCity() async{
    List<ComboItem>? items=[];
    items = await  refRepository.getCity(mosqueObj.regionId);
    return items;
  }
  Future<List<ComboItem>>  getDistricts() async{
    List<ComboItem>? items=[];
    items = await  refRepository.getDistricts();
    return items;
  }
  Future<List<ComboItem>>  getCenter() async{
    List<ComboItem>? items=[];
    items = await   refRepository.getCenter(mosqueObj.cityId);;
    return items;
  }
  void updateAgreeField(String key, bool val) {
    if(mode == FormMode.editRequest){
      if (val) _agreeField[key] = true; else _agreeField.remove(key);
      notifyListeners();
    }
  }

  startLoading(){
    isLoading=true;
    notifyListeners();
  }
  stopLoading(){
    isLoading=false;
    notifyListeners();
  }


}
