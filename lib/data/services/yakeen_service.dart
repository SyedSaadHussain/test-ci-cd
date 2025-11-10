import 'package:flutter/cupertino.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/services/network_service.dart';

class YakeenService {
  final NetworkService _networkService;

  YakeenService({NetworkService? networkService})
      : _networkService = networkService ?? NetworkService(baseUrl: Config.discoveryUrl);

  Future<String?> getUserName(String identity, String birthdate) async {
    try {
      final url = "yakeen/Yakeen/GetCitizenData"
          "?identity=$identity&birthdate=$birthdate";

      final response = await _networkService.get(url);

      if (response['personBasicInfo'] == null) {
        return null; // Not verified
      }
      final yakeenData = YakeenData.fromJson(response['personBasicInfo']);
      return yakeenData.name;

    } catch (e) {
      throw Exception("Yakeen verification failed: $e");
    } finally {
      _networkService.close();
    }
  }

  // For both Ar and En Yakeen names return
  Future<({String name, String nameEn})?> getUserNamesArEn( String identity,String birthdate,) async {
    try {
      final url =
          "/yakeen/Yakeen/GetCitizenData?identity=$identity&birthdate=$birthdate";

      print("yakeen url:$url");
      final fullUrl = '${Config.discoveryUrl}${url.startsWith('/') ? '' : '/'}$url';
      print("yakeen url full: $fullUrl");
      final response = await _networkService.get(url);

      final basic = response['personBasicInfo'];
      if (basic == null) return null;

      // if (basic is Map) {
      //   debugPrint('[Yakeen] AR parts: fn=${basic['firstName']} f=${basic['fatherName']} gf=${basic['grandFatherName']} fam=${basic['familyName']}');
      //   debugPrint('[Yakeen] EN parts: fnT=${basic['firstNameT']} fT=${basic['fatherNameT']} gfT=${basic['grandFatherNameT']} famT=${basic['familyNameT']}');
      // }

      final data = YakeenData.fromJson(basic);

      final ar = (data.name).trim();
      final en = (data.nameEn).trim();

      // name  = Arabic (existing getter)
      // nameEn = RAW English from *T fields (no title case)
      return (name: data.name , nameEn: data.nameEn);
    } catch (e) {
      throw Exception("Yakeen verification failed: $e");
    } finally {
      _networkService.close();
    }
  }

  /// Return the raw response from Yakeen (personBasicInfo, personIdInfo, result)
  Future<Map<String, dynamic>?> getCitizenDataRaw(String identity, String birthdate) async {
    try {
      final url = "/yakeen/Yakeen/GetCitizenData?identity=$identity&birthdate=$birthdate";
      final response = await _networkService.get(url);
      if (response is Map<String, dynamic>) return Map<String, dynamic>.from(response);
      return null;
    } catch (e) {
      throw Exception("Yakeen verification failed: $e");
    } finally {
      _networkService.close();
    }
  }


}