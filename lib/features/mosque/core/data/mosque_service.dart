import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
// import 'package:mosque_management_system/core/constants/odoo_models.dart'; // if you keep enums/consts here
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_merges.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_submit.dart';
import 'package:mosque_management_system/features/mosque/core/data/mosque_repository.dart';
import '../models/mosque_edit_request_model.dart';
import '../../../../core/models/mosque_list_items.dart';
import '../models/mosque_local.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart'; // you already use this elsewhere
import 'package:mosque_management_system/core/hive/hive_registry.dart';

import 'package:mosque_management_system/features/mosque/core/models/employee_local.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../edit_request/list/all_mosque_edit_request.dart';


String? _stripToBase64(dynamic v) {
  if (v == null || v == false) return null;
  var s = v.toString().trim();
  if (s.isEmpty || s.toLowerCase() == 'null') return null;

  // Python bytes literal: b'....' / b"...."
  if ((s.startsWith("b'") && s.endsWith("'")) ||
      (s.startsWith('b"') && s.endsWith('"'))) {
    s = s.substring(2, s.length - 1).trim();
  }

  // data URL
  final k = s.indexOf('base64,');
  if (k != -1) s = s.substring(k + 7);

  // URL-safe → standard
  s = s.replaceAll('-', '+').replaceAll('_', '/');

  // remove non-base64 chars & whitespace
  s = s.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');

  // pad
  final mod = s.length % 4;
  if (mod == 1) {
    // best-effort: drop the last char (likely noise) then re-evaluate
    s = s.substring(0, s.length - 1);
  }
  final mod2 = s.length % 4;
  if (mod2 == 2) s += '==';
  else if (mod2 == 3) s += '=';

  return s;
}

String? normalizeBase64ForSubmit(dynamic v) {
  final s = _stripToBase64(v);
  if (s == null) return null;
  // sanity decode to ensure it’s valid base64; return re-encoded clean string
  try {
    final bytes = base64Decode(s);
    return base64Encode(bytes);
  } catch (_) {
    return null;
  }
}


bool _looksLikeBase64(String s) {
  // very loose heuristic
  return s.length > 120 && (s.startsWith('data:image/') || s.contains('base64,'));
}

dynamic _redactLarge(dynamic v, {String? key}) {
  if (v is Map) {
    final out = <String, dynamic>{};
    v.forEach((k, val) {
      out['$k'] = _redactLarge(val, key: '$k');
    });
    return out; // ← now Map<String, dynamic>
  }
  if (v is List) {
    return v.map((e) => _redactLarge(e, key: key)).toList();
  }
  if (v is String) {
    final lk = (key ?? '').toLowerCase();
    if (lk.contains('image') || lk.contains('attachment') ||
        (v.length > 120 && (v.startsWith('data:image/') || v.contains('base64,')))) {
      return '[REDacted ${v.length} chars]';
    }
    if (v.length > 220) {
      return '${v.substring(0, 80)}...[${v.length} chars total]';
    }
  }
  return v;
}

void _logPayload(String tag, Map<String, dynamic> map) {
  if (!kDebugMode) return;
  try {
    final safe = _redactLarge(map) as Map<String, dynamic>; // ← safe now
    final pretty = const JsonEncoder.withIndent('  ').convert(safe);
    for (final line in pretty.split('\n')) {
      debugPrint('$tag $line');
    }
  } catch (e) {
    debugPrint('[logPayload] skipped: $e');
  }
}

class MosqueRepository {
  final MosqueService service;
  MosqueRepository():
        this.service = MosqueService(CustomOdooClient());

  static const String _createPath = '/post/app/mosque/create';

   Future<int> createMosqueFromLocal(MosqueLocal local, {Object acceptTerms = ''}) async {
    // Validate required fields (ids enforced)
    final errs = local.validateForSubmit(requireIds: true);
    if (errs.isNotEmpty) {
      throw StateError('Validation failed: ${errs.join(', ')}');
    }

    // Build top-level body and POST

    final body = await local.toSubmitBody(acceptTerms: acceptTerms);
    print('aaaaaaaaaaaa');
    print(body['mosque_vals']['name']);
    // Debug: Print full payload on mosque submission
    debugPrint('=== MOSQUE SUBMISSION PAYLOAD ===');
    debugPrint(jsonEncode(body));
    debugPrint('=================================');
    
    // Optimistically mark syncing
    // local
    //   ..status = SyncStatus.syncing
    //   ..updatedAt = DateTime.now()
    //   ..lastError = null;
    await local.save();

    try {

      final res = await service.submitMosque(body);

      final p = local.payload ??= {};
      if (res.number != null && res.number!.isNotEmpty) {
        local.number = res.number;       // if your model has it
        p['number']  = res.number;       // your BasicInfoTab reads payload['number']
      }
      if (res.stageName != null && res.stageName!.isNotEmpty) {
        p['stage']    = res.stageName;   // BasicInfoTab shows this
      }
      if (res.stageId != null) {
        p['stage_id'] = res.stageId;
      }
      if (res.mosqueName != null && res.mosqueName!.isNotEmpty) {
        // optional: reflect server's final name if you want
        local.name = res.mosqueName;
      }

      // Persist success
      // local
      //   ..serverId = res.serverId
      //   ..status = SyncStatus.synced
      //   ..updatedAt = DateTime.now()
      //   ..lastError = null;
      await local.save();

      return res.serverId;
    } catch (e) {
      // Persist failure state for observability
      // local
      //   ..status = SyncStatus.failed
      //   ..updatedAt = DateTime.now()
      //   ..lastError = e.toString();
      await local.save();
      rethrow;
    }
  }


