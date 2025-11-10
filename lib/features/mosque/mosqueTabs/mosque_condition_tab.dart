import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';

import 'logic/condition_rules.dart';
import 'logic/image_help_dialog.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';

import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';

// View adapter (same used in BasicInfoTab)

class MosqueConditionTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  /// Optional: pass cookies/headers for protected content
  final dynamic headersMap;

  const MosqueConditionTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
    this.headersMap,
  });

  @override
  State<MosqueConditionTab> createState() => _MosqueConditionTabState();
}

class _MosqueConditionTabState extends State<MosqueConditionTab> {

  bool? _lastShowDependents;
  String? _currentValue; // Track the current field value
  String _k(String field) => field;
  String _label(String key, String fallback) {
    final f = widget.fields.getField(key);
    final lbl = f?.label;
    return (lbl == null || lbl.trim().isEmpty) ? fallback : lbl;
  }

  // Normalize incoming dynamic values (API can send false/“false”/empty)
  String? _resolve(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v ? 'true' : null;
    final s = v.toString().trim();
    if (s.isEmpty || s.toLowerCase() == 'false') return null;
    return s;
  }

  // Notify parent after frame if visibility changed
  void _maybeNotify(bool show) {
    if (_lastShowDependents == show) return;
    _lastShowDependents = show;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // parent can setState to rebuild tabs
    //   widget.onRulesChange?.call(show);
    // });
  }

  @override
  void initState() {
    super.initState();
    _currentValue = widget.local.mosqueCondition;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;
    // final ctrl = context.read<MosqueFormController?>();      // FIX


    // Resolve current values with "local-first, then view" logic
    final String? currentMosqueCondition =
        widget.local.mosqueCondition ?? "";

    final String? currentBuildingMaterial =
        widget.local.buildingMaterial ?? "";

    final String? currentUrbanCondition =
        widget.local.urbanCondition ?? "";

    final String? currentDateMaintenanceLast =
        (widget.local.dateMaintenanceLast ?? "");

    // Dependent sections switch
    final condCode =
    MosqueConditionData.normalizeToCode(currentMosqueCondition);
    final showDependents = MosqueConditionData.showDependentTabs(condCode);
    _maybeNotify(showDependents);


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // 1) Mosque Condition
        // your field with the action added
        AppSelectionField(
          title: vm.fields.getField('mosque_condition').label,
          //title: 'mosque_condition'.tr(),
          value: _currentValue,
          type: SingleSelectionFieldType.selection,
          options: widget.fields.getComboList('mosque_condition'),
          isRequired: true,
          isReadonly: !widget.editing,
          isDisable: !widget.editing,

          // FIX: declaration toggle in the title row (Edit-Request only)
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('mosque_condition')),
            onChanged: (v) => vm.updateAgreeField(_k('mosque_condition'), v),
          )
              : null,

          onChanged: widget.editing
              ? (val) async {
            // Check if the new value will clear dependent data
            final normalizedVal = MosqueConditionData.normalizeToCode(val);
            final willClearData = !MosqueConditionData.showDependentTabs(normalizedVal);
            
            if (willClearData && val != null && val.isNotEmpty) {
              // Get the display name for the selection from the combo list
              final comboList = widget.fields.getComboList('mosque_condition');
              final selectedItem = comboList.firstWhere(
                (item) => item.key.toString() == normalizedVal,
                orElse: () => ComboItem(key: '', value: val),
              );
              final selectionName = selectedItem.value ?? val;
              
              // Show warning dialog using existing pattern
              final confirmed = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade600,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'mosque_condition_warning_title'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'mosque_condition_warning_message'.tr().replaceAll('{selection}', selectionName),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              text: 'mosque_condition_warning_cancel'.tr(),
                              onTab: () => Navigator.of(context).pop(false),
                            ),
                          ),
                          Expanded(
                            child: PrimaryButton(
                              text: 'mosque_condition_warning_confirm'.tr(),
                              onTab: () => Navigator.of(context).pop(true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
              
              // If user cancelled, revert to previous value
              if (confirmed != true) {
                setState(() {
                  _currentValue = vm.mosqueObj.mosqueCondition;
                });
                return;
              }
            }
            
            // Proceed with the change
            setState(() {
              _currentValue = val;
            });
            vm.mosqueObj.mosqueCondition = val;
            if (!vm.showDependentTabs) vm.mosqueObj.clearDependentData();
            vm.notifyListeners();
            vm.reloadTabs();

            if (isEditReq) {
              vm.updateAgreeField(_k('mosque_condition'), true);
            }

            _maybeNotify(vm.showDependentTabs);
          }
              : null,
        ),

