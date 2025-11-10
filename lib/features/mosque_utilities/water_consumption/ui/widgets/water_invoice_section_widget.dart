import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../electricity_consumption/ui/widgets/invoice_info_card_widget.dart';
import '../../providers/water_consumption_view_model.dart';
import '../../providers/water_invoice_view_model.dart';

class WaterInvoiceSectionWidget extends StatelessWidget {
  final int meterId;
  const WaterInvoiceSectionWidget({super.key, required this.meterId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WaterInvoiceViewModel, WaterConsumptionViewModel>(
      builder: (context, invoiceVm, consumptionVm, _) {
        if (invoiceVm.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
                amount: consumptionVm.thisMonthValue,
                subtitle: invoiceVm.thisMonthSubtitle,
                status: 'info'.tr(),
                statusColor: Colors.green,
              ),
              const SizedBox(height: 12),
              InvoiceInfoCardWidget(
                title: 'last_month_invoice'.tr(),
                amount: consumptionVm.lastMonthValue,
                subtitle: invoiceVm.lastMonthSubtitle,
                status: 'info'.tr(),
                statusColor: Colors.green,
              ),
              const SizedBox(height: 12),
              InvoiceInfoCardWidget(
                title: 'average_change_ratio'.tr(),
                amount: '${invoiceVm.averageChangeRatioPercent.toStringAsFixed(2)}%',
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

