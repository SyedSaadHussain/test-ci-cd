import 'package:mosque_management_system/core/utils/json_utils.dart';

class MeterConsumption {
  final int meterId;
  final double quantity;
  final String? invoiceDate;
  final double totalConsumption;

  MeterConsumption({
    required this.meterId,
    this.quantity = 0,
    this.invoiceDate,
    this.totalConsumption = 0,
  });

  factory MeterConsumption.fromJson(Map<String, dynamic> json) {
    return MeterConsumption(
      meterId: json['meter_id'] ?? 0,
      quantity: JsonUtils.toDouble(json['quantity']) ?? 0.0,
      invoiceDate: json['invoice_date'],
      totalConsumption: JsonUtils.toDouble(json['total_consumption']) ?? 0.0,
    );
  }

  // Create an empty consumption with zeros
  factory MeterConsumption.empty(int meterId) {
    return MeterConsumption(
      meterId: meterId,
      quantity: 0,
      totalConsumption: 0,
    );
  }
}