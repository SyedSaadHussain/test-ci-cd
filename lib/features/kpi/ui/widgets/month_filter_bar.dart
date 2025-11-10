import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class MonthFilterBar extends StatelessWidget {
  final int selectedMonth; // 1-12
  final ValueChanged<int> onMonthChanged;

  const MonthFilterBar({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final months = _buildMonths();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(
            'by_month'.tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: selectedMonth,
                items: months
                    .map(
                      (e) => DropdownMenuItem<int>(
                        value: e.$1,
                        child: Text(e.$2),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) onMonthChanged(val);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              DateTime.now().year.toString(),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<(int, String)> _buildMonths() {
    return [
      (1, 'jan'.tr()),
      (2, 'feb'.tr()),
      (3, 'mar'.tr()),
      (4, 'apr'.tr()),
      (5, 'may'.tr()),
      (6, 'jun'.tr()),
      (7, 'jul'.tr()),
      (8, 'aug'.tr()),
      (9, 'sep'.tr()),
      (10, 'oct'.tr()),
      (11, 'nov'.tr()),
      (12, 'dec'.tr()),
    ];
  }
}
