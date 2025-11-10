
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../../core/utils/json_utils.dart';
import '../../../../core/constants/config.dart';
import '../../../../data/services/custom_odoo_client.dart';

class SubmitResult {
  final int serverId;                     // mosque_id
  final String? mosqueName;               // result.mosque_name (optional)
  final String? number;                   // result.number
  final int? stageId;                     // result.stage.id
  final String? stageName;                // result.stage.name
  final Map<String, dynamic> raw;         // whole response (kept)

  SubmitResult({
    required this.serverId,
    required this.raw,
    this.mosqueName,
    this.number,
    this.stageId,
    this.stageName,
  });
}


// class RepoRawResponse {
//   final int? statusCode; // may be null when using client.post()
//   final Map<String, dynamic>? json;
//   final String? rawBody;
//   RepoRawResponse({this.statusCode, this.json, this.rawBody});
// }
class ApiSubmitError implements Exception {
  final String message;
  final Map<String, dynamic>? raw;
  ApiSubmitError(this.message, {this.raw});
  @override
  String toString() => message;
}

class MosqueService {
  final CustomOdooClient _client;
  MosqueService(this._client);

  static const String _createPath = '/post/app/mosque/create';

  Future<SubmitResult> submitMosque(Map<String, dynamic> body) async {
    final resp = await _client.post(_createPath, body,false);
    final Map<String, dynamic> root = Map<String, dynamic>.from(resp);

    // JSON-RPC error envelope
    if (root['error'] is Map) {
      final err = Map<String, dynamic>.from(root['error'] as Map);
      final msg = (err['message'] ?? err['data']?['message'] ?? 'Server error').toString();
      throw Exception(msg);
    }

    final Map<String, dynamic> result =
    (root['result'] is Map<String, dynamic>)
        ? Map<String, dynamic>.from(root['result'])
        : root;

    if (result['success'] == false) {
      throw Exception((result['message'] ?? 'Submit failed').toString());
    }

    // ---- extract the fields we care about ----
    final int? id = (result['mosque_id'] ?? result['id'] ?? result['data']?['id']) as int?;
    if (id == null) {
      final msg = (result['message'] ?? 'Submit succeeded but no ID returned').toString();
      throw Exception(msg);
    }


    final String? number    = result['number']?.toString();
    final String? mosqueName= result['mosque_name']?.toString();
    final Map<String, dynamic>? stageMap =
    (result['stage'] is Map) ? Map<String, dynamic>.from(result['stage']) : null;

// FIXED: no "map?['id']" and no Arabic semicolon
    final dynamic rawStageId   = stageMap != null ? stageMap['id']   : null;
    final int? stageId         = (rawStageId is int) ? rawStageId : int.tryParse('$rawStageId');

    final dynamic rawStageName = stageMap != null ? stageMap['name'] : null;
    final String? stageName    = rawStageName?.toString();


    return SubmitResult(
      serverId: id,
      number: number,
      mosqueName: mosqueName,
      stageId: stageId,
      stageName: stageName,
      raw: root,
    );
  }

  Future<Map<String, dynamic>> _rawGetJson({
    required String baseUrl,
    required String path,
    required String? sessionId,
    required String apiToken,
  }) async {
    final client = HttpClient();
    client.idleTimeout = const Duration(seconds: 0); // avoid reuse entirely
    try {
      final uri = Uri.parse(baseUrl).resolve(path);
      final req = await client.getUrl(uri);

      // Headers – mirror what works in Postman
      if (sessionId != null && sessionId.isNotEmpty) {
        req.headers.set(HttpHeaders.cookieHeader, 'session_id=$sessionId');
      }
      req.headers.set('APIAccessToken', apiToken);
      req.headers.set(HttpHeaders.acceptHeader, '*/*');
      // Many servers dislike Content-Type on GET; omit it.
      // If your server *requires* text/plain, uncomment:
      // req.headers.set(HttpHeaders.contentTypeHeader, 'text/plain');

      // Optional: force a new TCP connection for this one request
      req.headers.set(HttpHeaders.connectionHeader, 'close');

      final res = await req.close();
      final body = await res.transform(utf8.decoder).join();

      if (res.statusCode >= 400) {
        throw HttpException('HTTP ${res.statusCode}: $body', uri: uri);
      }

      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw const FormatException('Invalid JSON map');
    } finally {
      client.close(force: true);
    }
  }

