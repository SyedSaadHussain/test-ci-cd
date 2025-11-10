import 'package:flutter/foundation.dart';
import '../../core/models/mosque_local.dart';

/// ---- Small helpers ---------------------------------------------------------
bool _isBlank(String? s) => s == null || s.trim().isEmpty;
bool _isYes(String? v) {
  final s = (v ?? '').toLowerCase();
  return s == 'yes' || s == 'true' || s == '1';
}
bool _isPos(num? n) => n != null && n > 0;
double? _tryParseDouble(String? s) {
  if (s == null || s.trim().isEmpty) return null;
  return double.tryParse(s);
}
bool _isExistingOrAbandoned(String? code) =>
    code == 'existing_mosque' || code == 'abandoned_mosque';

T? _p<T>(MosqueLocal m, String key) => m.payload?[key] as T?;

bool _truthy(dynamic v) {
  if (v is bool) return v;
  if (v is num)  return v != 0;
  if (v is String) {
    final s = v.toLowerCase().trim();
    return s == '1' || s == 'true' || s == 'yes';
  }
  return false;
}

String? _strOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

List<Map<String, dynamic>> _asMapList(dynamic v) {
  if (v is List) {
    return v.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
  }
  return const <Map<String, dynamic>>[];
}


/// ---- Model for an issue ----------------------------------------------------
class ValidationIssue {
  final String field;   // e.g., 'name'
  final String message; // e.g., 'Name is required'
  final String tabKey;  // e.g., 'basic_info'
  const ValidationIssue({required this.field, required this.message, required this.tabKey});
}

/// Message label per field (for consistent errors)
const Map<String, String> _label = {
  // basic_info
  'name': 'Name',
  'observer_ids': 'Observers',
  'classification': 'Classification',
  'mosque_type_id' : 'Mosque type',

  // address
  'region_id': 'Region',
  'city_id': 'City',
  'moia_center_id': 'MOIA Center',
  'street': 'Street',
  'another_neighborhood_char': 'Other neighborhood name',
  'free_area': 'free area',
  'mosque_opening_date': 'Opening Year',
  'is_employee' : 'Is Employee',

  // condition
  'mosque_condition': 'Mosque condition',
  'building_material': 'Type of building',
  'urban_condition': 'Urban condition',
  'date_maintenance_last': 'Date of last renovation / maintenance',
  'image': 'Inner Mosque photo',
  'outer_image': 'Outer photo',

  // images / qr
  //'outer_image': 'Outer image',
  'is_qr_code_exist': 'QR code existence',
  'qr_panel_numbers': 'Number of QR panels',
  'is_mosque_name_qr': '“Name on QR”',
  'qr_image': 'QR image',
  'is_panel_readable': 'Panel readable',
  'mosque_data_correct': 'Data correctness',
  'num_qr_code_panels': 'Number of QR panels',

  // AC / electronics
  'has_air_conditioners': 'Has air conditioners',
  'num_air_conditioners': 'Number of ACs',
  'ac_type': 'AC type',
  'is_electronic_instrument': 'Electronic instrument',

  // structure
  'external_headset_number': 'External headset number',
  'internal_speaker_number': 'Internal speaker number',
  'num_lighting_inside': 'Lighting (inside)',
  'num_floors': 'Number of floors',
  'external_doors_numbers': 'External doors',
  'num_minarets': 'Number of minarets',
  'has_basement': 'Basement',
  'mosque_rooms': 'Rooms',
  'internal_doors_number': 'Internal doors',
  'land_area': 'Land area',
  'is_free_area': 'Is free area',

  // men / women sections
  'row_men_praying_number': 'Men rows',
  'length_row_men_praying': 'Men row length',
  'friday_prayer_rows': 'friday Prayer Rows',
  'has_women_prayer_room': 'Has women prayer room',
  'length_row_women_praying': 'Women row length',
  //'number_women_rows': 'Women rows',
  'toilet_woman_number': 'Women toilets',
  'women_prayer_room_capacity': 'Women Room Capacity',

  // residences
  'residence_for_imam': 'Residence for imam',
  'imam_residence_type': 'Imam residence type',
  'imam_residence_land_area': 'Imam residence land area',
  'residence_for_mouadhin': 'Residence for muezzin',
  'muezzin_residence_type': 'Muezzin residence type',
  'muezzin_residence_land_area': 'Muezzin residence land area',

  // water/electric meters
  'meter_ids': 'Electric meters',
  'water_meter_ids': 'Water meters',
  'meter_number': 'Meter number',
  'attachment_id': 'Attachment',

  // maintenance
  'maintenance_responsible': 'Maintenance responsible',
  //'maintenance_person': 'Maintenance person',
  //'company_name': 'Company name',
  //'contract_number': 'Contract number',

  // “other attachments”
  'is_other_attachment': 'Other attachments',
  'library_exist': 'Library',
  'lectures_hall': 'Lectures hall',
  'is_there_investment_building': 'Investment building',
  'is_there_headquarters': 'Headquarters',
  'is_there_quran_memorization_men': 'Quran memorization (men)',
  'is_there_quran_memorization_women': 'Quran memorization (women)',
  'has_washing_machine': 'Washing machine',
  'cars_parking': 'Cars parking',
  'ministry_authorized': 'Ministry authorized',
  'permitted_from_ministry': 'Permitted from ministry',

  // geo
  // 'place_id': 'Place Id',
  // 'global_code': 'Global code',
  // 'compound_code': 'Compound code',

  // misc/historic
  'capacity': 'Capacity',
  'toilet_men_number': 'Men toilets',
  'mosque_historical': 'Historical mosque',
  'prince_project_historic_mosque': 'Prince project historic mosque',
};

