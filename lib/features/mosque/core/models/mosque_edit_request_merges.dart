import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_model.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

import 'mosque_local.dart';

/// Keep the model lean; place all merge code here.
extension MosqueEditRequestMerges on MosqueEditRequestModel {
  /// Router used by the controller (tabKey → specific merger)
  void mergeByTabKey(String tabKey, Map<String, dynamic> response) {
    // Unwrap { status, data: {...} } or accept a flat map
    final Map<String, dynamic> data = (response['data'] is Map)
        ? Map<String, dynamic>.from(response['data'])
        : Map<String, dynamic>.from(response);

    String? _cleanApiBase64(dynamic v) {
      if (v == null || v == false) return null;
      var s = v.toString().trim();
      if (s.isEmpty) return null;

      if ((s.startsWith("b'") && s.endsWith("'")) ||
          (s.startsWith('b"') && s.endsWith('"'))) {
        s = s.substring(2, s.length - 1);
      }

      final k = s.indexOf('base64,');
      if (k != -1) s = s.substring(k + 7);

      s = s.replaceAll(RegExp(r'\s'), '');
      return s;
    }

    switch (tabKey) {
      case 'basic_info':
        _mergeBasicInfo(data);
        break;
      case 'mosque_address':
        _mergeAddress(data);
        break;
      case 'mosque_condition':
        _mergeCondition(data);
        break;
      case 'architectural_structure':
        _mergeArchitecture(data);
        break;
      case 'men_prayer_section':
        _mergeMenSection(data);
        break;
      case 'women_prayer_section':
        _mergeWomenSection(data);
        break;
      case 'imams_muezzins_details':
        _mergeResidences(data);
        break;
      case 'mosque_facilities':
        _mergeFacilities(data);
        break;
      case 'mosque_land':
        _mergeLand(data);
        break;
      case 'audio_and_electronics':
        _mergeAudioElectronics(data);
        break;
      case 'safety_equipment':
        _mergeSafety(data);
        break;
      case 'maintenance':
        _mergeMaintenance(data);
        break;
      case 'historical_mosques':
        _mergeHistorical(data);
        break;
      case 'qr_code_panel':
        _mergeQrCode(data);
        break;
      case 'meters':
        _mergeMeters(data);
        break;
      default:
      // no-op for unknown keys
        break;
    }

    updatedAt = DateTime.now();
    // status = SyncStatus.pending;
  }

  // ---------- helpers ----------
  T? _nullIfFalse<T>(dynamic v) => (v == false) ? null : v as T?;
  int? _toInt(dynamic v) => JsonUtils.toInt(v) ?? JsonUtils.toDouble(v)?.round();
  double? _toDouble(dynamic v) => JsonUtils.toDouble(v);
  String? _toText(dynamic v) => JsonUtils.toText(v);
  DateTime? _toDateTime(dynamic v) => JsonUtils.toDateTime(v);
  List<int>? _toList(dynamic v) => JsonUtils.toList(v);

  // ---------- mergers by tab ----------