  Future<dynamic> getMosqueViewDetail(Map<String, dynamic> queryString, String url) async {
    try {
      // mirrors the visit flow: GET /get/crm + url?mosque_id=...
      final response = await _client.get('/get/crm$url', queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getMosqueEditViewDetail(Map<String, dynamic> queryString, String url) async {
    try {
      // mirrors the visit flow: GET /get/crm + url?mosque_id=...
      final response = await _client.get('/get/crm$url', queryString);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// GET job numbers list for a city/family/position/relation
  Future<List<Map<String, dynamic>>> getJobNumbers({
    required int cityId,
    required int jobFamilyId,
    required int jobPositionId,
    required String staffRelationType,
    int page = 1,
    int limit = 10,
  }) async {
    final resp = await _client.get('/get/crm/job/numbers', {
      'city_id': cityId,
      'job_family_id': jobFamilyId,
      'job_position_id': jobPositionId,
      'staff_relation_type': staffRelationType,
      'page': page,
      'limit': limit,
    });
    final List data = (resp is Map && resp['data'] is List) ? resp['data'] as List : const [];
    return data.whereType<Map>().map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<dynamic> getMosques({
    int? stageId,
    required int page,
    required int limit,
  }) async {
    try {
      final query = <String, dynamic>{
        if (stageId != null) 'stage_id': stageId,
        'page': page,
        'limit': limit,
      };
      final resp = await _client.get('/mobile/get/crm/mosque', query);
      return resp;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> setMosqueEditToDraft(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/edit/request/action/set/draft',param);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getMosqueEditRequests({
    int? stageId,
    required int page,
    required int limit,
  }) async {
    try {
      final query = <String, dynamic>{
        if (stageId != null) 'stage_id': stageId,
        'page': page,
        'limit': limit,
      };
      final resp = await _client.get('/mobile/get/crm/mosque/edit/request', query);
      return resp;
    } catch (e) {
      rethrow;
    }
  }


  static const String _crmBase = '/get/crm';

  // Robust un-wrapper for both JSON-RPC and plain REST ({status:'success'})
  Map<String, dynamic> _unwrapRoot(dynamic resp) {
    final Map<String, dynamic> root = Map<String, dynamic>.from(resp as Map);

    if (root['error'] is Map) {
      final err = Map<String, dynamic>.from(root['error']);
      final msg = (err['message'] ?? err['data']?['message'] ?? 'Server error').toString();
      throw ApiSubmitError(msg, raw: root);
    }

    if (root['result'] is Map<String, dynamic>) {
      return Map<String, dynamic>.from(root['result']);
    }
    return root;
  }

  /// 1) Picker: GET /get/crm/mosque/edit/request
  /// Returns: [{id, name}, …] (sanitized)
  Future<List<Map<String, dynamic>>> getMosqueEditReqPicker() async {
    const path = '/get/crm/mosque/edit/request';
    debugPrint('[repo] GET $path');

    final resp = await _client.get(path);
    debugPrint('[repo] raw: ${resp.runtimeType}');

    // If your client returns already-unwrapped data:
    final Map<String, dynamic> root = (resp is Map<String, dynamic>)
        ? resp
        : <String, dynamic>{'data': resp};

    // Try common envelopes: {status, data} or {result: {data}}
    final Map<String, dynamic> un = () {
      if (root['data'] is Map || root['data'] is List) return root;
      if (root['result'] is Map && root['result']['data'] != null) {
        return Map<String, dynamic>.from(root['result']);
      }
      return root;
    }();

    final list = (un['data'] as List?) ?? (root['result']?['data'] as List?) ?? const [];
    debugPrint('[repo] picker data count = ${list.length}');

    final mapped = list.map<Map<String, dynamic>>((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return {
        'id'  : JsonUtils.toInt(m['id']) ?? 0,
        'name': JsonUtils.toText(m['name']) ?? '',
      };
    }).where((m) => (m['id'] as int) > 0 && (m['name'] as String).isNotEmpty).toList();

    debugPrint('[repo] picker mapped count = ${mapped.length}');
    return mapped;
  }

  // Future<List<Map<String, dynamic>>> getMosqueEditReqPicker() async {
  //
  //
  //   const String path = '/get/crm/mosque/edit/request';
  //   try {
  //     debugPrint('[repo] GET $path');
  //     final resp = await _client.get(path, {});        // your existing Dio call
  //
  //     // normal unwrap
  //     final un   = _unwrapRoot(resp);
  //     final list = (un['data'] as List?) ?? const [];
  //     return list.map<Map<String, dynamic>>((e) {
  //       final m = Map<String, dynamic>.from(e as Map);
  //       return {
  //         'id': JsonUtils.toInt(m['id']) ?? 0,
  //         'name': JsonUtils.toText(m['name']) ?? '',
  //       };
  //     }).where((m) => (m['id'] as int) > 0 && (m['name'] as String).isNotEmpty).toList();
  //
  //   } catch (e) {
  //     // 🔁 Fallback: raw one-shot socket (Postman-like)
  //     debugPrint('[repo] picker Dio failed → fallback raw HttpClient. Reason: $e');
  //
  //     // pull what we need from the existing client without changing its API
  //     final baseUrl = _client.baseUrl;              // expose via getter if not public
  //     final sid = await _client.readSessionId();    // small getter you add (below)
  //     final raw = await _rawGetJson(
  //       baseUrl: baseUrl,
  //       path: path,
  //       sessionId: sid,
  //       apiToken: Config.discoveryApiToken,
  //     );
  //
  //     final un   = _unwrapRoot(raw);
  //     final list = (un['data'] as List?) ?? const [];
  //     return list.map<Map<String, dynamic>>((e) {
  //       final m = Map<String, dynamic>.from(e as Map);
  //       return {
  //         'id': JsonUtils.toInt(m['id']) ?? 0,
  //         'name': JsonUtils.toText(m['name']) ?? '',
  //       };
  //     }).where((m) => (m['id'] as int) > 0 && (m['name'] as String).isNotEmpty).toList();
  //   }
  // }



  /// Map your TabKey → endpoint suffix (under /get/crm).
  /// Keep keys identical to your Tab keys in MosqueDetail.
  static const Map<String, String> kEditTabEndpoints = {
    'basic_info'            : '/mosque/edit/basic/info',
    'mosque_address'        : '/mosque/edit/address',
    'mosque_condition'      : '/mosque/edit/condition',
    'architectural_structure': '/mosque/edit/architecture',
    'men_prayer_section'    : '/mosque/edit/men/section',
    'women_prayer_section'  : '/mosque/edit/women/section',
    'imams_muezzins_details': '/mosque/edit/imam/muezzin',
    'mosque_facilities'     : '/mosque/edit/facilities',
    'mosque_land'           : '/mosque/edit/land',
    'audio_and_electronics' : '/mosque/edit/audio/electronics',
    'safety_equipment'      : '/mosque/edit/safety',
    'maintenance'           : '/mosque/edit/maintenance',
    'historical_mosques'    : '/mosque/edit/historical',
    'qr_code_panel'         : '/mosque/edit/qr/code',
    'meters'                : '/mosque/edit/meters/info',
  };

  /// 2) Per-tab fetch by TabKey (uses the map above)
  Future<Map<String, dynamic>> getMosqueEditTabByKey({
    required String tabKey,
    required int mosqueId,
  }) async {
    final suffix = kEditTabEndpoints[tabKey];
    if (suffix == null) {
      throw ApiSubmitError('Unknown edit tab key: $tabKey');
    }
    final full = '$_crmBase$suffix';
    final resp = await _client.get(full, {'mosque_id': mosqueId});
    final un   = _unwrapRoot(resp);
    final data = un['data'];
    return (data is Map)
        ? Map<String, dynamic>.from(data as Map)
        : <String, dynamic>{};
  }

  /// 3) Optional: fetch by explicit path (if you ever need to bypass the map)
  Future<Map<String, dynamic>> getMosqueEditTabByPath({
    required String path, // e.g. '/mosque/edit/address' or '/get/crm/mosque/edit/address'
    required int mosqueId,
  }) async {
    final full = path.startsWith('/get/crm') ? path : '$_crmBase$path';
    final resp = await _client.get(full, {'mosque_id': mosqueId});
    final un   = _unwrapRoot(resp);
    final data = un['data'];
    return (data is Map)
        ? Map<String, dynamic>.from(data as Map)
        : <String, dynamic>{};
  }

// lib/data/repositories/mosque_repository.dart

  Future<Map<String, dynamic>> postMosqueEditRequestSubmit(
      Map<String, dynamic> body,
      ) async {
    // Existing path is correct
    const path = '/post/app/mosque/edit/request';
    final raw = await _client.post(path, body,false);

    // ⬅️ NEW: return a flat map that is either `result{...}` or the root itself.
    if (raw is Map<String, dynamic>) {
      final map = Map<String, dynamic>.from(raw);
      if (map['result'] is Map) {
        return Map<String, dynamic>.from(map['result'] as Map);
      }
      return map;
    }
    // Defensive: ensure a Map comes back to the service
    return {'success': false, 'message': 'Invalid response from server'};
  }

  Future<dynamic> acceptMosqueEdit(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/edit/request/action/accept',param);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendMosqueEdit(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/edit/request/action/send',param);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> sendMosque(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/action/send',param);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future<dynamic> refuseMosqueEdit(dynamic param) async {
    const path = '/app/patch/mosque/edit/request/action/refuse';
    try {
      debugPrint('➡️ [Repo] PATCH $path');
      debugPrint('➡️ [Repo] Body(json): ${jsonEncode(param)}');

      final response = await _client.patch(path, param);

      // If your client returns a Response-like object, prefer response.data.
      final data = (response is Map) ;

      // 🔎 print raw classes + values
      debugPrint('⬅️ [Repo] Raw response type: ${response.runtimeType}');
      // If Response has statusCode, print it safely:
      try { debugPrint('⬅️ [Repo] statusCode: ${response}'); } catch (_) {}
      debugPrint('⬅️ [Repo] Data type: ${data.runtimeType}');
      debugPrint('⬅️ [Repo] Data: $data');

      return data;
    } catch (e, st) {
      debugPrint('❌ [Repo] Exception: $e');
      debugPrint('$st');
      rethrow;
    }
  }
  // Mosque View Workflow Actions
  Future<dynamic> acceptMosque(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/action/accept', param);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> refuseMosque(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/action/refuse', param);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> setMosqueToDraft(dynamic param) async {
    try {
      final response = await _client.patch('/app/patch/mosque/action/set/draft', param);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get edit request timeline
  Future<dynamic> getEditRequestTimeline(int requestId) async {
    try {
      final response = await _client.get('/get/crm/mosque/edit/request/timeline', {'request_id': requestId});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Get mosque creation timeline (declarations)
  Future<dynamic> getMosqueCreationTimeline(int mosqueId) async {
    try {
      final response = await _client.get('/get/crm/mosque/declarations/current/details', {'mosque_id': mosqueId});
      return response;
    } catch (e) {
      rethrow;
    }
  }



}