/// Field -> tab mapping (used by sheet & tab jump)
const Map<String, String> _fieldTab = {
  // basic_info
  // 'name': 'basic_info',
  // 'observer_ids': 'basic_info',
  // 'classification': 'basic_info',
  // 'is_employee' : 'employee_info',
  // 'mosque_type_id' : 'basic_info',

  // address
  // 'region_id': 'mosque_address',
  // 'city_id': 'mosque_address',
  // 'moia_center_id': 'mosque_address',
  // 'district_id' : 'mosque_address',
  // 'street': 'mosque_address',
  // 'another_neighborhood_char': 'mosque_address',

  'mosque_opening_date': 'mosque_land',

  // condition (high level)
  // 'mosque_condition': 'mosque_condition',
  // 'building_material': 'mosque_condition',
  // 'urban_condition': 'mosque_condition',
  // 'date_maintenance_last': 'mosque_condition',
  // 'image': 'mosque_condition',
  // 'outer_image': 'mosque_condition',

  // info / electronics / qr
  // 'outer_image': 'mosque_info',
  'is_qr_code_exist': 'qr_code_panel',
  'qr_panel_numbers': 'qr_code_panel',
  'is_mosque_name_qr': 'qr_code_panel',
  'qr_image': 'qr_code_panel',
  'is_panel_readable': 'qr_code_panel',
  'mosque_data_correct': 'qr_code_panel',
 // 'num_qr_code_panels': 'qr_code_panel',
  'has_air_conditioners': 'audio_and_electronics',
  'num_air_conditioners': 'audio_and_electronics',
  'ac_type': 'audio_and_electronics',
  'is_electronic_instrument': 'maintenance',

  // structure
  'external_headset_number': 'audio_and_electronics',
  'internal_speaker_number': 'audio_and_electronics',
  'num_lighting_inside': 'audio_and_electronics',
  'num_floors': 'architectural_structure',
  'external_doors_numbers': 'architectural_structure',
  'num_minarets': 'architectural_structure',
  'has_basement': 'architectural_structure',
  'mosque_rooms': 'architectural_structure',
  'internal_doors_number': 'architectural_structure',
  'land_area': 'mosque_land',
  'is_free_area': 'mosque_land',
  'free_area': 'mosque_land',
  // men prayer section
  'row_men_praying_number': 'men_prayer_section',
  'length_row_men_praying': 'men_prayer_section',
  'toilet_men_number': 'men_prayer_section',
  'capacity': 'men_prayer_section',
  'friday_prayer_rows' : 'men_prayer_section',

  //women prayer section
  'has_women_prayer_room': 'women_prayer_section',
  'length_row_women_praying': 'women_prayer_section',
  //'number_women_rows': 'women_prayer_section',
  'toilet_woman_number': 'women_prayer_section',
  'women_prayer_room_capacity': 'women_prayer_section',


  // residences
  // 'residence_for_imam': 'mosque_info',
  // 'imam_residence_type': 'mosque_info',
  'imam_residence_land_area': 'imams_muezzins_details',
  // 'residence_for_mouadhin': 'mosque_info',
  // 'muezzin_residence_type': 'mosque_info',
  'muezzin_residence_land_area': 'imams_muezzins_details',

  // maintenance
  // 'maintenance_responsible': 'maintenance',
  // 'maintenance_person': 'maintenance',
  // 'company_name': 'maintenance',
  // 'contract_number': 'maintenance',

  // other attachments
  'is_other_attachment': 'mosque_facilities',
  'library_exist': 'mosque_facilities',
  'lectures_hall': 'mosque_facilities',
  'is_there_investment_building': 'mosque_facilities',
  'is_there_headquarters': 'mosque_facilities',
  'is_there_quran_memorization_men': 'mosque_facilities',
  'is_there_quran_memorization_women': 'mosque_facilities',
  'has_washing_machine': 'mosque_facilities',
  'cars_parking': 'mosque_facilities',
  'ministry_authorized': 'mosque_facilities',
  'permitted_from_ministry': 'mosque_info',

  // geo
  // 'place_id': 'geo_location',
  // 'global_code': 'geo_location',
  // 'compound_code': 'geo_location',

  //meter tab
  'meter_ids': 'meters',
  'water_meter_ids': 'meters',
  'meter_number' : 'meters',

  // historic
  'mosque_historical': 'mosque_info',
  'prince_project_historic_mosque': 'mosque_info',
};