  // Basic Info
  void _mergeBasicInfo(Map<String, dynamic> json) {
    number = _toText(json['number']) ?? number;

    final p = (payload ??= <String, dynamic>{});

    // mosque_id → {id,name}
    final mosqueObj = json['mosque_id'];
    serverId = serverId ?? JsonUtils.getObjectId(mosqueObj);
    p['mosque_id'] = JsonUtils.getObjectId(mosqueObj);
    p['mosque_name'] = JsonUtils.getObjectName(mosqueObj);
    name = JsonUtils.getObjectName(mosqueObj) ?? name;
    serverId=JsonUtils.getObjectId(mosqueObj);
    // classification_id → {id,name}
    final clsObj = json['classification_id'];
    classificationId = JsonUtils.getObjectId(clsObj) ?? classificationId;
    classification = JsonUtils.getObjectName(clsObj) ?? classification;
    p['classification_name'] = JsonUtils.getObjectName(clsObj);
    // texts
    observationText = JsonUtils.toText(json['observation_text']) ?? observationText;
    refuseReason    = JsonUtils.toText(json['refuse_reason']) ?? refuseReason;
    mosqueName    = JsonUtils.toText(json['mosque_name']) ?? mosqueName;
    description    = JsonUtils.toText(json['description']) ?? description;
    mosqueCondition = JsonUtils.toText(json['mosque_condition']) ?? mosqueCondition;



    // mosque_type_id → {id,name} or false
    final typeObj = _nullIfFalse(json['mosque_type_id']);
    mosqueTypeId = JsonUtils.getObjectId(typeObj) ?? mosqueTypeId;
    mosqueType = JsonUtils.getObjectName(typeObj) ?? mosqueType;
    p['mosque_type_name'] = JsonUtils.getObjectName(typeObj);
    
          // New location fields - handle false values as null
      isInsidePrison = _toText(_nullIfFalse(json['is_inside_prison'])) ?? isInsidePrison;
      isInsideHospital = _toText(_nullIfFalse(json['is_inside_hospital'])) ?? isInsideHospital;
      isInsideGovernmentHousing = _toText(_nullIfFalse(json['is_inside_government_housing'])) ?? isInsideGovernmentHousing;
      isInsideRestrictedGovEntity = _toText(_nullIfFalse(json['is_inside_restricted_gov_entity'])) ?? isInsideRestrictedGovEntity;
      landOwner = _toText(_nullIfFalse(json['land_owner'])) ?? landOwner;
  }
  // Address
  void _mergeAddress(Map<String, dynamic> json) {
    // unwrap object-or-false → ids
    final regionObj = _nullIfFalse(json['region_id']);
    final cityObj   = _nullIfFalse(json['city_id']);
    final centerObj = _nullIfFalse(json['moia_center_id']);
    final distObj   = _nullIfFalse(json['district']);

    // ids
    regionId     = JsonUtils.getObjectId(regionObj) ?? regionId;
    region     = JsonUtils.getObjectName(regionObj) ?? region;
    cityId       = JsonUtils.getObjectId(cityObj)   ?? cityId;
    city       = JsonUtils.getObjectName(cityObj)   ?? city;
    moiaCenterId = JsonUtils.getObjectId(centerObj) ?? moiaCenterId;
    moiaCenter = JsonUtils.getObjectName(centerObj) ?? moiaCenter;
    districtId   = JsonUtils.getObjectId(distObj)   ?? districtId;
    district   = JsonUtils.getObjectName(distObj)   ?? district;

    // scalars
    street       = _toText(json['street'])                      ?? street;
    placeId      = _toText(_nullIfFalse(json['place_id']))      ?? placeId;
    globalCode   = _toText(_nullIfFalse(json['global_code']))   ?? globalCode;
    compoundCode = _toText(_nullIfFalse(json['compound_code'])) ?? compoundCode;
    latitude     = _toDouble(_nullIfFalse(json['latitude']))    ?? latitude;
    longitude    = _toDouble(_nullIfFalse(json['longitude']))   ?? longitude;

    // cache human-readable labels in payload for the UI
    final p = (payload ??= <String, dynamic>{});
    final regionName = JsonUtils.getObjectName(regionObj);
    final cityName   = JsonUtils.getObjectName(cityObj);
    final centerName = JsonUtils.getObjectName(centerObj);
    final distName   = JsonUtils.getObjectName(distObj);

    if (regionName != null && regionName.isNotEmpty) p['region_name'] = regionName;
    if (cityName   != null && cityName.isNotEmpty)   p['city_name']   = cityName;
    if (centerName != null && centerName.isNotEmpty) p['moia_center_name'] = centerName;
    if (distName   != null && distName.isNotEmpty)   p['district_name']    = distName;

    // keep extra flags (if backend sends them)
    if (json.containsKey('is_another_neighborhood')) {
      p['is_another_neighborhood'] = json['is_another_neighborhood'];
    }
    if (json.containsKey('another_neighborhood_char')) {
      p['another_neighborhood_char'] = json['another_neighborhood_char'];
    }
  }


  // Condition
  void _mergeCondition(Map<String, dynamic> json) {
    mosqueCondition     = _toText(_nullIfFalse(json['mosque_condition']))     ?? mosqueCondition;
    buildingMaterial    = _toText(_nullIfFalse(json['building_material']))    ?? buildingMaterial;
    urbanCondition      = _toText(_nullIfFalse(json['urban_condition']))      ?? urbanCondition;
    dateMaintenanceLast = _toText(_nullIfFalse(json['date_maintenance_last']))?? dateMaintenanceLast;

    // Some APIs also echo images here; pick them if present
    image      = _toText(json['image_1920'] ?? json['image']) ?? image;
    outerImage= _toText(json['outer_image'])?? outerImage;
  }

