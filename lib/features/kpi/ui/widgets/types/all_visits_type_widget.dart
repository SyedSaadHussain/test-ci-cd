import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/kpi/data/models/stat_item.dart';
import 'package:mosque_management_system/features/kpi/data/models/visits_draft_counts.dart';
import 'package:mosque_management_system/features/kpi/ui/utils/kpi_colors.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/stat_section.dart';

class AllVisitsTypeWidget extends StatelessWidget {
  final VisitsDraftCounts? counts;
  final bool hasError;
  final bool isLoading;
  final VoidCallback? onRetry;

  const AllVisitsTypeWidget({
    super.key,
    required this.counts,
    this.hasError = false,
    this.isLoading = false,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visit Summary Section - Only shown in All type
        StatSection(
          title: 'visit_summary'.tr(),
          icon: Icons.summarize,
          hasNoData: counts == null && !hasError && !isLoading,
          hasError: hasError,
          isLoading: isLoading,
          onRetry: onRetry,
          items: [
            StatItem(
              label: 'total_regular_visit',
              value: counts?.totalDraftRegularVisit ?? 0,
              icon: Icons.calendar_month_rounded,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'total_ondemand_visit',
              value: counts?.totalDraftOndemandVisit ?? 0,
              icon: Icons.flash_on,
              color: KpiColors.getColor(2),
            ),
            StatItem(
              label: 'total_jumma_visit',
              value: counts?.totalDraftJummaVisit ?? 0,
              icon: Icons.event,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'total_eid_visit',
              value: counts?.totalDraftEidVisit ?? 0,
              icon: Icons.celebration,
              color: KpiColors.getColor(2),
            ),
            StatItem(
              label: 'total_land_visit',
              value: counts?.totalLandVisit ?? 0,
              icon: Icons.landscape,
              color: KpiColors.getColor(4),
            ),
            StatItem(
              label: 'total_visits_all',
              value: counts?.totalDraftVisitsAll ?? 0,
              icon: Icons.assignment,
              color: KpiColors.getColor(0),
            ),
          ],
        ),
      ],
    );
  }
}
