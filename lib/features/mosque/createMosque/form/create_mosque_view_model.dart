import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/models/employee_local.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_service.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/models/field_list.dart';

class CreateMosqueViewModel extends CreateMosqueBaseViewModel<MosqueLocal> {

  bool isFromHive=true;
  Function? onActionCompleted;
  // CreateMosqueViewModel({required super.mosqueObj,required super.service});
  CreateMosqueViewModel({
    this.isFromHive=true,
    this.onActionCompleted,
    required MosqueRepository service,
    required MosqueLocal mosqueObj,
    required UserProfile profile,
  }) : super(mosqueObj,service,profile: profile);

  @override
  FormMode mode = FormMode.create;

  @override int? get id=> mosqueObj.serverId;

  @override String? get modelName => 'mosque.mosque';

  bool get _isCreateMode => mosqueObj.serverId == null && mosqueObj.localId == null;
  String _newLocalId() => 'local-${DateTime.now().millisecondsSinceEpoch}';
  bool _actionInFlight = false;



  loadTab(tabKey){

    if (loadedTabs.contains(tabKey)) return;
    startLoading();
    repository.fetchMosqueTabByKey(tabKey, mosqueObj.serverId??0).then((json){
      mosqueObj.mergeJson(json);
      onMosqueCoreMerged(tabKey);
      loadedTabs.add(tabKey);
      stopLoading();
    }).catchError((e){
      stopLoading();
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));
    });
  }

  @override
  Future<void> loadMosque() async{

    ///When this screen come from draft state
    if(mosqueObj.serverId!=null){
      print('yahoooooooooo1');
      addTabController();
      loadTab('basic_info');
    }
    else if(AppUtils.isNotNullOrEmpty(mosqueObj.localId)){

      MosqueLocal? _mosqueObj=await HiveRegistry.mosque.get(mosqueObj.localId);
      //EmployeeLocal? employee=await HiveRegistry.employee.get(mosqueObj.serverId);


      print(_isCreateMode);

      if(_mosqueObj!=null){
        // print(_mosqueObj!.name);
        // print(_mosqueObj!.localId);

        mosqueObj=_mosqueObj;
        notifyListeners();
      }
      reloadTabs();
    }
    // reloadTabs();
    // notifyListeners();

  }

  final tabKeys = [
    'basic_info',
    'mosque_address',
    'mosque_condition',
    'architectural_structure',
    'men_prayer_section',
    'women_prayer_section',
    //'employee_info',
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
  void onNextSuccess(){
    print('onNextSuccess');
    print(mosqueObj.localId);
    print(mosqueObj.name);
    HiveRegistry.mosque.put(mosqueObj.localId, mosqueObj);
    //   notifyListeners();
  }

  Future<void> _attachEmployeesIntoLocal() async {
    final all  = await HiveRegistry.employee.getAll();
    final mine = all.where((e) => e.parentLocalId == mosqueObj.localId).toList();

    final List<Map<String, dynamic>> imam    = [];
    final List<Map<String, dynamic>> muezzin = [];
    final List<Map<String, dynamic>> khatib  = [];
    final List<Map<String, dynamic>> khadem  = [];

    for (final e in mine) {
      final rec = e.toApiRecord(); // CHANGED: no includeEnglish param

      if (e.categoryIds.contains(8))  imam.add({...rec, 'category_ids': [8]});
      if (e.categoryIds.contains(9))  muezzin.add({...rec, 'category_ids': [9]});
      if (e.categoryIds.contains(10)) khatib.add({...rec, 'category_ids': [10]});
      if (e.categoryIds.contains(11)) khadem.add({...rec, 'category_ids': [11]});
    }

    // CHANGED: write into payload (API expects arrays of maps),
    // do NOT assign to typed List<int>? properties.
    final p = (mosqueObj.payload ??= {});
    p['imam_ids']    = imam;
    p['muezzin_ids'] = muezzin;
    p['khatib_ids']  = khatib;
    p['khadem_ids']  = khadem;

    // keep is_employee consistent
    p['is_employee'] =
    (imam.isNotEmpty || muezzin.isNotEmpty || khatib.isNotEmpty || khadem.isNotEmpty)
        ? 'yes'
        : 'no';

    mosqueObj.updatedAt = DateTime.now();
  }

  @override
  Future<void> onSubmit(context) async {

     if (formDetailKey.currentState!.validate()) {
      formDetailKey.currentState!.save();
      HiveRegistry.mosque.put(mosqueObj.localId, mosqueObj);
      _attachEmployeesIntoLocal();

      showDisclaimerDialog(
        context,
        text: kAcceptTermsText,
        onApproved: () async {
          await submitMosqueChanges(context);
        },
      );
      debugPrint("🟦 submitMosqueChanges() start");

    }
  }


  Future<void> submitMosqueChanges(BuildContext context) async {
    try {
      // [YAKEEN] preflight
      final all = await HiveRegistry.employee.getAll();
      final myEmps = all.where((e) => e.parentLocalId == mosqueObj.localId).toList();
      final notVerified = myEmps.where((e) => e.yakeenVerified != true).toList();

      if ((mosqueObj.isEmployee == 'yes') && myEmps.isNotEmpty && notVerified.isNotEmpty) {
        final names = notVerified
            .map((e) => (e.nameAr ?? e.nameEn ?? e.identificationId ?? 'Unknown'))
            .join(', ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${'verify_employees_yakeen_first'.tr()}\n$names',
            ),
          ),
        );
        debugPrint('⛔ submit blocked — unverified employees: $names');
        return;
      }

      startLoading();

      // Decide: create vs send
      if (mosqueObj.serverId == null) {
        // First-time CREATE on server

        final serverId = await repository.createMosqueFromLocal(
          mosqueObj,
          acceptTerms: kAcceptTermsText,
        );

        mosqueObj.serverId = serverId;
        HiveRegistry.mosque.put(mosqueObj.localId, mosqueObj);

        // Success UX
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("submit_success".tr()),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        ).closed;

        Navigator.of(context).pop();
        debugPrint('✅ CREATE success → serverId=$serverId');
      } else {
        // Already has serverId → SEND updates (reuse your existing method)
        await onSend(context,acceptTerms: kAcceptTermsText);
        debugPrint('✅ SEND success via onSend(context)');
      }
    } catch (e, st) {
      debugPrint("❌ submitMosqueChanges failed: $e");
      debugPrint(st.toString());

      // persist failure state if you track it
      // mosqueObj..status = SyncStatus.failed..lastError = e.toString()..updatedAt = DateTime.now();
      await mosqueObj.save();

      AppNotifier.showDialog(
        context,
        DialogMessage(type: DialogType.errorException, message: e),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onSend(BuildContext context, {required String acceptTerms}) async {
    // DEBUG: where is request_id coming from?
    final int? mId = mosqueObj.serverId;


    debugPrint('[onSend] start vm#${identityHashCode(this)} '
        'mosqueId=$mId model.req=${mosqueObj.serverId} payload.req=${mosqueObj.payload?['mosque_id']} '
        '=> effective rid=$mId');

    if (mId == null) {
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
      // ensure the model carries the id (service may read it from here)
      mosqueObj.serverId = mId;

      final res = await repository.sendMosque(
        mosque: mosqueObj,
        acceptTerms: acceptTerms,
        // if your service doesn’t take requestId, remove this arg;
        // if it does, pass it:
        // requestId: rid,
      );

      debugPrint('[onSend] ✅ ok → requestId=${res.serverId} '
          'stageId=${res.stageId} stageName=${res.stageName}');

      // MERGE: keep local payload fresh for UI
      mosqueObj.payload = {
        ...(mosqueObj.payload ?? const {}),
        'mosque_id': res.serverId ?? mId,
        'stage': {
          'id': res.stageId,
          'name': res.stageName,
        },
      };
      // Navigator.of(context).pop();
      notifyListeners();
       if(onActionCompleted!=null)
           onActionCompleted!();
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
  bool get isShowSubmitBtn => super.isShowSubmitBtn && mosqueObj.serverId==null;

  @override
  bool get isShowSendButton => super.isShowSubmitBtn && mosqueObj.serverId!=null;


}