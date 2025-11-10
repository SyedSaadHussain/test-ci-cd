import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_repository.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

class MosqueViewViewModel extends  MosqueBaseViewModel<MosqueLocal> {

  MosqueViewViewModel({
    required MosqueLocal  mosqueObj}): super(mosqueObj){
    tabsData = [
      TabModel(key: 'basic_info',
          name: 'Basic Info'.tr(),
          url: '/mosque/basic/info'),
      // icon: Icons.location_on_outlined),
      TabModel(key: 'mosque_address',
          name: 'Address'.tr(),
          url: '/mosque/address'),
      // icon: Icons.location_on_outlined),
      TabModel(key: 'mosque_condition',
          name: 'Mosque Condition'.tr(),
          url: '/mosque/condition/details'),
    ];
   }



  Function? showDialogCallback;
  @override String? get displayMosqueName => mosqueObj.name;

  @override
  dynamic headerMap;
  @override int? get idForImage => mosqueObj.serverId;
  @override
  List<ComboItem>? get observerName => mosqueObj.observerIdsArray;


  @override String? get modelName => 'mosque.mosque';
  @override String? get meterModelName => 'mosque.meter';
  @override String? get watetMeterModelName => 'water.meter';


  reloadTabs(){
     tabsData = [
      TabModel(key: 'basic_info',
          name: 'Basic Info'.tr(),
          url: '/mosque/basic/info'),
      // icon: Icons.location_on_outlined),
      TabModel(key: 'mosque_address',
          name: 'Address'.tr(),
          url: '/mosque/address'),
      // icon: Icons.location_on_outlined),
      TabModel(key: 'mosque_condition',
          name: 'Mosque Condition'.tr(),
          url: '/mosque/condition/details'),
    ];
    if(showDependentTabs){
      tabsData.add(TabModel(key: 'structure',
          name: 'Architectural Structure'.tr(),
          url: '/mosque/structure'));
      tabsData.add(TabModel(key: 'men',
          name: "Men's Prayer Section".tr(),
          url: '/men/prayer/mosque/capacity'));
          // icon: Icons.male),
      tabsData.add(TabModel(key: 'women',
          name: "Women's Prayer Section".tr(),
          url: '/mosque/women/prayer/info'));
      // employees tab: show Employees on (done/cancel) else Applicants on any stage before approved or cancelled
      final int? stageId = _getCurrentStageId();
      final bool showEmployees = stageId == 192 || stageId == 263;
      tabsData.add(TabModel(
          key: 'employees',
          name: 'Employee Info'.tr(), // Using the same tab name for both tabs
          url: showEmployees ? '/mosque/employee/info' : '/mosque/applicants/detail'));
    //icon: Icons.people_outline),
      tabsData.add(TabModel(key: 'residence',
          name: 'Imam & Muezzin Residences'.tr(),
          url: '/mosque/imam/muezzin/residences/details'));
    // icon: Icons.home_outlined),
      tabsData.add(TabModel(key: 'facilities',
          name: 'Mosque Facilities'.tr(),
          url: '/mosque/facilities'));
    //icon: Icons.handyman_outlined),
      tabsData.add(TabModel(key: 'land',
          name: 'Land'.tr(),
          url: '/mosque/land/info'));
    // icon: Icons.terrain_outlined),
      tabsData.add(TabModel(key: 'audio',
          name: 'Audio & Electronic'.tr(),
          url: '/mosque/audio/electronic/info'));
    //icon: Icons.speaker_outlined),
      tabsData.add(TabModel(key: 'safety',
          name: 'Fire & Safety'.tr(),
          url: '/mosque/fire/safety'));
    //icon: Icons.local_fire_department_outlined),
      tabsData.add(TabModel(key: 'maintenance',
          name: 'Maintenance & Operations'.tr(),
          url: '/mosque/maintenance/operation'));
    //icon: Icons.build_outlined),
      tabsData.add(TabModel(key: 'meters',
          name: 'Meter Details'.tr(),
          url: '/mosque/meters'));
    //icon: Icons.electric_meter_outlined),
      tabsData.add(TabModel(key: 'historical',
          name: 'Historical Mosque'.tr(),
          url: '/mosque/historical'));
    //icon: Icons.history_edu_outlined),
      tabsData.add(TabModel(key: 'qrcode',
          name: 'QR Code Panel'.tr(),
          url: '/mosque/qrcode/panel'));
    //icon: Icons.qr_code_2),
      tabsData.add(TabModel(key: 'declarations',
          name: 'Declarations'.tr(),
          url: '/mosque/declarations/details'));
      tabsData.add(TabModel(key: 'contracts',
          name: 'Maintenance Contracts'.tr(),
          url: '/mosque/maintenance/contracts/details'));
    }
  }