  // Architectural Structure
  void _mergeArchitecture(Map<String, dynamic> json) {
    externalDoorsNumbers = _toInt(json['external_doors_numbers']) ?? externalDoorsNumbers;
    internalDoorsNumber  = _toInt(json['internal_doors_number'])  ?? internalDoorsNumber;
    numMinarets          = _toInt(json['num_minarets'])           ?? numMinarets;
    numFloors            = _toInt(json['num_floors'])             ?? numFloors;
    hasBasement          = _toText(json['has_basement'])          ?? hasBasement;
    mosqueRooms          = _toInt(json['mosque_rooms'])           ?? mosqueRooms;
  }

  // Men Prayer Section
  void _mergeMenSection(Map<String, dynamic> json) {
    // backend sometimes sends doubles → convert safely
    final rows = _toInt(json['friday_prayer_rows']);
    fridayPrayerRows     = rows ?? fridayPrayerRows;

    rowMenPrayingNumber  = _toInt(json['row_men_praying_number'])          ?? rowMenPrayingNumber;
    lengthRowMenPraying  = _toDouble(json['length_row_men_praying'])       ?? lengthRowMenPraying;
    capacity             = _toInt(json['capacity'])                         ?? capacity;
    menPrayerAvgAttendance = _toText(_nullIfFalse(json['men_prayer_avg_attendance'])) ?? menPrayerAvgAttendance;
    // COMMENTED OUT: mosque_in_military_zone field
    // mosqueInMilitaryZone = _toText(_nullIfFalse(json['mosque_in_military_zone'])) ?? mosqueInMilitaryZone;
    toiletMenNumber      = _toInt(json['toilet_men_number'])                ?? toiletMenNumber;
  }

  // Women Prayer Section
  void _mergeWomenSection(Map<String, dynamic> json) {
    hasWomenPrayerRoom      = _toText(json['has_women_prayer_room'])        ?? hasWomenPrayerRoom;
    rowWomenPrayingNumber   = _toInt(json['row_women_praying_number'])      ?? rowWomenPrayingNumber;
    lengthRowWomenPraying   = _toDouble(json['length_row_women_praying'])   ?? lengthRowWomenPraying;
    womenPrayerRoomCapacity = _toInt(json['women_prayer_room_capacity'])    ?? womenPrayerRoomCapacity;
    toiletWomanNumber       = _toInt(json['toilet_woman_number'])           ?? toiletWomanNumber;
  }

  // Imam & Muezzin Residences
  void _mergeResidences(Map<String, dynamic> json) {
    residenceForImam          = _toText(json['residence_for_imam'])            ?? residenceForImam;
    imamResidenceType         = _toText(_nullIfFalse(json['imam_residence_type'])) ?? imamResidenceType;
    imamResidenceLandArea     = _toDouble(json['imam_residence_land_area'])    ?? imamResidenceLandArea;

    residenceForMouadhin      = _toText(json['residence_for_mouadhin'])        ?? residenceForMouadhin;
    muezzinResidenceType      = _toText(_nullIfFalse(json['muezzin_residence_type'])) ?? muezzinResidenceType;
    muezzinResidenceLandArea  = _toDouble(json['muezzin_residence_land_area']) ?? muezzinResidenceLandArea;
  }

