// Mosque Submit Payload Builder — complete mapping (Dart)
// Builds the final submit body:
// {
//   "mosque_vals": { ... },
//   "accept_terms": <string|bool>
// }
// - Includes ALL MosqueLocal fields (where meaningful) in mosque_vals
// - Groups employees into imam_ids/muezzin_ids/khatib_ids/khadem_ids using EmployeeLocal.toApiRecord()
// - Pulls meters from MosqueLocal.payload['electric_meters'|'water_meters'] and normalizes shape
// - Normalizes mosque_condition via MosqueConditionData.normalizeToCode
// - Removes null/empty fields to keep payload clean

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/mosque/core/models/employee_local.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/mosqueTabs/logic/condition_rules.dart';

extension MosqueSubmit on MosqueLocal {
  /// Top-level wrapper used by your submit flow
  Future<Map<String, dynamic>> toSubmitBody({required Object acceptTerms}) async {
    final vals = await _buildMosqueVals();
    return {
      'mosque_vals': vals,
      'accept_terms': acceptTerms,
    };
  }

  /// Builds the `mosque_vals` map with a comprehensive field mapping
  Future<Map<String, dynamic>> _buildMosqueVals() async {
    // ---------- Employees (from Hive) ----------
    final allEmployees = await HiveRegistry.employee.getAll();
    final related = allEmployees.where((e) => e.parentLocalId == localId);
    final grouped = _groupEmployees(related);

    // ---------- Meters (from payload) ----------
    final electricMeters = _extractMetersFromPayload('meter_ids');
    final waterMeters = _extractMetersFromPayload('water_meter_ids');

    // ---------- Base fields (ALL mirrored where meaningful) ----------
    final map = <String, dynamic>{
      // Core / identity
      'name': name,
      'number': number,
      // NOTE: your earlier mapping posts the district *id* in 'district'.
      // Keep that convention for wire compatibility; if you later expose both, add 'district_name'.
      'district': districtId ?? district,
      'street': street,
      'classification_id': classificationId,
      'mosque_type_id': mosqueTypeId,
      'region_id': regionId,
      'city_id': cityId,
      'moia_center_id': moiaCenterId,

      // Dates / meta
      'last_update_date': lastUpdateDate,
     // 'observer_ids': observerIds,
      'complete_address': completeAddress,

      // Geolocation / place
      'longitude': longitude,
      'latitude': latitude,
      //'place_id': placeId,
      //'global_code': globalCode,
      //'compound_code': compoundCode,
      
      // Haram location fields (keep as "yes"/"no" strings)
      'is_inside_haram_makkah': isInsideHaramMakkah,
      'is_in_pilgrim_housing_makkah': isInPilgrimHousingMakkah,
      'is_inside_haram_madinah': isInsideHaramMadinah,
      'is_in_visitor_housing_madinah': isInVisitorHousingMadinah,
      
      // New location fields (keep as "yes"/"no" strings)
      'is_inside_prison': isInsidePrison,
      'is_inside_hospital': isInsideHospital,
      'is_inside_government_housing': isInsideGovernmentHousing,
      'is_inside_restricted_gov_entity': isInsideRestrictedGovEntity,
      'land_owner': landOwner,

      // Condition / construction
      'mosque_condition': MosqueConditionData.normalizeToCode(mosqueCondition),
      'building_material': buildingMaterial,
      'urban_condition': urbanCondition,
      'date_maintenance_last': dateMaintenanceLast,
      'image': image,
      'outer_image': outerImage,

      // Structure & capacities
      'external_doors_numbers': externalDoorsNumbers,
      'internal_doors_number': internalDoorsNumber,
      'num_minarets': numMinarets,
      'num_floors': numFloors,
      'has_basement': hasBasement,
      'mosque_rooms': mosqueRooms,
      'friday_prayer_rows': fridayPrayerRows,
      'row_men_praying_number': rowMenPrayingNumber,
      'length_row_men_praying': lengthRowMenPraying,
      'capacity': capacity,
      'men_prayer_avg_attendance': menPrayerAvgAttendance,
      // COMMENTED OUT: mosque_in_military_zone field
      // 'mosque_in_military_zone': mosqueInMilitaryZone,
      'toilet_men_number': toiletMenNumber,
      'has_women_prayer_room': hasWomenPrayerRoom,
      'row_women_praying_number': rowWomenPrayingNumber,
      'length_row_women_praying': lengthRowWomenPraying,
      'women_prayer_room_capacity': womenPrayerRoomCapacity,
      'toilet_woman_number': toiletWomanNumber,
      'is_employee': isEmployee,

      // Residences
      'residence_for_imam': residenceForImam,
      'imam_residence_type': imamResidenceType,
      'imam_residence_land_area': imamResidenceLandArea,
      'residence_for_mouadhin': residenceForMouadhin,
      'muezzin_residence_type': muezzinResidenceType,
      'muezzin_residence_land_area': muezzinResidenceLandArea,

      // Facilities & rooms
      'cars_parking': carsParking,
      'has_washing_machine': hasWashingMachine,
      'is_other_attachment': isOtherAttachment,
      'lectures_hall': lecturesHall,
      'library_exist': libraryExist,

      // Programs / org flags
      'ministry_authorized': ministryAuthorized,
      'is_there_investment_building': isThereInvestmentBuilding,
      'is_there_headquarters': isThereHeadquarters,
      'is_there_quran_memorization_men': isThereQuranMemorizationMen,
      
      // Property type (flat array format - list of questions with answers)
      if (propertyTypeIds != null && propertyTypeIds!.isNotEmpty)
        'property_type_ids': propertyTypeIds!.map((item) {
          // Extract question_id from either direct value or nested array [id, name]
          final questionIdRaw = item['question_id'];
          final questionId = questionIdRaw is List && questionIdRaw.isNotEmpty
              ? questionIdRaw[0]
              : questionIdRaw;
          
          // Build clean object with required fields
          final result = <String, dynamic>{
            'question_id': questionId,
            'answer': item['answer'],
            'land_location': item['land_location'],
          };
          
          // Include the record 'id' if it exists (for updates to existing records)
          // For new mosques, this won't exist; for edit requests, it must be preserved
          if (item['id'] != null) {
            result['id'] = item['id'];
            debugPrint('  → property_type q$questionId has record id=${item['id']}');
          }
          
          return result;
        }).toList(),
      'is_there_quran_memorization_women': isThereQuranMemorizationWomen,

      // Land & title
      'land_area': mosqueLandArea,
      'non_building_area': nonBuildingArea,
      'roofed_area': roofedArea,
      'is_free_area': isFreeArea,
      'free_area': freeArea,
      'has_deed': hasDeed,
      'is_there_land_title': isThereLandTitle,
      'no_planned': noPlanned,
      'piece_number': pieceNumber,
      'mosque_opening_date': mosqueOpeningDate,

      // Equipment & safety
      'has_air_conditioners': hasAirConditioners,
      'ac_type': acType,
      'num_air_conditioners': numAirConditioners,
      'has_internal_camera': hasInternalCamera,
      'has_external_camera': hasExternalCamera,
      'num_lighting_inside': numLightingInside,
      'internal_speaker_number': internalSpeakerNumber,
      'external_headset_number': externalHeadsetNumber,
      'has_fire_extinguishers': hasFireExtinguishers,
      'has_fire_system_pumps': hasFireSystemPumps,

      // Maintenance / contracts
      'maintenance_responsible': maintenanceResponsible,
      //'maintenance_person': maintenancePerson,
      //'company_name': companyName,
      //'contract_number': contractNumber,

      // QR / data quality
      'is_qr_code_exist': isQrCodeExist,
      'qr_panel_numbers': qrPanelNumbers,
      'is_panel_readable': isPanelReadable,
      'code_readable': codeReadable,
      'mosque_data_correct': mosqueDataCorrect,
      'is_mosque_name_qr': isMosqueNameQr,
      'qr_code_notes': qrCodeNotes,
      'qr_image': qrImage,
      'observation_text': observationText,
      'user_pledge': userPledge,

      // Heritage
      'mosque_historical': mosqueHistorical,
      'prince_project_historic_mosque': princeProjectHistoricMosque,

      // Employees (arrays of objects)
      'imam_ids': grouped['imam_ids'],
      'muezzin_ids': grouped['muezzin_ids'],
      'khatib_ids': grouped['khatib_ids'],
      'khadem_ids': grouped['khadem_ids'],

      // Meters
      'meter_ids': electricMeters,
      'water_meter_ids': waterMeters,
    };

    // Remove null/empty containers to keep API payload tidy
    map.removeWhere((_, v) => v == null || (v is String && v.trim().isEmpty) || (v is List && v.isEmpty));
    return map;
  }

