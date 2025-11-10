import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import '../../../core/models/field_list.dart';
import '../core/models/mosque_local.dart';


import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';

class MosqueLandTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const MosqueLandTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<MosqueLandTab> createState() => _MosqueLandTabState();
}

class _MosqueLandTabState extends State<MosqueLandTab> {
  String _k(String field) => field;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Read controller + mode once (listens for changes)
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // mosque_land_area
        AppInputField(
          title: vm.fields.getField('land_area').label,
          //title: 'mosque_land_area'.tr(),
          value: vm.mosqueObj.mosqueLandArea ?? '',
          isReadonly: !widget.editing,
          type: InputFieldType.textField,
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('land_area')),
            onChanged: (v) => vm.updateAgreeField(_k('land_area'), v),
          )
              : null,
          onSave: widget.editing
              ? (v) {
                  vm.mosqueObj.mosqueLandArea = v;
                  // Update the toggle for land_area field
                  if (isEditReq) {
                    vm.updateAgreeField(_k('land_area'), true);
                  }
                }
              : null,
          onChanged: widget.editing
              ? (val) {
                  vm.mosqueObj.mosqueLandArea = val;
                  // Update the toggle for land_area field
                  if (isEditReq) {
                    vm.updateAgreeField(_k('land_area'), true);
                  }
                }
              : null,
        ),
        const SizedBox(height: 10),

        // non_building_area
        AppInputField(
          title: vm.fields.getField('non_building_area').label,
          //title: 'non_building_area'.tr(),
          value: widget.local.nonBuildingArea,
          isReadonly: !widget.editing,
          type: InputFieldType.double,
          isRequired: false,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('non_building_area')),
            onChanged: (v) => vm.updateAgreeField(_k('non_building_area'), v),
          )
              : null,
          onSave: widget.editing
              ? (v) {
                  vm.mosqueObj.nonBuildingArea = v;
                  // Update the toggle for non_building_area field
                  if (isEditReq) {
                    vm.updateAgreeField(_k('non_building_area'), true);
                  }
                }
              : null,
          onChanged: (val) {
            vm.mosqueObj.nonBuildingArea = val;
          },
        ),
        const SizedBox(height: 10),

        // roofed_area
        AppInputField(
          title: vm.fields.getField('roofed_area').label,
          //title: 'roofed_area'.tr(),
          value: widget.local.roofedArea,
          isReadonly: !widget.editing,
          type: InputFieldType.double,
          isRequired: false,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('roofed_area')),
            onChanged: (v) => vm.updateAgreeField(_k('roofed_area'), v),
          )
              : null,
          onSave: widget.editing
              ? (v) {
                  vm.mosqueObj.roofedArea = v;
                  // Update the toggle for roofed_area field
                  if (isEditReq) {
                    vm.updateAgreeField(_k('roofed_area'), true);
                  }
                }
              : null,
          onChanged: (val) {
            vm.mosqueObj.roofedArea = val;
          },
        ),
        const SizedBox(height: 10),

        // is_free_area
        AppSelectionField(
          title: vm.fields.getField('is_free_area').label,
          //title: 'is_free_area'.tr(),
          value: widget.local.isFreeArea,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('is_free_area'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('is_free_area')),
            onChanged: (v) => vm.updateAgreeField(_k('is_free_area'), v),
          )
              : null,
          onChanged: widget.editing
              ? (val) {
            vm.mosqueObj.isFreeArea=val;
            if (val == 'no') {
              vm.mosqueObj.freeArea = null;
              vm.updateAgreeField(_k('free_area'), false); // optional clear
            }
            vm.notifyListeners();
            // Update the toggle for is_free_area field
            if (isEditReq) vm.updateAgreeField(_k('is_free_area'), true);
          }
              : null,
        ),
        const SizedBox(height: 10),

        // free_area (conditional)
        if (vm.mosqueObj.isFreeArea=='yes')
          AppInputField(
            title: vm.fields.getField('free_area').label,
            //title: 'free_area'.tr(),
            value: vm.mosqueObj.freeArea,
            isReadonly: !widget.editing,
            type: InputFieldType.double,
            isRequired: true,
            action: isEditReq
                ? AppDeclarationField(
              value: vm.getAgree(_k('free_area')),
              onChanged: (v) => vm.updateAgreeField(_k('free_area'), v),
            )
                : null,
            onSave: widget.editing
                ? (v) {
                    vm.mosqueObj.freeArea = v;
                    // Update the toggle for free_area field
                    if (isEditReq) {
                      vm.updateAgreeField(_k('free_area'), true);
                    }
                  }
                : null,
            onChanged: (val) {
              vm.mosqueObj.freeArea = val;
            },
          ),
        if (vm.mosqueObj.isFreeArea=='yes') const SizedBox(height: 10),

        // mosque_opening_date (selection - string values like 'after_1441', 'prophet')
        AppSelectionField(
          title: vm.fields.getField('mosque_opening_date').label,
          //title: 'mosque_opening_date'.tr(),
          value: vm.mosqueObj.mosqueOpeningDate,
          type: SingleSelectionFieldType.selection,
          options: vm.fields.getComboList('mosque_opening_date'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('mosque_opening_date')),
            onChanged: (v) => vm.updateAgreeField(_k('mosque_opening_date'), v),
          )
              : null,
          onChanged: widget.editing
              ? (v) {
                  // Direct string assignment (values: 'after_1441', 'prophet', etc.)
                  vm.mosqueObj.mosqueOpeningDate = v?.toString();
                  // Update the toggle for mosque_opening_date field
                  if (isEditReq) vm.updateAgreeField(_k('mosque_opening_date'), true);
                }
              : null,
        ),
          ],
        ),
      ),
    );
  }
}
