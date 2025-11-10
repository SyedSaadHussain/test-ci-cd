import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/observer_rotation/screens/sent_details_screen.dart';

import 'custom_timeline_widget.dart';
import 'request_type.dart';
import 'sent_card_widget.dart';

class SentTab extends StatelessWidget {
  final RequestType requestType; // enum for type
  final bool isEmployeeTransferScreen;
  const SentTab(
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
                  child: SentCardWidget(
                    title: _getTitleForScreenType(),
                    requestNumber: "000${index + 1}",
                    creationDate: _formatDate(
                        DateTime.now().subtract(Duration(days: index))),
                    status: _getSampleStatus(index),
                    onViewDetails: () {
                      _navigateToDetails(context, index + 1);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

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

  // Helper method to get sample status based on index
  String _getSampleStatus(int index) {
    switch (index) {
      case 0:
        return "مقبول";
      case 1:
        return "مرفوض";
      case 2:
        return "تحت الاجراء";
      default:
        return "تحت الاجراء";
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
        builder: (context) => SentDetailsScreen(
          title: _getTitleForScreenType(),
          requestNumber: "000$rotationId",
          creationDate: _formatDate(
              DateTime.now().subtract(Duration(days: rotationId - 1))),
          employeeName: "أحمد محمد",
          currentMosque: "مسجد النور",
          newMosque: "مسجد الفجر",
          status: _getSampleStatus(rotationId - 1),
          timelineSteps: _getSampleTimelineSteps(rotationId),
          isEmployeeTransferScreen: isEmployeeTransferScreen,
          newRole: "امام",
        ),
      ),
    );
  }

  // Sample timeline data - replace with backend data
  List<TimelineStep> _getSampleTimelineSteps(int rotationId) {
    final now = DateTime.now();
    return [
      TimelineStep(
        title: "تم إنشاء الطلب",
        date: _formatDate(now.subtract(Duration(days: rotationId + 3))),
        isCompleted: true,
        icon: Icons.check,
      ),
      TimelineStep(
        title: "تم إرسال الطلب",
        date: _formatDate(now.subtract(Duration(days: rotationId + 2))),
        isCompleted: true,
        icon: Icons.send,
      ),
      TimelineStep(
        title: "قيد المراجعة",
        date: _formatDate(now.subtract(Duration(days: rotationId + 1))),
        isCompleted: true,
        icon: Icons.hourglass_empty,
      ),
      TimelineStep(
        title: "تم الموافقة",
        date: _formatDate(now.subtract(Duration(days: rotationId))),
        isCompleted: true,
        icon: Icons.approval,
      ),
      TimelineStep(
        title: "تم التنفيذ",
        date: "لم يكتمل بعد",
        isCompleted: false,
        icon: Icons.pending,
      ),
    ];
  }
}
