import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/kpi/data/models/regular_visit_stats.dart';
import 'package:mosque_management_system/features/kpi/ui/utils/kpi_colors.dart';

class DailyKpiHorizontalCards extends StatelessWidget {
  final List<DailyKpi> dailyKpis;
  final int? selectedMonth;
  final double cardHeight;
  final double cardWidth;
  final bool hasError;

  const DailyKpiHorizontalCards({
    super.key,
    required this.dailyKpis,
    this.selectedMonth,
    this.cardHeight = 320,
    this.cardWidth = 200,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return _buildErrorState();
    }

    if (dailyKpis.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(),
        const SizedBox(height: 12),
        _buildHorizontalCardsList(),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.today, color: AppColors.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            'daily_kpi'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCardsList() {
    return SizedBox(
      height: cardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: dailyKpis.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildDayCard(dailyKpis[index]);
        },
      ),
    );
  }

  Widget _buildDayCard(DailyKpi dailyKpi) {
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayHeader(dailyKpi),
          _buildDayStats(dailyKpi),
        ],
      ),
    );
  }

  Widget _buildDayHeader(DailyKpi dailyKpi) {
    final monthName = _getMonthName();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '${dailyKpi.dayNumber} $monthName',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName() {
    final monthNames = [
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

    if (selectedMonth != null && selectedMonth! >= 1 && selectedMonth! <= 12) {
      return monthNames[selectedMonth! - 1];
    }

    if (dailyKpis.isNotEmpty) {
      try {
        final date = DateTime.parse(dailyKpis.first.workday);
        return monthNames[date.month - 1];
      } catch (e) {
        return '';
      }
    }

    return '';
  }

  Widget _buildDayStats(DailyKpi dailyKpi) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Daily Metrics
            _buildStatRow(
              Icons.timelapse,
              'day_inprogress'.tr(),
              dailyKpi.dayInprogress,
              KpiColors.getColor(1),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.check_circle,
              'day_done'.tr(),
              dailyKpi.dayDone,
              KpiColors.getColor(2),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.exposure,
              'day_total'.tr(),
              dailyKpi.dayTotal,
              KpiColors.getColor(0),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.gps_fixed,
              'daily_target'.tr(),
              dailyKpi.dailyTarget,
              KpiColors.getColor(2),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.percent,
              'daily_progress_pct'.tr(),
              dailyKpi.dailyProgressPct.round(),
              KpiColors.getColor(0),
            ),
            const Divider(height: 16, thickness: 1),
            // Cumulative Metrics
            _buildStatRow(
              Icons.directions_run,
              'cum_actual'.tr(),
              dailyKpi.cumActual,
              KpiColors.getColor(1),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.trending_up,
              'cum_expected'.tr(),
              dailyKpi.cumExpected,
              KpiColors.getColor(2),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.pie_chart,
              'mtd_progress_pct'.tr(),
              dailyKpi.mtdProgressPct.round(),
              KpiColors.getColor(1),
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              Icons.compare_arrows,
              'variance_vs_plan'.tr(),
              dailyKpi.varianceVsPlan,
              KpiColors.getColor(3),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single stat row with icon, label, and value
  Widget _buildStatRow(IconData icon, String label, num value, Color color) {
    final displayValue = value is int 
        ? value.toString() 
        : (value as double).toStringAsFixed(2);
    
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          displayValue,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Builds an error state when there's an error loading data
  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.today, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'daily_kpi'.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'error_loading_data'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an empty state when no daily data is available
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'no_daily_data'.tr(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
