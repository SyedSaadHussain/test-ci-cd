class WaterTotalInvoices {
  final int meterId;
  final int totalInvoices;
  final String? meterStatus;

  const WaterTotalInvoices({
    required this.meterId,
    required this.totalInvoices,
    this.meterStatus,
  });

  factory WaterTotalInvoices.fromJson(Map<String, dynamic> json) {
    return WaterTotalInvoices(
      meterId: (json['meter_id'] as num?)?.toInt() ?? 0,
      totalInvoices: (json['total_invoices'] as num?)?.toInt() ?? 0,
      meterStatus: json['meter_status']?.toString(),
    );
  }
}

class WaterTotalInvoicesResponse {
  final int status;
  final String message;
  final List<WaterTotalInvoices> data;
  final int pageCount;
  final int totalCount;

  const WaterTotalInvoicesResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.pageCount,
    required this.totalCount,
  });

  factory WaterTotalInvoicesResponse.fromJson(Map<String, dynamic> json) {
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

    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(WaterTotalInvoices.fromJson)
        .toList();

    return WaterTotalInvoicesResponse(
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
      pageCount: pages,
      totalCount: total,
    );
  }

  factory WaterTotalInvoicesResponse.error() => const WaterTotalInvoicesResponse(
        status: 500,
        message: 'Error',
        data: [],
        pageCount: 0,
        totalCount: 0,
      );

  bool get isSuccess => status == 200;
}
