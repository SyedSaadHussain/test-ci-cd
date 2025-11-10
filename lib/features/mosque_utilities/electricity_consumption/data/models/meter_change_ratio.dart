import 'package:mosque_management_system/core/utils/json_utils.dart';

class MeterChangeRatio {
  final int meterId;
  final double avgChangeRatioPercent;

  MeterChangeRatio({
    required this.meterId,
    required this.avgChangeRatioPercent,
  });

  factory MeterChangeRatio.fromJson(Map<String, dynamic> json) {
    return MeterChangeRatio(
      meterId: json['meter_id'] ?? 0,
      avgChangeRatioPercent: JsonUtils.toDouble(json['avg_change_ratio_percent']) ?? 0.0,
    );
  }

  // Create an empty change ratio with zero percent
  factory MeterChangeRatio.empty(int meterId) {
    return MeterChangeRatio(
      meterId: meterId,
      avgChangeRatioPercent: 0.0,
    );
  }
}
