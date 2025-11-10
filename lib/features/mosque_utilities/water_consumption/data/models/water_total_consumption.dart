class WaterTotalConsumption {
  final int meterId;
  final double totalConsumption;

  const WaterTotalConsumption({
    required this.meterId,
    required this.totalConsumption,
  });

  factory WaterTotalConsumption.fromJson(Map<String, dynamic> json) {
    return WaterTotalConsumption(
      meterId: (json['meter_id'] as num?)?.toInt() ?? 0,
      totalConsumption: (json['total_consumption'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class WaterTotalConsumptionResponse {
  final int status;
  final String message;
  final List<WaterTotalConsumption> data;

  const WaterTotalConsumptionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WaterTotalConsumptionResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataField = json['data'];
    final List<dynamic> raw = dataField is List ? dataField : const [];
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(WaterTotalConsumption.fromJson)
        .toList();
    return WaterTotalConsumptionResponse(
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
    );
  }

  factory WaterTotalConsumptionResponse.error() => const WaterTotalConsumptionResponse(
        status: 500,
        message: 'Error',
        data: [],
      );

  bool get isSuccess => status == 200;
}