  Future<Map<String, dynamic>> getMosqueViewData(int mosqueId, String url) async {
    try {
      final queryParams = <String, dynamic>{'mosque_id': mosqueId};

      final resp = await service.getMosqueViewDetail(queryParams, url);

      // --- normalize shapes ---
      // Prefer: resp.result.body.data
      final dynamic result = (resp is Map) ? resp['result'] : null;
      final dynamic body   = (result is Map ? result['body'] : null) ?? (resp is Map ? resp['body'] : null) ?? resp;
      if (body is Map) {
        final dynamic dataNode = body['data'] ?? body['payload'] ?? body['mosque'] ?? body['mosqueRequest'] ?? body['result'] ?? body;
        if (dataNode is Map) {
          return Map<String, dynamic>.from(dataNode);
        }
        if (dataNode is List) {
          // If backend sends a list, wrap it for the viewer
          return <String, dynamic>{'items': dataNode};
        }
        // body is already a map-like payload
        return Map<String, dynamic>.from(body);
      }

      if (resp is Map<String, dynamic>) {
        // Fallback if server returned {data: {...}} at the top
        final dynamic data = resp['data'] ?? resp;
        if (data is Map<String, dynamic>) return data;
        if (data is List) return {'items': data};
      }

      // Nothing structured—return empty map
      return <String, dynamic>{};
    } catch (e) {
      // Keep parity with the visit flow (bubble up)
      rethrow;
    }
  }

