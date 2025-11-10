import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';


import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';

class HistoricalMosquesTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const HistoricalMosquesTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<HistoricalMosquesTab> createState() => _HistoricalMosquesTabState();
}

class _HistoricalMosquesTabState extends State<HistoricalMosquesTab> {
  String _k(String field) => field;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;
    final isEditReq1 = (vm.mode == FormMode.editRequest) && (vm.mosqueObj != null);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // mosque_historical
        AppSelectionField(
          title: vm.fields.getField('mosque_historical').label,
          //title: 'mosque_historical'.tr(),
          value: vm.mosqueObj.mosqueHistorical,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('mosque_historical'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('mosque_historical')),
            onChanged: (v) => vm.updateAgreeField(_k('mosque_historical'), v),
          )
              : null,
          onChanged: widget.editing
              ? (v) {
            vm.mosqueObj.mosqueHistorical=v;
            if (v == 'no') {
              // reset dependent data + (optionally) its agree flag
              vm.mosqueObj.princeProjectHistoricMosque = null;
              vm.updateAgreeField(_k('prince_project_historic_mosque'), false);
            }
            vm.notifyListeners();
            if (isEditReq) vm.updateAgreeField(_k('mosque_historical'), true);

          }
              : null,
        ),

        const Divider(height: 1),

        if (vm.mosqueObj.mosqueHistorical == 'yes')
          AppSelectionField(
            title: vm.fields.getField('prince_project_historic_mosque').label,
            //title: 'prince_project_historic_mosque'.tr(),
            value: vm.mosqueObj.princeProjectHistoricMosque,
            type: SingleSelectionFieldType.radio,
            isRequired: true,
            options: widget.fields.getComboList('prince_project_historic_mosque'),
            action: isEditReq
                ? AppDeclarationField(
              value: vm.getAgree(_k('prince_project_historic_mosque')),
              onChanged: (v) =>
                  vm.updateAgreeField(_k('prince_project_historic_mosque'), v),
            )
                : null,
            onChanged: widget.editing
                ? (v) {
              vm.mosqueObj.princeProjectHistoricMosque= v;
              if (isEditReq) {
                vm.updateAgreeField(_k('prince_project_historic_mosque'), true);
              }
            }
                : null,
          ),
          ],
        ),
      ),
    );
  }
}
