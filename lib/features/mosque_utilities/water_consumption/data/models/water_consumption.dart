class WaterConsumption {
  final int meterId;
  final double quantity;
  final String invoiceDate;

  const WaterConsumption({
    required this.meterId,
    required this.quantity,
    required this.invoiceDate,
  });

  factory WaterConsumption.fromJson(Map<String, dynamic> json) {
    return WaterConsumption(
      meterId: (json['meter_id'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      invoiceDate: json['invoice_date']?.toString() ?? '',
    );
  }
}

class WaterConsumptionResponse {
  final int status;
  final String message;
  final List<WaterConsumption> data;
  final int pageCount;
  final int totalCount;

  const WaterConsumptionResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pageCount,
    required this.totalCount,
  });

  factory WaterConsumptionResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataField = json['data'];
    List<dynamic> raw = const [];
    int total = 0;
    int pages = 0;
    if (dataField is List) {
      raw = dataField;
      total = (json['total_count'] as num?)?.toInt() ?? 0;
      pages = (json['page_count'] as num?)?.toInt() ?? 0;
    } else if (dataField is Map<String, dynamic>) {
      raw = (dataField['data'] as List?) ?? const [];
      total = (dataField['total_count'] as num?)?.toInt() ?? 0;
      pages = (dataField['page_count'] as num?)?.toInt() ?? 0;
    }
    final items = raw.whereType<Map<String, dynamic>>()
        .map(WaterConsumption.fromJson)
        .toList();
    return WaterConsumptionResponse(
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
      pageCount: pages,
      totalCount: total,
    );
  }

  factory WaterConsumptionResponse.error() => const WaterConsumptionResponse(
        status: 500,
        message: 'Error',
        data: [],
        pageCount: 0,
        totalCount: 0,
      );

  bool get isSuccess => status == 200;
}
