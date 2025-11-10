import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class NoDataFound extends StatelessWidget {
  String? label;
   NoDataFound({super.key,this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Background Circle
                // Tilted shadow card in the back
                Transform.translate(
                  offset: const Offset(0, 0),
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      width: 70,
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: const BoxDecoration(
                        color: Color(0xFFefeeee),
                      ),
                    ),
                  ),
                ),
                // Main card
                Container(
                  width: 70,
                  height: 100,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                  ),
                ),
                // Icon
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.manage_search,
                    color: AppColors.gray.withOpacity(0.4),
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              label??'no_record_found'.tr(),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}