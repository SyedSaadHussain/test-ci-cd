class WaterInvoice {
  final int meterId;
  final String invoiceNumber;
  final String invoiceDateFrom;
  final String invoiceDateTo;
  final String invoiceDate;
  final int invoiceTotalDays;
  final double amountTotal;

  const WaterInvoice({
    required this.meterId,
    required this.invoiceNumber,
    required this.invoiceDateFrom,
    required this.invoiceDateTo,
    required this.invoiceDate,
    required this.invoiceTotalDays,
    required this.amountTotal,
  });

  factory WaterInvoice.fromJson(Map<String, dynamic> json) {
    return WaterInvoice(
      meterId: (json['meter_id'] as num?)?.toInt() ?? 0,
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      invoiceDateFrom: json['invoice_date_from']?.toString() ?? '',
      invoiceDateTo: json['invoice_date_to']?.toString() ?? '',
      invoiceDate: json['invoice_date']?.toString() ?? '',
      invoiceTotalDays: (json['invoice_total_days'] as num?)?.toInt() ?? 0,
      amountTotal: (json['amount_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class WaterInvoiceResponse {
  final int status;
  final String message;
  final List<WaterInvoice> data;

  const WaterInvoiceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WaterInvoiceResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataField = json['data'];
    final List<dynamic> raw = dataField is List ? dataField : const [];
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(WaterInvoice.fromJson)
        .toList();
    return WaterInvoiceResponse(
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
    );
  }

  factory WaterInvoiceResponse.error() => const WaterInvoiceResponse(
        status: 500,
        message: 'Error',
        data: [],
      );

  bool get isSuccess => status == 200;
}
