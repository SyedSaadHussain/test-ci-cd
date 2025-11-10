import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

import '../createMosque/form/create_mosque_view_model.dart';

import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';


class ArchitecturalStructureTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const ArchitecturalStructureTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<ArchitecturalStructureTab> createState() => _ArchitecturalStructureTabState();
}

class _ArchitecturalStructureTabState extends State<ArchitecturalStructureTab> {
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
        // external_doors_numbers
        AppInputField(
          title: widget.fields.getField('external_doors_numbers').label,
          value: widget.local.externalDoorsNumbers,
          isReadonly: !widget.editing,
          validationRegex: RegExp(r'^([0-9]|[1-9][0-9])$'),
          validationError: 'Value must be between 0 and 99'.tr(),
          type: InputFieldType.number,

          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('external_doors_numbers')),
            onChanged: (v) => vm.updateAgreeField(_k('external_doors_numbers'), v),
          )
              : null,

          onChanged: widget.editing
              ? (v) {
            widget.local.externalDoorsNumbers=v;
            // (optional) auto-check once user edits
            if (isEditReq) {
              vm.updateAgreeField(_k('external_doors_numbers'), true);
            }
          }
              : null,
        ),
        const SizedBox(height: 10),

        // internal_doors_number
        AppInputField(
          title: widget.fields.getField('internal_doors_number').label,
          value: widget.local.internalDoorsNumber,
          isReadonly: !widget.editing,
          validationRegex: RegExp(r'^([1-9]|[1-9][0-9])$'),
          validationError: 'Value must be between 1 and 99'.tr(),
          type: InputFieldType.number,
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('internal_doors_number')),
            onChanged: (v) => vm.updateAgreeField(_k('internal_doors_number'), v),
          )
              : null,

          onChanged: widget.editing
              ? (v) {
            widget.local.internalDoorsNumber = v;
            // (optional) auto-check once user edits
            if (isEditReq) {
              vm.updateAgreeField(_k('internal_doors_number'), true);
            }
          }
              : null,
        ),
        const SizedBox(height: 10),

        // num_minarets
        AppInputField(
          title: widget.fields.getField('num_minarets').label,
          value: widget.local.numMinarets,
          isReadonly: !widget.editing,
          validationRegex: RegExp(r'^[0-9]$'),
          validationError: 'Value must be between 0 and 9'.tr(),
          type: InputFieldType.number,
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('num_minarets')),
            onChanged: (v) => vm.updateAgreeField(_k('num_minarets'), v),
          )
              : null,

          onChanged: widget.editing
              ? (v) {
            widget.local.numMinarets = v;
            // (optional) auto-check once user edits
            if (isEditReq) {
              vm.updateAgreeField(_k('num_minarets'), true);
            }
          }
              : null,
        ),
        const SizedBox(height: 10),

        // num_floors
        AppInputField(
          title: widget.fields.getField('num_floors').label,
          value: widget.local.numFloors,
          isReadonly: !widget.editing,
          type: InputFieldType.number,
          isRequired: true,
          validationRegex: RegExp(r'^([1-9])$'),
          validationError: 'Value must be between 1 and 9'.tr(),
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('num_floors')),
            onChanged: (v) => vm.updateAgreeField(_k('num_floors'), v),
          )
              : null,

          onChanged: widget.editing
              ? (v) {
            widget.local.numFloors = v;
            // (optional) auto-check once user edits
            if (isEditReq) {
              vm.updateAgreeField(_k('num_floors'), true);
            }
          }
              : null,
        ),
        const SizedBox(height: 10),

        // has_basement
        AppSelectionField(
          title: widget.fields.getField('has_basement').label,
          value: widget.local.hasBasement,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('has_basement'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('has_basement')),
            onChanged: (v) => vm.updateAgreeField(_k('has_basement'), v),
          )
              : null,

          onChanged: widget.editing
              ? (v) {
            widget.local.hasBasement = v;
            // (optional) auto-check once user edits
            if (isEditReq) {
              vm.updateAgreeField(_k('has_basement'), true);
            }
          }
              : null,
        ),
        const SizedBox(height: 10),

        // mosque_rooms
        AppInputField(
          title: widget.fields.getField('mosque_rooms').label,
          value: widget.local.mosqueRooms,
          isReadonly: !widget.editing,
          type: InputFieldType.number,
          isRequired: true,
          validationRegex: RegExp(r'^([0-9])$'),
          validationError: 'Value must be between 0 and 9'.tr(),
          action: isEditReq

              ? AppDeclarationField(
            value: vm.getAgree(_k('mosque_rooms')),
            onChanged: (v) => vm.updateAgreeField(_k('mosque_rooms'), v),
          )
              : null,

          onChanged: widget.editing
              ? (v) {
            widget.local.mosqueRooms = v;
            // (optional) auto-check once user edits
            if (isEditReq) {
              vm.updateAgreeField(_k('mosque_rooms'), true);
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
