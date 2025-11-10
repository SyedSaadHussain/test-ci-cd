// lib/features/mosque/edit_request/view/mosque_edit_view_model.dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_merges.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_model.dart';
import 'package:mosque_management_system/core/models/tab_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

import '../../../visit/core/constants/system_default.dart';
import '../../../../core/models/field_list.dart';
import '../../../../shared/widgets/dialogs/disclaimer_dialog.dart';


class MosqueEditViewViewModel extends  MosqueBaseViewModel<MosqueEditRequestModel> {
  // deps + state

  // late MosqueEditRequestModel editObj;

  Function? showDialogCallback;


  // contract fields
  @override bool isLoading = false;
  // @override FieldListData fields = FieldListData();

  // contract adapters
  // @override MosqueLocal get mosqueObj => editObj;
  @override String? get displayMosqueName => mosqueObj.mosqueName ?? mosqueObj.name;

  @override int? get requestIdForView =>
      mosqueObj.requestId ?? JsonUtils.toInt(mosqueObj.payload?['request_id']);
  @override
  List<ComboItem>? get observerName => mosqueObj.requesterName;



  @override
  dynamic headerMap;
  @override int? get idForImage => requestIdForView;


  @override String? get modelName => 'mosque.edit.request.new';
  @override String? get meterModelName => 'mosque.edit.meter.line';
  @override String? get watetMeterModelName => 'mosque.edit.water.line';

  // action flags
  // @override bool get canAccept     => mosqueObj.displayButtonAccept     ?? false;
  // @override bool get canRefuse     => mosqueObj.displayButtonRefuse     ?? false;
  // @override bool get canSend       => mosqueObj.displayButtonSend       ?? false;
  // @override bool get canSetToDraft => mosqueObj.displayButtonSetToDraft ?? false;

