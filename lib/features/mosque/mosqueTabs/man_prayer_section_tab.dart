import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';
import '../core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import '../../../shared/widgets/form_controls/app_declaration_field.dart';
import '../createMosque/form/create_mosque_view_model.dart';

import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import 'logic/validation_scope.dart';
import '../../../core/utils/asset_json_utils.dart';

class MenPrayerSectionTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;

  const MenPrayerSectionTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
  });

  @override
  State<MenPrayerSectionTab> createState() => _MenPrayerSectionTabState();
}

class _MenPrayerSectionTabState extends State<MenPrayerSectionTab> {
  late bool _showFridayRows;
  static const String _tabKey = 'men_prayer_section';                 // FIX
  String _k(String field) => '$field';

  @override
  void initState() {
    super.initState();
    _showFridayRows = widget.local.classificationId == 1 ;
  }

  /// Filters attendance options based on capacity
  /// Only shows ranges where max value <= capacity
  /// If capacity < 3, only shows "less_3" option
  List<ComboItem> _getFilteredAttendanceOptions() {
    final capacity = widget.local.capacity;
    final allOptions = widget.fields.getComboList('men_prayer_avg_attendance') ?? [];
    
    // COMMENTED OUT: Show all options regardless of capacity
    return allOptions;
    
    // if (capacity == null || capacity <= 0) {
    //   return allOptions;
    // }

    // // Special case: if capacity < 3, only show "less_3" option
    // if (capacity < 3) {
    //   return allOptions.where((option) => option.key.toString() == 'less_3').toList();
    // }

    // // Filter options based on capacity
    // return allOptions.where((option) {
    //   final maxValue = _extractMaxValueFromKey(option.key.toString());
    //   return maxValue <= capacity;
    // }).toList();
  }
  
  /// Checks if men_prayer_avg_attendance should be required
  /// Required when capacity < 3 (must select "less_3")
  bool _isAttendanceRequired() {
    // COMMENTED OUT: Don't make required based on capacity
    return false;
    // final capacity = widget.local.capacity;
    // return capacity != null && capacity > 0 && capacity < 3;
  }

  /// Gets the minimum value from all available options
  int _getMinimumOptionValue(List<ComboItem> options) {
    if (options.isEmpty) return 0;
    
    int minValue = 999999;
    for (var option in options) {
      final key = option.key.toString();
      int value;
      
      if (key.startsWith('less_')) {
        // "less_3" -> minimum is 1 (since it's less than 3)
        value = 1;
      } else if (key.contains('_') && !key.startsWith('more_')) {
        // "3_5" or "1_25" -> extract first number (minimum of range)
        final parts = key.split('_');
        value = int.tryParse(parts[0]) ?? 999999;
      } else {
        continue; // Skip "more_1000" type options for minimum calculation
      }
      
      if (value < minValue) {
        minValue = value;
      }
    }
    
    return minValue == 999999 ? 0 : minValue;
  }

  /// Extracts the maximum value from a range key
  /// Examples: "51_75" -> 75, "less_3" -> 3, "more_1000" -> infinity
  int _extractMaxValueFromKey(String key) {
    if (key.startsWith('less_')) {
      // "less_3" -> 3
      return int.tryParse(key.replaceFirst('less_', '')) ?? 0;
    } else if (key.startsWith('more_')) {
      // "more_1000" -> very large number (infinity)
      return 999999;
    } else if (key.contains('_')) {
      // "51_75" or "1_25" -> extract second number
      final parts = key.split('_');
      if (parts.length == 2) {
        return int.tryParse(parts[1]) ?? 999999;
      }
    }
    return 999999; // Default to large number if can't parse
  }