  @override
  int? get requestIdForView => null;

  @override
  Future<void> getViewData(TabModel tab)  async{
    if (tab.isLoaded)
      return;
    startLoading();
    // Special handling for applicants: save into payload.applicants and mark loaded
    if (tab.key == 'employees' && tab.url == '/mosque/applicants/detail') {
      mosqueRepository.getMosqueViewData(mosqueObj.serverId!, tab.url).then((result) async {
        final list = (result['items'] is List)
            ? List<Map<String, dynamic>>.from(result['items'])
            : (result['data'] is List)
                ? List<Map<String, dynamic>>.from(result['data'])
                : <Map<String, dynamic>>[];
        (mosqueObj.payload ??= {})['applicants'] = list;
        stopLoading();
        tab.isLoaded = true;
      }).catchError((e){
        stopLoading();
      });
      return;
    }
    mosqueRepository.getMosqueView(mosqueObj.serverId!, tab.url, mosqueObj).then((
        result) {
      mosqueObj = result;
      if(tab.url=='/mosque/basic/info'){
        reloadTabs();
        // Load timeline for mosque creation
        _loadMosqueTimeline();
      }
      if (mosqueObj.updatedAt == null) {
        mosqueObj.updatedAt = DateTime.now();
      }
      stopLoading();
      tab.isLoaded = true;
    }).catchError((e) {
      print('❌ Error loading tab: ${tab.url} - Error: $e');
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
      stopLoading();
    });
  }

  //region for action buttons


  @override
  void onAccept(String declarationText) async {
    final mosqueId = mosqueObj.serverId;
    if (mosqueId == null) {
      return;
    }

    try {
      startLoading();
      final result = await mosqueRepository.acceptMosque(
        mosqueId: mosqueId,
        acceptTerms: declarationText,
        // stageName: _getCurrentStageName(),
        stageName: mosqueObj.stageName??"draft",
        mosqueObj: mosqueObj,  // Pass mosque object to extract current state name
      );

      // Check if the result contains new stage info
      if (result['stage_id'] != null) {
        mosqueObj.payload ??= {};
        mosqueObj.payload!['stage_id'] = result['stage_id'];
      } else {
        // If API doesn't return new stage, predict it based on action
        // Accept typically moves to "Done" stage (192)
        mosqueObj.payload ??= {};
        mosqueObj.payload!['stage_id'] = 192; // Done stage
      }
      
      // Refresh basic info to update stage data
      await _refreshHeader();
      _loadMosqueTimeline();
      // Notify listeners to update UI
      notifyListeners();
      
      // Trigger callback to refresh the list
      if (onActionCompleted != null) {
        onActionCompleted!();
      }
    } catch (e) {
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
      // Handle error silently or show user-friendly message
    } finally {
      stopLoading();
    }
  }

  @override
  void onRefuse(String declarationOrReason, String refuseReason) async {
    final mosqueId = mosqueObj.serverId;
    if (mosqueId == null) {
      return;
    }

    try {
      startLoading();
      final result = await mosqueRepository.refuseMosque(
        mosqueId: mosqueId,
        acceptTerms: "أقر بأنه تم مراجعة جميع البيانات وأتحمل كامل المسؤولية عن صحتها",
        stageName: _getCurrentStageName(),
        refuseReason: refuseReason,
        mosqueObj: mosqueObj,  // Pass mosque object to extract current state name
      );
      // Check if the result contains new stage info
      if (result['stage_id'] != null) {
        mosqueObj.payload ??= {};
        mosqueObj.payload!['stage_id'] = result['stage_id'];
      } else {
        // If API doesn't return new stage, predict it based on action
        // Refuse typically moves to "Reject" stage (263)
        mosqueObj.payload ??= {};
        mosqueObj.payload!['stage_id'] = 263; // Reject stage
      }
      
      // Refresh basic info to update stage data
      // await _refreshBasicInfo();
      // _loadMosqueTimeline();
      // // Notify listeners to update UI
      // notifyListeners();
      //
      // Trigger callback to refresh the list
      if (onActionCompleted != null) {
        onActionCompleted!();
      }
    } catch (e) {
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
      // Handle error silently or show user-friendly message
    } finally {
      stopLoading();
    }
  }

