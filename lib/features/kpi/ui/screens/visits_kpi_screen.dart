import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/kpi/data/models/visits_draft_counts.dart';
import 'package:mosque_management_system/features/kpi/providers/regular_visits_view_model.dart';
import 'package:mosque_management_system/features/kpi/providers/visits_kpi_view_model.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/types/all_visits_type_widget.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/types/eid_visits_type_widget.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/types/jumma_visits_type_widget.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/types/land_visits_type_widget.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/types/ondemand_visits_type_widget.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/types/regular_visits_type_widget.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/visit_type_filter_bar.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:provider/provider.dart';

class VisitsKpiScreen extends StatefulWidget {
  const VisitsKpiScreen({super.key});

  @override
  State<VisitsKpiScreen> createState() => _VisitsKpiScreenState();
}

class _VisitsKpiScreenState extends State<VisitsKpiScreen> {
  VisitTypeFilter _selectedVisitType = VisitTypeFilter.all;
  int _selectedMonth = DateTime.now().month;

  void _loadRegularStatsIfNeeded() {
    if (_selectedVisitType == VisitTypeFilter.regular) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<RegularVisitsViewModel>().loadStats(_selectedMonth);
      });
    }
  }

  /// Check if user has access to KPI features (classification_id == 28)
  bool _hasKpiAccess(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return userProvider.userProfile.classificationId == 28;
  }

  @override
  Widget build(BuildContext context) {
    // Validate access at screen level
    if (!_hasKpiAccess(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppNotifier.showError(context, 'access_denied_kpi'.tr());
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          AppCustomBar(title: 'visits_indicators_dashboard'.tr()),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Consumer<VisitsKpiViewModel>(
                builder: (context, vm, _) {
                  final VisitsDraftCounts? counts = vm.counts;
                  final bool hasError = vm.hasError;
                  final bool isLoading = vm.isLoading;
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VisitTypeFilterBar(
                          selectedType: _selectedVisitType,
                          onTypeChanged: (type) {
                            setState(() {
                              _selectedVisitType = type;
                            });
                            _loadRegularStatsIfNeeded();
                          },
                          selectedMonth: _selectedMonth,
                          onMonthChanged: (month) {
                            setState(() {
                              _selectedMonth = month;
                            });
                            _loadRegularStatsIfNeeded();
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_selectedVisitType == VisitTypeFilter.all)
                          AllVisitsTypeWidget(
                            counts: counts,
                            hasError: hasError,
                            isLoading: isLoading,
                            onRetry: () => vm.refresh(),
                          ),
                        if (_selectedVisitType == VisitTypeFilter.regular)
                          Consumer<RegularVisitsViewModel>(
                            builder: (context, regularVm, _) {
                              return RegularVisitsTypeWidget(
                                stats: regularVm.stats,
                                dailyKpis: regularVm.dailyKpis,
                                selectedMonth: _selectedMonth,
                                isLoading: regularVm.isLoading,
                                hasStatsError: regularVm.hasStatsError,
                                hasDailyProgressError: regularVm.hasDailyProgressError,
                                onRetry: () =>
                                    regularVm.loadStats(_selectedMonth),
                              );
                            },
                          ),
                        if (_selectedVisitType == VisitTypeFilter.ondemand)
                          OndemandVisitsTypeWidget(counts: counts),
                        if (_selectedVisitType == VisitTypeFilter.jumma)
                          JummaVisitsTypeWidget(counts: counts),
                        if (_selectedVisitType == VisitTypeFilter.eid)
                          EidVisitsTypeWidget(counts: counts),
                        if (_selectedVisitType == VisitTypeFilter.land)
                          LandVisitsTypeWidget(counts: counts),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
