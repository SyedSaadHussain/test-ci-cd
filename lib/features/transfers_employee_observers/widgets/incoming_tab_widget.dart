import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../observer_rotation/screens/incoming_details_screen.dart';
import 'custom_timeline_widget.dart';
import 'incoming_card_widget.dart';
import 'request_type.dart';

class IncomingTab extends StatelessWidget {
  final RequestType requestType;
  final bool isEmployeeTransferScreen;
  const IncomingTab(
      {super.key,
      this.requestType = RequestType.observersRotation,
      this.isEmployeeTransferScreen = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Sample data
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: IncomingCardWidget(
                    title: _getTitleForScreenType(),
                    requestNumber: "000${index + 1}",
                    creationDate: _formatDate(
                        DateTime.now().subtract(Duration(days: index))),
                    onViewDetails: () {
                      _navigateToDetails(context, index + 1);
                    },
                    status: _getSampleStatus(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get title based on screen type
  String _getTitleForScreenType() {
    switch (requestType) {
      case RequestType.associatedMosque:
        return "إسناد مسجد";
      case RequestType.removeAssociatedMosque:
        return "ازالة إسناد مسجد";
      case RequestType.employeeTransfer:
        return "تدوير مساجد المراقب";
      case RequestType.observersRotation:
      default:
        return "تدوير مساجد المراقب";
    }
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  // Helper method to navigate to details screen
  void _navigateToDetails(BuildContext context, int rotationId) {
    // Use the original screen for other modules
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingDetailsScreen(
          title: _getTitleForScreenType(),
          requestNumber: "000$rotationId",
          creationDate: _formatDate(
              DateTime.now().subtract(Duration(days: rotationId - 1))),
          employeeName: "أحمد محمد",
          currentMosque: "مسجد النور",
          newMosque: "مسجد الفجر",
          status: "قيد المراجعة",
          timelineSteps: _getSampleTimelineSteps(rotationId),
          isEmployeeTransferScreen: isEmployeeTransferScreen,
          newRole: "امام",
        ),
      ),
    );
  }

  // Helper method to get sample status
  String _getSampleStatus(int index) {
    switch (index) {
      case 0:
        return "مقبول";
      case 1:
        return "مرفوض";
      default:
        return "مقبول"; // Default to مقبول instead of تحت الاجراء
    }
  }

  // Sample timeline data - replace with backend data
  List<TimelineStep> _getSampleTimelineSteps(int rotationId) {
    final now = DateTime.now();
    return [
      TimelineStep(
        title: "request_created".tr(),
        date: _formatDate(now.subtract(Duration(days: rotationId + 2))),
        isCompleted: true,
        icon: Icons.check,
      ),
      TimelineStep(
        title: "under_review".tr(),
        date: _formatDate(now.subtract(Duration(days: rotationId + 1))),
        isCompleted: true,
        icon: Icons.hourglass_empty,
      ),
      TimelineStep(
        title: "request_approved".tr(),
        date: _formatDate(now.subtract(Duration(days: rotationId))),
        isCompleted: true,
        icon: Icons.approval,
      ),
      TimelineStep(
        title: "request_implemented".tr(),
        date: "not_completed_yet".tr(),
        isCompleted: false,
        icon: Icons.pending,
      ),
    ];
  }
}