  String _deriveLocalId(Map<String, dynamic> m) {
    // Prefer anything the API might already give us
    final apiLocal = m['local_id'] as String?;
    if (apiLocal != null && apiLocal.isNotEmpty) return apiLocal;

    // Fall back to a stable synthetic id
    final rid = m['id'] ?? m['request_id'] ?? m['mosque_id'];
    if (rid != null) return 'editreq-$rid';

    // Absolute fallback: unique per fetch (won’t collide)
    return 'editreq-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<MosqueListResult> getMosquesPaged({
    int? stageId,
    required int pageIndex,
    required int limit,
  }) async {
    final resp = await service.getMosques(
      stageId: stageId,
      page: pageIndex,
      limit: limit,
    );


    // Future<PagedEditReqResult> getEditRequestsPaged({
    //   int? stageId,
    //   required int pageIndex,
    //   required int limit,
    // }) async {
    //   // call your endpoint, e.g. /get/crm/mosque/edit/request
    //   final res = await repo.getEditRequestsPaged(stageId: stageId, page: pageIndex, limit: limit);
    //
    //   final items = res.items.map<MosqueEditReqListItem>((j) {
    //     return MosqueEditReqListItem(
    //       id: j['id'],
    //       mosqueId: j['mosque_id'] is Map ? j['mosque_id']['id'] : (j['mosque_id'] ?? 0),
    //       name: j['mosque_name'] ?? (j['mosque_id'] is Map ? j['mosque_id']['name'] : '—'),
    //       number: j['number'],
    //       cityName: j['city_name'],
    //       stageName: j['state_name'] ?? j['state'],
    //     );
    //   }).toList();
    //
    //   return PagedEditReqResult(items: items, hasMore: res.hasMore);
    // }


    final map = (resp is Map) ? Map<String, dynamic>.from(resp) : <String, dynamic>{};
    final rawList = (map['mosques'] is List)
        ? List<Map<String, dynamic>>.from(map['mosques'])
        : const <Map<String, dynamic>>[];

    final items = rawList.map(MosqueListItem.fromJson).toList();
    final page = (map['page'] is int) ? map['page'] as int : int.tryParse('${map['page']}') ?? pageIndex;
    final pageSize = (map['page_size'] is int) ? map['page_size'] as int : int.tryParse('${map['page_size']}') ?? limit;
    final total = (map['total_records'] is int) ? map['total_records'] as int : int.tryParse('${map['total_records']}') ?? (items.length);

    return MosqueListResult(items: items, page: page, pageSize: pageSize, totalRecords: total);
  }

  // Back-compat convenience (returns just the items)
  Future<List<MosqueListItem>> getMosques({
    int? stageId,
    required int pageIndex,
    required int limit,
  }) async {
    final r = await getMosquesPaged(stageId: stageId, pageIndex: pageIndex, limit: limit);
    return r.items;
  }
  Future<List<Map<String, dynamic>>> fetchEditableMosques() async { //burger
    debugPrint('[svc] fetchEditableMosques()');
    final list = await service.getMosqueEditReqPicker();
    debugPrint('[svc] received ${list.length} items');
    return list;
  }

  Future<List<ComboItem>> fetchUserMosques() async { //burger
    List<ComboItem> items=[];
    debugPrint('[svc] fetchEditableMosques222()');
    final list = await service.getMosqueEditReqPicker();
    items = (list as List).map((item) => ComboItem.fromJsonObject(item))
        .toList();
    return items;
  }

  /// Lazy GET for a specific tab by key (preferred)
  Future<Map<String, dynamic>> fetchEditTabByKey(String tabKey, int mosqueId) {
    debugPrint('[svc] fetchEditTabByKey key=$tabKey mosqueId=$mosqueId');

    return service.getMosqueEditTabByKey(tabKey: tabKey, mosqueId: mosqueId);
  }

  /// Optional: direct path version
  Future<Map<String, dynamic>> fetchEditTabByPath(String path, int mosqueId) {
    return service.getMosqueEditTabByPath(path: path, mosqueId: mosqueId);
  }

  Future<EditRequestSubmitResult> submitEditRequest(
      MosqueEditRequestModel m, {
        required String acceptTerms,
      }) async {
    // 1) Build base body from the model
    final b = m.toEditSubmitBody(acceptTerms: acceptTerms);

    // 2) Get mosque_vals (fallback to legacy 'vals' if needed)
    final Map<String, dynamic> mv = Map<String, dynamic>.from(
        (b['mosque_vals'] ?? b['vals'] ?? const <String, dynamic>{}) as Map
    );

    // 3) Enforce INNER mosque_id only (per contract)
    mv['mosque_id'] ??= m.serverId;

    // 4) Sanitize binaries before posting  -----------------------------------

    // (a) Mosque main image
    // if (mv['image'] != null) {
    //   final clean = normalizeBase64ForSubmit(mv['image']);   // <-- your helper
    //   if (clean == null) {
    //     // Drop invalid to avoid 400s (or set a field error if you prefer)
    //     mv.remove('image');
    //     debugPrint('[svc] dropped invalid mosque image (base64 sanitize failed)');
    //   } else {
    //     // If BE wants a data URL, wrap; otherwise leave pure base64.
    //     mv['image'] = clean.startsWith('data:')
    //         ? clean
    //         : 'data:image/jpeg;base64,$clean';
    //   }
    // }

    // (b) Fix meter attachment_id fields (both electric & water lists)
    void _fixAttachments(String key) {
      final list = mv[key];
      if (list is List) {
        for (final e in list) {
          if (e is Map && e['attachment_id'] != null) {
            final fixed = normalizeBase64ForSubmit(e['attachment_id']); // helper
            if (fixed == null) {
              e.remove('attachment_id');
              debugPrint('[svc] dropped invalid $key.attachment_id');
            } else {
              e['attachment_id'] = fixed;
            }
          }
        }
      }
    }
    _fixAttachments('meter_ids');
    _fixAttachments('water_meter_ids');

    // 5) Build final payload (no root mosque_id) ------------------------------
    final Map<String, dynamic> payload = {
      'accept_terms': b['accept_terms'],
      'mosque_vals': mv,
      if (b['extras'] != null) 'extras': b['extras'],
    };

    // ---- Diagnostics (read-only; do not mutate 'payload') -------------------
    String _len(Object? x) =>
        (x is String) ? '${x.length} (mod4=${x.length % 4})' : 'null';

    final img = mv['image'];
    debugPrint('[svc] mv.image len=${_len(img)}');
    if (img is String && img.length >= 40) {
      debugPrint('[svc] mv.image headtail: '
          '${img.substring(0, 20)}...${img.substring(img.length - 20)}');
    }
    if (mv['meter_ids'] is List) {
      for (var i = 0; i < (mv['meter_ids'] as List).length; i++) {
        final it = (mv['meter_ids'] as List)[i];
        final s = (it is Map) ? it['attachment_id'] : null;
        debugPrint('[svc] meter_ids[$i].attachment_id len=${_len(s)}');
      }
    }
    if (mv['water_meter_ids'] is List) {
      for (var i = 0; i < (mv['water_meter_ids'] as List).length; i++) {
        final it = (mv['water_meter_ids'] as List)[i];
        final s = (it is Map) ? it['attachment_id'] : null;
        debugPrint('[svc] water_meter_ids[$i].attachment_id len=${_len(s)}');
      }
    }

    // Redacted dump: make a deep copy first so logs don't mutate the payload
    final redacted = _redactDeep(payload);
    debugPrint('[svc] payload → ${const JsonEncoder.withIndent('  ').convert(redacted)}');

    // 6) Call repo
    final resp = await service.postMosqueEditRequestSubmit(payload);

    // 7) Map response → DTO
    return _mapEditSubmit(resp);
  }

