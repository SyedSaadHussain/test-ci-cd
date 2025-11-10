import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

class VisitWorkflow {
  final String title;
  final String dateTime;
  final String status;
  // final Color color;
  // final IconData icon;

  VisitWorkflow({
    required this.title,
    required this.dateTime,
    // required this.color,
    required this.status,
    // required this.icon,
  });

  /// Factory constructor to create an instance from JSON
  factory VisitWorkflow.fromJson(Map<String, dynamic> json) {
    return VisitWorkflow(
      title: JsonUtils.toText(json['state'])??"",
      status: JsonUtils.toText(json['status'])??"",
      dateTime: JsonUtils.toLocalDateTimeFormat(json['date_time'])??"",
    );
  }

  /// Computed color based on status
  Color get color {
    switch (status.toLowerCase()) {
      case 'complete':
        return AppColors.success;
      case 'in_progress':
        return AppColors.success.withOpacity(.6);
      case 'pending':
        return Colors.grey;
      default:
        return Colors.grey;; // fallback
    }
  }

  /// Computed icon based on status
  IconData get icon {
    switch (status.toLowerCase()) {
      case 'complete':
        return Icons.check;
      case 'in_progress':
        return Icons.hourglass_bottom;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.pending; // fallback
    }
  }
}