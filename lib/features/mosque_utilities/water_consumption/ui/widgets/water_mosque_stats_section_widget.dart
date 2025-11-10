import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../providers/water_consumption_view_model.dart';
import '../../providers/water_invoice_view_model.dart';
import 'water_stat_card_widget.dart';

class WaterMosqueStatsSectionWidget extends StatelessWidget {
  final int meterId;
  const WaterMosqueStatsSectionWidget({super.key, required this.meterId});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WaterConsumptionViewModel, WaterInvoiceViewModel>(
      builder: (context, consumptionVm, invoiceVm, _) {
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
              WaterStatCardWidget(
                title: 'this_month'.tr(),
                value: consumptionVm.thisMonthValue,
                amount: '${invoiceVm.thisMonthAmountFormatted} ${'sar_currency'.tr()}',
              ),
              WaterStatCardWidget(
                title: 'last_month'.tr(),
                value: consumptionVm.lastMonthValue,
                amount: '${invoiceVm.lastMonthAmountFormatted} ${'sar_currency'.tr()}',
              ),
              WaterStatCardWidget(
                title: 'total'.tr(),
                value: consumptionVm.totalValue,
                amount: '-- ${'sar_currency'.tr()}',
              ),
            ],
          ),
        );
      },
    );
  }
}

