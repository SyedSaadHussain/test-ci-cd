import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/kpi/data/models/stat_item.dart';
import 'package:mosque_management_system/features/kpi/providers/mosque_indicators_view_model.dart';
import 'package:mosque_management_system/features/kpi/ui/utils/kpi_colors.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/stat_section.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:provider/provider.dart';

class MosqueIndicatorsScreen extends StatelessWidget {
  const MosqueIndicatorsScreen({Key? key}) : super(key: key);

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
          AppCustomBar(title: 'mosque_indicators_dashboard'.tr()),
          Expanded(
            child: Consumer<MosqueIndicatorsViewModel>(
              builder: (context, viewModel, child) {
                return Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 28,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMosquesSection(),
                        const SizedBox(height: 20),
                        _buildMosquesTypesSection(),
                        const SizedBox(height: 20),
                        _buildVerificationSection(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMosquesTypesSection() {
    return Consumer<MosqueIndicatorsViewModel>(
      builder: (context, viewModel, child) {
        final mosquesTypesCounts = viewModel.mosquesTypesCounts;
        final isLoading = viewModel.isLoading;

        final jamee = mosquesTypesCounts?.jamee ?? 0;
        final regular = mosquesTypesCounts?.regular ?? 0;
        final eid = mosquesTypesCounts?.eid ?? 0;

        return StatSection(
          title: 'mosque_categories'.tr(),
          icon: Icons.assignment,
          hasNoData: mosquesTypesCounts == null && !viewModel.hasMosquesTypesCountsError && !isLoading,
          hasError: viewModel.hasMosquesTypesCountsError,
          isLoading: isLoading,
          onRetry: () => viewModel.refresh(),
          items: [
            StatItem(
              label: 'jamee',
              value: jamee,
              icon: Icons.view_day,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'regular',
              value: regular,
              icon: Icons.calendar_month_rounded,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'eid',
              value: eid,
              icon: Icons.celebration,
              color: KpiColors.getColor(2),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerificationSection() {
    return Consumer<MosqueIndicatorsViewModel>(
      builder: (context, viewModel, child) {
        final verificationCounts = viewModel.verificationCounts;
        final isLoading = viewModel.isLoading;

        final mosqueVerificationRequest =
            verificationCounts?.mosqueVerificationRequest ?? 0;
        final draftVerification =
            verificationCounts?.draftVerificationMosque ?? 0;
        final supervisorStageVerification =
            verificationCounts?.supervisorStageVerificationMosque ?? 0;
        final managementStageVerification =
            verificationCounts?.managementStageVerificationMosque ?? 0;
        final doneVerification =
            verificationCounts?.doneVerificationMosques ?? 0;
        final rejectedVerification =
            verificationCounts?.rejectedVerificationMosques ?? 0;
        final unverifiedMosques = verificationCounts?.unverifiedMosques ?? 0;
        final totalAssignedMosques =
            verificationCounts?.totalAssignedMosques ?? 0;
        final verificationPercentage =
            verificationCounts?.verifiedPctDistinctMosques ?? 0.0;

        return StatSection(
          title: 'mosque_verification'.tr(),
          icon: Icons.verified_user,
          hasNoData: verificationCounts == null && !viewModel.hasVerificationCountsError && !isLoading,
          hasError: viewModel.hasVerificationCountsError,
          isLoading: isLoading,
          onRetry: () => viewModel.refresh(),
          items: [
            StatItem(
              label: 'total_assigned_mosques',
              value: totalAssignedMosques,
              icon: Icons.assignment,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'unverified_mosques',
              value: unverifiedMosques,
              icon: Icons.close,
              color: KpiColors.getColor(2),
            ),
            StatItem(
              label: 'mosque_varification_request',
              value: mosqueVerificationRequest,
              icon: Icons.assignment_turned_in,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'supervisor_stage_varification_mosque',
              value: supervisorStageVerification,
              icon: Icons.supervisor_account,
              color: KpiColors.getColor(2),
            ),
            StatItem(
              label: 'management_stage_varification_mosque',
              value: managementStageVerification,
              icon: Icons.manage_history_rounded,
              color: KpiColors.getColor(2),
            ),
            StatItem(
              label: 'draft_varification_mosque',
              value: draftVerification,
              icon: Icons.edit,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'done_varification_mosques',
              value: doneVerification,
              icon: Icons.check_circle,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'rejected_varification_mosques',
              value: rejectedVerification,
              icon: Icons.cancel,
              color: KpiColors.getColor(3),
            ),
            StatItem(
              label: 'verification_percentage',
              value: verificationPercentage.toInt(),
              icon: Icons.percent,
              color: KpiColors.getColor(2),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMosquesSection() {
    return Consumer<MosqueIndicatorsViewModel>(
      builder: (context, viewModel, child) {
        final mosqueCounts = viewModel.mosqueCounts;
        final isLoading = viewModel.isLoading;

        final allMosques = mosqueCounts?.allMosques ?? 0;
        final draftMosques = mosqueCounts?.draftMosques ?? 0;
        final inprogressMosques = mosqueCounts?.inprogressMosques ?? 0;
        final doneMosques = mosqueCounts?.doneMosques ?? 0;

        return StatSection(
          title: 'assigned_mosques'.tr(),
          icon: AppIcons.mosque,
          hasNoData: mosqueCounts == null && !viewModel.hasMosqueCountsError && !isLoading,
          hasError: viewModel.hasMosqueCountsError,
          isLoading: isLoading,
          onRetry: () => viewModel.refresh(),
          items: [
            StatItem(
              label: 'all_mosques',
              value: allMosques,
              icon: Icons.dashboard,
              color: KpiColors.getColor(0),
            ),
            StatItem(
              label: 'draft_mosques',
              value: draftMosques,
              icon: Icons.edit_document,
              color: KpiColors.getColor(1),
            ),
            StatItem(
              label: 'inprogress_mosques',
              value: inprogressMosques,
              icon: Icons.sync,
              color: KpiColors.getColor(2),
            ),
            StatItem(
              label: 'done_mosques',
              value: doneMosques,
              icon: Icons.check_circle,
              color: KpiColors.getColor(2),
            ),
          ],
        );
      },
    );
  }
}
