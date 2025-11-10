import 'package:mosque_management_system/core/utils/json_utils.dart';

import 'water_meter.dart';

class WaterMosqueSearchResult {
  final int cityId;
  final int meterId;
  final int mosqueId;
  final int regionId;
  final String periodEnd;
  final String mosqueName;
  final String meterNumber;
  final String meterStatus;
  final String periodStart;
  final int invoiceCount;
  final String mosqueNumber;
  final int moiaCenterId;
  final double totalConsumption;
  final double totalAmountInvoices;

  const WaterMosqueSearchResult({
    required this.cityId,
    required this.meterId,
    required this.mosqueId,
    required this.regionId,
    required this.periodEnd,
    required this.mosqueName,
    required this.meterNumber,
    required this.meterStatus,
    required this.periodStart,
    required this.invoiceCount,
    required this.mosqueNumber,
    required this.moiaCenterId,
    required this.totalConsumption,
    required this.totalAmountInvoices,
  });

  factory WaterMosqueSearchResult.fromJson(Map<String, dynamic> json) {
    return WaterMosqueSearchResult(
      cityId: json['city_id'] ?? 0,
      meterId: json['meter_id'] ?? 0,
      mosqueId: json['mosque_id'] ?? 0,
      regionId: json['region_id'] ?? 0,
      periodEnd: json['period_end']?.toString() ?? '',
      mosqueName: json['mosque_name']?.toString() ?? '',
      meterNumber: json['meter_number']?.toString() ?? '',
      meterStatus: json['meter_status']?.toString() ?? '',
      periodStart: json['period_start']?.toString() ?? '',
      invoiceCount: json['invoice_count'] ?? 0,
      mosqueNumber: json['mosque_number']?.toString() ?? '',
      moiaCenterId: json['moia_center_id'] ?? 0,
      totalConsumption: JsonUtils.toDouble(json['total_consumption']) ?? 0.0,
      totalAmountInvoices: JsonUtils.toDouble(json['total_amount_invoices']) ?? 0.0,
    );
  }

  WaterMeterSummary toWaterMeterSummary() {
    return WaterMeterSummary(
      cityId: cityId,
      meterId: meterId,
      mosqueId: mosqueId,
      regionId: regionId,
      mosqueName: mosqueName,
      meterNumber: meterNumber,
      mosqueNumber: mosqueNumber,
      moiaCenterId: moiaCenterId,
      mosqueClassificationId: 0,
    );
  }
}

class WaterMosqueSearchResponse {
  final int status;
  final String message;
  final List<WaterMosqueSearchResult> data;

  const WaterMosqueSearchResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WaterMosqueSearchResponse.fromJson(Map<String, dynamic> json) {
    // The API sometimes returns data as a flat list, and sometimes nested under {data: {data: [...]}}
    final dynamic dataField = json['data'];
    List<dynamic> rawItems = const [];

    if (dataField is List) {
      rawItems = dataField;
    } else if (dataField is Map<String, dynamic>) {
      rawItems = (dataField['data'] as List?) ?? const [];
    }

    final List<WaterMosqueSearchResult> searchResults = rawItems
        .whereType<Map<String, dynamic>>()
        .map(WaterMosqueSearchResult.fromJson)
        .toList();

    return WaterMosqueSearchResponse(
      status: json['status'] ?? 0,
      message: json['message']?.toString() ?? '',
      data: searchResults,
    );
  }

  factory WaterMosqueSearchResponse.error() {
    return const WaterMosqueSearchResponse(
      status: 500,
      message: 'Error',
      data: [],
    );
  }

  bool get isSuccess => status == 200;
}