// Deep-copy + redact (no side effects on real payload)
  Map<String, dynamic> _redactDeep(Object? node) {
    Object? walk(Object? n) {
      if (n is Map) {
        final out = <String, Object?>{};
        n.forEach((k, v) => out[k.toString()] = walk(v));
        return out;
      } else if (n is List) {
        return n.map(walk).toList();
      } else if (n is String) {
        // Redact large strings (e.g., base64)
        return (n.length > 256) ? '[REDacted ${n.length} chars]' : n;
      }
      return n;
    }
    final r = walk(node);
    return (r is Map<String, dynamic>) ? r : <String, dynamic>{};
  }



  EditRequestSubmitResult _mapEditSubmit(dynamic resp) {
    final Map<String, dynamic> root = Map<String, dynamic>.from(resp ?? const {});
    // unwrap JSON-RPC if present
    final Map<String, dynamic> result =
    (root['result'] is Map) ? Map<String, dynamic>.from(root['result']) : root;

    final bool ok = result['success'] == true ||
        (result['status']?.toString().toLowerCase() == 'success');

    if (!ok) {
      final msg = result['message']?.toString() ?? 'Submit failed';
      throw ApiSubmitError(msg, raw: root);
    }

    // request_id (primary for edit request)
    final int? id = result._toInt(result['request_id'] ?? result['id']);
    if (id == null) {
      throw ApiSubmitError('Submit succeeded but no request_id returned', raw: root);
    }

    final String? reqName = result['request_name']?.toString();
    final Map<String, dynamic> stageMap =
    (result['stage'] is Map) ? Map<String, dynamic>.from(result['stage']) : const {};
    final int? stageId = stageMap._toInt(stageMap['id']);
    final String? stageName = stageMap['name']?.toString();

    return EditRequestSubmitResult(
      success: ok,
      requestId: id,
      requestName: reqName,
      stageId: stageId,
      stageName: stageName,
      message: result['message']?.toString(),
      raw: root,
    );
  }

  Future<PaginatedEditRequests> getEditRequests({
    int? stageId,
    int pageIndex = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'stage_id': stageId,
      'page': pageIndex,
      'limit': limit,
    }..removeWhere((_, v) => v == null);

    debugPrint('getEditRequests query: $queryParams');

    // Call repo. If your repo only accepts a Map, pass queryParams.
    // If it accepts named args (page, limit, stageId) use that instead.
    final resp = await service.getMosqueEditRequests(
      page: pageIndex,
      limit: limit,
      stageId: stageId,
    );

    debugPrint('getEditRequests raw response: $resp');

    // Unwrap common envelopes: {"result": {...}} OR plain map
    final Map<String, dynamic> root =
    (resp is Map && resp['result'] is Map)
        ? Map<String, dynamic>.from(resp['result'] as Map)
        : Map<String, dynamic>.from(resp as Map);

    // In UAT/BE we’ve seen different list keys
    final dynamic rawList =
        root['edit request'] ??
            root['edit_requests'] ??
            root['items'] ??
            root['data'] ??
            const [];

    final items = (rawList is List ? rawList : const <dynamic>[])
        .whereType<Map>()
        .map((row) {
      final m = Map<String, dynamic>.from(row);
      return MosqueEditRequestModel.fromJson(
        m,
        // We must provide a localId because MosqueEditRequestModel extends MosqueLocal.
        localId: _deriveLocalId(m),
      );
    })
        .toList();

    // hasMore: explicit or derived
    final bool hasMore = (root['has_more'] as bool?) ??
        (root['hasMore'] as bool?) ??
        (() {
          final totalDyn = root['total'];
          final total = (totalDyn is int) ? totalDyn : int.tryParse('$totalDyn');
          if (total != null) return (pageIndex * limit) < total;
          return items.length >= limit;
        })();

    return PaginatedEditRequests(items: items, hasMore: hasMore);
  }


  //get Mosque View API

  Future<MosqueLocal> getMosqueView(int mosqueId,String path,MosqueLocal mosque) async {
    try{
      final queryParams = {
        'mosque_id': mosqueId
      };
      final response = await service.getMosqueViewDetail(queryParams,path);
      if(response["success"]!=false){
        // Handle different response structures
        // For endpoints like /contracts/details that return {"success": true, "data": [...]}
        // Pass the whole response so mergeJson can access response['data']
        if (response["data"] is List && response["mosque"] == null) {
          mosque.mergeJson(response);
        } else {
          // For other endpoints that return {"mosque": {...}} or {"data": {...}}
          final responseData = response["mosque"] ?? response["data"];
          mosque.mergeJson(responseData);
        }
        print('🔄 Merged data for path: $path');
      }else{
        throw response["message"];
      }
      return mosque;
    }catch(e){
      throw e;
    }
  }

  Future<Map<String, dynamic>> fetchEditRequestTabByKey(String tabKey, int requestId) async {
    final path  = _pathForEditRequestTab(tabKey);
    final query = {'request_id': requestId};

    final res = await service.getMosqueEditViewDetail(query, path);

    // Your edit-view endpoints return:
    // { "success": true, "edit request": { ...tab json... } }
    if (res is Map && (res['success'] == true || res['success'] == 'true')) {
      final data = res['edit request'] ?? res['mosque'] ?? res;
      return Map<String, dynamic>.from(data as Map);
    }

    throw res is Map && res['message'] != null
        ? res['message']
        : 'Failed to load $tabKey';
  }



  Future<Map<String,dynamic>> fetchMosqueTabByKey(String tabKey, int mosqueId) async {
    final path  = _pathForViewTab(tabKey);

    final query = {'mosque_id': mosqueId };

    final res = await service.getMosqueViewDetail(query, path);

    // Your edit-view endpoints return:
    // { "success": true, "edit request": { ...tab json... } }
    if (res is Map && (res['success'] == true || res['success'] == 'true')) {
      final data = res['mosque']  ?? res['data'] ?? res;
      return data;
    }

    throw res is Map && res['message'] != null
        ? res['message']
        : 'Failed to load $tabKey';
  }

  String _pathForEditRequestTab(String key) {
    switch (key) {
      case 'basic_info':
        return '/mosque/edit/view/basic/info';
      case 'mosque_address':
        return '/mosque/edit/request/view/address';
      case 'mosque_condition':
        return '/mosque/edit/request/view/condition/details';
      case 'architectural_structure':
        return '/mosque/edit/request/view/structure';
      case 'men_prayer_section':
        return '/men/prayer/mosque/edit/request/capacity';
      case 'women_prayer_section':
        return '/mosque/edit/request/women/prayer/info';
      case 'imams_muezzins_details':
        return '/mosque/edit/imam/muezzin/residences/details';
      case 'mosque_facilities':
        return '/mosque/edit/request/view/facilities';
      case 'mosque_land':
        return '/mosque/edit/request/land/info';
      case 'audio_and_electronics':
        return '/mosque/edit/request/audio/electronic/info';
      case 'safety_equipment':
        return '/mosque/edit/request/fire/safety';
      case 'maintenance':
        return '/mosque/edit/request/maintenance/operation';
      case 'meters':
        return '/mosque/edit/request/meters';
      case 'historical_mosques':
        return '/mosque/edit/request/view/historical';
      case 'qr_code_panel':
        return '/mosque/edit/request/view/qrcode/panel';
      default:
        return '/mosque/edit/view/basic/info';
    }
  }
  String _pathForViewTab(String key) {
    switch (key) {
      case 'basic_info':
        return '/mosque/basic/info';
      case 'mosque_address':
        return '/mosque/address';
      case 'mosque_condition':
        return '/mosque/condition/details';
      case 'architectural_structure':
        return '/mosque/structure';
      case 'men_prayer_section':
        return '/men/prayer/mosque/capacity';
      case 'women_prayer_section':
        return '/mosque/women/prayer/info';
      case 'employee_info':
        return '/mosque/employee/info';
      case 'imams_muezzins_details':
        return '/mosque/imam/muezzin/residences/details';
      case 'mosque_facilities':
        return '/mosque/facilities';
      case 'mosque_land':
        return '/mosque/land/info';
      case 'audio_and_electronics':
        return '/mosque/audio/electronic/info';
      case 'safety_equipment':
        return '/mosque/fire/safety';
      case 'meters':
        return '/mosque/meters';
      case 'historical_mosques':
        return '/mosque/historical';
      case 'qr_code_panel':
        return '/mosque/qrcode/panel';
      case 'maintenance':
        return '/mosque/maintenance/operation';
      default:
        return '';
    }
  }



  Future<MosqueEditRequestModel> getMosqueEditView(int requestId,String path,MosqueEditRequestModel mosque) async {
      try{
        final queryParams = {
          'request_id': requestId
        };
        final response = await service.getMosqueEditViewDetail(queryParams,path);
        if(response["success"]!=false){
          mosque.mergeJson(response["edit_request"]);
        }else{
          throw response["message"];
        }
        return mosque;
      }catch(e){
        throw e;
      }
    }

  /// Helper to extract current state name from mosque/edit request model
  /// Returns the actual state name (e.g., "مرفوض") from payload if available
  /// Priority: payload['state_name'] > payload['stage']['name'] > model.stageName
  /// This extracts the "name" field value (like "مرفوض") from the stage object
  String? _getCurrentStateName(dynamic mosqueObj) {
    if (mosqueObj == null) return null;
    
    // Priority 1: Try payload['state_name'] first (the display name like "مرفوض")
    final stateName = mosqueObj.payload?['state_name']?.toString().trim();
    if (stateName != null && stateName.isNotEmpty) {
      return stateName;
    }
    
    // Priority 2: Try payload['stage']['name'] if stage is an object (from API response)
    // The stage object has: {"id": 442, "name": "مرفوض", "state": "cancel"}
    // We want the "name" field value
    final stage = mosqueObj.payload?['stage'];
    if (stage is Map && stage['name'] != null) {
      final name = stage['name'].toString().trim();
      if (name.isNotEmpty) return name;
    }
    
    // Priority 3: Try model.stageName property
    final modelStageName = mosqueObj.stageName?.toString().trim();
    if (modelStageName != null && modelStageName.isNotEmpty) {
      return modelStageName;
    }
    
    return null;
  }

  Future<Map<String, dynamic>> setMosqueEditReqToDraft({
    required int requestId,
    required String acceptTerms,
    required String stageName,           // e.g. "MMC05" - will be overridden if current state name available
    String? observationText,             // optional note/reason
    dynamic mosqueObj,                   // Optional: to extract current state name
  }) async {
    try {
      // Use actual state name from payload if available, otherwise use provided stageName
      final actualStageName = (mosqueObj != null) ? _getCurrentStateName(mosqueObj) : null;
      final finalStageName = actualStageName ?? stageName;
      
      final body = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'request_id': requestId,
          'accept_terms': acceptTerms,
          if (finalStageName != null && finalStageName.isNotEmpty) 'stage_name': finalStageName,
          if (observationText != null && observationText.isNotEmpty)
            'observation_text': observationText,
        },
      };

      // Your repo already does: _client.patch('/app/patch/mosque/edit/request/action/set/draft', body)
      final res = await service.setMosqueEditToDraft(body);

      // Expected:
      // { "jsonrpc":"2.0","id":null,"result": { "request_id": 4, "stage": {"id":498,"name":"Draft"}, "observation_text": "..."} }
      if (res is Map && res['result'] is Map) {
        return Map<String, dynamic>.from(res['result']);
      }
      if (res is Map && res['error'] != null) {
        throw res['error'];
      }
      throw 'Set to draft failed';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> acceptMosqueEditReq({
    required int requestId,
    required String acceptTerms,
    required String stageName, // e.g. "MMC05" - will be overridden if current state name available
    dynamic mosqueObj,         // Optional: to extract current state name
  }) async {
    try {
      // Use actual state name from payload if available, otherwise use provided stageName
      final actualStageName = (mosqueObj != null) ? _getCurrentStateName(mosqueObj) : null;
      final finalStageName = actualStageName ?? stageName;
      
      // Query param (as per your URL): ?request_id=4
      final query = {'request_id': requestId};

      // JSON-RPC body (as per your sample)
      final pram = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'request_id': requestId,
          'accept_terms': acceptTerms,
          if (finalStageName != null && finalStageName.isNotEmpty) 'stage_name': finalStageName,
        },
      };

       final res = await service.acceptMosqueEdit(pram);


      if (res is Map && res['result'] is Map) {
        return Map<String, dynamic>.from(res['result']);
      }

      // JSON-RPC error pattern
      if (res is Map && res['error'] != null) {
        throw res['error'];
      }

      throw 'Accept failed';
    } catch (e) {
      rethrow;
    }
  }

  // Mosque View Workflow Actions
  Future<Map<String, dynamic>> acceptMosque({
    required int mosqueId,
    required String acceptTerms,
    required String stageName,
    dynamic mosqueObj,         // Optional: to extract current state name
  }) async {
    try {
      // Use actual state name from payload if available, otherwise use provided stageName
      final actualStageName = (mosqueObj != null) ? _getCurrentStateName(mosqueObj) : null;
      final finalStageName = actualStageName ?? stageName;
      
      final param = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'mosque_id': mosqueId,
          'accept_terms': acceptTerms,
          if (finalStageName != null && finalStageName.isNotEmpty) 'stage_name': finalStageName,
        },
      };

      print('📤 Sending accept payload: $param');
      final res = await service.acceptMosque(param);
      print('📥 Accept API response: $res');

      if (res is Map && res['result'] is Map) {
        return Map<String, dynamic>.from(res['result']);
      }

      // JSON-RPC error pattern
      if (res is Map && res['error'] != null) {
        print('❌ API Error: ${res['error']}');
        throw res['error'];
      }

      print('❌ Unexpected response format: $res');
      throw 'Accept mosque failed';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refuseMosque({
    required int mosqueId,
    required String acceptTerms,
    required String stageName,
    required String refuseReason,
    dynamic mosqueObj,         // Optional: to extract current state name
  }) async {
    try {
      // Use actual state name from payload if available, otherwise use provided stageName
      final actualStageName = (mosqueObj != null) ? _getCurrentStateName(mosqueObj) : null;
      final finalStageName = actualStageName ?? stageName;
      
      final param = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'mosque_id': mosqueId,
          'accept_terms': acceptTerms,
          if (finalStageName != null && finalStageName.isNotEmpty) 'stage_name': finalStageName,
          'refuse_reason': refuseReason,
        },
      };

      final res = await service.refuseMosque(param);

      if (res is Map && res['result'] is Map) {
        return Map<String, dynamic>.from(res['result']);
      }

      // JSON-RPC error pattern
      if (res is Map && res['error'] != null) {
        throw res['error'];
      }

      throw 'Refuse mosque failed';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> setMosqueToDraft({
    required int mosqueId,
    required String acceptTerms,
    required String stageName,
    required String observationText,
    dynamic mosqueObj,         // Optional: to extract current state name
  }) async {
    try {
      // Use actual state name from payload if available, otherwise use provided stageName
      final actualStageName = (mosqueObj != null) ? _getCurrentStateName(mosqueObj) : null;
      final finalStageName = actualStageName ?? stageName;
      
      final param = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'mosque_id': mosqueId,
          'accept_terms': acceptTerms,
          if (finalStageName != null && finalStageName.isNotEmpty) 'stage_name': finalStageName,
          'observation_text': observationText,
        },
      };

      final res = await service.setMosqueToDraft(param);

      if (res is Map && res['result'] is Map) {
        return Map<String, dynamic>.from(res['result']);
      }

      // JSON-RPC error pattern
      if (res is Map && res['error'] != null) {
        throw res['error'];
      }

      throw 'Set mosque to draft failed';
    } catch (e) {
      rethrow;
    }
  }


  /// Send an edit-request (observer “Send” action).
  /// Expects the **full** mosque payload in [mosqueVals].

  /// SEND (observer) — sends the whole edit-request payload