// Tabs enforced only when condition is existing/abandoned.
// (We always allow basic_info and mosque_address to pass.)
const Set<String> _tabsRequiringExistingOrAbandoned = {
  'mosque_condition',
  'architectural_structure',
  'men_prayer_section',
  'women_prayer_section',
  'mosque_info',
  'maintenance',
  'mosque_land',
  'mosque_facilities',
  'geo_location',
  'historical_mosques',
  'imams_muezzins_details',
  'safety_equipment',
  'audio_and_electronics',
  'meters',
  'qr_code_panel',
};

String _tabOf(String field) {
  // Handle dynamic list keys like: meter_ids[0].attachment_id
  if (field.startsWith('meter_ids[') || field.startsWith('water_meter_ids[')) {
    return 'meters';
  }
  return _fieldTab[field] ?? 'basic_info';
}

String _msg(String field, [String suffix = 'مطلوب']) =>
    '${_label[field] ?? field} $suffix';

/// Per-field validator signature
typedef FieldValidator = String? Function(MosqueLocal m);

class MosqueValidator {
  /// One place to define all field-level rules.
  /// Return `null` when the field is valid.
  static final Map<String, FieldValidator> _v = <String, FieldValidator>{
    // -------- BASIC INFO --------
    // 'name': (m) => _isBlank(m.name) ? _msg('name') : null,
    // 'observer_ids': (m) {
    //   final ids = m.observerIds ??
    //       (_p<List<dynamic>>(m, 'observer_ids')?.cast<int>() ?? const <int>[]);
    //   return ids.isEmpty ? _msg('observer_ids') : null;
    // },
    // 'classification': (m) => (m.classificationId == null && _isBlank(m.classification))
    //     ? _msg('classification')
    //     : null,
    // 'mosque_type_id': (m) => (m.mosqueTypeId == null && _isBlank(m.mosqueType))
    //     ? _msg('mosque_type_id')
    //     : null,

    // -------- ADDRESS --------
    // 'region_id': (m) => (m.regionId == null) ? _msg('region_id') : null,
    // 'city_id': (m) => (m.cityId == null) ? _msg('city_id') : null,
    // 'district_id' : (m) => (m.districtId == null) ? _msg('district_id') : null,
    // 'moia_center_id': (m) {
    //   final id = m.moiaCenterId ?? _p<int>(m, 'moia_center_id');
    //   final hasId = id != null && id != 0;
    //   final hasLabel = !_isBlank(m.moiaCenter);
    //   return (hasId && hasLabel) ? null : _msg('moia_center_id');
    // },
    // 'street': (m) => _isBlank(m.street) ? _msg('street') : null,
    // 'another_neighborhood_char': (m) {
    //   final another = _isYes('${_p(m, 'is_another_neighborhood')}');
    //   final txt = (_p(m, 'another_neighborhood_char') ?? '').toString();
    //   return another && _isBlank(txt) ? _msg('another_neighborhood_char') : null;
    // },

    'free_area': (m) => _isYes(m.isFreeArea) && !_isPos(m.freeArea)
        ? _msg('free_area')
        : null,
    'mosque_opening_date': (m) =>
    _isBlank(m.mosqueOpeningDate)  // Now a string field ('after_1441', 'prophet', etc.)
        ? _msg('mosque_opening_date')
        : null,

    // -------- CONDITION / STRUCTURE SWITCHES --------
    // 'mosque_condition': (m) => _isBlank(m.mosqueCondition) ? _msg('mosque_condition') : null,
    // 'building_material': (m) =>
    // _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.buildingMaterial)
    //     ? _msg('building_material')
    //     : null,
    // 'urban_condition': (m) =>
    // _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.urbanCondition)
    //     ? _msg('urban_condition')
    //     : null,
    //
    // // -------- IMAGES / QR --------
    // 'outer_image': (m) =>
    // _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.outerImage)
    //     ? _msg('outer_image')
    //     : null,
    // 'image': (m) => _isBlank(m.image) ? _msg('image') : null,


    'is_qr_code_exist': (m) =>
    _isBlank(m.isQrCodeExist) ? _msg('is_qr_code_exist') : null,

    'qr_panel_numbers': (m) => _isExistingOrAbandoned(m.mosqueCondition) &&
    _isYes(m.isQrCodeExist) && !_isPos(m.qrPanelNumbers)
        ? _msg('qr_panel_numbers')
        : null,
    // 'qr_panel_numbers': (m) =>
    // _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.qrPanelNumbers)
    //     ? _msg('qr_panel_numbers')
    //     : null,

    'is_mosque_name_qr': (m) =>
    _isYes(m.isQrCodeExist) && _isBlank(m.isMosqueNameQr)
        ? _msg('is_mosque_name_qr')
        : null,
    'qr_image': (m) =>
    _isYes(m.isQrCodeExist) && _isBlank(m.qrImage)
        ? _msg('qr_image')
        : null,
    'is_panel_readable': (m) =>
    _isYes(m.isQrCodeExist) && _isBlank(m.isPanelReadable)
        ? _msg('is_panel_readable')
        : null,
    'mosque_data_correct': (m) =>
    _isYes(m.isQrCodeExist) && _isBlank(m.mosqueDataCorrect)
        ? _msg('mosque_data_correct')
        : null,


    // -------- AC / ELECTRONIC INSTRUMENT --------
    'has_air_conditioners': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.hasAirConditioners)
        ? _msg('has_air_conditioners')
        : null,
    'num_air_conditioners': (m) =>
    _isYes(m.hasAirConditioners) && !_isPos(m.numAirConditioners)
        ? _msg('num_air_conditioners')
        : null,
    'ac_type': (m) =>
    _isYes(m.hasAirConditioners) && (m.acType == null || (m.acType is List && m.acType!.isEmpty))
        ? _msg('ac_type')
        : null,
    'is_electronic_instrument': (m) =>
    _isBlank('${_p(m, 'is_electronic_instrument')}')
        ? _msg('is_electronic_instrument')
        : null,

