import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import '../core/models/mosque_local.dart';
import '../createMosque/form/create_mosque_view_model.dart';


import 'package:provider/provider.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';



class ImamsMuezzinsDetailsTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const ImamsMuezzinsDetailsTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields
  });

  @override
  State<ImamsMuezzinsDetailsTab> createState() =>
      _ImamsMuezzinsDetailsTabState();
}

class _ImamsMuezzinsDetailsTabState extends State<ImamsMuezzinsDetailsTab> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;

    String _k(String field) => field;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
          AppSelectionField(
            title: vm.fields.getField('residence_for_imam').label,
            //title: 'residence_for_imam'.tr(),
            value: widget.local.residenceForImam,
            type: SingleSelectionFieldType.selection,
            options: widget.fields.getComboList('residence_for_imam'),
            isRequired: true,

    // ✅ show toggle only in Edit-Request, in the title row (AppSelectionField should render action before title RTL-friendly)
                action: isEditReq
                ? AppDeclarationField(
                value: vm.getAgree(_k('residence_for_imam')),
                onChanged: (v) => vm.updateAgreeField(_k('residence_for_imam'), v),
                )
                    : null,

                onChanged: widget.editing
                ? (val) {
                widget.local.residenceForImam = val;
                // reset dependents if "no"
                if (val == 'no') {
                widget.local.imamResidenceType = null;
                widget.local.imamResidenceLandArea = null;
                  vm.notifyListeners();
                }


                // ✅ auto-check the declaration when user changes value (edit-request only)
                if (isEditReq) {
                vm.updateAgreeField(_k('residence_for_imam'), true);
                }

                setState(() {});
                }
                    : null,
                ),
        if (widget.local.residenceForImam == 'yes')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSelectionField(
                title: vm.fields.getField('imam_residence_type').label,
                //title: 'imam_residence_type'.tr(),
                value: widget.local.imamResidenceType,
                type: SingleSelectionFieldType.radio,
                options: widget.fields.getComboList('imam_residence_type'),
                isRequired: true,
                onChanged: widget.editing
                    ? (val) {
                  widget.local.imamResidenceType = val;
                  // Update the single toggle for imam residence section
                  if (isEditReq) {
                    vm.updateAgreeField(_k('residence_for_imam'), true);
                  }
                }
                    : null,
              ),
            ],
          ),
        if (widget.local.residenceForImam == 'land_not_building' ||
            widget.local.residenceForImam == 'yes')
          AppInputField(
            title: vm.fields.getField('imam_residence_land_area').label,
            //title: 'imam_residence_land_area'.tr(),
            value: widget.local.imamResidenceLandArea,
            type: InputFieldType.double,
            isRequired: true,
            validationRegex: RegExp(r'^(?!0*(?:\.0+)?$)\d+(?:\.\d+)?$'),
            validationError: 'Value should not be zero'.tr(),
            onSave: widget.editing
                ? (val) {
              widget.local.imamResidenceLandArea = val;
              // Update the single toggle for imam residence section
              if (isEditReq) {
                vm.updateAgreeField(_k('residence_for_imam'), true);
              }
            }
                : null,
            onChanged: (val) {
              widget.local.imamResidenceLandArea = val;
              // Update the single toggle for imam residence section

            },
          ),

        AppSelectionField(
          title: vm.fields.getField('residence_for_mouadhin').label,
          //title: 'residence_for_mouadhin'.tr(),
          value: widget.local.residenceForMouadhin,
          type: SingleSelectionFieldType.selection,
          options: widget.fields.getComboList('residence_for_mouadhin'),
          isRequired: true,

          //  toggle in title row, only in Edit-Request
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('residence_for_mouadhin')),
            onChanged: (v) => vm.updateAgreeField(_k('residence_for_mouadhin'), v),
          )
              : null,

          onChanged: widget.editing
              ? (val) {
            widget.local.residenceForMouadhin = val;

              // reset dependents if "no"
              if (val == 'no') {
                widget.local.muezzinResidenceType = null;
                widget.local.muezzinResidenceLandArea = null;
              }


            //  auto-check declaration after any change (Edit-Request only)
            if (isEditReq) {
              vm.updateAgreeField(_k('residence_for_mouadhin'), true);
            }

            setState(() {});
          }
              : null,
        ),
        if (widget.local.residenceForMouadhin == 'yes')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSelectionField(
                title: vm.fields.getField('muezzin_residence_type').label,
                //title: 'muezzin_residence_type'.tr(),
                value: widget.local.muezzinResidenceType,
                type: SingleSelectionFieldType.radio,
                options: widget.fields.getComboList('muezzin_residence_type'),
                isRequired: true,
                onChanged: widget.editing
                    ? (val) {
                  widget.local.muezzinResidenceType = val;
                  // Update the single toggle for muezzin residence section
                  if (isEditReq) {
                    vm.updateAgreeField(_k('residence_for_mouadhin'), true);
                  }
                }
                    : null,
              ),
            ],
          ),
        if (widget.local.residenceForMouadhin == 'land_not_building' ||
            widget.local.residenceForMouadhin == 'yes')
          AppInputField(
            title: vm.fields.getField('muezzin_residence_land_area').label,
            //title: 'muezzin_residence_land_area'.tr(),
            value: widget.local.muezzinResidenceLandArea,
            type: InputFieldType.double,
            isRequired: true,
            validationRegex: RegExp(r'^(?!0*(?:\.0+)?$)\d+(?:\.\d+)?$'),
            validationError: 'Value should not be zero'.tr(),
            onSave: widget.editing
                ? (val) {
              widget.local.muezzinResidenceLandArea = val;
              // Update the single toggle for muezzin residence section
              if (isEditReq) {
                vm.updateAgreeField(_k('residence_for_mouadhin'), true);
              }
            }
                : null,
            onChanged: (val) {
              widget.local.muezzinResidenceLandArea = val;
            },
          ),
          ],
        ),
      ),
    );
  }
}