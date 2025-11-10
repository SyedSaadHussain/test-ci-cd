import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../data/models/mosque_meter_summary.dart';

class FilterDropdownWidget extends StatelessWidget {
  final String label;
  final FilterOption? selectedValue;
  final List<FilterOption> items;
  final ValueChanged<FilterOption?>? onChanged;
  final bool isEnabled;
  final bool isLoading;
  final bool isFixed;

  const FilterDropdownWidget({
    super.key,
    required this.label,
    this.selectedValue,
    required this.items,
    this.onChanged,
    this.isEnabled = true,
    this.isLoading = false,
    this.isFixed = false,
  });

  @override
  Widget build(BuildContext context) {
    final validSelectedValue = items.contains(selectedValue) ? selectedValue : null;
    final isDisabled = items.isEmpty || !isEnabled;
    
    // Build label with fixed indicator
    String displayLabel = label;
    if (isFixed && selectedValue != null) {
      displayLabel = '${selectedValue!.name} (${'fixed'.tr()})';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDisabled 
            ? Colors.grey.withOpacity(0.1)
            : AppColors.primaryContainer.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDisabled 
              ? Colors.grey.withOpacity(0.3)
              : AppColors.primaryContainer.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: isLoading 
          ? Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'loading'.tr(),
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<FilterOption>(
                value: validSelectedValue,
                hint: Text(
                  displayLabel,
                  style: TextStyle(
                    color: isDisabled ? Colors.grey : AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: isDisabled ? Colors.grey : AppColors.textPrimary,
                ),
                dropdownColor: Colors.white,
                isExpanded: true,
                menuMaxHeight: 300,
                items: items.map((FilterOption option) {
                  return DropdownMenuItem<FilterOption>(
                    value: option,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        option.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: isDisabled ? null : onChanged,
              ),
            ),
    );
  }
}