    // -------- STRUCTURE DETAILS (existing/abandoned) --------
    'external_headset_number': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && (m.externalHeadsetNumber == null || m.externalHeadsetNumber! < 0)
        //!_isPos(m.externalHeadsetNumber)
        ? _msg('external_headset_number')
        : null,
    'internal_speaker_number': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.internalSpeakerNumber)
        ? _msg('internal_speaker_number')
        : null,
    'num_lighting_inside': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.numLightingInside)
        ? _msg('num_lighting_inside')
        : null,
    'num_floors': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.numFloors)
        ? _msg('num_floors')
        : null,
    'external_doors_numbers': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && (m.externalDoorsNumbers == null || m.externalDoorsNumbers! < 0)
        // !_isPos(m.externalDoorsNumbers)
        ? _msg('external_doors_numbers')
        : null,
    'num_minarets': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && (m.numMinarets == null || m.numMinarets! < 0)
        ? _msg('num_minarets')
        : null,
    'has_basement': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.hasBasement)
        ? _msg('has_basement')
        : null,
    'mosque_rooms': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && (m.mosqueRooms == null || m.mosqueRooms! < 0)
        // !_isPos(m.mosqueRooms)
        ? _msg('mosque_rooms')
        : null,
    'internal_doors_number': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.internalDoorsNumber)
        ? _msg('internal_doors_number')
        : null,
    'land_area': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(_tryParseDouble(m.mosqueLandArea))
        ? _msg('land_area')
        : null,
    'is_free_area': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.isFreeArea)
        ? _msg('is_free_area')
        : null,

    // -------- MEN / WOMEN --------
    'has_women_prayer_room': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.hasWomenPrayerRoom)
        ? _msg('has_women_prayer_room')
        : null,
    'length_row_women_praying': (m) =>
    _isYes(m.hasWomenPrayerRoom) && !_isPos(m.lengthRowWomenPraying)
        ? _msg('length_row_women_praying')
        : null,
    // 'number_women_rows': (m) =>
    // _isYes(m.hasWomenPrayerRoom) && !_isPos(m.rowWomenPrayingNumber)
    //     ? _msg('number_women_rows')
    //     : null,
    //fix to carry toilet_woman_number instead of the question is there one
