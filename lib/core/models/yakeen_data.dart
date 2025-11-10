import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class YakeenData {
   String? nationalId;
   String? nameEnglish;
   String?  nameArabic;
   String?  nationality;
   String?  json;

   String? familyName;
   String? familyNameT;
   String? fatherName;
   String? fatherNameT;
   String? firstName;
   String? firstNameT;
   String? grandFatherName;
   String? grandFatherNameT;

   // Extended fields from personBasicInfo
   String? birthCity;
   String? occupationCode;      // occupationCode
   String? sexDescAr;           // sexDescAr
   String? statusDescAR;        // statusDescAR
   String? convertDateString;   // convertDate.dateString (Hijri)

   // From personIdInfo
   String? idExpirationDate;    // idExpirationDate (ISO string)
   String? preSamisIssueDate;   // preSamisIssueDate (ISO string)

   String get name => '${(firstName??"")} ${(fatherName??"")} ${(grandFatherName??"")} ${(familyName??"")}';
   String get nameEn => '${(firstNameT ?? "")} ${(fatherNameT ?? "")} ${(grandFatherNameT ?? "")} ${(familyNameT ?? "")}';


   YakeenData({
    this.nationalId,
    this.nameEnglish,
    this.nameArabic,
    this.nationality,
    this.json,
     //New Yakeen
     this.familyName,
     this.familyNameT,
     this.fatherName,
     this.fatherNameT,
     this.firstName,
     this.firstNameT,
     this.grandFatherName,
     this.grandFatherNameT,
     // extended
     this.birthCity,
     this.occupationCode,
     this.sexDescAr,
     this.statusDescAR,
     this.convertDateString,
     this.idExpirationDate,
     this.preSamisIssueDate,
  });

   Map<String, dynamic> toJson() {
     return {
       'national_id': nationalId,
       'name_english': nameEnglish,
       'name_arabic': nameArabic,
       'nationality': nationality,
     };
   }

  factory YakeenData.fromJson(Map<String, dynamic> json) {
    // This expects personBasicInfo map, but gracefully reads extended fields if present
    final convert = json['convertDate'] is Map ? json['convertDate'] as Map : const {};
    return YakeenData(
      familyName: JsonUtils.toText(json['familyName']),
      familyNameT: JsonUtils.toText(json['familyNameT']),
      fatherName: JsonUtils.toText(json['fatherName']),
      fatherNameT: JsonUtils.toText(json['fatherNameT']),
      firstName: JsonUtils.toText(json['firstName']),
      firstNameT: JsonUtils.toText(json['firstNameT']),
      grandFatherName: JsonUtils.toText(json['grandFatherName']),
      grandFatherNameT: JsonUtils.toText(json['grandFatherNameT']),
      birthCity: JsonUtils.toText(json['birthCity']),
      occupationCode: JsonUtils.toText(json['occupationCode']),
      sexDescAr: JsonUtils.toText(json['sexDescAr']),
      statusDescAR: JsonUtils.toText(json['statusDescAR']),
      convertDateString: JsonUtils.toText(convert['dateString']),
    );
  }

  // Build from full API response: { personBasicInfo: {...}, personIdInfo: {...} }
  factory YakeenData.fromFullResponse(Map<String, dynamic> response) {
    final basic = (response['personBasicInfo'] is Map)
        ? Map<String, dynamic>.from(response['personBasicInfo'] as Map)
        : const <String, dynamic>{};
    final idInfo = (response['personIdInfo'] is Map)
        ? Map<String, dynamic>.from(response['personIdInfo'] as Map)
        : const <String, dynamic>{};

    final d = YakeenData.fromJson(basic);
    d.idExpirationDate = JsonUtils.toText(idInfo['idExpirationDate']);
    d.preSamisIssueDate = JsonUtils.toText(idInfo['preSamisIssueDate']);
    d.json = response.toString();
    return d;
  }

  // factory YakeenData.fromJson(Map<String, dynamic> json) {
  //
  //   return YakeenData(
  //     id: JsonUtils.toInt(json['id'])!.toInt(),
  //     name: JsonUtils.toText(json['name']),
  //     centerCode: JsonUtils.toText(json['center_code']),
  //   );
  // }


}
