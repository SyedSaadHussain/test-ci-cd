import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';

/// Base class for visit view models for all visit types
abstract  class VisitViewModel<T extends VisitModelBase> extends ChangeNotifier {
  /// List of tab data models (abstract: to be provided by subclass)
  List<TabModel> tabsData=[];

  /// The current visit object being displayed or modified
  late T visitObj;

  /// The current visit come from list scsreen
  late T visitPram;

  /// Service for fetching and saving visit-related data
  late VisitRepository visitRepository;

  /// Holds field definitions translation from JSON view files
  FieldListData fields = FieldListData();

  /// Defines from which tab index dynamic loading of data should start
  int tabStartIndex = 1;

  /// Stores HTTP header parameters for API calls
  dynamic headerMap;




  /// Path to the JSON translation/view file for this visit type.
  ///
  /// This file defines the fields (labels, types, options, etc.)
  /// that will be loaded dynamically for rendering the form.
  String get viewPath;

  /// Controls tab navigation between different sections of the visit
  late TabController tabController;

  /// Indicates whether data is being loaded
  bool isLoading = false;

  /// List of tab labels (abstract: to be provided by subclass)
  List<String> get tabs;

  void startLoading(){
    isLoading=true;
    notifyListeners();
  }
  void stopLoading(){
    isLoading=false;
    notifyListeners();
  }
  ///Reload first tab after take action to change UI of first tab
  reloadFirstTab(){
    tabsData[0].isLoaded=false;
    getViewData(tabsData[0]);
  }

  final Function? onCallback;

  Function?  showDialogCallback;

  VisitViewModel(this.visitRepository,this.visitPram,this.visitObj,this.onCallback);
  
  void loadAPI() async{
    await loadView();
    loadTabs();
    tabController.addListener(_onTabChanged);
    //

    getViewData(tabsData[0]);
    //
    visitRepository.getHeadersMap().then((pramHeaderMap) {
      headerMap = pramHeaderMap;
    });
  }
  // Inside class VisitViewModel<T>
  void _onTabChanged() {
    if (tabController.indexIsChanging) return;
    if (tabController.index > tabStartIndex) {
      getViewData(tabsData[tabController.index - tabStartIndex]);
    }
  }

  ///Get all action types  to use in action pane;
  Future<List<ComboItem>> getActionTypes() async{
    try{
      List<ComboItem> items=[];
      items= await visitRepository.getActionTypes();
      return items;
    }catch(e){
      return [];
    }
  }

  /// Abstract method for fetching data related to a given tab
  void getViewData(TabModel tab);

  /// Abstract method for initializing tab models (must be implemented in subclass)
  void loadTabs();

  /// Loads the form view JSON and populates the fields labes and combo data.
  Future<void> loadView() async {
    fields.list=[];
    final fieldItems = await AssetJsonUtils.loadView<FieldList>(
      path: viewPath!,
      fromKeyValue: (key, value) => FieldList.fromStringJson(key, value),
    );
    fields.list.addAll(fieldItems);

    notifyListeners();
  }

  /// Cleans up the tab controller when the widget is disposed
  @override
  void dispose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.dispose();
  }

  onUnderProgress();
  onTakeAction(TakeVisitActionModel action);
  onAccept(String declarationText);

}
