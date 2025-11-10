class WaterBasicInfo {
  final String? fullAddress;
  final String? mosqueNumber;

  WaterBasicInfo({this.fullAddress, this.mosqueNumber});

  factory WaterBasicInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
      final item = data.first as Map<String, dynamic>;
      return WaterBasicInfo(
        fullAddress: item['full_address']?.toString(),
        mosqueNumber: item['mosque_number']?.toString(),
      );
    }
    if (json.containsKey('full_address') || json.containsKey('mosque_number')) {
      return WaterBasicInfo(
        fullAddress: json['full_address']?.toString(),
        mosqueNumber: json['mosque_number']?.toString(),
      );
    }
    return WaterBasicInfo();
  }
}

class WaterBasicInfoResponse {
  final int status;
  final String message;
  final List<WaterBasicInfo> data;

  WaterBasicInfoResponse({required this.status, required this.message, required this.data});

  factory WaterBasicInfoResponse.fromJson(Map<String, dynamic> json) {
    final list = <WaterBasicInfo>[];
    final dataField = json['data'];
    if (dataField is List) {
      for (final item in dataField) {
        if (item is Map<String, dynamic>) {
          list.add(WaterBasicInfo.fromJson(item));
        }
      }
    } else if (dataField is Map<String, dynamic>) {
      list.add(WaterBasicInfo.fromJson(dataField));
    }
    return WaterBasicInfoResponse(
      status: json['status'] ?? 0,
      message: json['message']?.toString() ?? '',
      data: list,
    );
  }

  factory WaterBasicInfoResponse.error() =>
      WaterBasicInfoResponse(status: 0, message: 'error', data: const []);
}


