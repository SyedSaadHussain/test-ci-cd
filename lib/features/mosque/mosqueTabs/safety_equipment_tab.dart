import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import '../../../core/models/field_list.dart';
import '../core/models/mosque_local.dart';


import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';

class SafetyEquipmentTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const SafetyEquipmentTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<SafetyEquipmentTab> createState() => _SafetyEquipmentTabState();
}

class _SafetyEquipmentTabState extends State<SafetyEquipmentTab> {
  String _k(String field) => field;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;
    // read controller + mode (listens for changes)
    final isEditReq1 = (vm.mode == FormMode.editRequest) && (vm.mosqueObj != null);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // has_fire_extinguishers
        AppSelectionField(
          title: vm.fields.getField('has_fire_extinguishers').label,
          //title: 'has_fire_extinguishers'.tr(),
          value: vm.mosqueObj.hasFireExtinguishers,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('has_fire_extinguishers'),
          isRequired: true,
          // toggle in title row, only in Edit-Request
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('has_fire_extinguishers')),
            onChanged: (v) => vm.updateAgreeField(_k('has_fire_extinguishers'), v),
          )
              : null,
          onChanged: widget.editing
              ? (val) {
            vm.mosqueObj.hasFireExtinguishers = val;
            // auto-check after any change (Edit-Request only)
            if (isEditReq) vm.updateAgreeField(_k('has_fire_extinguishers'), true);
          }
              : null,
        ),

        const Divider(height: 1),

        // has_fire_system_pumps
        AppSelectionField(
          title: vm.fields.getField('has_fire_system_pumps').label,
          //title: 'has_fire_system_pumps'.tr(),
          value: vm.mosqueObj.hasFireSystemPumps,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('has_fire_system_pumps'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('has_fire_system_pumps')),
            onChanged: (v) => vm.updateAgreeField(_k('has_fire_system_pumps'), v),
          )
              : null,
          onChanged: widget.editing
              ? (val) {
            vm.mosqueObj.hasFireSystemPumps = val;
            if (isEditReq) vm.updateAgreeField(_k('has_fire_system_pumps'), true);
          }
              : null,
        ),
          ],
        ),
      ),
    );
  }
}
