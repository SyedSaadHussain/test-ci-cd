import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../data/models/invoice_entry.dart';
import '../data/models/meter_change_ratio.dart';
import '../data/repositories/invoice_repository.dart';
import '../data/repositories/meter_consumption_repository.dart';

class InvoiceViewModel with ChangeNotifier {
  final InvoiceRepository repository;
  final MeterConsumptionRepository meterRepository;

  InvoiceViewModel(this.repository, this.meterRepository);

  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  InvoiceEntry? thisMonth;
  InvoiceEntry? lastMonth;
  MeterChangeRatio? averageChangeRatio;
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
        repository.getThisMonthInvoice(meterId),
        repository.getLastMonthInvoice(meterId),
        meterRepository.getMonthlyAmountChangeRatio(meterId),
        repository.getMeterTotalInvoices(meterId),
      ]);

      thisMonth = results[0] as InvoiceEntry?;
      lastMonth = results[1] as InvoiceEntry?;
      averageChangeRatio = results[2] as MeterChangeRatio?;
      final totalsMap = results[3] as Map<String, dynamic>?;
      meterStatus = totalsMap?['meter_status']?.toString();
      totalInvoices = (totalsMap?['total_invoices'] as num?)?.toInt();
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
    return '${amt.toStringAsFixed(2)} ${'sar_currency'.tr()}';
  }

  String get lastMonthAmountFormatted {
    final amt = lastMonth?.amountTotal ?? 0.0;
    return '${amt.toStringAsFixed(2)} ${'sar_currency'.tr()}';
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

  String get averageChangeRatioFormatted {
    final ratio = averageChangeRatio?.avgChangeRatioPercent ?? 0.0;
    return '${ratio.toStringAsFixed(1)}%';
  }

  double get averageChangeRatioPercent => averageChangeRatio?.avgChangeRatioPercent ?? 0.0;
}


