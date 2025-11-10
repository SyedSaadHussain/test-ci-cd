import 'package:mosque_management_system/core/utils/json_utils.dart';

class MosqueMeterSummary {
  final int cityId;
  final int meterId;
  final int mosqueId;
  final int regionId;
  final String mosqueName;
  final String meterNumber;
  final String mosqueNumber;
  final int moiaCenterId;
  final int mosqueClassificationId;
  
  // YTD endpoint additional fields
  final String? periodStart;
  final String? periodEnd;
  final String? meterStatus;
  final int? invoiceCount;
  final double? totalConsumption;
  final double? totalAmountInvoices;

  MosqueMeterSummary({
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

  factory MosqueMeterSummary.fromJson(Map<String, dynamic> json) {
    return MosqueMeterSummary(
      cityId: json['city_id'] ?? 0,
      meterId: json['meter_id'] ?? 0,
      mosqueId: json['mosque_id'] ?? 0,
      regionId: json['region_id'] ?? 0,
      mosqueName: json['mosque_name'] ?? '',
      meterNumber: json['meter_number'] ?? '',
      mosqueNumber: json['mosque_number'] ?? '',
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
}

class MosqueMeterSummaryResponse {
  final int status;
  final String message;
  final MosqueMeterSummaryData data;

  MosqueMeterSummaryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MosqueMeterSummaryResponse.fromJson(Map<String, dynamic> json) {
    // Handle both nested and flat response structures
    final dynamic dataField = json['data'];
    
    MosqueMeterSummaryData parsedData;
    if (dataField is List) {
      // Flat structure: data is directly a list
      parsedData = MosqueMeterSummaryData.fromList(
        dataField,
        pageCount: json['page_count'] ?? 0,
        totalCount: json['total_count'] ?? 0,
      );
    } else if (dataField is Map<String, dynamic>) {
      // Nested structure: data contains {data, page_count, total_count}
      parsedData = MosqueMeterSummaryData.fromJson(dataField);
    } else {
      // Fallback to empty data
      parsedData = MosqueMeterSummaryData(data: [], pageCount: 0, totalCount: 0);
    }
    
    return MosqueMeterSummaryResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: parsedData,
    );
  }
}

class MosqueMeterSummaryData {
  final List<MosqueMeterSummary> data;
  final int pageCount;
  final int totalCount;

  MosqueMeterSummaryData({
    required this.data,
    required this.pageCount,
    required this.totalCount,
  });

  factory MosqueMeterSummaryData.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List? ?? [];
    List<MosqueMeterSummary> summaries = dataList
        .map((item) => MosqueMeterSummary.fromJson(item))
        .toList();

    return MosqueMeterSummaryData(
      data: summaries,
      pageCount: json['page_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
    );
  }

  // Factory for flat list structure (YTD endpoint)
  factory MosqueMeterSummaryData.fromList(
    List<dynamic> dataList, {
    required int pageCount,
    required int totalCount,
  }) {
    List<MosqueMeterSummary> summaries = dataList
        .map((item) => MosqueMeterSummary.fromJson(item as Map<String, dynamic>))
        .toList();

    return MosqueMeterSummaryData(
      data: summaries,
      pageCount: pageCount,
      totalCount: totalCount,
    );
  }
}

// Filter option classes
class FilterOption {
  final int id;
  final String name;

  FilterOption({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterOption && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name;
}
