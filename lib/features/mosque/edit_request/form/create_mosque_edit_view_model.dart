import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_merges.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_model.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';

import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';

import '../../../../core/utils/app_notifier.dart';


class CreateMosqueEditViewModel extends CreateMosqueBaseViewModel<MosqueEditRequestModel> {

   int? mosqueId;
   int? reqId;

   bool _actionInFlight = false;

// helper to coerce dynamic -> int?
  int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is String) return int.tryParse(v);
    if (v is List && v.isNotEmpty) return _toInt(v.first);
    if (v is Map && v['id'] != null) return _toInt(v['id']);
    return null;
  }


  CreateMosqueEditViewModel({
      this.mosqueId,
      this.reqId,
    required MosqueRepository service,
    required MosqueEditRequestModel mosqueObj,
    required UserProfile profile,
  }) : super(mosqueObj,service,profile: profile);

  // CreateMosqueEditViewModel({required mosqueId,required super.mosqueObj,required super.service});

  @override String? get modelName => 'mosque.edit.request.new';

  @override int? get id=> mosqueObj.requestId;

  @override
  FormMode mode = FormMode.editRequest;
  final tabKeys = [
    'basic_info',
    'mosque_address',
    'mosque_condition',
    'architectural_structure',
    'men_prayer_section',
    'women_prayer_section',
    // 'employee_info',
    'imams_muezzins_details',
    'mosque_facilities',
    'mosque_land',
    'audio_and_electronics',
    'safety_equipment',
    'maintenance',
    'meters',
    'historical_mosques',
    'qr_code_panel'];

  @override
  Future<void> loadMosque() async{
    // addTabController();
    try{
      loadTab('basic_info');
    }
    catch(e){
      print(e);
    }

    print(tabController);

  }
   void addTabController(){
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) return;
      loadTab(tabKeys[tabController!.index]);
    });
  }

  loadTab(tabKey){

    if (loadedTabs.contains(tabKey)) return;
    if(mosqueId!=null){
      startLoading();
      repository.fetchEditTabByKey(tabKey, mosqueId!).then((json){
        mosqueObj.mergeByTabKey(tabKey, json);
        onMosqueCoreMerged(tabKey);
        loadedTabs.add(tabKey);
        stopLoading();
      }).catchError((e){
        stopLoading();
        showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
      });
    }else if(reqId!=null){
      // _service.fetchEditRequestTabByKey(apiKey, requestId!)
      print('tabKey.................');
      print(tabKey);
      startLoading();
      repository.fetchEditRequestTabByKey(tabKey, reqId!).then((json){
        print('json.......');
        print(json);
        mosqueObj.mergeByTabKey(tabKey, json['edit_request']);
        onMosqueCoreMerged(tabKey);
        loadedTabs.add(tabKey);
        stopLoading();
      }).catchError((e){
        stopLoading();
        showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
      });
    }

  }

  /// Preload all tabs to ensure complete data before submission
  /// This prevents incomplete payloads that cause backend errors
  Future<void> _ensureAllTabsLoaded() async {
    if (reqId == null && mosqueId == null) {
      debugPrint('⚠️ [_ensureAllTabsLoaded] No reqId or mosqueId - skipping preload');
      return;
    }

    final unloadedTabs = tabKeys.where((key) => !loadedTabs.contains(key)).toList();
    
    if (unloadedTabs.isEmpty) {
      debugPrint('✅ [_ensureAllTabsLoaded] All ${tabKeys.length} tabs already loaded');
      return;
    }

    debugPrint('📥 [_ensureAllTabsLoaded] Loading ${unloadedTabs.length} remaining tabs: $unloadedTabs');

    for (final tabKey in unloadedTabs) {
      try {
        if (mosqueId != null) {
          final json = await repository.fetchEditTabByKey(tabKey, mosqueId!);
          mosqueObj.mergeByTabKey(tabKey, json);
          onMosqueCoreMerged(tabKey);
          loadedTabs.add(tabKey);
          debugPrint('  ✓ Loaded tab: $tabKey');
        } else if (reqId != null) {
          final json = await repository.fetchEditRequestTabByKey(tabKey, reqId!);
          mosqueObj.mergeByTabKey(tabKey, json['edit_request']);
          onMosqueCoreMerged(tabKey);
          loadedTabs.add(tabKey);
          debugPrint('  ✓ Loaded tab: $tabKey');
        }
      } catch (e) {
        debugPrint('  ⚠️ Failed to load tab $tabKey: $e');
        // Continue loading other tabs even if one fails
      }
    }

    debugPrint('✅ [_ensureAllTabsLoaded] Completed. Total loaded: ${loadedTabs.length}/${tabKeys.length}');
  }
   @override
   void onSubmit(context){
    if(reqId!=null){
      if (formDetailKey.currentState!.validate()) {
        formDetailKey.currentState!.save();
        showDisclaimerDialog(
          context,
          text: kAcceptTermsText,
          onApproved: () async {
            try {
              await onSend(context, acceptTerms: kAcceptTermsText);
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text("submit_success".tr()),
                  duration: Duration(seconds: 2),backgroundColor: Colors.green,
                ),
              )
                  .closed // Future<SnackBarClosedReason>
                  .then((reason) {
                // After snackbar is dismissed → go back
                Navigator.of(context).pop();
              });
            } catch (e) {
              AppNotifier.showDialog(context, DialogMessage(type: DialogType.errorException,message: e));
            }
          },
        );

      }
    } else{
      if (formDetailKey.currentState!.validate()) {
        formDetailKey.currentState!.save();
        showDisclaimerDialog(
          context,
          text: kAcceptTermsText,
          onApproved: () async {
            try {
              await submit(acceptTerms: kAcceptTermsText);
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text("submit_success".tr()),
                  duration: Duration(seconds: 2),backgroundColor: Colors.green,
                ),
              )
                  .closed // Future<SnackBarClosedReason>
                  .then((reason) {
                // After snackbar is dismissed → go back
                Navigator.of(context).pop();
              });
            } catch (e) {
              AppNotifier.showDialog(context, DialogMessage(type: DialogType.errorException,message: e));

            }
          },
        );

      }
    }
   }
  bool isLoading=false;
   Future<EditRequestSubmitResult> submit({required String acceptTerms}) async {
     isLoading = true;
     notifyListeners();
     try {
       // 1) call service (Step 2 already implemented)
       final res = await repository.submitEditRequest(
         mosqueObj,
         acceptTerms: acceptTerms,
       );

       // 2) stamp response into payload for later list/detail rendering
       final p = Map<String, dynamic>.from(mosqueObj!.payload ?? const {});
       p['request_id'] = res.requestId;
       if (res.requestName != null) p['request_name'] = res.requestName;
       if (res.stageId != null || res.stageName != null) {
         p['stage'] = {
           if (res.stageId != null) 'id': res.stageId,
           if (res.stageName != null) 'name': res.stageName,
         };
       }
       if (res.message != null) p['submit_message'] = res.message;


       // await mosqueObj!.save();
       return res;
     } catch (e) {
       print('eeeeeeeeeeeeeeeeeeeeee');
       print(e);
       // store last error and keep draft pending/error
       // mosqueObj!
       //   ..lastError = e.toString()
       //   ..status = SyncStatus.failed
       //   ..updatedAt = DateTime.now();
       // await mosqueObj!.safve();
       rethrow;
     } finally {
       isLoading = false; notifyListeners();
     }
   }


  Future<void> onSend(BuildContext context, {required String acceptTerms}) async {
    // DEBUG: where is request_id coming from?
    final int? rid = reqId
        ?? mosqueObj.requestId
        ?? _toInt(mosqueObj.payload?['request_id']);

    debugPrint('[onSend] start vm#${identityHashCode(this)} '
        'reqId=$reqId model.req=${mosqueObj.requestId} payload.req=${mosqueObj.payload?['request_id']} '
        '=> effective rid=$rid');

    if (rid == null) {
      debugPrint('[onSend] missing request_id');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Missing request id')),
        );
      }
      return;
    }

    // GUARD: prevent double execution
    if (_actionInFlight) {
      debugPrint('[onSend] ignored (already running)');
      return;
    }
    _actionInFlight = true;

    isLoading = true; notifyListeners();

    try {
      // ⚠️ CRITICAL: Preload all tabs to ensure complete payload
      // Without this, only visited tabs would be in the payload, causing incomplete submissions
      debugPrint('🔄 [onSend] Ensuring all tabs are loaded before submission...');
      await _ensureAllTabsLoaded();
      debugPrint('✅ [onSend] All tabs loaded. Proceeding with submission.');

      // ensure the model carries the id (service may read it from here)
      mosqueObj.requestId = rid;

      final res = await repository.sendMosqueEditReq(
        request: mosqueObj,
        acceptTerms: acceptTerms,
        // if your service doesn't take requestId, remove this arg;
        // if it does, pass it:
        // requestId: rid,
      );

      debugPrint('[onSend] ✅ ok → requestId=${res.requestId} '
          'stageId=${res.stageId} stageName=${res.stageName}');

      // MERGE: keep local payload fresh for UI
      mosqueObj.payload = {
        ...(mosqueObj.payload ?? const {}),
        'request_id': res.requestId ?? rid,
        'stage': {
          'id': res.stageId,
          'name': res.stageName,
        },
      };

      notifyListeners();

      if (context.mounted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Sent by obs')),
        //);
      }
    } catch (e, st) {
      debugPrint('[onSend] failed: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      _actionInFlight = false;
      isLoading = false; notifyListeners();
    }
  }


  @override
  // TODO: implement isShowSubmitBtn
  bool get isShowSubmitBtn => super.isShowSubmitBtn && reqId==null;

   @override
  bool get isShowSendButton => super.isShowSubmitBtn && reqId!=null;
}