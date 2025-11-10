import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class DeclarationsSection extends StatelessWidget {
  const DeclarationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;

        // Use mergeJson pattern - get declarations data directly from model
        final declarationsList = m.declarationsArray ?? [];

        // Check if we have any data to display
        if (declarationsList.isEmpty) {
          return _buildEmptyState();
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: declarationsList.map<Widget>((declaration) {
            return _buildDeclarationCard(declaration);
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد إقرارات متاحة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم عرض الإقرارات هنا عند توفرها',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeclarationCard(dynamic declaration) {
    final state = declaration['state']?.toString() ?? '';
    final approverName = declaration['approver_id']?['name']?.toString() ?? 'غير محدد';
    final dateTime = declaration['date_time']?.toString() ?? '';
    final acceptTerms = declaration['accept_terms']?.toString() ?? '';
    final isAccepted = declaration['accept'] == true;
    final recordName = declaration['record_name']?.toString() ?? '';
    // Ensure we get the national ID properly, handle null/empty cases
    final nationalId = (declaration['national_id']?.toString() ?? '').trim();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusChip(state),
                if (isAccepted)
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Approver information
            AppInputView(
              title: 'المُعتمد',
              value: approverName,
            ),

            // Date and time
            if (dateTime.isNotEmpty)
              AppInputView(
                title: 'تاريخ الإقرار',
                value: _formatDateTime(dateTime),
              ),

            // Record name if meaningful
            if (recordName.isNotEmpty && !recordName.startsWith('mosque.mosque('))
              AppInputView(
                title: 'الرقم التسلسلي للمسجد',
                value: recordName,
              ),

            // National ID - always show, indicate if not available
            AppInputView(
              title: 'الهوية الوطنية',
              value: nationalId.isNotEmpty ? nationalId : 'غير متوفر',
            ),

            // Declaration text
            if (acceptTerms.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نص الإقرار',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      acceptTerms,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String state) {
    final color = _getStateColor(state);
    final text = _getStateText(state);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStateIcon(state),
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'draft':
        return Colors.orange;
      case 'supervisor':
        return Colors.blue;
      case 'checker':
        return Colors.green;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStateText(String state) {

    switch (state.toLowerCase()) {
      case 'draft':
        return 'تعهد المراقب';
      case 'in_progress':
        return 'تعهد المشرف';
      case 'checker':
        return 'تعهد المدقق';
      case 'approved':
        return 'معتمد';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'تعهد $state';
    }
  }

  IconData _getStateIcon(String state) {
    switch (state.toLowerCase()) {
      case 'draft':
        return Icons.edit_outlined;
      case 'supervisor':
        return Icons.supervisor_account_outlined;
      case 'checker':
        return Icons.verified_outlined;
      case 'approved':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _formatDateTime(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      return '${parsedDate.year}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.day.toString().padLeft(2, '0')} - ${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }

}