  Future<void> _refreshHeader() async {
    final rid = requestIdForView;
    if (rid == null) return;

    try {
      // re-fetch the BASIC INFO tab which also returns the latest action flags
      final updated = await mosqueRepository.getMosqueEditView(
        rid,
        '/mosque/edit/view/basic/info',
        mosqueObj,
      );
      mosqueObj = updated;
      _loadEditRequestTimeline();

      debugPrint('🔎 [header refresh] flags: '
          'accept=${mosqueObj.displayButtonAccept}, '
          'refuse=${mosqueObj.displayButtonRefuse}, '
          'draft=${mosqueObj.displayButtonSetToDraft}, '
          'send=${mosqueObj.displayButtonSend}');

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

  @override
  void onAccept(String declarationText) async {
    final rid = requestIdForView;
    if (rid == null) {
      showDialogCallback?.call(
        DialogMessage(type: DialogType.error, message: 'Missing request id'),
      );
      return;
    }

    // derive stage name from your model (e.g. "mmc05" -> "MMC05")
    // final sName = (mosqueObj.workflowState).toUpperCase();


    // return;
    try {
      startLoading();

      // call the service using named params (as per your API)
      final result = await mosqueRepository.acceptMosqueEditReq(
        requestId: rid,
        acceptTerms: declarationText,
        stageName: mosqueObj.stageName??'draft',
        mosqueObj: mosqueObj,  // Pass mosque object to extract current state name
      );

      // optional: merge returned stage immediately so UI updates fast
      final stage = result is Map ? result['stage'] : null;
      if (stage is Map) {
        final id = JsonUtils.getObjectId(stage['stage']);
        final name = JsonUtils.toText(stage['name']);
        (mosqueObj.payload ??= {})['stage_id'] = id;
        (mosqueObj.payload ??= {})['state'] = name;
        (mosqueObj.payload ??= {})['state_name'] = name;
        notifyListeners();
      }

      // refresh header to update the four action flags
      await _refreshHeader();
      
      // Trigger callback to refresh the list
      if (onActionCompleted != null) {
        onActionCompleted!();
      }
    } catch (e) {
      showDialogCallback?.call(
        DialogMessage(type: DialogType.errorException, message: e),
      );
    } finally {
      stopLoading();
    }
  }

  @override
  Future<void> onSetToDraft(String note) async {
    final rid = requestIdForView;
    if (rid == null) {
      showDialogCallback?.call(
        DialogMessage(type: DialogType.error, message: 'Missing request id'),
      );
      return;
    }


    try {
      startLoading();

      final result = await mosqueRepository.setMosqueEditReqToDraft(
        requestId: rid,
        acceptTerms: VisitDefaults.declarationText, // or show disclaimer first
        stageName: "set_to_draft".tr(),
        observationText: note,                      // <-- from user input
        mosqueObj: mosqueObj,                       // Pass mosque object to extract current state name
      );

      final stage = result['stage'];
      if (stage is Map) {
        (mosqueObj.payload ??= {})['stage_id']   = stage['id'];
        (mosqueObj.payload ??= {})['state']      = stage['name'];
        (mosqueObj.payload ??= {})['state_name'] = stage['name'];
        notifyListeners();
      }

      await _refreshHeader(); // refresh button flags
      
      // Trigger callback to refresh the list
      if (onActionCompleted != null) {
        onActionCompleted!();
      }
    } catch (e) {
      showDialogCallback?.call(
        DialogMessage(type: DialogType.errorException, message: e),
      );
    } finally {
      stopLoading();
    }
  }


  @override
// In MosqueEditViewViewModel (same class as onAccept)
// Same file where onAccept lives (e.g., MosqueEditViewViewModel)

  @override

  @override
  Future<void> onRefuse(String declarationText, String refuseReason) async {
    final rid = requestIdForView;
    if (rid == null) {
      showDialogCallback?.call(
        DialogMessage(type: DialogType.error, message: 'Missing request id'.tr()),
      );
      return;
    }

    // We will NOT pass stageName on refuse; backend should move it to Refuse.
    // final sName = (mosqueObj.workflowState).toUpperCase();
    // debugPrint('🟥 onRefuse | rid=$rid, currentStage="$sName" → OMIT stage_name for refuse');

    final sw = Stopwatch()..start();
    final beforePayload = Map<String, dynamic>.from(mosqueObj.payload ?? {});
    try {
      startLoading();

      // Use current state name from payload if available
      final result = await mosqueRepository.refuseMosqueEditReq(
        requestId: rid,
        acceptTerms: declarationText,
        stageName: 'refused'.tr(),           // Fallback if current state name not available
        refuseReason: refuseReason,
        mosqueObj: mosqueObj,                 // Pass mosque object to extract current state name
      );

      debugPrint('🟥 onRefuse | Service returned (${result.runtimeType}): $result');

      final stage = result is Map ? result['stage'] : null;
      if (stage is Map) {
        (mosqueObj.payload ??= {})['stage_id']   = stage['id'];
        (mosqueObj.payload ??= {})['state']      = stage['name'];
        (mosqueObj.payload ??= {})['state_name'] = stage['name'];
        debugPrint('🟥 onRefuse | Merged stage -> id=${stage['id']} name=${stage['name']}');
      } else {
        debugPrint('🟥 onRefuse | WARN: result["stage"] missing; will rely on header refresh');
      }

      final serverReason = (result is Map) ? result['refuse_reason'] : null;
      (mosqueObj.payload ??= {})['refuse_reason'] =
      (serverReason is String && serverReason.trim().isNotEmpty)
          ? serverReason
          : refuseReason;

      debugPrint('🟥 onRefuse | refuse_reason set to: ${mosqueObj.payload?['refuse_reason']}');

      final afterPayload = Map<String, dynamic>.from(mosqueObj.payload ?? {});
      debugPrint('🟥 onRefuse | Payload.after  = $afterPayload');
      debugPrint('🟥 onRefuse | DIFF stage_id: ${beforePayload['stage_id']} -> ${afterPayload['stage_id']}');
      debugPrint('🟥 onRefuse | DIFF state:    ${beforePayload['state']}    -> ${afterPayload['state']}');
      debugPrint('🟥 onRefuse | DIFF reason:   ${beforePayload['refuse_reason']} -> ${afterPayload['refuse_reason']}');

      notifyListeners();

      debugPrint('🟥 onRefuse | Refreshing header/action flags…');
      await _refreshHeader();
      debugPrint('🟥 onRefuse | Header refreshed OK.');
      debugPrint('🟥 onRefuse | editObj.stage from header = ${mosqueObj.payload?['state'] ?? mosqueObj.stageName ?? mosqueObj.workflowState}');
      
      // Trigger callback to refresh the list
      if (onActionCompleted != null) {
        onActionCompleted!();
      }
    } catch (e, st) {
      debugPrint('🟥 onRefuse | EXCEPTION during refuse: $e');
      debugPrint('$st');
      showDialogCallback?.call(
        DialogMessage(type: DialogType.errorException, message: e),
      );
    } finally {
      stopLoading();
      debugPrint('🟥 onRefuse | END | elapsed=${sw.elapsedMilliseconds}ms');
    }
  }


  MosqueEditViewViewModel({
    required MosqueEditRequestModel  mosqueObj}): super(mosqueObj){
    tabsData = [
      TabModel(
          key: 'basic_info',
          name: 'Basic Info'.tr(),
          url: '/mosque/edit/view/basic/info'),
      // icon: Icons.location_on_outlined),
      TabModel(
          key: 'mosque_address',
          name: 'Address'.tr(),
          url: '/mosque/edit/request/view/address',
          icon: Icons.location_on_outlined),
      TabModel(
          key: 'mosque_condition',
          name: 'Mosque Condition'.tr(),
          url: '/mosque/edit/request/view/condition/details',
          icon: Icons.fact_check_outlined),
    ];
  }

  // tabsData = [
  //   TabModel(
  //       key: 'basic_info',
  //       name: 'Basic Info'.tr(),
  //       url: '/mosque/edit/view/basic/info'),
  //   // icon: Icons.location_on_outlined),
  //   TabModel(
  //       key: 'mosque_address',
  //       name: 'Address'.tr(),
  //       url: '/mosque/edit/request/view/address',
  //       icon: Icons.location_on_outlined),
  //   TabModel(
  //       key: 'mosque_condition',
  //       name: 'Mosque Condition'.tr(),
  //       url: '/mosque/edit/request/view/condition/details',
  //       icon: Icons.fact_check_outlined),
  // ];

  reloadTabs(){
    tabsData = [
      TabModel(
          key: 'basic_info',
          name: 'Basic Info'.tr(),
          url: '/mosque/edit/view/basic/info'),
      // icon: Icons.location_on_outlined),
      TabModel(
          key: 'mosque_address',
          name: 'Address'.tr(),
          url: '/mosque/edit/request/view/address',
          icon: Icons.location_on_outlined),
      TabModel(
          key: 'mosque_condition',
          name: 'Mosque Condition'.tr(),
          url: '/mosque/edit/request/view/condition/details',
          icon: Icons.fact_check_outlined),
    ];
    if(showDependentTabs){
      tabsData.add(TabModel(
          key: 'structure',
          name: 'Architectural Structure'.tr(),
          url: '/mosque/edit/request/view/structure',
          icon: Icons.account_balance_outlined));
      tabsData.add(TabModel(
    key: 'men',
    name: "Men's Prayer Section".tr(),
    url: '/men/prayer/mosque/edit/request/capacity',
    icon: Icons.male));
      tabsData.add(TabModel(
    key: 'women',
    name: "Women's Prayer Section".tr(),
    url: '/mosque/edit/request/women/prayer/info',
    icon: Icons.female));
      tabsData.add(TabModel(
    key: 'residence',
    name: 'Imam & Muezzin Residences'.tr(),
    url: '/mosque/edit/imam/muezzin/residences/details',
    icon: Icons.home_outlined));
      tabsData.add(TabModel(
    key: 'facilities',
    name: 'Mosque Facilities'.tr(),
    url: '/mosque/edit/request/view/facilities',
    icon: Icons.handyman_outlined));
      tabsData.add(TabModel(
    key: 'land',
    name: 'Land'.tr(),
    url: '/mosque/edit/request/land/info',
    icon: Icons.terrain_outlined));
      tabsData.add(TabModel(
    key: 'audio',
    name: 'Audio & Electronic'.tr(),
    url: '/mosque/edit/request/audio/electronic/info'));
    // icon: Icons.speaker_outlined),
      tabsData.add(TabModel(
    key: 'safety',
    name: 'Fire & Safety'.tr(),
    url: '/mosque/edit/request/fire/safety',
    icon: Icons.local_fire_department_outlined));
      tabsData.add(TabModel(
    key: 'maintenance',
    name: 'Maintenance & Operations'.tr(),
    url: '/mosque/edit/request/maintenance/operation',
    icon: Icons.build_outlined));
      tabsData.add(TabModel(
    key: 'meters',
    name: 'Meter Details'.tr(),
    url: '/mosque/edit/request/meters',
    icon: Icons.electric_meter_outlined));
      tabsData.add(TabModel(
    key: 'historical',
    name: 'Historical Mosque'.tr(),
    url: '/mosque/edit/request/view/historical',
    icon: Icons.history_edu_outlined));
      tabsData.add(TabModel(
    key: 'qrcode',
    name: 'QR Code Panel'.tr(),
    url: '/mosque/edit/request/view/qrcode/panel',
    icon: Icons.qr_code_2));
    }
  }


  @override
  Future<void> getViewData(TabModel tab) async{
    if (tab.isLoaded) return;

    final rid = requestIdForView;

    if (rid == null) {
      showDialogCallback?.call(
          DialogMessage(type: DialogType.errorException, message: e)
      );
      return;
    }

    startLoading();
    mosqueRepository
        .getMosqueEditView(rid, tab.url, mosqueObj)
        .then((result) {
      mosqueObj = result;
      print('final...');
      print(mosqueObj.stageName);

      if(tab.url=='/mosque/edit/view/basic/info'){
        reloadTabs();
        // Load timeline for edit request
        _loadEditRequestTimeline();
      }
      tab.isLoaded = true;
      stopLoading();
    })
        .catchError((e) {
      stopLoading();
      showDialogCallback?.call(
        DialogMessage(type: DialogType.errorException, message: e),
      );
    });
  }

  /// Load edit request timeline
  Future<void> _loadEditRequestTimeline() async {
    final requestId = requestIdForView;
    if (requestId == null) return;

    try {
      final timeline = await mosqueRepository.fetchEditRequestTimeline(requestId);
      mosqueObj.workflowEditRequest = timeline;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading edit request timeline: $e');
      // Silently fail, timeline is optional
    }
  }


}
