import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/mosque_utilities/water_consumption/data/models/water_total_invoices.dart';

import '../data/models/water_change_ratio.dart';
import '../data/models/water_invoice.dart';
import '../data/repositories/water_consumption_repository.dart';
import '../data/repositories/water_invoice_repository.dart';

class WaterInvoiceViewModel with ChangeNotifier {
  final WaterInvoiceRepository invoiceRepository;
  final WaterConsumptionRepository consumptionRepository;

  WaterInvoiceViewModel(this.invoiceRepository, this.consumptionRepository);

  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  WaterInvoice? thisMonth;
  WaterInvoice? lastMonth;
  WaterChangeRatio? averageChangeRatio;
  String? meterStatus;
  int? totalInvoices;

  Future<void> loadByMeterId(int meterId) async {
    if (isLoading) return;
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        invoiceRepository.getThisMonthInvoice(meterId: meterId),
        invoiceRepository.getLastMonthInvoice(meterId: meterId),
        consumptionRepository.getMonthlyChangeRatio(meterId: meterId),
        invoiceRepository.getTotalInvoices(meterId: meterId),
      ]);

      final thisMonthResp = results[0] as WaterInvoiceResponse;
      final lastMonthResp = results[1] as WaterInvoiceResponse;
      final ratioResp = results[2] as WaterChangeRatioResponse;
      final totalsResp = results[3] as WaterTotalInvoicesResponse;

      thisMonth = thisMonthResp.data.isNotEmpty ? thisMonthResp.data.first : null;
      lastMonth = lastMonthResp.data.isNotEmpty ? lastMonthResp.data.first : null;
      averageChangeRatio = ratioResp.data.isNotEmpty ? ratioResp.data.first : null;
      if (totalsResp.data.isNotEmpty) {
        meterStatus = totalsResp.data.first.meterStatus;
        totalInvoices = totalsResp.data.first.totalInvoices;
      } else {
        meterStatus = null;
        totalInvoices = null;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String get thisMonthAmountFormatted {
    final amt = thisMonth?.amountTotal ?? 0.0;
    return amt.toStringAsFixed(2);
  }

  String get lastMonthAmountFormatted {
    final amt = lastMonth?.amountTotal ?? 0.0;
    return amt.toStringAsFixed(2);
  }

  String get thisMonthSubtitle {
    final from = thisMonth?.invoiceDateFrom ?? '';
    final to = thisMonth?.invoiceDateTo ?? '';
    if (from.isEmpty && to.isEmpty) return 'this_month'.tr();
    return '$from - $to';
  }

  String get lastMonthSubtitle {
    final from = lastMonth?.invoiceDateFrom ?? '';
    final to = lastMonth?.invoiceDateTo ?? '';
    if (from.isEmpty && to.isEmpty) return 'last_month'.tr();
    return '$from - $to';
  }

  double get averageChangeRatioPercent => averageChangeRatio?.avgChangeRatioPercent ?? 0.0;
}
