import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/create_mosque_edit_view_model.dart';
import 'package:mosque_management_system/features/mosque/edit_request/view/mosque_edit_view_model.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_item_bottom_sheet.dart';
import '../../../core/providers/user_provider.dart';
import '../core/models/mosque_local.dart';
import '../../../shared/widgets/form_controls/app_input_view.dart';
import '../createMosque/form/create_mosque_screen.dart';
import 'logic/validation_scope.dart';
import 'geo_capture.dart';

import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';

class BasicInfoTab extends StatelessWidget {

  String _k(String field) => field;

  const BasicInfoTab({
    super.key
  });


  @override
  Widget build(BuildContext context) {

    final user = context.read<UserProvider>();
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final ValidationController? vs = ValidationScope.of(context);

    Future<Map<String, dynamic>?> showClassificationModal() async {
      print('aaaaaaaaaaa');// FIX// FIX// [CHANGED] return type
      // if (!_editing) return null;                                              // [CHANGED] return null instead of void
      try {
        final raw = await rootBundle.loadString('assets/data/mosque/classifications.json');
        final data = json.decode(raw);
        final List<Map<String, dynamic>> items =
        (data is List) ? data.cast<Map<String, dynamic>>() : const [];
                                         // [CHANGED] return null
        if (items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('no_record_found'.tr())),
          );
          return null;                                                         // [CHANGED]
        }

        final picked = await showModalBottomSheet<Map<String, dynamic>>(       // [ADDED] capture the result
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => SafeArea(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (itemCtx, i) {

                  final m = items[i];
                  final dynamic rawId = m['classification_id'];
                  final int? id = rawId is int ? rawId : int.tryParse('$rawId');
                  final String name = (m['classification_name'] ?? '').toString();

                  return ListTile(
                    title: Text(name.isEmpty ? '—' : name),
                    onTap: () {
                      // [REMOVED] setState that mutates _local/newMosque
                      // [ADDED] return selection to caller
                      Navigator.of(itemCtx).pop(<String, dynamic>{              // [ADDED]
                        'id': id,                                               // [ADDED]
                        'name': name,                                           // [ADDED]
                      });                                                       // [ADDED]
                    },
                  );
                },
              ),
            ),
          ),
        );

        return picked;                                                         // [ADDED] return selected map (or null)
      } catch (_) {                                        // [CHANGED]
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_load'.tr())),
        );
        return null;                                                           // [CHANGED]
      }
    }

    Future<Map<String, dynamic>?> showMosqueTypeModal() async {
      debugPrint('[TYPE] modal start');

      try {
        final raw = await rootBundle.loadString('assets/data/mosque/types.json');
        final data = json.decode(raw);
        final List<Map<String, dynamic>> items =
        (data is List) ? data.cast<Map<String, dynamic>>() : const [];



        if (items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('no_record_found'.tr())),
          );
          return null;
        }

        // Return the picked {id, name} back to the caller.
        final picked = await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (_) => SafeArea(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 500),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (itemCtx, i) {
                  final m = items[i];
                  final dynamic rawId = m['mosque_type_id'];
                  final int? id = rawId is int ? rawId : int.tryParse('$rawId');
                  final String name = (m['mosque_type_name'] ?? '').toString();

                  return ListTile(
                    title: Text(name.isEmpty ? '—' : name),
                    onTap: () {
                      Navigator.of(itemCtx).pop(<String, dynamic>{
                        'id': id,
                        'name': name,
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );

        return picked;
      } catch (e, st) {
        debugPrint('[TYPE] load error: $e\n$st');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_load'.tr())),
        );
        return null;
      }
    }


   // final view = localViewOf(context, local);

    final isEditReq = vm.mode == FormMode.editRequest;

// prefer model → then payload → then null
    final String? observationText =
        vm.mosqueObj.observationText ??
            (vm.mosqueObj.payload?['observation_text'] as String?);

    // Get refuse_reason from payload or model property
    final String? refuseReason = 
        vm.mosqueObj.payload?['refuse_reason'] as String? ??
        vm.mosqueObj.refuseReason;

    final String nameValue = isEditReq
        ? (vm.mosqueObj.mosqueName ?? vm.mosqueObj.name  ?? '')
        : (vm.mosqueObj.name ??  '');

    print("nameValue:$nameValue");

    print("obsText:$observationText");

// true only when there is non-empty text
    final bool hasObservationText = (observationText?.trim().isNotEmpty ?? false);
    final bool hasRefuseReason = (refuseReason?.trim().isNotEmpty ?? false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            // Show refuse reason at the top if available
            Visibility(
              visible: hasRefuseReason,
              child: AppInputView(
                title: vm.fields.getField('refuse_reason').label,
                //title: 'refuse_reason'.tr(),
                value: refuseReason?.trim(),
                isShowWarning: true
              ),
            ),
            // Show observation text if available
            Visibility(
              visible: hasObservationText,
              child: AppInputView(
                title: vm.fields.getField('observation_text').label,
                //title: 'observation_text'.tr(),
                value: observationText?.trim(),
                isShowWarning: true
              ),
            ),

            AppInputField(                                                                   // FIX
              title: vm.fields.getField('observer_ids').label,
              //title: 'observer_ids'.tr(),
              // FIX
              value: user.userProfile!.name,      //burger                                                  // FIX
              isReadonly: true,                                                              // FIX
              isDisable: true,                                                               // FIX
              isRequired: true,                                                              // FIX
            ),                                                                               // FIX
            const SizedBox(height: 10),

            // -------------------- NAME --------------------
            // FIX: AppInputField + declaration action                                         // FIX
            AppInputField(                                                                   // FIX
              title: vm.fields.getField('name').label,
              //title: 'name'.tr(),                                                                 // FIX
              value: nameValue,                                                               // FIX
              isRequired: true,                                                              // FIX
              action: isEditReq                                                              // FIX
                  ? AppDeclarationField(                                                     // FIX
                value: vm.getAgree(('name')),                                     // FIX
                onChanged: (v) => vm.updateAgreeField(_k('name'), v),               // FIX
              )
                  : null,                                                                    // FIX
              onChanged:  (val) {
                vm.mosqueObj.name=val;
                if(vm.getAgree('name')==false)
                     vm.updateAgreeField('name', true);
                // updateLocal((m) => m.name = val);                                      // FIX
                // vs?.clearError('name');                                                // FIX
                // if (isEditReq) vm.updateAgreeField(_k('name'), true);              // FIX
              },                                                                    // FIX
            ),                                                                               // FIX

            const SizedBox(height: 10),

            // -------------------- NUMBER (read-only) --------------------
            // FIX: AppInputField + declaration (still read-only)                              // FIX
            AppInputField(                                                                   // FIX
              title: vm.fields.getField('number').label,
              //title: 'number'.tr(),                                                               // FIX
              value: vm.mosqueObj.number,           // FIX
              isReadonly: true,                                                              // FIX
              isDisable: true,                                                               // FIX
              // action: isEditReq                                                              // FIX
              //     ? AppDeclarationField(                                                     // FIX
              //   value: vm.getAgree(_k('number')),                                   // FIX
              //   onChanged: (v) => vm.updateAgreeField(_k('number'), v),             // FIX
              // )
              //     : null,                                                                    // FIX
             // onChanged: null,                                                               // FIX
            ),                                                                               // FIX

            const SizedBox(height: 10),

            // -------------------- CLASSIFICATION (picker) --------------------
            // FIX: AppInputField (read-only) with onTab to open your picker + declaration    // FIX

            AppInputField(                                                                   // FIX
              title: vm.fields.getField('classification_id').label,
              //title: 'classification_id'.tr(),                                                       // FIX
              value: vm.mosqueObj.classification ?? '',      // FIX
              isReadonly: true,                                                              // FIX
              isRequired: true,                                                              // FIX
              action: isEditReq                                                              // FIX
                  ? AppDeclarationField(                                                     // FIX
                value: vm.getAgree(_k('classification')),                           // FIX
                onChanged: (v) => vm.updateAgreeField(_k('classification'), v),     // FIX
              )
                  : null,                                                                    // FIX
              onTab:  () async {

                final picked = await showClassificationModal();                           // FIX
                if (picked == null) return;                                            // FIX
                final int? id = picked['id'] as int?;                                  // FIX
                final String? name = (picked['name'])?.trim();                         // FIX
                if (id != null) {
                  vm.mosqueObj.classificationId=id;// FIX
                  vm.mosqueObj.classification=name;// FIX
                  vm.updateAgreeField(_k('classification'), true);
                  if (id != 1) vm.mosqueObj.fridayPrayerRows = null;
                  vm.notifyListeners();
                  // updateLocal((m) {                                                    // FIX
                  //   m.classificationId = id;                                           // FIX
                  //   if (name != null && name.isNotEmpty) m.classification = name;      // FIX
                  //   (m.payload ??= {})['classification_id'] = id;                      // FIX
                  //   m.updatedAt = DateTime.now();                                      // FIX
                  // });                                                                  // FIX
                  // vs?.clearError('classification');                                    // FIX
                  // if (isEditReq) vm.updateAgreeField(_k('classification'), true);  // FIX
                }                                                                       // FIX
              },                                                                    // FIX
            ),                                                                               // FIX

            // Show backend validation error (if any)
            if (vs?.errorOf('classification') != null)                                       // FIX
              Padding(                                                                       // FIX
                padding: const EdgeInsetsDirectional.only(top: 6, start: 4),                 // FIX
                child: Text(                                                                 // FIX
                  vs!.errorOf('classification')!,                                            // FIX
                  style: const TextStyle(color: Colors.red, fontSize: 12),                   // FIX
                ),                                                                           // FIX
              ),                                                                             // FIX

            const SizedBox(height: 10),

            // -------------------- MOSQUE TYPE (picker) --------------------
            // FIX: AppInputField (read-only) with onTab + declaration                         // FIX
            AppInputField(                                                                   // FIX
              title: vm.fields.getField('mosque_type_id').label,
              //title: 'mosque_type_id'.tr(),                                                          // FIX
              value: (vm.mosqueObj.mosqueType) ,                          // FIX
                         // FIX
              isReadonly: true,                                                              // FIX
              isRequired: true,                                                              // FIX
              action: isEditReq                                                              // FIX
                  ? AppDeclarationField(                                                     // FIX
                value: vm.getAgree(_k('mosque_type_id')),                           // FIX
                onChanged: (v) => vm.updateAgreeField(_k('mosque_type_id'), v),     // FIX
              )
                  : null,                                                                    // FIX
              onTab:  () async {
                vm.getMosqueTypes().then((items){
                  showItemBottomSheet(
                      title: vm.fields.getField('mosque_type_id').label,
                      context: context,
                      items: items,
                      onChange: (ComboItem item){
                        vm.mosqueObj.mosqueTypeId=item.key;// FIX
                        vm.mosqueObj.mosqueType=item.value;// FIX
                        vm.updateAgreeField(_k('mosque_type_id'), true);
                        if (item.key != 1) vm.mosqueObj.fridayPrayerRows = null;
                        vm.notifyListeners();// FIX
                      }
                  );
                });                                                                      // FIX
              },                                                                     // FIX
            ),

            const SizedBox(height: 10),

            // -------------------- MOSQUE IN MILITARY ZONE --------------------
            // COMMENTED OUT: mosque_in_military_zone field
            // AppSelectionField(
            //   title: vm.fields.getField('mosque_in_military_zone').label,
            //   value: vm.mosqueObj.mosqueInMilitaryZone,
            //   type: SingleSelectionFieldType.radio,
            //   options: vm.fields.getComboList('mosque_in_military_zone'),
            //   isRequired: false,
            //   action: isEditReq
            //       ? AppDeclarationField(
            //     value: vm.getAgree(_k('mosque_in_military_zone')),
            //     onChanged: (v) => vm.updateAgreeField(_k('mosque_in_military_zone'), v),
            //   )
            //       : null,
            //   onChanged: (val) {
            //     vm.mosqueObj.mosqueInMilitaryZone = val;
            //     if (isEditReq && vm.getAgree(_k('mosque_in_military_zone')) == false) {
            //       vm.updateAgreeField(_k('mosque_in_military_zone'), true);
            //     }
            //     vm.notifyListeners();
            //   },
            // ),

            const SizedBox(height: 10),

            // -------------------- NEW LOCATION FIELDS --------------------
            AppSelectionField(
              title: vm.fields.getField('is_inside_prison').label,
              value: vm.mosqueObj.isInsidePrison,
              type: SingleSelectionFieldType.radio,
              options: vm.fields.getComboList('is_inside_prison'),
              isRequired: true,
              action: isEditReq
                  ? AppDeclarationField(
                value: vm.getAgree(_k('is_inside_prison')),
                onChanged: (v) => vm.updateAgreeField(_k('is_inside_prison'), v),
              )
                  : null,
              onChanged: (val) {
                vm.mosqueObj.isInsidePrison = val;
                if (isEditReq && vm.getAgree(_k('is_inside_prison')) == false) {
                  vm.updateAgreeField(_k('is_inside_prison'), true);
                }
                vm.notifyListeners();
              },
            ),

            const SizedBox(height: 10),

            AppSelectionField(
              title: vm.fields.getField('is_inside_hospital').label,
              value: vm.mosqueObj.isInsideHospital,
              type: SingleSelectionFieldType.radio,
              options: vm.fields.getComboList('is_inside_hospital'),
              isRequired: true,
              action: isEditReq
                  ? AppDeclarationField(
                value: vm.getAgree(_k('is_inside_hospital')),
                onChanged: (v) => vm.updateAgreeField(_k('is_inside_hospital'), v),
              )
                  : null,
              onChanged: (val) {
                vm.mosqueObj.isInsideHospital = val;
                if (isEditReq && vm.getAgree(_k('is_inside_hospital')) == false) {
                  vm.updateAgreeField(_k('is_inside_hospital'), true);
                }
                vm.notifyListeners();
              },
            ),

            const SizedBox(height: 10),

            AppSelectionField(
              title: vm.fields.getField('is_inside_government_housing').label,
              value: vm.mosqueObj.isInsideGovernmentHousing,
              type: SingleSelectionFieldType.radio,
              options: vm.fields.getComboList('is_inside_government_housing'),
              isRequired: true,
              action: isEditReq
                  ? AppDeclarationField(
                value: vm.getAgree(_k('is_inside_government_housing')),
                onChanged: (v) => vm.updateAgreeField(_k('is_inside_government_housing'), v),
              )
                  : null,
              onChanged: (val) {
                vm.mosqueObj.isInsideGovernmentHousing = val;
                if (isEditReq && vm.getAgree(_k('is_inside_government_housing')) == false) {
                  vm.updateAgreeField(_k('is_inside_government_housing'), true);
                }
                vm.notifyListeners();
              },
            ),

            const SizedBox(height: 10),

            AppSelectionField(
              title: vm.fields.getField('is_inside_restricted_gov_entity').label,
              value: vm.mosqueObj.isInsideRestrictedGovEntity,
              type: SingleSelectionFieldType.radio,
              options: vm.fields.getComboList('is_inside_restricted_gov_entity'),
              isRequired: true,
              action: isEditReq
                  ? AppDeclarationField(
                value: vm.getAgree(_k('is_inside_restricted_gov_entity')),
                onChanged: (v) => vm.updateAgreeField(_k('is_inside_restricted_gov_entity'), v),
              )
                  : null,
              onChanged: (val) {
                vm.mosqueObj.isInsideRestrictedGovEntity = val;
                if (isEditReq && vm.getAgree(_k('is_inside_restricted_gov_entity')) == false) {
                  vm.updateAgreeField(_k('is_inside_restricted_gov_entity'), true);
                }
                vm.notifyListeners();
              },
            ),

            const SizedBox(height: 10),

            AppSelectionField(
              title: vm.fields.getField('land_owner').label,
              value: vm.mosqueObj.landOwner,
              type: SingleSelectionFieldType.radio,
              options: vm.fields.getComboList('land_owner'),
              isRequired: false,
              action: isEditReq
                  ? AppDeclarationField(
                value: vm.getAgree(_k('land_owner')),
                onChanged: (v) => vm.updateAgreeField(_k('land_owner'), v),
              )
                  : null,
              onChanged: (val) {
                vm.mosqueObj.landOwner = val;
                if (isEditReq && vm.getAgree(_k('land_owner')) == false) {
                  vm.updateAgreeField(_k('land_owner'), true);
                }
                vm.notifyListeners();
              },
            ),

            if (isEditReq) ...[
              const SizedBox(height: 8),
              Builder(
                  builder: (context) {
                    final vmEdit = context.watch<CreateMosqueBaseViewModel>() as CreateMosqueEditViewModel;
                    return AppInputField(
                      title: vm.fields.getField('description').label,
                      //title: 'description'.tr(),
                      // prefer model → then payload → then empty
                      value: vmEdit.mosqueObj.description,
                      //isReadonly: !editing,
                      isRequired: false,
                      type: InputFieldType.textArea,
                      onChanged: (txt) {
                        vmEdit.mosqueObj.description = txt;
                        vm.notifyListeners();
                      },
                      // If your AppInputField uses onSaved instead of onChanged,
                      // keep both — harmless if one is unused.

                    );
                  }
              )
            ],// FIX
            // FIX


            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