/*
    'is_women_toilets': (m) =>
    _isYes(m.hasWomenPrayerRoom) && _isBlank(m.hasWomenPrayerRoom)
        ? _msg('is_women_toilets')
        : null,
*/
    'toilet_woman_number': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) &&
        (m.toiletWomanNumber == null || m.toiletWomanNumber! < 0) && _isYes(m.hasWomenPrayerRoom)
        ? _msg('toilet_woman_number')
        : null,
    'women_prayer_room_capacity': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.womenPrayerRoomCapacity) && _isYes(m.hasWomenPrayerRoom)
        ? _msg('women_prayer_room_capacity')
        : null,


    'row_men_praying_number': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.rowMenPrayingNumber)
        ? _msg('row_men_praying_number')
        : null,
    'length_row_men_praying': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.lengthRowMenPraying)
        ? _msg('length_row_men_praying')
        : null,

    'imam_residence_land_area': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.imamResidenceLandArea)
        ? _msg('imam_residence_land_area')
        : null,



    // -------- Is Employee --------
    // 'is_employee': (m) => _isBlank(m.payload?['is_employee']?.toString())
    //     ? _msg('is_employee')
    //     : null,

    // -------- RESIDENCES --------
    // 'residence_for_imam': (m) =>
    // _isBlank(m.residenceForImam) ? _msg('residence_for_imam') : null,
    'imam_residence_type': (m) =>
    _isYes(m.residenceForImam) && _isBlank(m.imamResidenceType)
        ? _msg('imam_residence_type')
        : null,
    // 'imam_residence_land_area': (m) =>
    // _isYes(m.residenceForImam) && !_isPos(m.imamResidenceLandArea)
    //     ? _msg('imam_residence_land_area')
    //     : null,


    //
    // 'residence_for_mouadhin': (m) =>
    // _isBlank(m.residenceForMouadhin) ? _msg('residence_for_mouadhin') : null,
    'muezzin_residence_type': (m) =>
    _isYes(m.residenceForMouadhin) && _isBlank(m.muezzinResidenceType)
        ? _msg('muezzin_residence_type')
        : null,

    'muezzin_residence_land_area': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.muezzinResidenceLandArea)
        ? _msg('muezzin_residence_land_area')
        : null,
    // 'muezzin_residence_land_area': (m) =>
    // _isYes(m.residenceForMouadhin) && !_isPos(m.muezzinResidenceLandArea)
    //     ? _msg('muezzin_residence_land_area')
    //     : null,

    // -------- MAINTENANCE --------

    // 'maintenance_responsible': (m) =>
    // _isBlank(m.maintenanceResponsible) ? _msg('maintenance_responsible') : null,
    // 'maintenance_person': (m) =>
    // (m.maintenanceResponsible?.trim() == 'Other' && _isBlank(m.maintenancePerson))
    //     ? _msg('maintenance_person')
    //     : null,
    // 'company_name': (m) =>
    // (m.maintenanceResponsible?.trim() == 'Company' && _isBlank(m.companyName))
    //     ? _msg('company_name')
    //     : null,
    // 'contract_number': (m) =>
    // (m.maintenanceResponsible?.trim() == 'Company' && _isBlank(m.contractNumber))
    //     ? _msg('contract_number')
    //     : null,

    // -------- “OTHER ATTACHMENTS” --------
    'is_other_attachment': (m) =>
    _isBlank(m.isOtherAttachment) ? _msg('is_other_attachment') : null,
    'library_exist': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.libraryExist)
        ? _msg('library_exist')
        : null,
    'lectures_hall': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.lecturesHall)
        ? _msg('lectures_hall')
        : null,
    'is_there_investment_building': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.isThereInvestmentBuilding)
        ? _msg('is_there_investment_building')
        : null,
    'is_there_headquarters': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.isThereHeadquarters)
        ? _msg('is_there_headquarters')
        : null,
    'is_there_quran_memorization_men': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.isThereQuranMemorizationMen)
        ? _msg('is_there_quran_memorization_men')
        : null,
    'is_there_quran_memorization_women': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.isThereQuranMemorizationWomen)
        ? _msg('is_there_quran_memorization_women')
        : null,
    'has_washing_machine': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.hasWashingMachine)
        ? _msg('has_washing_machine')
        : null,
    'cars_parking': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.carsParking)
        ? _msg('cars_parking')
        : null,
    'ministry_authorized': (m) =>
    _isYes(m.isOtherAttachment) && _isBlank(m.ministryAuthorized)
        ? _msg('ministry_authorized')
        : null,

    // -------- GEO --------
    // 'place_id': (m) => _isBlank(m.placeId) ? _msg('place_id') : null,
    // 'global_code': (m) => _isBlank(m.globalCode) ? _msg('global_code') : null,
    // 'compound_code': (m) => _isBlank(m.compoundCode) ? _msg('compound_code') : null,

    // -------- HISTORIC / CAPACITY --------
    'capacity': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && !_isPos(m.capacity)
        ? _msg('capacity')
        : null,
    'toilet_men_number': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) &&
        (m.toiletMenNumber == null || m.toiletMenNumber! < 0)
        ? _msg('toilet_men_number')
        : null,
    'mosque_historical': (m) =>
    _isExistingOrAbandoned(m.mosqueCondition) && _isBlank(m.mosqueHistorical)
        ? _msg('mosque_historical')
        : null,
    'prince_project_historic_mosque': (m) =>
    _isYes(m.mosqueHistorical) && _isBlank(m.princeProjectHistoricMosque)
        ? _msg('prince_project_historic_mosque')
        : null,

    // Special: Friday rows required only when classificationId == 1
    // [CHANGED] friday_prayer_rows required when classificationId is 1 or 3
    'friday_prayer_rows': (m) {
      // Prefer typed; fall back to payload['classification_id']
      int? clsId = m.classificationId;
      if (clsId == null) {
        final mp = m.payload;                                   // [FIX] no null-aware index
        final dynamic raw = mp != null ? mp['classification_id'] : null;
        print("class:$raw");
        if (raw is int) {
          clsId = raw;
        } else if (raw is String) {
          clsId = int.tryParse(raw);
        }
      }
      debugPrint('clsId=$clsId cond=${m.mosqueCondition} fridayTyped=${m.fridayPrayerRows} '
          'fridayRaw=${m.payload?['friday_prayer_rows']} menFridayRaw=${m.payload?['men_friday_rows']}');


      final needsIt = _isExistingOrAbandoned(m.mosqueCondition) &&
          (clsId == 1 );               // required for 1 or 3

      return (needsIt && !_isPos(m.fridayPrayerRows))
          ? _msg('friday_prayer_rows')
          : null;


    },



  };

  /// Validate all fields -> list of issues (empty = OK)
  static List<ValidationIssue> validate(MosqueLocal m) {
    final List<ValidationIssue> issues = [];

    if (kDebugMode) {
      debugPrint('VALIDATE: condition="${m.mosqueCondition}"');
    }

    // 1) Collect raw issues from all per-field rules
    _v.forEach((field, validator) {
      final msg = validator(m);
      if (msg != null) {
        issues.add(ValidationIssue(field: field, message: msg, tabKey: _tabOf(field)));
      }
    });

    // 2) Dynamic list validations (meters)
    //_validateMetersAndWaterMeters(m, issues);

    // 3) Final gating by Mosque Condition
    final isEA = _isExistingOrAbandoned(m.mosqueCondition);

    if (!isEA) {
      // Drop any issues from non-basic/non-address tabs
      issues.removeWhere((iss) => _tabsRequiringExistingOrAbandoned.contains(iss.tabKey));
    }

    // (Optional) debug the *final* issues actually returned to UI
    if (kDebugMode) {
      for (final i in issues) {
        debugPrint('FINAL ISSUE field=${i.field} tab=${i.tabKey} msg=${i.message}');
      }
    }

    return issues;
  }


  /// Validate a single field -> error text or null (for inline)
  static String? validateField(MosqueLocal m, String fieldKey) {
    final fn = _v[fieldKey];
    return fn == null ? null : fn(m);
  }

  /// Expose tab lookup for the UI (optional)
  static String tabForField(String fieldKey) => _tabOf(fieldKey);
}


