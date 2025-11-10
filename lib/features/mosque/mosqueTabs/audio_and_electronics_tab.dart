import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';

import '../../../core/models/field_list.dart';
import '../../../core/models/combo_list.dart';
import '../core/models/mosque_local.dart';

import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';


class AudioElectronicsTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const AudioElectronicsTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<AudioElectronicsTab> createState() => _AudioElectronicsTabState();
}

class _AudioElectronicsTabState extends State<AudioElectronicsTab> {
  String _k(String field) => field;

  List<ComboItem> _acTypeOptions = [];

  @override
  void initState() {
    super.initState();
    _loadAcTypeOptions();
  }

  Future<void> _loadAcTypeOptions() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/mosque/ac_type.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _acTypeOptions = jsonList.map((item) => ComboItem(
          key: item['id'],
          value: item['name'],
        )).toList();
      });
    } catch (e) {
      debugPrint('Error loading ac_type.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // has_air_conditioners
        AppSelectionField(
          title: widget.fields.getField('has_air_conditioners').label,
          value: vm.mosqueObj.hasAirConditioners,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('has_air_conditioners'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('has_air_conditioners')),
            onChanged: (v) => vm.updateAgreeField(_k('has_air_conditioners'), v),
          )
              : null,
          onChanged: (val) {
            vm.mosqueObj.hasAirConditioners=val;
            
            // Reset dependent fields when set to 'no'
            if (val == 'no') {
              vm.mosqueObj.acType=null;
              vm.mosqueObj.numAirConditioners=null;
              // Clear dependent field toggles
              vm.updateAgreeField(_k('ac_type'), false);
              vm.updateAgreeField(_k('num_air_conditioners'), false);
            }
            
            vm.notifyListeners();
            
            // Update the toggle for has_air_conditioners field
            if (isEditReq) {
              vm.updateAgreeField(_k('has_air_conditioners'), true);
            }
          },
        ),
        const SizedBox(height: 10),

        if (vm.mosqueObj.hasAirConditioners=='yes')
          Column(
            children: [
              // ac_type (multiple selection)
              AppSelectionField(
                title: widget.fields.getField('ac_type').label,
                value: vm.mosqueObj.acType ?? [],
                type: SingleSelectionFieldType.checkBox,
                options: _acTypeOptions,
                isRequired: true,
                action: isEditReq
                    ? AppDeclarationField(
                  value: vm.getAgree(_k('ac_type')),
                  onChanged: (v) => vm.updateAgreeField(_k('ac_type'), v),
                )
                    : null,
                onChanged:(item, isChecked) {
                  final List<int> currentList = List<int>.from(vm.mosqueObj.acType ?? []);
                  if (isChecked) {
                    if (!currentList.contains(item.key)) {
                      currentList.add(item.key);
                    }
                  } else {
                    currentList.remove(item.key);
                  }
                  vm.mosqueObj.acType = currentList;
                  if (isEditReq) {
                    vm.updateAgreeField(_k('ac_type'), true);
                    // Update the toggle for has_air_conditioners field
                    vm.updateAgreeField(_k('has_air_conditioners'), true);
                  }
                  vm.notifyListeners();
                },
              ),
              const SizedBox(height: 10),

              // num_air_conditioners
              AppInputField(
                title: widget.fields.getField('num_air_conditioners').label,
                value: vm.mosqueObj.numAirConditioners,
                isReadonly: !widget.editing,
                type: InputFieldType.number,
                isRequired: true,
                validationRegex: RegExp(r'^([1-9]|[1-9][0-9])$'),
                validationError: 'Value must be between 1 and 99'.tr(),
                action: isEditReq
                    ? AppDeclarationField(
                  value: vm.getAgree(_k('num_air_conditioners')),
                  onChanged: (v) =>
                      vm.updateAgreeField(_k('num_air_conditioners'), v),
                )
                    : null,
                onChanged: widget.editing
                    ? (val) {
                        vm.mosqueObj.numAirConditioners=val;
                        // Update the toggle for num_air_conditioners field
                        if (isEditReq) {
                          vm.updateAgreeField(_k('num_air_conditioners'), true);
                          // Update the toggle for has_air_conditioners field
                          vm.updateAgreeField(_k('has_air_conditioners'), true);
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 10),
            ],
          ),

        // has_internal_camera
        AppSelectionField(
          title: widget.fields.getField('has_internal_camera').label,
          value: vm.mosqueObj.hasInternalCamera,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('has_internal_camera'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('has_internal_camera')),
            onChanged: (v) => vm.updateAgreeField(_k('has_internal_camera'), v),
          )
              : null,
            onChanged:(val) {
              vm.mosqueObj.hasInternalCamera=val;
              // Update the toggle for has_internal_camera field
              if (isEditReq) {
                vm.updateAgreeField(_k('has_internal_camera'), true);
              }
            },
        ),
        const SizedBox(height: 10),

        // has_external_camera
        AppSelectionField(
          title: widget.fields.getField('has_external_camera').label,
          value: vm.mosqueObj.hasExternalCamera,
          type: SingleSelectionFieldType.radio,
          options: widget.fields.getComboList('has_external_camera'),
          isRequired: true,
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('has_external_camera')),
            onChanged: (v) => vm.updateAgreeField(_k('has_external_camera'), v),
          )
              : null,
            onChanged:(val) {
              vm.mosqueObj.hasExternalCamera=val;
              // Update the toggle for has_external_camera field
              if (isEditReq) {
                vm.updateAgreeField(_k('has_external_camera'), true);
              }
            },
        ),
        const SizedBox(height: 10),

        // num_lighting_inside
        AppInputField(
          title: widget.fields.getField('num_lighting_inside').label,
          value: vm.mosqueObj.numLightingInside,
          isReadonly: !widget.editing,
          type: InputFieldType.number,
          isRequired: true,
          validationRegex: RegExp(r'^([1-9]|[1-9][0-9]|[1-9][0-9][0-9]|[1-9][0-9][0-9][0-9])$'),
          validationError: 'Value must be between 1 and 9999'.tr(),
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('num_lighting_inside')),
            onChanged: (v) => vm.updateAgreeField(_k('num_lighting_inside'), v),
          )
              : null,
          onChanged:(val) {
            vm.mosqueObj.numLightingInside=val;
            vm.updateAgreeField(_k('num_lighting_inside'), true);
          },
        ),
        const SizedBox(height: 10),

        // internal_speaker_number
        AppInputField(
          title: widget.fields.getField('internal_speaker_number').label,
          value: vm.mosqueObj.internalSpeakerNumber,
          isReadonly: !widget.editing,
          type: InputFieldType.number,
          isRequired: true,
          validationRegex: RegExp(r'^([1-9]|[1-9][0-9])$'),
          validationError: 'Value must be between 1 and 99'.tr(),
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('internal_speaker_number')),
            onChanged: (v) =>
                vm.updateAgreeField(_k('internal_speaker_number'), v),
          )
              : null,
          onChanged:(val) {
            vm.mosqueObj.internalSpeakerNumber=val;
            vm.updateAgreeField(_k('internal_speaker_number'), true);
          },
        ),
        const SizedBox(height: 10),

        // external_headset_number
        AppInputField(
          title: widget.fields.getField('external_headset_number').label,
          value: vm.mosqueObj.externalHeadsetNumber,
          isReadonly: !widget.editing,
          type: InputFieldType.number,
          isRequired: true,
          validationRegex: RegExp(r'^(?:[0-9]|[1-9][0-9])$'),
          validationError: 'Value must be between 0 and 99'.tr(),
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('external_headset_number')),
            onChanged: (v) =>
                vm.updateAgreeField(_k('external_headset_number'), v),
          )
              : null,
          onChanged:(val) {
            vm.mosqueObj.externalHeadsetNumber=val;
            vm.updateAgreeField(_k('external_headset_number'), true);
          },
        ),
          ],
        ),
      ),
    );
  }
}

