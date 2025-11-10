import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/invoice_view_model.dart';
import 'invoice_info_card_widget.dart';

class InvoiceSectionWidget extends StatelessWidget {
  final int meterId;

  const InvoiceSectionWidget({super.key, required this.meterId});

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading && vm.thisMonth == null && vm.lastMonth == null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'invoice_information'.tr(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              InvoiceInfoCardWidget(
                title: 'current_month_invoice'.tr(),
                amount: vm.thisMonthAmountFormatted,
                subtitle: vm.thisMonthSubtitle,
                status: 'info'.tr(),
                statusColor: Colors.green,
              ),
              const SizedBox(height: 12),
              InvoiceInfoCardWidget(
                title: 'last_month_invoice'.tr(),
                amount: vm.lastMonthAmountFormatted,
                subtitle: vm.lastMonthSubtitle,
                status: 'info'.tr(),
                statusColor: Colors.green,
              ),
              const SizedBox(height: 12),
              InvoiceInfoCardWidget(
                title: 'average_change_ratio'.tr(),
                amount: vm.averageChangeRatioFormatted,
                subtitle: 'monthly_average_change'.tr(),
                status: 'info'.tr(),
                statusColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }
}
