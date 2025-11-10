import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

import 'electricity_consumption/ui/screens/electricity_filter_screen.dart';
import 'water_consumption/ui/screens/water_filter_screen.dart';
import 'widgeds/utilities_item.dart';

class MosqueUtilitiesMenuScreen extends StatelessWidget {
  const MosqueUtilitiesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('mosque_utilities'.tr()),
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
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  UtilitiesItem(
                    title: 'electricity'.tr(),
                    icon: Icons.electrical_services,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ElectricityFiltersScreen(),
                        ),
                      );
                    },
                  ),
                  UtilitiesItem(
                    title: 'water'.tr(),
                    icon: Icons.water_drop,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WaterFiltersScreen(),
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
