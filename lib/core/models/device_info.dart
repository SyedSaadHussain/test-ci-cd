import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class DeviceInformation {
  int id;
  int? employeeId;
  String? name;
  String?  os;
  String?  osVersion;
  String?  imei;
  String?  status;
  String?  make;
  String?  model;
  // Add more fields as needed

  DeviceInformation({
    required this.id,
    this.name,
    this.employeeId,
    this.imei,
    this.status,
    this.osVersion,
    this.make,
    this.model,
    this.os
  });

  factory DeviceInformation.fromJson(Map<String, dynamic> json) {

    return DeviceInformation(
      id: JsonUtils.toInt(json['id'])!.toInt(),
      name: JsonUtils.toText(json['device_name']),
      employeeId: JsonUtils.getId(json['employee_id']),
      imei: JsonUtils.toText(json['imei']),
      status: JsonUtils.toText(json['status']),
      osVersion: JsonUtils.toText(json['os_version']),
      make: JsonUtils.toText(json['make']),
      model: JsonUtils.toText(json['model']),
      os: JsonUtils.toText(json['device_os']),
    );
  }
}