  @override
  Future<void> onSetToDraft(String declarationText) async {
    final mosqueId = mosqueObj.serverId;
    if (mosqueId == null) {
      return;
    }

    try {
      startLoading();
      final result = await mosqueRepository.setMosqueToDraft(
        mosqueId: mosqueId,
        acceptTerms: "أقر بأنه تم مراجعة جميع البيانات وأتحمل كامل المسؤولية عن صحتها",
        stageName: _getCurrentStageName(),
        observationText: declarationText,
        mosqueObj: mosqueObj,  // Pass mosque object to extract current state name
      );
      
      // Check if the result contains new stage info
      if (result['stage_id'] != null) {
        mosqueObj.payload ??= {};
        mosqueObj.payload!['stage_id'] = result['stage_id'];
      } else {
        // If API doesn't return new stage, predict it based on action
        // Set to draft typically moves back to "Draft" stage (189)
        mosqueObj.payload ??= {};
        mosqueObj.payload!['stage_id'] = 189; // Draft stage
      }
      
      // Refresh basic info to update stage data
      await _refreshBasicInfo();
      // Notify listeners to update UI
      notifyListeners();
      
      // Trigger callback to refresh the list
      if (onActionCompleted != null) {
        onActionCompleted!();
      }
    } catch (e) {
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    } finally {
      stopLoading();
    }
  }

  //endregion

  String _getCurrentStageName() {
    // Map stage IDs to stage names
    final stageId = _getCurrentStageId();
    switch (stageId) {
      case 189: return 'draft';
      case 190: return 'in_progress'; 
      case 191: return 'checker';
      default: return 'in_progress';
    }
  }

  Future<void> _refreshHeader() async {
    final mId = mosqueObj.serverId;
    if (mId == null) return;

    try {
      // re-fetch the BASIC INFO tab which also returns the latest action flags
      final updated = await mosqueRepository.getMosqueView(
        mId,
        '/mosque/basic/info',
        mosqueObj,
      );
      mosqueObj = updated;

      // mark basic tab as loaded (optional) and notify UI
      final basic = tabsData.firstWhere(
            (t) => t.key == 'basic_info',
        orElse: () => tabsData.first,
      );
      basic.isLoaded = true;

      notifyListeners();
    } catch (err) {
      // optional: surface refresh issues
      showDialogCallback?.call(
        DialogMessage(type: DialogType.errorException, message: err),
      );
    }
  }

  Future<void> _refreshBasicInfo() async {
    try {
      // Find basic info tab
      final basicInfoTab = tabsData.firstWhere(
        (tab) => tab.key == 'basic_info',
        orElse: () => TabModel(key: 'basic_info', name: 'Basic Info'.tr(), url: '/mosque/basic/info'),
      );
      
      // Mark as not loaded to force refresh
      basicInfoTab.isLoaded = false;
      
      // Reload the tab
      await getViewData(basicInfoTab);
      
      // Force UI update
      notifyListeners();
    } catch (e) {
      // Handle error silently
    }
  }

  int? _getCurrentStageId() {
    // Try to get stage from payload first
    final payload = mosqueObj.payload;
    if (payload != null) {
      final stageId = payload['stage_id'] ?? payload['stageId'];
      if (stageId != null) {
        return int.tryParse(stageId.toString());
      }
    }
    // MosqueLocal doesn't have stageId property, so return null if not in payload
    return null;
  }

  /// Load mosque creation timeline
  Future<void> _loadMosqueTimeline() async {
    final mosqueId = mosqueObj.serverId;
    if (mosqueId == null) return;

    try {
      final timeline = await mosqueRepository.fetchMosqueCreationTimeline(mosqueId);
      mosqueObj.workflow = timeline;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading mosque timeline: $e');
      // Silently fail, timeline is optional
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}