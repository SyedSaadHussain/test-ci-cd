import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class ContractsSection extends StatelessWidget {
  const ContractsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {



        final m = vm.mosqueObj;

        //Use mergeJson pattern - get contracts data directly from model
        final contractsList = m.maintenanceContractsArray ?? [];

        // Check if we have any data to display
        if (contractsList.isEmpty) {
          return _buildEmptyState();
        }
        //
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: contractsList.map<Widget>((contract) {
            return _buildContractCard(contract);
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
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد عقود صيانة متاحة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'سيتم عرض عقود الصيانة هنا عند توفرها',
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

  Widget _buildContractCard(dynamic contract) {
    final contractorName = contract['company_contractor_id']?['name']?.toString() ?? 'غير محدد';
    final contractState = contract['contract_state']?.toString() ?? '';
    final purchaseOrderNo = contract['purchase_order_no']?.toString() ?? '';
    final memberId = contract['member_id']?.toString() ?? '';
    final mobile = contract['mobile']?.toString() ?? '';

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
            // Header with contract state
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStateChip(contractState),
              ],
            ),
            const SizedBox(height: 12),

            // Contractor information - main focus
            AppInputView(
              title: 'المقاول',
              value: contractorName,
            ),

            // Purchase Order Number
            if (purchaseOrderNo.isNotEmpty)
              AppInputView(
                title: 'رقم أمر الشراء',
                value: purchaseOrderNo,
              ),

            // Member ID
            if (memberId.isNotEmpty)
              AppInputView(
                title: 'اسم المندوب',
                value: memberId,
              ),

            // Mobile
            if (mobile.isNotEmpty)
              AppInputView(
                title: 'رقم الجوال',
                value: mobile,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateChip(String state) {
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
      case 'valid':
        return Colors.green;
      case 'expired':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getStateText(String state) {
    switch (state.toLowerCase()) {
      case 'valid':
        return 'ساري';
      case 'expired':
        return 'منتهي';
      case 'pending':
        return 'معلق';
      case 'cancelled':
        return 'ملغي';
      default:
        return state;
    }
  }

  IconData _getStateIcon(String state) {
    switch (state.toLowerCase()) {
      case 'valid':
        return Icons.check_circle_outline;
      case 'expired':
        return Icons.cancel_outlined;
      case 'pending':
        return Icons.schedule_outlined;
      case 'cancelled':
        return Icons.block_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
//