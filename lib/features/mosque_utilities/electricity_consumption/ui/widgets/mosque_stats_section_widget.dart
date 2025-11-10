import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../providers/invoice_view_model.dart';
import '../../providers/meter_consumption_view_model.dart';
import 'stat_card_widget.dart';

class MosqueStatsSectionWidget extends StatelessWidget {
  final int meterId;
  
  const MosqueStatsSectionWidget({
    super.key,
    required this.meterId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<MeterConsumptionViewModel, InvoiceViewModel>(
      builder: (context, consumptionVm, invoiceVm, child) {
        if (consumptionVm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (consumptionVm.hasError) {
          return Center(child: Text('Error: ${consumptionVm.errorMessage}'));
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              StatCardWidget(
                title: 'this_month'.tr(),
                value: consumptionVm.thisMonthValue,
                amount: invoiceVm.thisMonthAmountFormatted,
              ),
              StatCardWidget(
                title: 'last_month'.tr(),
                value: consumptionVm.lastMonthValue,
                amount: invoiceVm.lastMonthAmountFormatted,
              ),
              StatCardWidget(
                title: 'total'.tr(),
                value: consumptionVm.totalValue,
                amount: consumptionVm.totalInvoice,
              ),
            ],
          ),
        );
      },
    );
  }
}