  // Facilities
  void _mergeFacilities(Map<String, dynamic> json) {
    isOtherAttachment             = _toText(json['is_other_attachment'])             ?? isOtherAttachment;
    libraryExist                  = _toText(json['library_exist'])                   ?? libraryExist;
    lecturesHall                  = _toText(json['lectures_hall'])                   ?? lecturesHall;
    isThereInvestmentBuilding     = _toText(json['is_there_investment_building'])    ?? isThereInvestmentBuilding;
    isThereHeadquarters           = _toText(json['is_there_headquarters'])           ?? isThereHeadquarters;
    isThereQuranMemorizationMen   = _toText(json['is_there_quran_memorization_men']) ?? isThereQuranMemorizationMen;
    isThereQuranMemorizationWomen = _toText(json['is_there_quran_memorization_women']) ?? isThereQuranMemorizationWomen;
    hasWashingMachine             = _toText(json['has_washing_machine'])             ?? hasWashingMachine;
    carsParking                   = _toText(json['cars_parking'])                    ?? carsParking;
    ministryAuthorized            = _toText(json['ministry_authorized'])             ?? ministryAuthorized;
    
    // ⚠️ CRITICAL: Handle property_type_ids with full deduplication and ID preservation
    // This is called by mergeByTabKey('mosque_facilities') during lazy tab loading
    if (json['property_type_ids'] is List) {
      // Delegate to the main mergeJson logic to ensure consistent handling
      mergeJson({'property_type_ids': json['property_type_ids']});
    }
  }

  // Land Information
  void _mergeLand(Map<String, dynamic> json) {
    // API sometimes returns strings like "0"
    mosqueLandArea   = _toText(_nullIfFalse(json['land_area']))        ?? mosqueLandArea;
    nonBuildingArea  = _toDouble(_nullIfFalse(json['non_building_area']))?? nonBuildingArea;
    roofedArea       = _toDouble(_nullIfFalse(json['roofed_area']))      ?? roofedArea;
    isFreeArea       = _toText(_nullIfFalse(json['is_free_area']))       ?? isFreeArea;
    freeArea         = _toDouble(_nullIfFalse(json['free_area']))        ?? freeArea;

    hasDeed          = _toText(_nullIfFalse(json['has_deed']))           ?? hasDeed;
    isThereLandTitle = _toText(_nullIfFalse(json['is_there_land_title']))?? isThereLandTitle;

    noPlanned        = _toDouble(_nullIfFalse(json['no_planned']))       ?? noPlanned;
    pieceNumber      = _toDouble(_nullIfFalse(json['piece_number']))     ?? pieceNumber;

    mosqueOpeningDate= _toText(_nullIfFalse(json['mosque_opening_date'])) ?? mosqueOpeningDate;
  }

  // Audio & Electronics
  void _mergeAudioElectronics(Map<String, dynamic> json) {
    hasAirConditioners     = _toText(json['has_air_conditioners'])      ?? hasAirConditioners;
    acType                 = _toList(_nullIfFalse(json['ac_type']))     ?? acType;
    numAirConditioners     = _toInt(json['num_air_conditioners'])       ?? numAirConditioners;

    hasInternalCamera      = _toText(json['has_internal_camera'])       ?? hasInternalCamera;
    numLightingInside      = _toInt(json['num_lighting_inside'])        ?? numLightingInside;
    internalSpeakerNumber  = _toInt(json['internal_speaker_number'])    ?? internalSpeakerNumber;
    externalHeadsetNumber  = _toInt(json['external_headset_number'])    ?? externalHeadsetNumber;
  }

  // Safety Equipment
  void _mergeSafety(Map<String, dynamic> json) {
    hasFireExtinguishers = _toText(json['has_fire_extinguishers']) ?? hasFireExtinguishers;
    hasFireSystemPumps   = _toText(json['has_fire_system_pumps'])  ?? hasFireSystemPumps;
  }

  // Maintenance
  void _mergeMaintenance(Map<String, dynamic> json) {
    maintenanceResponsible = _toText(_nullIfFalse(json['maintenance_responsible'])) ?? maintenanceResponsible;
   // maintenancePerson      = _toText(_nullIfFalse(json['maintenance_person']))      ?? maintenancePerson;
    //companyName            = _toText(json['company_name'])                          ?? companyName;
    //contractNumber         = _toText(json['contract_number'])                       ?? contractNumber;
  }

  // Historical
  void _mergeHistorical(Map<String, dynamic> json) {
    mosqueHistorical            = _toText(json['mosque_historical'])             ?? mosqueHistorical;
    princeProjectHistoricMosque = _toText(json['prince_project_historic_mosque'])?? princeProjectHistoricMosque;
  }

