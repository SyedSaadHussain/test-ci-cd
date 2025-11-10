import 'package:flutter/foundation.dart';

import '../../electricity_consumption/data/services/location_service.dart';
import '../data/models/water_basic_info.dart';
import '../data/models/water_change_ratio.dart';
import '../data/models/water_consumption.dart';
import '../data/models/water_total_consumption.dart';
import '../data/repositories/water_consumption_repository.dart';

class WaterConsumptionViewModel with ChangeNotifier {
  final WaterConsumptionRepository repository;

  WaterConsumptionViewModel(this.repository);

  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  WaterConsumption? thisMonth;
  WaterConsumption? lastMonth;
  WaterTotalConsumption? total;
  List<WaterConsumption> monthlyData = [];
  WaterChangeRatio? changeRatio;
  WaterBasicInfo? basicInfo;

  Future<void> loadConsumptions(int meterId) async {
    if (isLoading) return;
    isLoading = true;
    hasError = false;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getThisMonthConsumption(meterId: meterId),
        repository.getLastMonthConsumption(meterId: meterId),
        repository.getTotalConsumption(meterId: meterId),
        repository.getMonthlyConsumptionGraph(meterId: meterId),
        repository.getMonthlyChangeRatio(meterId: meterId),
        repository.getBasicInfo(meterId: meterId),
      ]);

      final thisMonthResp = results[0] as WaterConsumptionResponse;
      final lastMonthResp = results[1] as WaterConsumptionResponse;
      final totalResp = results[2] as WaterTotalConsumptionResponse;
      final monthlyResp = results[3] as WaterConsumptionResponse;
      final ratioResp = results[4] as WaterChangeRatioResponse;
      final basicResp = results[5] as WaterBasicInfoResponse;

      thisMonth = thisMonthResp.data.isNotEmpty ? thisMonthResp.data.first : null;
      lastMonth = lastMonthResp.data.isNotEmpty ? lastMonthResp.data.first : null;
      total = totalResp.data.isNotEmpty ? totalResp.data.first : null;
      monthlyData = monthlyResp.data;
      changeRatio = ratioResp.data.isNotEmpty ? ratioResp.data.first : null;
      basicInfo = basicResp.data.isNotEmpty ? basicResp.data.first : null;

      hasError = false;
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String get thisMonthValue => '${thisMonth?.quantity ?? 0} m³';
  String get lastMonthValue => '${lastMonth?.quantity ?? 0} m³';
  String get totalValue => '${total?.totalConsumption ?? 0} m³';
  double get changeRatioPercent => changeRatio?.avgChangeRatioPercent ?? 0.0;

  String get fullLocationString {
    final raw = basicInfo?.fullAddress?.trim() ?? '';
    if (raw.isEmpty) return '';
    // If response looks like "1470/2687/38535/الزهور", map IDs to names like electricity
    if (raw.contains('/')) {
      // Synchronous formatting using local assets
      final parsed = LocationService.instance.parseFullAddress(raw);
      if (parsed.isEmpty) return raw;
      final regionId = parsed['regionId'] as int?;
      final cityId = parsed['cityId'] as int?;
      final centerId = parsed['centerId'] as int?;
      final neighborhood = parsed['neighborhood'] as String? ?? '';

      final parts = <String>[];
      if (neighborhood.isNotEmpty) parts.add(neighborhood);
      final centerName = centerId != null ? LocationService.instance.getCenterName(centerId) : null;
      if (centerName != null && centerName.isNotEmpty) parts.add(centerName);
      final cityName = cityId != null ? LocationService.instance.getCityName(cityId) : null;
      if (cityName != null && cityName.isNotEmpty) parts.add(cityName);
      final regionName = regionId != null ? LocationService.instance.getRegionName(regionId) : null;
      if (regionName != null && regionName.isNotEmpty) parts.add(regionName);
      return parts.isNotEmpty ? parts.join('/ ') : raw;
    }
    return raw;
  }
}
