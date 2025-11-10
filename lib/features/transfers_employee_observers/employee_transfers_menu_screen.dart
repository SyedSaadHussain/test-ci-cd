import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/employee_transfer/screens/employee_transfers_form_screen.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/observer_rotation/screens/mosques_supervisor_management_manu_screen.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/employee_transfer_app_bar.dart';

import 'widgets/category_item.dart';
// moved to module paths

class EmployeeTransferMenuScreen extends StatelessWidget {
  const EmployeeTransferMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            EmployeeTransferAppBar(
                title: "transfer_of_employee_and_observer".tr()),
            // Grid of items
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  crossAxisCount: 2, // <-- 3 items per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    CategoryItem(
                        text: "employee_transfer".tr(),
                        icon: Icons.swap_horiz,
                        onTab: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EmployeeTransfersFormScreen(),
                                  ))
                            }),
                    CategoryItem(
                        text: "mosques_supervisor_management".tr(),
                        icon: Icons.admin_panel_settings,
                        onTab: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MosquesSupervisorManagementManuScreen(),
                                  ))
                            }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
