import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/kpi/data/models/visits_draft_counts.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/daily_kpi_horizontal_cards.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/stat_section.dart';

class LandVisitsTypeWidget extends StatelessWidget {
  final VisitsDraftCounts? counts;

  const LandVisitsTypeWidget({
    super.key,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visit Analytics Section
        StatSection(
          title: 'visit_analytics'.tr(),
          icon: Icons.data_usage,
          hasNoData: true,
          items: [],
        ),
        const SizedBox(height: 16),
        // Daily KPI Section - Horizontal Cards
        const DailyKpiHorizontalCards(
          dailyKpis: [],
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
