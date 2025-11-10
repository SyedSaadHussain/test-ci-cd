// lib/core/models/mosque_edit_request_model.dart
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mosque_management_system/core/models/combo_list.dart' show ComboItem;
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_merges.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import '../../../../core/hive/hive_typeIds.dart';
import '../../edit_request/list/all_mosque_edit_request.dart';
import '../../../../core/models/combo_list.dart';
import 'mosque_local.dart';

part 'mosque_edit_request_model.g.dart';

///Start hive from 130
@HiveType(typeId: HiveTypeIds.mosqueEditRequestModel)
class MosqueEditRequestModel extends MosqueLocal {
  // New fields start after MosqueLocal's last field (112)
  @HiveField(130)
  int? supervisorId;

  @HiveField(131)
  String? requester;

  @HiveField(132)
  String? createDate;   // keep as String (consistent with other date strings)

  @HiveField(133)
  String? submitDate;   // keep as String

  @HiveField(134)
  String? description;

  @HiveField(135)
  String? supervisorName;

  @HiveField(136)
  String? mosqueName;

  @HiveField(137)
  int? requestId;

  String? requestName;


  List<ComboItem>? requesterName;

  // Workflow timeline for edit request process (not stored in Hive)
  List<Map<String, dynamic>>? workflowEditRequest;





  // Constructor in the same spirit as RegularVisitModel (pass common super fields you care about)
  MosqueEditRequestModel({
    // Core super
    required super.localId,
    super.serverId,
    // super.status = SyncStatus.synced,
    super.createdAt,
    super.updatedAt,
    super.lastError,
    super.payload,

    // Frequently-used inherited fields (optional convenience)
    super.name,
    super.regionId,
    super.cityId,
    super.moiaCenterId,
    super.districtId,
    super.latitude,
    super.longitude,
    super.classificationId,
    super.mosqueTypeId,

    // New fields
    this.supervisorId,
    this.requester,
    this.createDate,
    this.submitDate,
    this.description,
    this.supervisorName,
    this.mosqueName,
    this.requestId
  });

  /// Create a new instance from JSON (edit-request header style).
  /// Pass `localId` you generate and optionally `serverId` (mosque id).
  factory MosqueEditRequestModel.fromJson(
      Map<String, dynamic> json, {
        required String localId,
      }) {
    // Request ID for view APIs
    final int? reqId = JsonUtils.toInt(json['id'] ?? json['request_id']);

    // Mosque, stage, requester (your existing style)
    final int? mosqueId      = JsonUtils.getId(json['mosque_id']) ;
    final String? mosqueNm   = JsonUtils.getName(json['mosque_id']) ;
    final int? stageId       = JsonUtils.getId(json['stage_id']);
    final String? stageName  = JsonUtils.getName(json['stage_id']);
    final int? requesterId   = JsonUtils.getId(json['requester']);
    //final String? requesterName = JsonUtils.getName(json['requester']);

    final Map<String, dynamic> payload = {
      'request_id': reqId,
      'request_name': JsonUtils.toText(json['name']),
      'number': JsonUtils.toText(json['number']),
      // Stage
      'stage_id': stageId,
      'state_name': stageName,
      'state': stageName,
      // Mosque
      'mosque_id': mosqueId,
      'mosque_name': mosqueNm,
      // Requester
      'requester_id': requesterId,
     // 'requester_name': requesterName,
    }..removeWhere((_, v) => v == null);

    return MosqueEditRequestModel(
      localId: localId,
      serverId: mosqueId,     // keep: mosque_id as serverId (your convention)
      name: mosqueNm,
      mosqueName: mosqueNm,
      //requester: requesterName,
      payload: payload,
      requestId: reqId,       // <-- NEW: store the request id
      // nullable others
      supervisorId: null,
      supervisorName: null,
      createDate: null,
      submitDate: null,
      description: null,
    );
  }



  /// Same vibe as your shallowCopy: copy selected super fields + new fields.
  MosqueEditRequestModel.shallowCopy(MosqueEditRequestModel other)
      : super(
    localId: other.localId,
    serverId: other.serverId,
    // status: other.status,
    createdAt: other.createdAt,
    updatedAt: other.updatedAt,
    lastError: other.lastError,
    payload: other.payload,

    // pick the inherited fields you want to carry by default
    name: other.name,
    regionId: other.regionId,
    cityId: other.cityId,
    moiaCenterId: other.moiaCenterId,
    districtId: other.districtId,
    latitude: other.latitude,
    longitude: other.longitude,
    classificationId: other.classificationId,
    mosqueTypeId: other.mosqueTypeId,
  ) {
    supervisorId = other.supervisorId;
    supervisorName = other.supervisorName;
    requester = other.requester;
    createDate = other.createDate;
    submitDate = other.submitDate;
    description = other.description;
  }


