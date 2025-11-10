import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

enum VisitTypeFilter {
  all,
  regular,
  ondemand,
  jumma,
  eid,
  land,
}

class VisitTypeFilterBar extends StatelessWidget {
  final VisitTypeFilter selectedType;
  final ValueChanged<VisitTypeFilter> onTypeChanged;
  final int selectedMonth;
  final ValueChanged<int> onMonthChanged;

  const VisitTypeFilterBar({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  String _getLabel(VisitTypeFilter type) {
    switch (type) {
      case VisitTypeFilter.all:
        return 'visit_type_all'.tr();
      case VisitTypeFilter.regular:
        return 'visit_type_regular'.tr();
      case VisitTypeFilter.ondemand:
        return 'visit_type_ondemand'.tr();
      case VisitTypeFilter.jumma:
        return 'visit_type_jumma'.tr();
      case VisitTypeFilter.eid:
        return 'visit_type_eid'.tr();
      case VisitTypeFilter.land:
        return 'visit_type_land'.tr();
    }
  }

  String _getMonthName(int month) {
    final months = [
      'month_january'.tr(),
      'month_february'.tr(),
      'month_march'.tr(),
      'month_april'.tr(),
      'month_may'.tr(),
      'month_june'.tr(),
      'month_july'.tr(),
      'month_august'.tr(),
      'month_september'.tr(),
      'month_october'.tr(),
      'month_november'.tr(),
      'month_december'.tr(),
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_note,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${'filter_year'.tr()}: $currentYear',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Month and Type dropdowns
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButton<VisitTypeFilter>(
                  value: selectedType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down,
                      color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  items: VisitTypeFilter.values.map((type) {
                    return DropdownMenuItem<VisitTypeFilter>(
                      value: type,
                      child: Text(_getLabel(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onTypeChanged(value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButton<int>(
                  value: selectedMonth,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down,
                      color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  items: List.generate(currentMonth, (index) {
                    final month = index + 1;
                    return DropdownMenuItem<int>(
                      value: month,
                      child: Text(_getMonthName(month)),
                    );
                  }),
                  onChanged: (value) {
                    if (value != null) {
                      onMonthChanged(value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
