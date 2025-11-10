import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:mosque_management_system/core/models/device_info.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';


class DeviceDetail {
  Future<DeviceInformation?> getImei() async {
    var deviceInfo = DeviceInfoPlugin();
    var info = DeviceInformation(id: 0);
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;

      info.name = iosDeviceInfo.utsname.machine;
      info.os = "ios";
      final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
      info.imei=await _secureStorage.read(key: "appUUID");
      if(info.imei==null || info.imei==''){
        info.imei = iosDeviceInfo.identifierForVendor;
        _secureStorage.write(key: "appUUID", value: info.imei);
      }
      // if(info.imei==null || info.imei==''){
      //   info.imei = iosDeviceInfo.identifierForVendor;
      //   if(AppUtils.isNotNullOrEmpty(info.imei)){
      //     String udid = await FlutterUdid.consistentUdid;
      //     info.imei = udid;
      //   }
      //   _secureStorage.write(key: "appUUID", value: info.imei);
      // }

      info.osVersion = iosDeviceInfo.systemVersion;

      return info; // unique ID on iOS
    }

    else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      info.name = androidDeviceInfo.model;
      info.os = "android";
      String udid = await FlutterUdid.consistentUdid;
      udid+='_';
      udid+=await FlutterUdid.udid;
      info.imei = udid;
      info.osVersion = androidDeviceInfo.version.release;
      info.make=androidDeviceInfo.manufacturer;
      info.model=androidDeviceInfo.model;
      return info; // unique ID on Android
    }
    return null;
  }
}



