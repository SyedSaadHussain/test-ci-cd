import 'package:mosque_management_system/core/utils/json_utils.dart';

class InvoiceEntry {
  final int meterId;
  final double amountTotal;
  final String? invoiceDate; // e.g. 2025-09-12
  final String? invoiceNumber;
  final String? invoiceDateFrom;
  final String? invoiceDateTo;
  final int? invoiceTotalDays;

  InvoiceEntry({
    required this.meterId,
    required this.amountTotal,
    this.invoiceDate,
    this.invoiceNumber,
    this.invoiceDateFrom,
    this.invoiceDateTo,
    this.invoiceTotalDays,
  });

  factory InvoiceEntry.fromJson(Map<String, dynamic> json) {
    return InvoiceEntry(
      meterId: (json['meter_id'] as num?)?.toInt() ?? 0,
      amountTotal: JsonUtils.toDouble(json['amount_total']) ?? 0.0,
      invoiceDate: json['invoice_date']?.toString(),
      invoiceNumber: json['invoice_number']?.toString(),
      invoiceDateFrom: json['invoice_date_from']?.toString(),
      invoiceDateTo: json['invoice_date_to']?.toString(),
      invoiceTotalDays: (json['invoice_total_days'] as num?)?.toInt(),
    );
  }
}


