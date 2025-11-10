import 'package:flutter/foundation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../data/models/meter_change_ratio.dart';
import '../data/models/meter_consumption.dart';
import '../data/repositories/meter_consumption_repository.dart';

class MeterConsumptionViewModel with ChangeNotifier {
  final MeterConsumptionRepository repository;

  MeterConsumptionViewModel(this.repository);

  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  MeterConsumption? thisMonth;
  MeterConsumption? lastMonth;
  MeterConsumption? total;
  List<MeterConsumption> monthlyData = [];
  MeterChangeRatio? changeRatio;

  Future<void> loadConsumptions(int meterId) async {
    if (isLoading) return;

    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      // Load all consumptions in parallel
      final results = await Future.wait([
        repository.getThisMonthConsumption(meterId),
        repository.getLastMonthConsumption(meterId),
        repository.getTotalConsumption(meterId),
        repository.getMonthlyConsumptionGraph(meterId),
        repository.getMonthlyConsumptionChangeRatio(meterId),
      ]);

      thisMonth = results[0] as MeterConsumption;
      lastMonth = results[1] as MeterConsumption;
      total = results[2] as MeterConsumption;
      monthlyData = results[3] as List<MeterConsumption>;
      changeRatio = results[4] as MeterChangeRatio;

      hasError = false;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      debugPrint('Error loading consumptions: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Formatted getters for the UI
  String get thisMonthValue => '${thisMonth?.quantity} ${'kwh_unit'.tr()}';
  String get lastMonthValue => '${lastMonth?.quantity} ${'kwh_unit'.tr()}';
  String get totalValue => '${total?.totalConsumption} ${'kwh_unit'.tr()}';

  // Invoice amounts should come from backend. These fallbacks are 0 when not available.
  String get thisMonthInvoice => '-- ${'sar_currency'.tr()}';
  String get lastMonthInvoice => '-- ${'sar_currency'.tr()}';
  String get totalInvoice => '-- ${'sar_currency'.tr()}';

  // Change ratio getter with fallback to 0
  double get changeRatioPercent => changeRatio?.avgChangeRatioPercent ?? 0.0;
}
