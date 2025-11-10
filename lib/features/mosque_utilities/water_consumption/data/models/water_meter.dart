import 'package:mosque_management_system/core/utils/json_utils.dart';

class WaterMeterSummary {
  final int cityId;
  final int meterId;
  final int mosqueId;
  final int regionId;
  final String mosqueName;
  final String meterNumber;
  final String mosqueNumber;
  final int moiaCenterId;
  final int mosqueClassificationId;

  final String? periodStart;
  final String? periodEnd;
  final String? meterStatus;
  final int? invoiceCount;
  final double? totalConsumption;
  final double? totalAmountInvoices;

  const WaterMeterSummary({
    required this.cityId,
    required this.meterId,
    required this.mosqueId,
    required this.regionId,
    required this.mosqueName,
    required this.meterNumber,
    required this.mosqueNumber,
    required this.moiaCenterId,
    required this.mosqueClassificationId,
    this.periodStart,
    this.periodEnd,
    this.meterStatus,
    this.invoiceCount,
    this.totalConsumption,
    this.totalAmountInvoices,
  });

  factory WaterMeterSummary.fromJson(Map<String, dynamic> json) {
    return WaterMeterSummary(
      cityId: json['city_id'] ?? 0,
      meterId: json['meter_id'] ?? 0,
      mosqueId: json['mosque_id'] ?? 0,
      regionId: json['region_id'] ?? 0,
      mosqueName: json['mosque_name']?.toString() ?? '',
      meterNumber: json['meter_number']?.toString() ?? '',
      mosqueNumber: json['mosque_number']?.toString() ?? '',
      moiaCenterId: json['moia_center_id'] ?? 0,
      mosqueClassificationId: json['mosque_classification_id'] ?? 0,
      periodStart: json['period_start']?.toString(),
      periodEnd: json['period_end']?.toString(),
      meterStatus: json['meter_status']?.toString(),
      invoiceCount: json['invoice_count'],
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
      'mosque_name': mosqueName,
      'meter_number': meterNumber,
      'mosque_number': mosqueNumber,
      'moia_center_id': moiaCenterId,
      'mosque_classification_id': mosqueClassificationId,
      if (periodStart != null) 'period_start': periodStart,
      if (periodEnd != null) 'period_end': periodEnd,
      if (meterStatus != null) 'meter_status': meterStatus,
      if (invoiceCount != null) 'invoice_count': invoiceCount,
      if (totalConsumption != null) 'total_consumption': totalConsumption,
      if (totalAmountInvoices != null) 'total_amount_invoices': totalAmountInvoices,
    };
  }
}


