import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';

part 'userProfile.g.dart';

@HiveType(typeId: HiveTypeIds.userInfoModel)
class UserProfile extends HiveObject {

  @HiveField(0)
  final int userId;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final List<ComboItem>? cityIds;

  @HiveField(5)
  final int? parentId;

  @HiveField(6)
  final String? parent;

  @HiveField(7)
  final List<ComboItem>? stateIds;

  @HiveField(8)
  final List<String>? roleNames;

  @HiveField(9)
  final int? employeeId;

  @HiveField(10)
  final String? employee;

  @HiveField(11)
  final List<ComboItem>? moiaCenterIds;

  @HiveField(12)
  final String? userAppVersion;

  @HiveField(13)
  final int? classificationId;

  @HiveField(14)
  final String? classification;

  @HiveField(15)
  final String? identificationId;

  @HiveField(16)
  final String? staffRelationType;

  @HiveField(17)
  final String? genderArabic;

  @HiveField(18)
  bool? isDeviceVerify;

  String language;

  String tz;

  int companyId;

  UserProfile({
    required this.userId,
     this.email,
     this.phone,
     this.name,
     this.cityIds,
     this.parentId,
     this.parent,
     this.stateIds,
     this.roleNames,
     this.employeeId,
     this.employee,
     this.moiaCenterIds,
     this.userAppVersion,
     this.classificationId,
     this.classification,
     this.identificationId,
     this.staffRelationType,
     this.genderArabic,
    this.language="ar_001",
    this.tz="Asia/Riyadh",
    this.companyId=1,
    this.isDeviceVerify=false,
  });


  factory UserProfile.fromMansoobJson(Map<String, dynamic> json) {
    return UserProfile(
        userId: JsonUtils.toInt(json['id'])??0,
        employeeId: JsonUtils.toInt(json['id']),
        name: JsonUtils.toText(json['name']),
        phone: JsonUtils.toText(json['work_phone']),
        identificationId: JsonUtils.toText(json['identification_id']),
    );
  }
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    print(json['city_ids']);
    return UserProfile(
        name: JsonUtils.toText(json['name']),
        cityIds: JsonUtils.toListObject(json['city_ids'])
            .map((item) => ComboItem.fromJsonObject(item))
            .toList(),
        parentId: JsonUtils.getId(json['parent_id']),
        parent: JsonUtils.getName(json['parent_id']),
        stateIds: JsonUtils.toListObject(json['state_ids'])
            .map((item) => ComboItem.fromJsonObject(item))
            .toList(),
        roleNames: List<String>.from(json['role_names']),
        employeeId: JsonUtils.getId(json['employee_id']),
        employee: JsonUtils.getName(json['employee_id']),
        moiaCenterIds: JsonUtils.toListObject(json['moia_center_ids'])
            .map((item) => ComboItem.fromJson(item))
            .toList(),
        userAppVersion: JsonUtils.toText(json['user_app_version']),
        classificationId: JsonUtils.getId(json['classification_id']) ,
        classification: JsonUtils.getName(json['classification_id']),
        identificationId: JsonUtils.toText(json['identification_id']),
        staffRelationType: JsonUtils.toText(json['staff_relation_type']),
        genderArabic: JsonUtils.toText(json['gender_arabic']),
        email: JsonUtils.toText(json['email']),
        phone: JsonUtils.toText(json['phone']),
        userId: JsonUtils.toInt(json['user_id'])??0
    );
  }

  factory UserProfile.fromJsonSearch(dynamic responseData) {

    return UserProfile(
        userId: responseData[0],
        name: responseData[1]
    );
  }
}


class UserProfileData extends PagedData<UserProfile>{

}