        const SizedBox(height: 16),

        if (showDependents) ...[
          // 2) Building Material
          AppSelectionField(
            title: vm.fields.getField('building_material').label,
            //title: 'building_material'.tr(),
            value: vm.mosqueObj.buildingMaterial,
            type: SingleSelectionFieldType.selection,
            options: widget.fields.getComboList('building_material'),
            isRequired: true,
            isReadonly: !widget.editing,
            isDisable: !widget.editing,
            onChanged: widget.editing
                ? (val) {
              vm.mosqueObj.buildingMaterial=val;
            }
                : null,
          ),
          const SizedBox(height: 10),

          // 3) Urban Condition
          AppSelectionField(
            title: vm.fields.getField('urban_condition').label,
            //title: 'urban_condition'.tr(),
            value: vm.mosqueObj.urbanCondition,
            type: SingleSelectionFieldType.selection,
            options: widget.fields.getComboList('urban_condition'),
            isRequired: true,
            isReadonly: !widget.editing,
            isDisable: !widget.editing,
            onChanged: widget.editing
                ?  (val) {
              vm.mosqueObj.urbanCondition=val;
            }
                : null,
          ),
          const SizedBox(height: 12),

          // 4) Date of last renovation / maintenance
          AppDateField(
            title: vm.fields.getField('date_maintenance_last').label,
            //title: 'date_maintenance_last'.tr(),
            value: vm.mosqueObj.dateMaintenanceLast,
            //value: widget.local.dateMaintenanceLast,
            isReadonly: !widget.editing,
            isRequired: false,
            isDisable: true,
            onChanged: widget.editing
                ? (val) {
              vm.mosqueObj.dateMaintenanceLast=val;
              // widget.updateLocal((m) {
              //   m.dateMaintenanceLast = val;
              //   // Keep a normalized YYYY-MM-DD mirror in payload for BE safety
              //   (m.payload ??= {})['date_maintenance_last'] =
              //   val == null
              //       ? null
              //       : '${val.year.toString().padLeft(4, '0')}-'
              //       '${val.month.toString().padLeft(2, '0')}-'
              //       '${val.day.toString().padLeft(2, '0')}';
              //   m.updatedAt = DateTime.now();
              // });
              // setState(() {});
            }
                : null,
          ),

          const SizedBox(height: 16),

          // 5) Mosque Photo  -> AppAttachmentField (image-only)
          ImageHelpDialog.fieldTitleRow(
            title: vm.fields.getField('image').label,
            onHelpTap: () => ImageHelpDialog.showInternalMosqueHelp(context),
            isRequired: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: AppAttachmentField(
              title: '', // Empty title since we're using custom title above
              headersMap: vm.headerMap,
              value: vm.mosqueObj.image,
              path:  '${EnvironmentConfig.baseUrl}/web/image?model=${vm.modelName}&field=image&id=${vm.id}&unique=${vm.mosqueObj.uniqueId ?? ''}',
              isRequired: true,
              isMemory: false, // local bytes
              onChanged: (val) {
                vm.mosqueObj.image=val;
              },
            ),
          ),
          const SizedBox(height: 12),

          // 6) Outer Photo of Mosque -> AppAttachmentField (image-only)
          ImageHelpDialog.fieldTitleRow(
            title: _label('outer_image', 'Outer Photo of Mosque'),
            onHelpTap: () => ImageHelpDialog.showExternalMosqueHelp(context),
            isRequired: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: AppAttachmentField(
              title: '', // Empty title since we're using custom title above
              value: vm.mosqueObj.outerImage??'',
              headersMap: vm.headerMap,
              path:  '${EnvironmentConfig.baseUrl}/web/image?model=${vm.modelName}&field=outer_image&id=${vm.id}&unique=${vm.mosqueObj.uniqueId ?? ''}',
              isRequired: true,
              isMemory: true,
              onChanged: (val) {
                vm.mosqueObj.outerImage=val;
              },
            ),
          ),
        ],
          ],
        ),
      ),
    );
  }
}