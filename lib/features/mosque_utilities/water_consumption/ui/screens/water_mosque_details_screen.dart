import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/config.dart';
import '../../../../../data/services/custom_odoo_client.dart';
import '../../data/repositories/water_consumption_repository.dart';
import '../../data/repositories/water_invoice_repository.dart';
import '../../providers/water_consumption_view_model.dart';
import '../../providers/water_invoice_view_model.dart';
import '../widgets/water_invoice_section_widget.dart';
import '../widgets/water_meter_details_section_widget.dart';
import '../widgets/water_monthly_consumption_chart_widget.dart';
import '../widgets/water_mosque_details_header_widget.dart';
import '../widgets/water_mosque_stats_section_widget.dart';

class WaterMosqueDetailsScreen extends StatelessWidget {
  final String mosqueName;
  final String consumption;
  final int? meterId;
  final String? meterNumber;
  final String? mosqueNumber;

  const WaterMosqueDetailsScreen({
    super.key,
    required this.mosqueName,
    required this.consumption,
    this.meterId,
    this.meterNumber,
    this.mosqueNumber,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
            final repo = WaterConsumptionRepository(client);
            final vm = WaterConsumptionViewModel(repo);
            if (meterId != null) vm.loadConsumptions(meterId!);
            return vm;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
            final invoiceRepo = WaterInvoiceRepository(client);
            final consumptionRepo = WaterConsumptionRepository(client);
            final vm = WaterInvoiceViewModel(invoiceRepo, consumptionRepo);
            if (meterId != null) vm.loadByMeterId(meterId!);
            return vm;
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WaterMosqueDetailsHeaderWidget(
                  mosqueName: mosqueName,
                  meterId: meterId,
                  mosqueNumber: mosqueNumber,
                ),
                const SizedBox(height: 20),
                // Inline note: current-year data only (match electricity styling)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.withOpacity(0.6), width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'current_year_only_note'.tr(),
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (meterId != null) WaterMosqueStatsSectionWidget(meterId: meterId!),
                const SizedBox(height: 20),
                const WaterMonthlyConsumptionChartWidget(),
                const SizedBox(height: 20),
                if (meterId != null) WaterInvoiceSectionWidget(meterId: meterId!),
                const SizedBox(height: 20),
                if (meterId != null)
                  WaterMeterDetailsSectionWidget(meterId: meterId!, meterNumber: meterNumber),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