  /// Automatically calculates capacity based on formula:
  /// capacity = row_men_praying_number * length_row_men_praying * 2
  void _calculateCapacity() {
    final rowNumber = widget.local.rowMenPrayingNumber;
    final rowLength = widget.local.lengthRowMenPraying;
    
    if (rowNumber != null && rowNumber > 0 && rowLength != null && rowLength > 0) {
      final oldCapacity = widget.local.capacity;
      final newCapacity = (rowNumber * rowLength * 2).round();
      widget.local.capacity = newCapacity;
      
      // COMMENTED OUT: Don't clear avg_attendance based on capacity restriction
      // // Clear avg_attendance if it's now out of range
      // if (oldCapacity != newCapacity && widget.local.menPrayerAvgAttendance != null) {
      //   final maxValue = _extractMaxValueFromKey(widget.local.menPrayerAvgAttendance!);
      //   if (maxValue > newCapacity) {
      //     widget.local.menPrayerAvgAttendance = null;
      //   }
      // }
      
      // Update capacity agreement field if capacity changed and in edit request mode
      if (oldCapacity != newCapacity) {
        final vm = context.read<CreateMosqueBaseViewModel>();
        if (vm.mode == FormMode.editRequest) {
          vm.updateAgreeField(_k('capacity'), true);
        }
      }
      
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final vs = ValidationScope.of(context);
    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        if (_showFridayRows)
          AppInputField(
            title: widget.fields.getField('friday_prayer_rows').label,
            value: widget.local.fridayPrayerRows,
            type: InputFieldType.number,
            isRequired: true,
            validationRegex: RegExp(r'^(?!0$)\d+$'),
            validationError: 'Value should not be zero'.tr(),
            isReadonly: !widget.editing,
            action: isEditReq                                                    // FIX
                ? AppDeclarationField(
              value: vm.getAgree(_k('friday_prayer_rows')),
              onChanged: (v) => vm.updateAgreeField(_k('friday_prayer_rows'), v),
            )
                : null,
            onChanged: widget.editing
                ? (v) {
              widget.local.fridayPrayerRows = v;
              if (isEditReq) {                                             // FIX
                vm.updateAgreeField(_k('friday_prayer_rows'), true);
              }
            }
                : null,
          ),
        if (_showFridayRows) const SizedBox(height: 10),

        AppInputField(
          title: widget.fields.getField('row_men_praying_number').label,
          value: widget.local.rowMenPrayingNumber,
          type: InputFieldType.number,
          isRequired: true,
          isReadonly: !widget.editing,
          validationRegex: RegExp(r'^(?!0$)\d+$'),
          validationError: 'Value should not be zero'.tr(),
          action: isEditReq                                                      // FIX
              ? AppDeclarationField(
            value: vm.getAgree(_k('row_men_praying_number')),
            onChanged: (v) => vm.updateAgreeField(_k('row_men_praying_number'), v),
          )
              : null,
          onChanged: widget.editing
              ? (v) {
            widget.local.rowMenPrayingNumber = v;
            _calculateCapacity(); // Auto-calculate capacity
            if (isEditReq) {                                               // FIX
              vm.updateAgreeField(_k('row_men_praying_number'), true);
            }
          }
              : null,
        ),
        const SizedBox(height: 10),

        AppInputField(
          title: widget.fields.getField('length_row_men_praying').label,
          value: widget.local.lengthRowMenPraying,
          type: InputFieldType.double,
          isRequired: true,
          validationRegex: RegExp(r'^(?!0*(?:\.0+)?$)\d+(?:\.\d+)?$'),
          validationError: 'Value should not be zero'.tr(),
          isReadonly: !widget.editing,
          action: isEditReq                                                      // FIX
              ? AppDeclarationField(
            value: vm.getAgree(_k('length_row_men_praying')),
            onChanged: (v) => vm.updateAgreeField(_k('length_row_men_praying'), v),
          )
              : null,
          onSave:(v) {
            widget.local.lengthRowMenPraying = v;
            vm.agreeField('length_row_men_praying');
            _calculateCapacity();
          },
          onChanged: (val) {
                                                             // FIX
              widget.local.lengthRowMenPraying = val;
           },
        ),
        const SizedBox(height: 10),

        AppInputField(
          title: widget.fields.getField('capacity').label,
          value: widget.local.capacity,
          type: InputFieldType.number,
          validationRegex: RegExp(r'^(?!0$)\d+$'),
          validationError: 'Value should not be zero for Capacity'.tr(),
          isRequired: true,
          isReadonly: true, // Always readonly - auto-calculated
          action: isEditReq                                                      // FIX
              ? AppDeclarationField(
            value: vm.getAgree(_k('capacity')),
            onChanged: (v) => vm.updateAgreeField(_k('capacity'), v),
          )
              : null,
          onChanged: null, // No manual changes allowed - auto-calculated
        ),
        const SizedBox(height: 10),

        // men_prayer_avg_attendance (selection - string values like '1_25', 'less_3')
        // Filtered based on capacity. Required if capacity < 3 (must select "less_3")
        Builder(
          builder: (context) {
            final filteredOptions = _getFilteredAttendanceOptions();
            final currentValue = widget.local.menPrayerAvgAttendance;
            final isRequired = _isAttendanceRequired();
            
            // COMMENTED OUT: Don't validate based on filtered options
            // // Check if current value is in filtered options
            // final isValueValid = currentValue == null || 
            //                      filteredOptions.any((opt) => opt.key.toString() == currentValue);
            
            // // Clear value if it's no longer valid for current capacity
            // final displayValue = isValueValid ? currentValue : null;
            
            // Show current value without filtering
            final displayValue = currentValue;
            
            return AppSelectionField(
              title: widget.fields.getField('men_prayer_avg_attendance').label,
              value: displayValue,
              type: SingleSelectionFieldType.selection,
              options: filteredOptions,
              isRequired: true, // Always false now (capacity restriction removed)
              action: isEditReq
                  ? AppDeclarationField(
                      value: vm.getAgree(_k('men_prayer_avg_attendance')),
                      onChanged: (v) => vm.updateAgreeField(_k('men_prayer_avg_attendance'), v),
                    )
                  : null,
              onChanged: widget.editing
                  ? (v) {
                      // Direct string assignment (values: '1_25', 'less_3', etc.)
                      widget.local.menPrayerAvgAttendance = v?.toString();
                      if (isEditReq) {
                        vm.updateAgreeField(_k('men_prayer_avg_attendance'), true);
                      }
                    }
                  : null,
            );
          },
        ),
        const SizedBox(height: 10),

        AppInputField(
          title: widget.fields.getField('toilet_men_number').label,
          value: widget.local.toiletMenNumber,
          type: InputFieldType.number,
          isRequired: true,
          isReadonly: !widget.editing,
          validationRegex: RegExp(r'^(?:[0-9]|[1-9][0-9])$'),
          validationError: 'Value must be between 0 and 99'.tr(),
          action: isEditReq                                                      // FIX
              ? AppDeclarationField(
            value: vm.getAgree(_k('toilet_men_number')),
            onChanged: (v) => vm.updateAgreeField(_k('toilet_men_number'), v),
          )
              : null,
          onChanged: widget.editing
              ? (v) {
            widget.local.toiletMenNumber = v;
            if (isEditReq) {                                               // FIX
              vm.updateAgreeField(_k('toilet_men_number'), true);
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