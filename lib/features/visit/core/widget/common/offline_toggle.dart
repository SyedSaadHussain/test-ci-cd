import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';

Widget offlineToggle({
  required bool isOfflineView,
  required ValueChanged<bool> onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
       Text(
        VisitMessages.downloadOnly,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(width: 8),
      Transform.scale(
        scale: 0.7,
        child: Switch(
          inactiveThumbColor: AppColors.gray.withOpacity(.5),
          inactiveTrackColor: AppColors.gray.withOpacity(.3),
          value: isOfflineView,
          onChanged: onChanged,
        ),
      ),
    ],
  );
}