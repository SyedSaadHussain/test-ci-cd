import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:provider/provider.dart';

class EmployeesKpiScreen extends StatelessWidget {
  const EmployeesKpiScreen({super.key});

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
          AppCustomBar(title: 'employees_indicators_dashboard'.tr()),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: Text('coming_soon'.tr()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
