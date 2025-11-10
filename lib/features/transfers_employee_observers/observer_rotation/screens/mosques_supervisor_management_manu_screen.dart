import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/observer_rotation/screens/remove_associated_mosque_screen.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/category_item.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/widgets/employee_transfer_app_bar.dart';

import 'associated_mosque_screen.dart';
import 'observers_rotation_screen.dart';

class MosquesSupervisorManagementManuScreen extends StatelessWidget {
  const MosquesSupervisorManagementManuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Header
            EmployeeTransferAppBar(title: "mosques_supervisor_management".tr()),
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
                        text: "observers_rotation".tr(),
                        icon: Icons.swap_horiz,
                        onTab: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ObserversRotationScreen(),
                                  ))
                            }),
                    CategoryItem(
                        text: "remove_associated_mosque".tr(),
                        icon: Icons.remove_circle_outline,
                        onTab: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RemoveAssociatedMosqueScreen(),
                                  ))
                            }),
                    CategoryItem(
                        text: "associated_mosque".tr(),
                        icon: Icons.add_circle_outline,
                        onTab: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AssociatedMosqueScreen(),
                                  ))
                            })
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
