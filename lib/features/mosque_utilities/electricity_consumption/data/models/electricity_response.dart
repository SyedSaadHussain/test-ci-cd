import 'electricity_meter.dart';

class ElectricitySummaryResponse {
  final int status;
  final String message;
  final List<ElectricityMeterSummary> data;
  final int totalCount;
  final int pageCount;

  const ElectricitySummaryResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.pageCount,
  });

  factory ElectricitySummaryResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataField = json['data'];

    List<dynamic> rawItems = const [];
    int totalCount = 0;
    int pageCount = 0;

    if (dataField is Map<String, dynamic>) {
      rawItems = (dataField['data'] as List<dynamic>?) ?? const [];
      totalCount = (dataField['total_count'] as num?)?.toInt() ?? 0;
      pageCount = (dataField['page_count'] as num?)?.toInt() ?? 0;
    } else if (dataField is List) {
      rawItems = dataField;
      totalCount = (json['total_count'] as num?)?.toInt() ?? 0;
      pageCount = (json['page_count'] as num?)?.toInt() ?? 0;
    }

    final items = rawItems
        .map((e) => ElectricityMeterSummary.fromJson(e as Map<String, dynamic>))
        .toList();

    return ElectricitySummaryResponse(
      status: json['status'] is int ? json['status'] as int : 0,
      message: json['message']?.toString() ?? '',
      data: items,
      totalCount: totalCount,
      pageCount: pageCount,
    );
  }

  factory ElectricitySummaryResponse.error() {
    return const ElectricitySummaryResponse(
      status: 500,
      message: 'Error',
      data: [],
      totalCount: 0,
      pageCount: 0,
    );
  }

  bool get isSuccess => status == 200;
}
