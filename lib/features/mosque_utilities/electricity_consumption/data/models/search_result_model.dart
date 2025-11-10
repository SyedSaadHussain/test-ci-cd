import 'package:mosque_management_system/core/utils/json_utils.dart';

import 'electricity_meter.dart';

class MosqueSearchResult {
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

  const MosqueSearchResult({
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

  factory MosqueSearchResult.fromJson(Map<String, dynamic> json) {
    return MosqueSearchResult(
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

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'meter_id': meterId,
      'mosque_id': mosqueId,
      'region_id': regionId,
      'period_end': periodEnd,
      'mosque_name': mosqueName,
      'meter_number': meterNumber,
      'meter_status': meterStatus,
      'period_start': periodStart,
      'invoice_count': invoiceCount,
      'mosque_number': mosqueNumber,
      'moia_center_id': moiaCenterId,
      'total_consumption': totalConsumption,
      'total_amount_invoices': totalAmountInvoices,
    };
  }

  // Convert to ElectricityMeterSummary for compatibility with existing widgets
  ElectricityMeterSummary toElectricityMeterSummary() {
    return ElectricityMeterSummary(
      cityId: cityId,
      meterId: meterId,
      mosqueId: mosqueId,
      regionId: regionId,
      mosqueName: mosqueName,
      meterNumber: meterNumber,
      mosqueNumber: mosqueNumber,
      moiaCenterId: moiaCenterId,
      mosqueClassificationId: 0, // Not provided in search API
    );
  }
}

class MosqueSearchResponse {
  final int status;
  final String message;
  final List<MosqueSearchResult> data;

  const MosqueSearchResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MosqueSearchResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawData = json['data'] ?? [];
    final List<MosqueSearchResult> searchResults = rawData
        .map((item) => MosqueSearchResult.fromJson(item as Map<String, dynamic>))
        .toList();

    return MosqueSearchResponse(
      status: json['status'] ?? 0,
      message: json['message']?.toString() ?? '',
      data: searchResults,
    );
  }

  factory MosqueSearchResponse.error() {
    return const MosqueSearchResponse(
      status: 500,
      message: 'Error',
      data: [],
    );
  }

  bool get isSuccess => status == 200;
}