// void _validateMetersAndWaterMeters(MosqueLocal m, List<ValidationIssue> out) {
//   // ---- Electric meters ------------------------------------------------------
//   final meters = _asMapList(_p(m, 'meter_ids'));
//   for (var i = 0; i < meters.length; i++) {
//     final row = meters[i];
//
//     final anySelected = _truthy(row['imam']) ||
//         _truthy(row['mosque']) ||
//         _truthy(row['muezzin']) || // in case you reuse this flag here
//         _truthy(row['facility']);
//
//     if (!anySelected) continue; // no constraints if nothing selected
//
//     final meterNum = _strOrNull(row['meter_number']);
//     final attach   = _strOrNull(row['attachment_id']) ?? _strOrNull(row['attachment']);
//
//     if (meterNum == null) {
//       out.add(ValidationIssue(
//         field: 'meter_ids[$i].meter_number',
//         message: _msg('meter_number'),
//         tabKey: 'meters',
//       ));
//     }
//
//     if (attach == null) {
//       out.add(ValidationIssue(
//         field: 'meter_ids[$i].attachment_id',
//         message: _msg('attachment_id'),
//         tabKey: 'meters',
//       ));
//     }
//   }
//
//   // ---- Water meters ---------------------------------------------------------
//   // final wmeters = _asMapList(_p(m, 'water_meter_ids'));
//   // for (var i = 0; i < wmeters.length; i++) {
//   //   final row = wmeters[i];
//   //
//   //   final anySelected = _truthy(row['muezzin']) ||
//   //       _truthy(row['facility']) ||
//   //       _truthy(row['mosque']); // some UIs use 'mosque' for both
//   //
//   //   if (!anySelected) continue;
//   //
//   //   final meterNum = _strOrNull(row['meter_number']);
//   //   final attach   = _strOrNull(row['attachment_id']) ?? _strOrNull(row['attachment']);
//   //
//   //   if (meterNum == null) {
//   //     out.add(ValidationIssue(
//   //       field: 'water_meter_ids[$i].meter_number',
//   //       message: _msg('meter_number'),
//   //       tabKey: 'meters',
//   //     ));
//   //   }
//   //
//   //   if (attach == null) {
//   //     out.add(ValidationIssue(
//   //       field: 'water_meter_ids[$i].attachment_id',
//   //       message: _msg('attachment_id'),
//   //       tabKey: 'meters',
//   //     ));
//   //   }
//   // }
// }