  void mergeJson(dynamic json) {
    super.mergeJson(json);


    supervisorId = JsonUtils.toInt(json['supervisor_id']) ?? supervisorId;


    final requesterIdsData = json['requester'];
    if (requesterIdsData != null && requesterIdsData != false &&
        requesterIdsData is List) {
      requesterName = (requesterIdsData)
          .map((item) => ComboItem.fromJsonObject(item))
          .toList();
    }

    createDate = JsonUtils.toText(json['create_date']) ?? createDate;
    submitDate = JsonUtils.toText(json['submit_date']) ?? submitDate;


    // [BASIC INFO]
    // =========================
    requestId = JsonUtils.toInt(json['id']) ?? requestId;
    requestName = JsonUtils.toText(json['name']) ?? requestName;
    number = JsonUtils.toText(json['number']) ?? number;
    name = JsonUtils.getObjectName(json['mosque_id']) ?? name;
    serverId = JsonUtils.getObjectId(json['mosque_id']) ?? serverId;


    mosqueName = JsonUtils.toText(json['mosque_name']) ?? mosqueName;
    description = JsonUtils.toText(json['description']) ?? description;

    // optional

    // dates
    //mosqueLastUpdate = JsonUtils.toDateTime(json['mosque_last_update']) ?? mosqueLastUpdate;

    // observers (ids / names) — keep the ones that your JsonUtils actually provides
    observerIdsArray = json['observer_ids'] == null
        ? observerIdsArray
        : (json['observer_ids'] as List).map((item) =>
        ComboItem.fromJsonObject(item)).toList();
    //observerNames = JsonUtils.toStringList(json['observer_names']) ?? observerNames;


    // extras
    compoundCode = JsonUtils.toText(json['compound_code']) ?? compoundCode;


    // // [METERS INFO]
    // // =========================
    // if (json['meter_ids'] is List) {
    //   electricMetersArray = (json['meter_ids'] as List)
    //       .where((item) => item != null && item is Map<String, dynamic>)
    //       .cast<Map<String, dynamic>>()
    //       .toList();
    // }
    //
    // if (json['water_meter_ids'] is List) {
    //   waterMetersArray = (json['water_meter_ids'] as List)
    //       .where((item) => item != null && item is Map<String, dynamic>)
    //       .cast<Map<String, dynamic>>()
    //       .toList();
    //
    //
    //   updatedAt = DateTime.now();
    // }
  }


  /// Same pattern as fromJsonReadMerge in your sample.
    factory MosqueEditRequestModel.fromJsonReadMerge(
        MosqueEditRequestModel existing, dynamic json) {
      final copy = MosqueEditRequestModel.shallowCopy(existing);
      copy.mergeJson(json);
      return copy;
    }

  /// Payload helper (mirrors your `toJson` style by adding new fields on top of base payload).
  Map<String, dynamic> toJson() {
    // call the extension on `this` (not super)
    final base = MosqueLocalApi(this).toCreatePayload();

    return {
      'supervisor_id': supervisorId,
      'requester': requester,
      'create_date': createDate,
      'submit_date': submitDate,
      ...base,
    }..removeWhere((_, v) => v == null);
  }

  // --- Convenience getters for listing & search ---
  Map<String, dynamic> get _p =>
      Map<String, dynamic>.from(payload ?? const <String, dynamic>{});
  String _s(dynamic v) => (v ?? '').toString().trim();

  /// Human-readable mosque name cached in payload by mergers,
  /// or fallback to base `name` (inherited from MosqueLocal).
  String get mosqueNm =>
      _s(_p['mosque_name'] ?? (_p['mosque'] is Map ? _p['mosque']['name'] : null) ?? name);

  /// Human-readable mosque number if present in payload or nested `mosque`.
  String get mosqueNumber =>
      _s(_p['number'] ?? (_p['mosque'] is Map ? _p['mosque']['number'] : null) ?? number);

  /// Mosque id as string for filtering/search (payload or nested).
  String get mosqueIdStr {
    final nestedId = (_p['mosque'] is Map) ? _p['mosque']['id'] : null;
    return _s(_p['mosque_id'] ?? nestedId ?? serverId);
  }

  /// Request title / label (adapt keys to your backend if needed).
  // String get requestName =>
  //     _s(_p['request_name'] ?? _p['title'] ?? _p['tab_name']);


