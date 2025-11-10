// lib/screens/mosque/mosqueTabs/maintenance_operation_tab.dart

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

class MaintenanceOperationTab extends StatelessWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const MaintenanceOperationTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  String _k(String field) => field;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // Maintenance Responsible (selection)
        AppSelectionField(
          title: fields.getField('maintenance_responsible').label,
          value: vm.mosqueObj.maintenanceResponsible,
          type: SingleSelectionFieldType.selection,
          options: fields.getComboList('maintenance_responsible'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
                  value: vm.getAgree(_k('maintenance_responsible')),
                  onChanged: (v) => vm.updateAgreeField(_k('maintenance_responsible'), v),
                )
              : null,
          onChanged: editing
              ? (val) {
                  vm.mosqueObj.maintenanceResponsible = val;
                  vm.notifyListeners();
                  if (isEditReq) vm.updateAgreeField(_k('maintenance_responsible'), true);
                }
              : null,
        ),
          ],
        ),
      ),
    );
  }
}