import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

class MosqueWorkflow {
  final String title;
  final String dateTime;
  final String status;

  MosqueWorkflow({
    required this.title,
    required this.dateTime,
    required this.status,
  });

  /// Factory constructor to create an instance from JSON
  factory MosqueWorkflow.fromJson(Map<String, dynamic> json) {
    final state = JsonUtils.toText(json['state']) ?? "";
    
    // If state is "Draft", show translated string
    final title = (state == "Draft") 
        ? "draft_state_timeline".tr()
        : state;
    
    return MosqueWorkflow(
      title: title.isNotEmpty ? title : "",
      status: JsonUtils.toText(json['status']) ?? "",
      dateTime: JsonUtils.toLocalDateTimeFormat(json['date_time']) ?? "",
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
        return Colors.grey; // fallback
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

