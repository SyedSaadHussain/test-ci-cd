import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import '../core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'logic/image_help_dialog.dart';

class QrCodePanelTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const QrCodePanelTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<QrCodePanelTab> createState() => _QrCodePanelTabState();
}

class _QrCodePanelTabState extends State<QrCodePanelTab> {
  // late bool _hasPanel;

  @override
  void initState() {
    super.initState();
    // _hasPanel = widget.local.isQrCodeExist == 'yes';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;
    final isEditReq1 = (vm.mode == FormMode.editRequest) && (vm.mosqueObj != null);
    String _k(String field) => field;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        AppSelectionField(
          title: vm.fields.getField('is_qr_code_exist').label,
          //title: 'is_qr_code_exist'.tr(),
          value: vm.mosqueObj.isQrCodeExist,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('is_qr_code_exist'),
          isRequired: true,

          // toggle in title row, only in Edit-Request
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('is_qr_code_exist')),
            onChanged: (v) => vm.updateAgreeField(_k('is_qr_code_exist'), v),
          )
              : null,

          onChanged: widget.editing
              ? (val) {
            vm.mosqueObj.isQrCodeExist = val;

            // Clear dependents when switched to "no"
            if (val == 'no') {
              vm.mosqueObj.qrPanelNumbers = null;
              vm.mosqueObj.isPanelReadable = null;
              vm.mosqueObj.mosqueDataCorrect = null;
              vm.mosqueObj.isMosqueNameQr = null;
              vm.mosqueObj.qrCodeNotes = null;
              vm.mosqueObj.qrImage = null;
            }
            vm.notifyListeners();

            // auto-check declaration after any change (Edit-Request only)
            if (isEditReq) vm.updateAgreeField(_k('is_qr_code_exist'), true);

            // setState(() {
            //   _hasPanel = val == 'yes';
            // });
          }
              : null,
        ),
        const SizedBox(height: 8),

        if (vm.mosqueObj.isQrCodeExist=='yes') ...[
          AppInputField(
            title: vm.fields.getField('qr_panel_numbers').label,
            //title: 'qr_panel_numbers'.tr(),
            value: widget.local.qrPanelNumbers,
            isReadonly: !widget.editing,
            validationRegex: RegExp(r'^([1-9])$'),
            validationError: 'Value must be between 1 and 9'.tr(),
            type: InputFieldType.number,
            isRequired: true,
            onChanged: widget.editing
                ? (v) {
                    vm.mosqueObj.qrPanelNumbers = v;
                    // Update the single toggle for QR code panel section
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_qr_code_exist'), true);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 10),

          AppSelectionField(
            title: vm.fields.getField('is_panel_readable').label,
            //title: 'is_panel_readable'.tr(),
            value: widget.local.isPanelReadable,
            type: SingleSelectionFieldType.radio,
            options: widget.fields.getComboList('is_panel_readable'),
            isRequired: true,
            onChanged: widget.editing
                ? (val) {
                    vm.mosqueObj.isPanelReadable = val;
                    // Update the single toggle for QR code panel section
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_qr_code_exist'), true);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 8),

          AppSelectionField(
            title: vm.fields.getField('mosque_data_correct').label,
            //title: 'mosque_data_correct'.tr(),
            value: widget.local.mosqueDataCorrect,
            type: SingleSelectionFieldType.radio,
            options: widget.fields.getComboList('mosque_data_correct'),
            isRequired: true,
            onChanged: widget.editing
                ? (val) {
                    vm.mosqueObj.mosqueDataCorrect = val;
                    // Update the single toggle for QR code panel section
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_qr_code_exist'), true);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 8),

          AppSelectionField(
            title: vm.fields.getField('is_mosque_name_qr').label,
            //title: 'is_mosque_name_qr'.tr(),
            value: widget.local.isMosqueNameQr,
            type: SingleSelectionFieldType.radio,
            options: widget.fields.getComboList('is_mosque_name_qr'),
            isRequired: true,
            onChanged: widget.editing
                ? (val) {
                    vm.mosqueObj.isMosqueNameQr = val;
                    // Update the single toggle for QR code panel section
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_qr_code_exist'), true);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 8),

          AppInputField(
            title: vm.fields.getField('qr_code_notes').label,
            //title: 'qr_code_notes'.tr(),
            value: widget.local.qrCodeNotes,
            isReadonly: !widget.editing,
            onChanged: widget.editing
                ? (v) {
                    vm.mosqueObj.qrCodeNotes = v;
                    // Update the single toggle for QR code panel section
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_qr_code_exist'), true);
                    }
                  }
                : null,
          ),
          const SizedBox(height: 10),

          // Custom title row with help icon
          ImageHelpDialog.fieldTitleRow(
            title: vm.fields.getField('qr_image').label,
            onHelpTap: () => ImageHelpDialog.showQrPanelHelp(context),
            isRequired: true,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: AppAttachmentField(
              title: '', // Empty title since we're using custom title above
              value: widget.local.qrImage,
              isRequired: true,
              isMemory: true,
              onChanged: widget.editing
                  ? (v) {
                      vm.mosqueObj.qrImage = v;
                      // Update the single toggle for QR code panel section
                      if (isEditReq) {
                        vm.updateAgreeField(_k('is_qr_code_exist'), true);
                      }
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 10),
        ],
          ],
        ),
      ),
    );
  }
}