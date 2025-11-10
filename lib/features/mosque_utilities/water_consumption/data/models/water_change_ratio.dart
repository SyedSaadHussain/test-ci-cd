class WaterChangeRatio {
  final int meterId;
  final double avgChangeRatioPercent;

  const WaterChangeRatio({
    required this.meterId,
    required this.avgChangeRatioPercent,
  });

  factory WaterChangeRatio.fromJson(Map<String, dynamic> json) {
    return WaterChangeRatio(
      meterId: (json['meter_id'] as num?)?.toInt() ?? 0,
      avgChangeRatioPercent:
          (json['avg_change_ratio_percent'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class WaterChangeRatioResponse {
  final int status;
  final String message;
  final List<WaterChangeRatio> data;

  const WaterChangeRatioResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WaterChangeRatioResponse.fromJson(Map<String, dynamic> json) {
    final dynamic dataField = json['data'];
    final List<dynamic> raw = dataField is List ? dataField : const [];
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(WaterChangeRatio.fromJson)
        .toList();
    return WaterChangeRatioResponse(
      status: (json['status'] as num?)?.toInt() ?? 0,
      message: json['message']?.toString() ?? '',
      data: items,
    );
  }

  factory WaterChangeRatioResponse.error() => const WaterChangeRatioResponse(
        status: 500,
        message: 'Error',
        data: [],
      );

  bool get isSuccess => status == 200;
}