  /// Workflow state coming from server; fallback to 'draft'.
  String get workflowState =>
      _s(_p['state'] ?? _p['workflow_state'] ?? 'draft');

  /// Submitted/updated date for display (string).
  String get dateSubmit =>
      _s(submitDate ?? _p['date_submit'] ?? _p['submitted_at'] ?? _p['updated_at']);
}

class PaginatedEditRequests {
  final List<MosqueEditRequestModel> items;
  final bool hasMore;

  const PaginatedEditRequests({
    required this.items,
    required this.hasMore,
  });
}


extension MosqueEditRequestSubmit on MosqueEditRequestModel {
  Map<String, dynamic> toEditSubmitBody({required String acceptTerms}) {

    if (serverId == null || serverId == 0) {
      throw StateError('Submit: serverId (mosque_id) is null/0 – initForEditRequest not called or a merge cleared it.');
    }
    // helper: normalize dynamic → List<Map<String, dynamic>>
    List<Map<String, dynamic>> _asListOfMaps(dynamic v) {
      if (v is List) {
        return v
            .where((e) => e is Map)
            .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
      return const <Map<String, dynamic>>[];
    }

    List<Map<String, dynamic>> _normalizeMeters(dynamic raw, {required String type}) {
      final list = _asListOfMaps(raw);

      return list.map<Map<String, dynamic>>((m) {
        final attRaw = m['attachment_id'] ??
            m['attachmentId'] ??
            m['attachment'] ??
          //  m['image'] ??
            m['file'] ??
            m['base64'];

       // final att = _sanitizeBase64(attRaw);

        final out = <String, dynamic>{
          'meter_number': m['meter_number'] ?? m['number'] ?? '',
          'imam': (m['imam'] == true),
          'muezzin': (m['muezzin'] == true),
          'mosque': (m['mosque'] == true),
          'facility': (m['facility'] == true),
          // DO NOT INCLUDE 'meter_type' (backend doesn't expect it)
          'meter_new': (m['meter_new'] == true),
          //if (att != null && att.isNotEmpty)
           'attachment_id': attRaw,
        };
        
        // Preserve meter ID if it exists from the API (for edit request creation and patch/send operations)
        // This ensures existing meters are updated rather than creating duplicates
        if (m['id'] != null) {
          out['id'] = m['id'];
        }

        out.removeWhere((_, v) => v == null);
        return out;
      }).toList();
    }

    final String? effectiveMosqueName =
        mosqueName  ??
            name        ??                              // UI-edited value
            (payload?['mosque_name'] as String?);
    // Build the flat values (your existing fields)
    final vals = <String, dynamic>{
      // minimal core

      'mosque_name': effectiveMosqueName,
      'number': number,
      'classification_id': classificationId,
      'mosque_type_id': mosqueTypeId,
      'region_id': regionId,
      'city_id': cityId,
      'moia_center_id': moiaCenterId,
      'district': districtId, // (backend expects 'district', keep your current key)
      'street': street,
      'longitude': longitude,
      'latitude': latitude,
      'place_id': placeId,
      'global_code': globalCode,
      'compound_code': compoundCode,

      //Added newly 22/10/2025 7:353 PM By Saleh
      // Haram location fields
      'is_inside_haram_makkah': isInsideHaramMakkah,
      'is_in_pilgrim_housing_makkah': isInPilgrimHousingMakkah,
      'is_inside_haram_madinah': isInsideHaramMadinah,
      'is_in_visitor_housing_madinah': isInVisitorHousingMadinah,

      'is_inside_prison': isInsidePrison,
      'is_inside_hospital': isInsideHospital,
      'is_inside_government_housing': isInsideGovernmentHousing,
      'is_inside_restricted_gov_entity': isInsideRestrictedGovEntity,
      'land_owner': landOwner,

      // condition/structure
      'mosque_condition': mosqueCondition,
      'building_material': buildingMaterial,
      'urban_condition': urbanCondition,
      'date_maintenance_last': dateMaintenanceLast,
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


      // women
      'has_women_prayer_room': hasWomenPrayerRoom,
      'row_women_praying_number': rowWomenPrayingNumber,
      'length_row_women_praying': lengthRowWomenPraying,
      'women_prayer_room_capacity': womenPrayerRoomCapacity,
      'toilet_woman_number': toiletWomanNumber,

      // residences
      'residence_for_imam': residenceForImam,
      'imam_residence_type': imamResidenceType,
      'imam_residence_land_area': imamResidenceLandArea,
      'residence_for_mouadhin': residenceForMouadhin,
      'muezzin_residence_type': muezzinResidenceType,
      'muezzin_residence_land_area': muezzinResidenceLandArea,

      // facilities
      'is_other_attachment': isOtherAttachment,
      'library_exist': libraryExist,
      'lectures_hall': lecturesHall,
      'is_there_investment_building': isThereInvestmentBuilding,
      'is_there_headquarters': isThereHeadquarters,
      'is_there_quran_memorization_men': isThereQuranMemorizationMen,
      'is_there_quran_memorization_women': isThereQuranMemorizationWomen,
      'has_washing_machine': hasWashingMachine,
      'cars_parking': carsParking,
      'ministry_authorized': ministryAuthorized,
      
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

      // land
      'land_area': mosqueLandArea,
      'non_building_area': nonBuildingArea,
      'roofed_area': roofedArea,
      'is_free_area': isFreeArea,
      'free_area': freeArea,
      'mosque_opening_date': mosqueOpeningDate,
      'has_deed': hasDeed,
      'is_there_land_title': isThereLandTitle,
      'no_planned': noPlanned,
      'piece_number': pieceNumber,

      // audio & electronics
      'has_air_conditioners': hasAirConditioners,
      'ac_type': acType,
      'num_air_conditioners': numAirConditioners,
      'has_internal_camera': hasInternalCamera,
      'has_external_camera': hasExternalCamera,
      'num_lighting_inside': numLightingInside,
      'internal_speaker_number': internalSpeakerNumber,
      'external_headset_number': externalHeadsetNumber,

      // safety
      'has_fire_extinguishers': hasFireExtinguishers,
      'has_fire_system_pumps': hasFireSystemPumps,

      // maintenance
      'maintenance_responsible': maintenanceResponsible,
      'maintenance_person': maintenancePerson,
      'company_name': companyName,
      'contract_number': contractNumber,

      // historical
      'mosque_historical': mosqueHistorical,
      'prince_project_historic_mosque': princeProjectHistoricMosque,

      // QR code
      'is_qr_code_exist': isQrCodeExist,
      'qr_panel_numbers': qrPanelNumbers,
      'is_panel_readable': isPanelReadable,
      'mosque_data_correct': mosqueDataCorrect,
      'is_mosque_name_qr': isMosqueNameQr,
      'qr_code_notes': qrCodeNotes,
      'description' : description,
    }..removeWhere((k, v) => v == null);

    // pull optional arrays & image from payload (as in your server example)
    final meters       = _normalizeMeters(payload?['meter_ids'], type: 'electric');
    final waterMeters  = _normalizeMeters(payload?['water_meter_ids'], type: 'water');
    // AFTER (fallback to model fields too)
    final image      = this.image ?? payload?['image'];
    final outerImage = this.outerImage ?? payload?['outer_image'];
    final qrImage = this.qrImage ?? payload?['qr_image'];
    // keep both options

    // Build the exact `mosque_vals` expected by backend
    final mosqueVals = <String, dynamic>{
      ...vals,
      if (image != null) 'image': image,
      if (outerImage != null) 'outer_image' : outerImage,
      if (qrImage != null) 'qr_image': qrImage,
      if (meters.isNotEmpty) 'meter_ids': meters,
      if (waterMeters.isNotEmpty) 'water_meter_ids': waterMeters,
    };

// 1) clean nullable noise first
    mosqueVals.removeWhere((k, v) => v == null);

// 2) finally enforce the id so nothing can override it
    mosqueVals['mosque_id'] = serverId;

    final body = <String, dynamic>{
      // keep top-level if your backend accepts it (harmless), or drop it.
          'mosque_vals': mosqueVals,
      'accept_terms': acceptTerms,
      if (supervisorId != null) 'supervisor_id': supervisorId,
      if (requester != null) 'requester': requester,
      if (description != null) 'description': description,
    };

// Debug while testing
    debugPrint('[model] enforce inner=${mosqueVals['mosque_id']} top=${body['mosque_id']} model.serverId=$serverId');

    return body;
  }
}

class EditActionResult {
  final int? requestId;
  final int? stageId;
  final String? stageName;
  final String? refuseReason;

  const EditActionResult({this.requestId, this.stageId, this.stageName, this.refuseReason});

  factory EditActionResult.fromJson(Map<String, dynamic> j) => EditActionResult(
    requestId: j['request_id'] as int?,
    stageId: (j['stage'] is Map) ? (j['stage']['id'] as int?) : null,
    stageName: (j['stage'] is Map) ? (j['stage']['name'] as String?) : null,
    refuseReason: j['refuse_reason'] as String?,
  );
}