// MosqueService.dart
  Future<EditSendResult> sendMosqueEditReq({
    required MosqueEditRequestModel request,
    required String acceptTerms,
  }) async {
    // Extract current state name if available
    final currentStateName = _getCurrentStateName(request);
    // --- helpers (scoped to this method) ---
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      if (v is num) return v.toInt();
      return null;
    }

    String _pretty(Object o) {
      try {
        return const JsonEncoder.withIndent('  ').convert(o);
      } catch (_) {
        return o.toString();
      }
    }

    dynamic _redact(dynamic v) {
      // keep logs readable: trim huge base64/bytes
      if (v is String && v.length > 200) {
        return '${v.substring(0, 80)}… (len=${v.length})';
      }
      if (v is Map) return v.map((k, val) => MapEntry(k, _redact(val)));
      if (v is List) return v.map(_redact).toList();
      return v;
    }

    // --- build param ---
    final int? rid = request.requestId;
    if (rid == null) {
      throw StateError('sendMosqueEditReq: request.requestId is null');
    }

    // Your model builds a rich body (accept_terms, mosque_vals, may include extras).
    final fullBody = request.toEditSubmitBody(acceptTerms: acceptTerms);

    // ❗ IMPORTANT: Only send exactly what the endpoint expects
    // (This avoids "can't adapt type 'dict'" for things like requester/supervisor maps)
    final filteredBody = <String, dynamic>{
      'accept_terms': fullBody['accept_terms'],
      'mosque_vals': fullBody['mosque_vals'],
    };

    final param = <String, dynamic>{
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'request_id': rid,
        ...filteredBody,
        // Include current state name if available
        if (currentStateName != null && currentStateName.isNotEmpty) 'stage_name': currentStateName,
      },
    };

    // --- debug: print the outgoing payload (sanitized) ---
    debugPrint('🚚 [sendEdit] request_id=$rid payload=\n${_pretty(_redact(param))}');

    // --- call repo ---
    final raw = await service.sendMosqueEdit(param);

    // --- normalize result (repo may already unwrap) ---
    final result = (raw is Map && raw['result'] != null) ? raw['result'] : raw;
    debugPrint('✅ [sendEdit] raw result=\n${_pretty(result)}');

    // --- robust stage parsing: support {id,name} or [id,"Name"] or flat keys ---
    dynamic stage = (result is Map) ? result['stage'] : null;

    int? stageId;
    String? stageName;

    if (stage is Map) {
      stageId = _toInt(stage['id']);
      stageName = stage['name']?.toString();
    } else if (stage is List && stage.isNotEmpty) {
      // [id, "Name"]
      stageId = _toInt(stage[0]);
      if (stage.length > 1) stageName = stage[1]?.toString();
    } else if (result is Map) {
      stageId = _toInt(result['stage_id']);
      stageName = result['stage_name']?.toString();
    }

    return EditSendResult(
      requestId: _toInt((result is Map) ? result['request_id'] : rid) ?? rid,
      stageId: stageId,
      stageName: stageName,
    );
  }




  Future<SubmitResult> sendMosque({
    required MosqueLocal mosque,
    required String acceptTerms,
  }) async {
    // Extract current state name if available
    final currentStateName = _getCurrentStateName(mosque);
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      if (v is num) return v.toInt();
      return null;
    }

    String _pretty(Object o) {
      try {
        return const JsonEncoder.withIndent('  ').convert(o);
      } catch (_) {
        return o.toString();
      }
    }

    dynamic _redact(dynamic v) {
      if (v is String && v.length > 200) {
        return '${v.substring(0, 80)}… (len=${v.length})';
      }
      if (v is Map) return v.map((k, val) => MapEntry(k, _redact(val)));
      if (v is List) return v.map(_redact).toList();
      return v;
    }

    // --- build param ---
    final int? mId = mosque.serverId;
    if (mId == null) {
      throw StateError('sendMosque: mosque.serverId is null');
    }

    // NOTE: this returns Future<Map> → await it
    final Map<String, dynamic> fullBody =
    await mosque.toSubmitBody(acceptTerms: acceptTerms);

    // send only what's needed
    final filteredBody = <String, dynamic>{
      'accept_terms': fullBody['accept_terms'],
      'mosque_vals': fullBody['mosque_vals'], // <- underscore, no space
    };

    final param = <String, dynamic>{
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'mosque_id': mId,
        ...filteredBody,
        // Include current state name if available
        if (currentStateName != null && currentStateName.isNotEmpty) 'stage_name': currentStateName,
      },
    };

    debugPrint('[sendMosque] mosque_id=$mId payload=\n${_pretty(_redact(param))}');

    // Call the correct endpoint for "submit mosque" (NOT edit)
    // Change this to your real repo method, e.g. repo.sendMosqueSubmit
    final raw = await service.sendMosque(param);

    final result = (raw is Map && raw['result'] != null) ? raw['result'] : raw;
    debugPrint('✅ [sendMosque] raw result=\n${_pretty(result)}');

    dynamic stage = (result is Map) ? result['stage'] : null;

    int? stageId;
    String? stageName;

    if (stage is Map) {
      stageId = _toInt(stage['id']);
      stageName = stage['name']?.toString();
    } else if (stage is List && stage.isNotEmpty) {
      stageId = _toInt(stage[0]);
      if (stage.length > 1) stageName = stage[1]?.toString();
    } else if (result is Map) {
      stageId = _toInt(result['stage_id']);
      stageName = result['stage_name']?.toString();
    }

    return SubmitResult(
      serverId: _toInt((result is Map) ? result['mosque_id'] : mId) ?? mId,
      stageId: stageId,
      stageName: stageName,
      raw: raw,
    );
  }


  Future<Map<String, dynamic>> refuseMosqueEditReq({
    required int requestId,
    required String acceptTerms,
    required String refuseReason,
    String? stageName,
    dynamic mosqueObj,         // Optional: to extract current state name
  }) async {
    try {
      // Use actual state name from payload if available, otherwise use provided stageName
      final actualStageName = (mosqueObj != null) ? _getCurrentStateName(mosqueObj) : null;
      final finalStageName = actualStageName ?? stageName;
      
      final pram = {
        'jsonrpc': '2.0',
        'method': 'call',
        'params': {
          'request_id': requestId,
          'accept_terms': acceptTerms,
          if (finalStageName != null && finalStageName.isNotEmpty) 'stage_name': finalStageName,
          'refuse_reason': refuseReason,
        },
      };

      // 🔎 Print the payload as JSON (exact body the server expects)
      debugPrint('➡️ [Svc] Refuse REQ json = ${jsonEncode(pram)}');
      // (Optional) also print param types
      debugPrint('➡️ [Svc] Types -> request_id:${requestId.runtimeType} '
          'accept_terms:${acceptTerms.runtimeType} '
          'stage_name:${stageName?.runtimeType} '
          'refuse_reason:${refuseReason.runtimeType}');

      final res = await service.refuseMosqueEdit(pram);

      debugPrint('⬅️ [Svc] Refuse RAW type: ${res.runtimeType}');
      debugPrint('⬅️ [Svc] Refuse RAW: $res');

      if (res is Map && res['result'] is Map) {
        final result = Map<String, dynamic>.from(res['result']);
        debugPrint('✅ [Svc] Parsed result: $result');
        return result;
      }

      if (res is Map && res['error'] != null) {
        debugPrint('❌ [Svc] JSON-RPC error: ${res['error']}');
        throw res['error'];
      }

      if (res == true) {
        debugPrint('✅ [Svc] Refuse succeeded with boolean true (no payload)');
        return {'refuse_reason': refuseReason};
      }

      if (res is Map && (res.containsKey('stage') || res.containsKey('refuse_reason'))) {
        debugPrint('✅ [Svc] Refuse success (no envelope): $res');
        return Map<String, dynamic>.from(res);
      }

      throw 'Refuse failed: unexpected shape ${res.runtimeType} → $res';
    } catch (e, st) {
      debugPrint('❌ [Svc] Exception: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  /// Fetch mosque edit request timeline
  /// GET /get/crm/mosque/edit/request/timeline?request_id=70
  Future<List<Map<String, dynamic>>> fetchEditRequestTimeline(int requestId) async {
    try {
      debugPrint('📡 [Repo] fetchEditRequestTimeline requestId=$requestId');
      
      final res = await service.getEditRequestTimeline(requestId);
      
      if (res is Map && res['success'] == true) {
        final editRequest = res['edit_request'];
        if (editRequest is Map && editRequest['workflow'] is List) {
          return List<Map<String, dynamic>>.from(editRequest['workflow']);
        }
      }
      
      debugPrint('⚠️ [Repo] fetchEditRequestTimeline: unexpected response $res');
      return [];
    } catch (e, st) {
      debugPrint('❌ [Repo] fetchEditRequestTimeline exception: $e');
      debugPrint('$st');
      return [];
    }
  }

  /// Fetch mosque creation timeline (declarations)
  /// GET /get/crm/mosque/declarations/current/details?mosque_id=130799
  Future<List<Map<String, dynamic>>> fetchMosqueCreationTimeline(int mosqueId) async {
    try {
      debugPrint('📡 [Repo] fetchMosqueCreationTimeline mosqueId=$mosqueId');
      
      final res = await service.getMosqueCreationTimeline(mosqueId);
      
      if (res is Map && res['success'] == true) {
        final data = res['data'];
        if (data is Map && data['workflow'] is List) {
          return List<Map<String, dynamic>>.from(data['workflow']);
        }
      }
      
      debugPrint('⚠️ [Repo] fetchMosqueCreationTimeline: unexpected response $res');
      return [];
    } catch (e, st) {
      debugPrint('❌ [Repo] fetchMosqueCreationTimeline exception: $e');
      debugPrint('$st');
      return [];
    }
  }

}



class MosqueListResult {
  final List<MosqueListItem> items;
  final int page;
  final int pageSize;
  final int totalRecords;

  MosqueListResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalRecords,
  });

  bool get hasMore => (page * pageSize) < totalRecords;

}

extension MosqueLocalSubmit on MosqueLocal {
  /// Build the exact body expected by /post/app/mosque/legacy_forms

}

/// submit  Result of /post/app/mosque/edit/request
// ----- DTO kept in Service layer -----
class EditRequestSubmitResult {
  final bool success;
  final int requestId;
  final String? requestName;
  final int? stageId;
  final String? stageName;
  final String? message;
  final Map<String, dynamic> raw;

  EditRequestSubmitResult({
    required this.success,
    required this.requestId,
    this.requestName,
    this.stageId,
    this.stageName,
    this.message,
    required this.raw,
  });
}

extension on Map<String, dynamic> {
  int? _toInt(dynamic v) => v is int ? v : int.tryParse('$v');
}

class EditSendResult {
  final int requestId;
  final int? stageId;
  final String? stageName;

  EditSendResult({
    required this.requestId,
    this.stageId,
    this.stageName,
  });
}

// ----- STEP 2: implement submit in Service -----

// ----- mapper for API shapes like the one you shared -----





