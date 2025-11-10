import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/kpi/providers/kpi_provider_wrapper.dart';
import 'package:mosque_management_system/features/kpi/ui/screens/employees_kpi_screen.dart';
import 'package:mosque_management_system/features/kpi/ui/screens/mosque_indicators_screen.dart';
import 'package:mosque_management_system/features/kpi/ui/screens/visits_kpi_screen.dart';
import 'package:mosque_management_system/features/kpi/ui/widgets/kpi_item.dart';
import 'package:provider/provider.dart';

class KpiMenuScreen extends StatelessWidget {
  const KpiMenuScreen({super.key});

  /// Check if user has access to KPI features (classification_id == 28)
  bool _hasKpiAccess(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return userProvider.userProfile.classificationId == 28;
  }

  /// Show access denied message and optionally navigate back
  void _handleAccessDenied(BuildContext context) {
    AppNotifier.showError(
      context,
      'access_denied_kpi'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('kpi'.tr()),
        backgroundColor: AppColors.appBar,
        elevation: 0,
        foregroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  KpiItem(
                    title: 'mosque_indicators_dashboard'.tr(),
                    icon: AppIcons.mosque,
                    onTap: () {
                      if (!_hasKpiAccess(context)) {
                        _handleAccessDenied(context);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KpiProviderWrapper(
                            child: MosqueIndicatorsScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  KpiItem(
                    title: 'visits_indicators_dashboard'.tr(),
                    icon: Icons.bar_chart,
                    onTap: () {
                      if (!_hasKpiAccess(context)) {
                        _handleAccessDenied(context);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KpiProviderWrapper(
                            child: const VisitsKpiScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  KpiItem(
                    title: 'employees_indicators_dashboard'.tr(),
                    icon: Icons.people_alt,
                    onTap: () {
                      if (!_hasKpiAccess(context)) {
                        _handleAccessDenied(context);
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmployeesKpiScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
