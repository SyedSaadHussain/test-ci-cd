import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/cards/app_card.dart';

import '../../widgets/custom_timeline_widget.dart';

class SentDetailsScreen extends StatelessWidget {
  final String title;
  final String requestNumber;
  final String creationDate;
  final String? employeeName;
  final String? currentMosque;
  final String? newMosque;
  final String? status;
  final List<TimelineStep>? timelineSteps;
  final String? newRole;
  final bool isEmployeeTransferScreen;

  const SentDetailsScreen(
      {super.key,
      required this.title,
      required this.requestNumber,
      required this.creationDate,
      this.employeeName,
      this.currentMosque,
      this.newMosque,
      this.status,
      this.timelineSteps,
      this.newRole,
      this.isEmployeeTransferScreen = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        automaticallyImplyLeading: false,
        title: Text(
          "request_details".tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "request_details".tr(),
                      style: AppTextStyles.headingLG,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow("type_of_request".tr(), title),
                    const SizedBox(height: 8),
                    _buildDetailRow("request_number".tr(), requestNumber),
                    const SizedBox(height: 8),
                    _buildDetailRow("creation_date".tr(), creationDate),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        "request_status".tr(), status ?? "under_review".tr()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Employee Information Card
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "employee_info".tr(),
                      style: AppTextStyles.headingLG,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow("employee_name".tr(),
                        employeeName ?? "not_specified".tr()),
                    const SizedBox(height: 8),
                    _buildDetailRow("current_mosque".tr(),
                        currentMosque ?? "not_specified".tr()),
                    const SizedBox(height: 8),
                    _buildDetailRow("الرقم التسلسلي", "UDSD7987987987"),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        "new_mosque".tr(), newMosque ?? "not_specified".tr()),
                    const SizedBox(height: 8),
                    _buildDetailRow("الرقم التسلسلي", "USA32432"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Timeline Card
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "request_status".tr(),
                      style: AppTextStyles.headingLG,
                    ),
                    const SizedBox(height: 16),
                    CustomTimelineWidget(
                      steps: _getDefaultTimelineSteps(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: AppTextStyles.formLabel.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.formLabel,
          ),
        ),
      ],
    );
  }

  List<TimelineStep> _getDefaultTimelineSteps() {
    final now = DateTime.now();
    return [
      TimelineStep(
        title: "request_created".tr(),
        date:
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}",
        isCompleted: true,
        icon: Icons.check,
      ),
      TimelineStep(
        title: "request_approved_mmc04".tr(),
        date:
            "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}",
        isCompleted: true,
        icon: Icons.check,
      ),
      TimelineStep(
        title: "under_review".tr(),
        date:
            "${(now.day + 1).toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}",
        isCompleted: true,
        icon: Icons.hourglass_empty,
      ),
      TimelineStep(
        title: "completed".tr(),
        date: "not_completed_yet".tr(),
        isCompleted: false,
        icon: Icons.pending,
      ),
    ];
  }
}
