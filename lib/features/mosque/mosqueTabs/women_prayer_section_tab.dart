import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/utils/app_regix_validation.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';
import '../core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import '../../../shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';


class WomenPrayerSectionTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const WomenPrayerSectionTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<WomenPrayerSectionTab> createState() => _WomenPrayerSectionTabState();
}

class _WomenPrayerSectionTabState extends State<WomenPrayerSectionTab> {
  late bool _hasWomenPrayerSection;

  String _k(String field) => field;

  @override
  void initState() {
    super.initState();
    _hasWomenPrayerSection = widget.local.hasWomenPrayerRoom == 'yes';
  }

  /// Automatically calculates women's prayer room capacity based on formula:
  /// capacity = row_women_praying_number * length_row_women_praying * 2
  void _calculateWomenCapacity(CreateMosqueBaseViewModel vm) {
    final rowNumber = vm.mosqueObj.rowWomenPrayingNumber;
    final rowLength = vm.mosqueObj.lengthRowWomenPraying;
    
    if (rowNumber != null && rowNumber > 0 && rowLength != null && rowLength > 0) {
      final oldCapacity = vm.mosqueObj.womenPrayerRoomCapacity;
      final newCapacity = (rowNumber * rowLength * 2).round();
      vm.mosqueObj.womenPrayerRoomCapacity = newCapacity;
      
      vm.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;


    // FIX: return the Selector from build()


       // final isEditReq = vm.mode == FormMode.editRequest;

        final bool showDeclaration =
            vm.mode == FormMode.editRequest && vm.mosqueObj != null;

        // read value from controller payload first, then direct field, then local fallback
        final String? val =
            (vm.mosqueObj?.payload?['has_women_prayer_room'] as String?) ??
                vm.mosqueObj?.hasWomenPrayerRoom ??
                widget.local.hasWomenPrayerRoom;

        final bool showSection = val == 'yes';
        _hasWomenPrayerSection = showSection;


        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
            AppSelectionField(
              // FIX: remount when value changes so it preselects
              key: ValueKey('has_women_prayer_room:${val ?? 'nil'}'), // FIX ✅
              title: widget.fields.getField('has_women_prayer_room').label,
              value: vm.mosqueObj.hasWomenPrayerRoom,
              type: SingleSelectionFieldType.radio,
              options: widget.fields.getComboList('has_women_prayer_room'),
              isRequired: true,

              // FIX: gate the toggle with showDeclaration
              action: isEditReq
                  ? AppDeclarationField(
                value: vm.getAgree(_k('has_women_prayer_room')),
                onChanged: (v) =>
                    vm.updateAgreeField(_k('has_women_prayer_room'), v),
              )
                  : null, // FIX ✅

              onChanged: widget.editing
                  ? (newVal) {
                // update local
                vm.mosqueObj.hasWomenPrayerRoom = newVal;
                if (newVal == 'no') {
                  vm.mosqueObj.rowWomenPrayingNumber = null;
                  vm.mosqueObj.lengthRowWomenPraying = null;
                  vm.mosqueObj.womenPrayerRoomCapacity = null;
                  vm.mosqueObj.toiletWomanNumber = null;
                }
                vm.notifyListeners();

                // FIX: only mirror into controller payload when we’re in edit-request
                // if (vm.model != null) { // FIX ✅
                //   final p = (vm.model!.payload ??= <String, dynamic>{});
                //   p['has_women_prayer_room'] = newVal;
                //   vm.model!
                //     ..updatedAt = DateTime.now();
                //   vm.notifyListeners();
                // }

                // FIX: only auto-check declaration in edit-request
                if (showDeclaration) { // FIX ✅
                  vm.updateAgreeField(_k('has_women_prayer_room'), true);
                }
              }
                  : null,
            ),
            if (vm.mosqueObj.hasWomenPrayerRoom=='yes') ...[
              AppInputField(
                title: widget.fields.getField('row_women_praying_number').label,
                value: vm.mosqueObj.rowWomenPrayingNumber,
                isReadonly: !widget.editing,
                isRequired: true,
                type: InputFieldType.number,
                validationRegex: RegExp(r'^(?!0$)\d+$'),
                validationError: 'Value should not be zero'.tr(),
                onChanged: widget.editing
                    ? (v) {
                      vm.mosqueObj.rowWomenPrayingNumber = v;
                      _calculateWomenCapacity(vm); // Auto-calculate capacity
                      // Update the single toggle for women prayer room section
                      if (isEditReq) {
                        vm.updateAgreeField(_k('has_women_prayer_room'), true);
                      }
                    }
                    : null,
              ),
              const SizedBox(height: 10),
              AppInputField(
                title: widget.fields.getField('length_row_women_praying').label,
                value: vm.mosqueObj.lengthRowWomenPraying,
                isReadonly: !widget.editing,
                validationRegex: RegExp(r'^(?!0*(?:\.0+)?$)\d+(?:\.\d+)?$'),
                validationError: 'Value should not be zero'.tr(),
                isRequired: true,
                type: InputFieldType.double,
                onSave:(v) {
                  widget.local.lengthRowWomenPraying = v;
                  _calculateWomenCapacity(vm);
                  // Update the single toggle for women prayer room section
                  if (isEditReq) {
                    vm.updateAgreeField(_k('has_women_prayer_room'), true);
                  }
                },
                onChanged: (v) {
                  vm.mosqueObj.lengthRowWomenPraying = v;
                },
              ),
              const SizedBox(height: 10),
              AppInputField(
                title: widget.fields.getField('women_prayer_room_capacity').label,
                value: vm.mosqueObj.womenPrayerRoomCapacity,
                isReadonly: true, // Always readonly - auto-calculated
                isRequired: true,
                validationRegex: RegExp(r'^(?!0$)\d+$'),
                validationError: 'Value should not be zero'.tr(),
                type: InputFieldType.number,
                onChanged: null, // No manual changes allowed - auto-calculated
              ),
              const SizedBox(height: 10),
              AppInputField(
                title: widget.fields.getField('toilet_woman_number').label,
                value: vm.mosqueObj.toiletWomanNumber,
                isReadonly: !widget.editing,
                isRequired: true,
                type: InputFieldType.number,
                validationRegex: AppRegexValidation.zeroTo99,
                validationError: 'Value must be between 0 and 99'.tr(),
                onChanged: widget.editing
                    ? (v) {
                        vm.mosqueObj.toiletWomanNumber = v;
                        // Update the single toggle for women prayer room section
                        if (isEditReq) {
                          vm.updateAgreeField(_k('has_women_prayer_room'), true);
                        }
                      }
                    : null,
              ),
            ],
              ],
            ),
          ),
        );


    // FIX: close Selector and return it
  }
}