  /// Groups employees into imam/muezzin/khatib/khadem arrays using their category ids (8/9/10/11)
  Map<String, List<Map<String, dynamic>>> _groupEmployees(Iterable<EmployeeLocal> list) {
    final Map<String, List<Map<String, dynamic>>> out = {
      'imam_ids': <Map<String, dynamic>>[],
      'muezzin_ids': <Map<String, dynamic>>[],
      'khatib_ids': <Map<String, dynamic>>[],
      'khadem_ids': <Map<String, dynamic>>[],
    };

    for (final e in list) {
      // Expect EmployeeLocal.toApiRecord() to:
      // - include required fields (name, identification_id, birthday, etc.)
      // - include english_name only when non-null
      // - validate work_phone format (12 digits, starts with 966)
      final rec = e.toApiRecord();
      final cats = e.categoryIds ?? const <int>[];
      if (cats.contains(8)) out['imam_ids']!.add(rec);
      if (cats.contains(9)) out['muezzin_ids']!.add(rec);
      if (cats.contains(10)) out['khatib_ids']!.add(rec);
      if (cats.contains(11)) out['khadem_ids']!.add(rec);
    }
    return out;
  }

  /// Converts payload['electric_meters'|'water_meters'] list-of-maps to the API shape.
  /// Enforces the keys required by the server; leaves optional values out when null.
  /// Preserves meter IDs if they exist from the API.
  List<Map<String, dynamic>> _extractMetersFromPayload(String key) {
    final src = payload?[key];
    if (src is! List) return const <Map<String, dynamic>>[];

    return src
        .whereType<Map>()
        .map((raw) => Map<String, dynamic>.from(raw))
        .map((m) {
      final meterNew = (m['meter_new'] ?? m['is_meter_new']) == true;
      final out = <String, dynamic>{
        'meter_number': m['meter_number'] ?? m['number'],
        'imam': m['imam'] ?? false,
        'muezzin': m['muezzin'] ?? false,
        'mosque': m['mosque'] ?? false,
        'facility': m['facility'] ?? false,
        'meter_new': meterNew,
        'attachment_id': m['attachment_id'] ?? m['attachment'],
      };
      
      // Preserve meter ID if it exists from the API (for patch/send operations)
      // This ensures existing meters are updated rather than creating duplicates
      if (m['id'] != null) {
        out['id'] = m['id'];
        debugPrint('  → ${key} meter_number=${out['meter_number']} has record id=${m['id']}');
      }
      
      // drop nulls
      out.removeWhere((_, v) => v == null);
      return out;
    })
    // enforce required meter_number
        .where((m) => m['meter_number'] != null)
        .toList(growable: false);
  }
}

