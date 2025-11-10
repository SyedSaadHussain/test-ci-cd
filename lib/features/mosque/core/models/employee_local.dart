import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';

part 'employee_local.g.dart';

@HiveType(typeId: HiveTypeIds.employeeModel) // keep this unique in your app
class EmployeeLocal extends HiveObject {
  @HiveField(0)
  String localId;

  @HiveField(1)
  String parentLocalId;

  /// e.g. [8] إمام, [9] مؤذن, [10] خطيب, [11] خادم
  @HiveField(2)
  List<int> categoryIds;

  @HiveField(3)
  String? nameAr;             // read-only (Yaqeen)

  @HiveField(4)
  String? nameEn;

  @HiveField(5)
  DateTime? birthday;         // store DateTime; send yyyy-MM-dd

  @HiveField(6)
  String? identificationId;   // 10 digits

  @HiveField(7)
  String? staffRelationType;  // e.g., 'regular'

  @HiveField(8)
  String? workEmail;

  @HiveField(9)
  String? workPhone;          // 12 digits, starts with 966

  /// Always 22 for employees
  @HiveField(10)
  int classificationId;

  @HiveField(11)
  bool verified;

  // ----- Extended fields to store Yakeen + job info -----
  @HiveField(12)
  String? gender;                 // e.g. 'male' or Arabic value from Yakeen

  @HiveField(13)
  String? statusDescAr;           // statusDescAR

  @HiveField(14)
  String? occupationCode;         // occupationCode

  @HiveField(15)
  String? preSamisIssueDate;      // personIdInfo.preSamisIssueDate (ISO/String)

  @HiveField(16)
  String? idExpired;              // personIdInfo.idExpirationDate

  @HiveField(17)
  String? cityOfBirth;            // personBasicInfo.birthCity

  @HiveField(18)
  int? jobFamilyId;               // job_family_id

  @HiveField(19)
  int? jobId;                     // job_id (position)

  @HiveField(20)
  int? jobNumberId;               // job_number_id

  @HiveField(21)
  String? hijriBirthday;          // from Yakeen convertDate.dateString (yyyy-MM-dd)

  bool get yakeenVerified => verified == true;

  EmployeeLocal({
    required this.localId,
    required this.parentLocalId,
    required this.categoryIds,
    this.nameAr,
    this.nameEn,
    this.birthday,
    this.identificationId,
    this.staffRelationType,
    this.workEmail,
    this.workPhone,
    this.classificationId = 22,
    this.verified = false,
    this.gender,
    this.statusDescAr,
    this.occupationCode,
    this.preSamisIssueDate,
    this.idExpired,
    this.cityOfBirth,
    this.jobFamilyId,
    this.jobId,
    this.jobNumberId,
    this.hijriBirthday,
  });

  /// Primary role convenience
  int? get primaryCategoryId => categoryIds.isNotEmpty ? categoryIds.first : null;
  set primaryCategoryId(int? id) => categoryIds = id == null ? <int>[] : <int>[id];

  /// Quick factory when adding one role
  factory EmployeeLocal.newForMosque({
    required String parentLocalId,
    required int roleId, // 8/9/10/11
  }) {
    return EmployeeLocal(
      localId: 'emp_${DateTime.now().microsecondsSinceEpoch}',
      parentLocalId: parentLocalId,
      categoryIds: <int>[roleId],
    );
  }

  Map<String, dynamic> toApiRecord() => <String, dynamic>{
    // Names
    'name'                 : nameAr,                      // primary display name
    'full_arabic_name'     : nameAr,
    'full_english_name'    : nameEn,

    // Core identity
    'birthday'             : birthday != null ? _fmt(birthday!) : null,
    'identification_id'    : identificationId,
    'staff_relation_type'  : staffRelationType,

    // Contacts
    'email_from'           : workEmail,                   // WAS work_email
    'partner_mobile'       : workPhone,                   // WAS work_phone

    // (Removed) categories/classification per requirements

    // Job mapping
    'job_family_id'        : jobFamilyId,
    'job_id'               : jobId,
    'job_number_id'        : jobNumberId,

    // Yakeen verification flag
    'yaqeen_verification'  : verified == true,

    // Extra Yakeen-derived fields
    'status_desc_ar'       : statusDescAr,
    'occupation_code'      : occupationCode,
    'pre_samis_issue_date' : _dateOnly(preSamisIssueDate),
    'id_expired'           : _dateOnly(idExpired),
    'city_of_birth'        : cityOfBirth,
    'gender'               : gender,
    'hijri_birthday'       : hijriBirthday, // already in yyyy-MM-dd
  }..removeWhere((_, v) => v == null);

  static String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// keep a shared date formatter (same as before)
// helper: yyyy-MM-dd
String _fmtDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

extension EmployeeApi on EmployeeLocal {
  /// Build one staff record for the legacy_forms payload.
  /// - Arabic name is primary ('name'); if missing, fall back to English.
  /// - english_name is OPTIONAL (only sent if non-empty).
  Map<String, dynamic> toApiRecord() {
    final ar = (nameAr ?? '').trim();
    final en = (nameEn ?? '').trim();

    final map = <String, dynamic>{
      'name'                 : ar.isNotEmpty ? ar : (en.isNotEmpty ? en : null),
      'full_arabic_name'     : ar.isNotEmpty ? ar : null,
      if (en.isNotEmpty) 'full_english_name' : en,
      'birthday'             : birthday == null ? null : _fmtDate(birthday!),
      'identification_id'    : identificationId?.trim(),
      'staff_relation_type'  : staffRelationType?.trim(),
      'email_from'           : workEmail?.trim(),
      'partner_mobile'       : workPhone?.trim(),
      // (Removed) categories/classification per requirements

      // Job mapping
      if (jobFamilyId != null) 'job_family_id' : jobFamilyId,
      if (jobId != null) 'job_id' : jobId,
      if (jobNumberId != null) 'job_number_id' : jobNumberId,

      // Yakeen flag
      'yaqeen_verification'  : verified == true,

      // Extra Yakeen-derived fields
      if ((statusDescAr ?? '').isNotEmpty) 'status_desc_ar'       : statusDescAr,
      if ((occupationCode ?? '').isNotEmpty) 'occupation_code'    : occupationCode,
      if ((preSamisIssueDate ?? '').isNotEmpty) 'pre_samis_issue_date' : _dateOnly(preSamisIssueDate),
      if ((idExpired ?? '').isNotEmpty) 'id_expired'              : _dateOnly(idExpired),
      if ((cityOfBirth ?? '').isNotEmpty) 'city_of_birth'         : cityOfBirth,
      if ((gender ?? '').isNotEmpty) 'gender'                     : gender,
      if ((hijriBirthday ?? '').isNotEmpty) 'hijri_birthday'      : hijriBirthday,
    };

    // strip null/empty
    map.removeWhere((k, v) =>
    v == null ||
        (v is String && v.trim().isEmpty) ||
        (v is List && v.isEmpty));

    return map;
  }
}

String? _dateOnly(String? iso) {
  if (iso == null) return null;
  final s = iso.trim();
  if (s.isEmpty) return null;
  final m = RegExp(r'^(\d{4}-\d{2}-\d{2})').firstMatch(s);
  return m != null ? m.group(1) : s;
}



