import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/kpi/data/models/regular_visit_stats.dart';
import 'package:mosque_management_system/features/kpi/data/models/stat_item.dart';
import 'package:mosque_management_system/features/kpi/ui/utils/kpi_colors.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/daily_kpi_horizontal_cards.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/stat_section.dart';

class RegularVisitsTypeWidget extends StatelessWidget {
  final RegularVisitStats? stats;
  final List<DailyKpi> dailyKpis;
  final int selectedMonth;
  final bool isLoading;
  final bool hasStatsError;
  final bool hasDailyProgressError;
  final VoidCallback onRetry;

  const RegularVisitsTypeWidget({
    super.key,
    required this.stats,
    required this.dailyKpis,
    required this.selectedMonth,
    required this.isLoading,
    required this.hasStatsError,
    required this.hasDailyProgressError,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatSection(
          title: 'visit_analytics'.tr(),
          icon: Icons.data_usage,
          hasNoData: stats == null && !hasStatsError && !isLoading,
          hasError: hasStatsError,
          isLoading: isLoading,
          items: [
            StatItem(
              label: 'total_drafts',
              value: stats?.totalDraftVisit ?? 0,
              icon: Icons.assignment,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'total_low_visit',
              value: stats?.totalLowDraftVisit ?? 0,
              icon: Icons.low_priority,
              color: KpiColors.getColor(3),
            ),
            StatItem(
              label: 'total_medium_visit',
              value: stats?.totalMediumDraftVisit ?? 0,
              icon: Icons.fiber_manual_record,
              color: KpiColors.getColor(5),
            ),
            StatItem(
              label: 'total_high_visit',
              value: stats?.totalHighDraftVisit ?? 0,
              icon: Icons.priority_high,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'this_month_inprogress_visit',
              value: stats?.thisMonthInprogressVisit ?? 0,
              icon: Icons.autorenew,
              color: KpiColors.getColor(4),
            ),
            StatItem(
              label: 'this_month_approved_visit',
              value: stats?.thisMonthDoneVisit ?? 0,
              icon: Icons.done_all,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'this_month_total_performed',
              value: stats?.thisMonthTotalPerformed ?? 0,
              icon: Icons.fact_check,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'this_month_progress_pct',
              value: stats?.thisMonthProgressPct.round() ?? 0,
              icon: Icons.percent,
              color: KpiColors.getColor(2),
            ),
     
          ],
        ),
        const SizedBox(height: 16),
        // Daily KPI Section - Horizontal Cards
        _buildDailyKpiSection(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDailyKpiSection() {
    return DailyKpiHorizontalCards(
      dailyKpis: dailyKpis,
      selectedMonth: selectedMonth,
      hasError: hasDailyProgressError,
    );
  }
}