// ------------------------ OPTIONAL: Lightweight validator ------------------------
extension MosqueSubmitValidation on MosqueLocal {
  /// Returns a list of human-readable errors if something critical is missing.
  /// Uses your existing minimum field rules + meter regex for new meters.
  // List<String> validateForSubmit({bool requireIds = true}) {
  //   final errors = <String>[];
  //
  //   // reuse your hasMinimumFields logic
  //   final missing = missingMinimumFields(requireIds: requireIds);
  //   errors.addAll(missing.map((k) => 'Missing required: $k'));
  //
  //   // meter pattern check (only when meter_new == true)
  //   final RegExp meterNewPattern = RegExp(r'^[A-Za-z]{3}[0-9]{13}\$');
  //
  //   for (final key in const ['meter_ids', 'water_meter_ids']) {
  //     final meters = payload?[key];
  //     if (meters is! List) continue;
  //     for (final m in meters.whereType<Map>()) {
  //       final isNew = (m['meter_new'] ?? m['is_meter_new']) == true;
  //       if (isNew) {
  //         final num = (m['meter_number'] ?? m['number'])?.toString() ?? '';
  //         if (!meterNewPattern.hasMatch(num)) {
  //           errors.add('Meter $key has invalid new meter number format: "$num"');
  //         }
  //       }
  //     }
  //   }
  //
  //   return errors;
  // }
  List<String> validateForSubmit({bool requireIds = true}) {
    final errors = <String>[];


    // Only required fields
    final missing = missingMinimumFields(requireIds: requireIds);
    errors.addAll(missing.map((k) => 'Missing required: $k'));



    return errors;
  }
}
