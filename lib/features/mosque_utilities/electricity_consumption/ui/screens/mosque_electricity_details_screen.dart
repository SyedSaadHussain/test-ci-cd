import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../data/services/custom_odoo_client.dart';
import '../../data/repositories/electricity_repository.dart';
import '../../data/repositories/invoice_repository.dart';
import '../../data/repositories/meter_consumption_repository.dart';
import '../../providers/invoice_view_model.dart';
import '../../providers/meter_consumption_view_model.dart';
import '../../providers/mosque_details_view_model.dart';
import '../widgets/invoice_section_widget.dart';
import '../widgets/meter_details_section_widget.dart';
import '../widgets/monthly_consumption_chart_widget.dart';
import '../widgets/mosque_details_header_widget.dart';
import '../widgets/mosque_stats_section_widget.dart';

class MosqueElectricityDetailsScreen extends StatelessWidget {
  final String mosqueName;
  final String consumption;
  final int? meterId;
  final String? meterNumber;

  const MosqueElectricityDetailsScreen({
    super.key,
    required this.mosqueName,
    required this.consumption,
    this.meterId,
    this.meterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
            final repo = MeterConsumptionRepository(client);
            final vm = MeterConsumptionViewModel(repo);
            if (meterId != null) {
              vm.loadConsumptions(meterId!);
            }
            return vm;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
            final repo = ElectricityRepository(client);
            final vm = MosqueDetailsViewModel(repo);
            if (meterId != null) {
              vm.loadByMeterId(meterId!);
            }
            return vm;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
            final invoiceRepo = InvoiceRepository(client);
            final meterRepo = MeterConsumptionRepository(client);
            final vm = InvoiceViewModel(invoiceRepo, meterRepo);
            if (meterId != null) {
              vm.loadByMeterId(meterId!);
            }
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
                MosqueDetailsHeaderWidget(
                  mosqueName: mosqueName,
                  meterId: meterId,
                ),
                const SizedBox(height: 20),
                // Inline note: current-year data only
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
                if (meterId != null)
                  MosqueStatsSectionWidget(meterId: meterId!),
                const SizedBox(height: 20),
                const MonthlyConsumptionChartWidget(),
                const SizedBox(height: 20),
                if (meterId != null) InvoiceSectionWidget(meterId: meterId!),
                const SizedBox(height: 20),
                if (meterId != null) MeterDetailsSectionWidget(meterId: meterId!, meterNumber: meterNumber),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}