  // QR Code Information
  void _mergeQrCode(Map<String, dynamic> json) {
    isQrCodeExist    = _toText(json['is_qr_code_exist'])   ?? isQrCodeExist;
    qrPanelNumbers   = _toInt(json['qr_panel_numbers'])    ?? qrPanelNumbers;
    isPanelReadable  = _toText(json['is_panel_readable'])  ?? isPanelReadable;
    mosqueDataCorrect= _toText(json['mosque_data_correct'])?? mosqueDataCorrect;
    isMosqueNameQr   = _toText(json['is_mosque_name_qr'])  ?? isMosqueNameQr;
    qrCodeNotes      = _toText(json['qr_code_notes'])      ?? qrCodeNotes;

    // Often comes as a separate download/upload flow; keep if present
    qrImage          = _toText(json['qr_image'])           ?? qrImage;
  }

  // Meters
  void _mergeMeters(Map<String, dynamic> json) {
    // Can be list<int> or list<map>; keep both safely
    if (json['meter_ids'] is List) {
      final list = List.from(json['meter_ids'] as List);
      if (list.isNotEmpty && list.first is Map) {
        (payload ??= {})['meter_ids'] = list;
      } else {
        meterIds = list.map((e) => _toInt(e)).whereType<int>().toList();
      }
    }
    if (json['water_meter_ids'] is List) {
      final list = List.from(json['water_meter_ids'] as List);
      if (list.isNotEmpty && list.first is Map) {
        (payload ??= {})['water_meter_ids'] = list;
      } else {
        waterMeterIds = list.map((e) => _toInt(e)).whereType<int>().toList();
      }
    }
  }
}
const int kEditReqDraftStageId = 469;

// tiny helper for safe UI strings
String _nz(String? s, [String fallback = '—']) {
  final v = s?.trim();
  return (v == null || v.isEmpty) ? fallback : v;
}

extension MosqueEditRequestView on MosqueEditRequestModel {
  String get displayTitle {
    final n = JsonUtils.toText(name);
    if ((n ?? '').isNotEmpty) return n!;
    final p = JsonUtils.toText(payload?['mosque_name']);
    return (p ?? '').isNotEmpty ? p! : '—';
  }

  String get displayNumber =>
      (JsonUtils.toText(number) ??
          JsonUtils.toText(payload?['number']) ??
          '');

  String get displayCity =>
      (JsonUtils.toText(city) ??
          JsonUtils.toText(payload?['city_name']) ??
          '');

  String get displayStage =>
      (JsonUtils.toText(payload?['stage_name']) ??
          JsonUtils.toText(payload?['stage']) ??
          (workflowState ?? ''));

  String get displayRequestIdStr {
    final id = JsonUtils.toInt(payload?['request_id']) ??
        JsonUtils.toInt(payload?['id']) ??
        serverId;
    return id == null ? '' : '#$id';
  }

  /// For navigation (read-only screens etc.)
  int get navMosqueId =>
      JsonUtils.toInt(payload?['mosque_id']) ?? (serverId ?? 0);

  Map<String, dynamic> get _p => Map<String, dynamic>.from(payload ?? const {});

  /// Stage id can come in multiple shapes
  int? get stageId {
    final raw = _p['stage_id'] ??
        _p['stageId'] ??
        (_p['stage'] is Map ? (_p['stage'] as Map)['id'] : null);

    if (raw is int) return raw;
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  /// Stage name from payload or workflowState fallback
  String get stageName {
    final raw = _p['stage_name'] ??
        (_p['stage'] is Map ? (_p['stage'] as Map)['name'] : null) ??
        workflowState;
    return (raw ?? '').toString();
  }

  /// Draft if:
  ///  - NO stage at all (pure local draft), OR
  ///  - stageId == kEditReqDraftStageId, OR
  ///  - name says Draft (Arabic handled)
  bool get isDraft {
    final id = stageId;
    final name = stageName.trim().toLowerCase();

    if (id == null && name.isEmpty) return true; // local draft
    if (id != null) return id == kEditReqDraftStageId;

    return name == 'draft' || name == 'مسودة';
  }

  /// Handy UI strings
  String get displayName   => _nz(mosqueName, localId);
  String get displaySub     => _nz(mosqueNumber, _nz(mosqueIdStr));
  String get displayChip    => _nz(stageName, 'Draft');
}

