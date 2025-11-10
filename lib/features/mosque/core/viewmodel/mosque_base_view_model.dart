// features/mosque/view/mosque_view_contract.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';

import '../../../../core/models/field_list.dart';

abstract class MosqueBaseViewModel<T extends MosqueLocal> extends ChangeNotifier {

  FieldListData fields = FieldListData();
  // MosqueLocal get mosqueObj;     // MosqueEditRequestModel extends MosqueLocal
  int? get requestIdForView;
  List<ComboItem>? get observerName;
  late MosqueRepository mosqueRepository;
  TabController? tabController;
  
  // Callback to trigger refresh of the list when returning after an action
  Function? onActionCompleted;

  bool get showDependentTabs=>
      mosqueObj.mosqueCondition == 'existing_mosque' || mosqueObj.mosqueCondition == 'abandoned_mosque';


  @override
  void dispose() {
    tabController?.dispose(); // Clean up tab controller
    super.dispose();
  }

  /// Indicates whether data is being loaded
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    print('🔄 Calling notifyListeners() - isLoading: $isLoading');
    notifyListeners();
    print('🔄 notifyListeners() called');
  }

  /// Satisfies MosqueViewContract.mosqueObj (field already provides a getter)
  late T mosqueObj;

  MosqueBaseViewModel(this.mosqueObj):
        this.mosqueRepository = MosqueRepository();

  String? get displayMosqueName;
  String? get modelName;
  String? get meterModelName;
  String? get watetMeterModelName;

  dynamic headerMap;
  int? get idForImage;

  /// --- Action flags (edit-request shows; normal view returns false)
  bool get canAccept     => mosqueObj.displayButtonAccept     ?? false;
  bool get canRefuse     => mosqueObj.displayButtonRefuse     ?? false;
  bool get canSend       => mosqueObj.displayButtonSend       ?? false;
  bool get canSetToDraft => mosqueObj.displayButtonSetToDraft ?? false;
  /// --- Action handlers (no-ops in normal view)
  void onAccept(String declarationText);
   void onRefuse(String declarationOrReason, String refuseReason);
  //Future<void> onSend(BuildContext context,{required String acceptTerms});
  Future<void> onSetToDraft(String note);

  List<TabModel> tabsData=[];

  Future<void> loadPage() async {

    headerMap = await AppUtils.getHeadersMap();
    reloadTabs();
    await _loadView();
    // reloadTabController();
    getViewData(tabsData[0]);
  }
  void reloadTabs();
  void reloadTabController(){
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) return;
      if (tabController!.index > 0) {
        getViewData(tabsData[tabController!.index]);
      }
    });
  }

  Future<void> getViewData(TabModel tab);

  Future<void> _loadView() async {
    fields.list = [];
    final fieldItems = await AssetJsonUtils.loadView<FieldList>(
      path: 'assets/views/mosque_view.json', // reuse same spec
      fromKeyValue: (key, value) => FieldList.fromStringJson(key, value),
    );
    fields.list.addAll(fieldItems);
    notifyListeners();
  }

// null for normal view
}

