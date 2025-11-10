import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/cards/app_card.dart';

class SentCardWidget extends StatelessWidget {
  final String title;
  final String requestNumber;
  final String creationDate;
  final VoidCallback? onViewDetails;
  final String status; // "تحت الاجراء", "مقبول", "مرفوض"

  const SentCardWidget({
    super.key,
    required this.title,
    required this.requestNumber,
    required this.creationDate,
    this.onViewDetails,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Content with Status Indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Right Side - Card Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      _buildInfoRow("type_of_request".tr(), title),
                      const SizedBox(height: 8),

                      // رقم الطلب
                      _buildInfoRow("request_number".tr(), requestNumber),
                      const SizedBox(height: 8),

                      // تاريخ الانشاء
                      _buildInfoRow("creation_date".tr(), creationDate),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Left Side - Status Indicator
                _buildStatusIndicator(),
              ],
            ),
          ),

          // Divider
          const Divider(height: 1, thickness: 1),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "show_details".tr(),
                  style: AppTextStyles.formLabel.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case "مقبول":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "مرفوض":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case "تحت الاجراء":
      default:
        statusColor = const Color(0xFF8B4513); // Brown color
        statusIcon = Icons.hourglass_empty;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: AppTextStyles.formLabel.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          value,
          style: AppTextStyles.formLabel,
        ),
      ],
    );
  }
}
