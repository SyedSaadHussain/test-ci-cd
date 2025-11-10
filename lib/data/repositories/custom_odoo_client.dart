import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class CustomOdooClient {

// Singleton instance
  static CustomOdooClient? _instance;
  // Map<String, dynamic>? session;

  // Singleton factory constructor
  factory CustomOdooClient() {
    _instance ??= CustomOdooClient._internal(EnvironmentConfig.baseUrl);
    return _instance!;
  }

  static CustomOdooClient getInstance(String baseUrl) {
    _instance ??= CustomOdooClient._internal(baseUrl);
    return _instance!;
  }

  CustomOdooClient._internal(this.baseURL)
      : dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  ) {
    _setupInterceptors();
  }

  // ✅ Add this getter:
  // Future<String?> get sessionId =>  readSessionId();


  /// Reset the singleton (useful for logout, server switch)
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }

  /// Dispose resources
  void dispose() {
    dio.close(force: true);
  }

  //final String baseUrl;

  //final String hardcodedDb ='moia_live';
  final String baseURL;
  // final String dbName = EnvironmentConfig.dbValue;


  final Dio dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();


  // ✅ Interceptors
  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final sessionId = await SessionManager.instance.getSessionId() ?? "";
          final cookieHeader = 'session_id=$sessionId';

          options.headers['Cookie'] = cookieHeader;
          options.headers['APIAccessToken'] = Config.discoveryApiToken;
          debugPrint('➡️ [Request] ${options.uri} with cookie $cookieHeader');

          handler.next(options);
        },
        onError: (DioException e, handler) async {
          print('❌ ERROR in Dio request');
          print('Status code: ${e.response?.statusCode}');
          print('URL: ${e.requestOptions.uri}');
          print('Response: ${e.response?.data}');
          if (Config.enableSentry) {
            await Sentry.captureException(
              e,
              withScope: (scope) {
                // Build HTTP context for structured view
                final httpContext = {
                  'url': e.requestOptions.uri.toString(),
                  'method': e.requestOptions.method,
                  if (e.response?.statusCode != null) 'statusCode': e.response!
                      .statusCode,
                  if (e.requestOptions.data != null) 'requestData': e
                      .requestOptions.data,
                  if (e.response?.data != null) 'responseData': e.response!
                      .data,
                };

                // Add to Sentry "Contexts" (structured section)
                scope.setContexts('HTTP Request', httpContext);

                // Also add "Extras" (flat key-values that are easy to see)
                scope.setExtra('HTTP URL', e.requestOptions.uri.toString());
                scope.setExtra('HTTP Method', e.requestOptions.method);
                scope.setExtra('HTTP Status', e.response?.statusCode);
                scope.setExtra('HTTP Request Data', e.requestOptions.data);
                scope.setExtra('HTTP Response Data', e.response?.data);
                scope.setExtra('Dio Error Type', e.type.toString());

                // Mark the event level as error
                scope.level = SentryLevel.error;
              },
            );
          }

          return handler.next(e);
        },

      ),
    );
  }
  // In CustomOdooClient
  Future<void> clearSessionStorage() async {
    final storage = const FlutterSecureStorage();
    await storage.delete(key: 'sessionId');
    await storage.delete(key: 'session');
    // If you store anything else, you can use: await storage.deleteAll();
  }

  /// ✅ Authenticate with dynamic username/password
  Future<dynamic> authenticate(String db,String username, String password) async {
    debugPrint('🔑 [authenticate] called!');
    debugPrint('📌 Username: $username');

    final body = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': {
        'db': db,
        'login':  await _secureStorage.read(key: "credentialUserName"),
        'password':  await _secureStorage.read(key: "credentialUserPassword"),
      },
      'id': DateTime.now().millisecondsSinceEpoch
    };

    debugPrint('📤 Auth Request Body: $body');

    try {
      final response = await dio.post(
        '/mobile/session/authenticate',
        data: jsonEncode(body),
      );


      debugPrint('✅ Response Status: ${response.statusCode}');
      debugPrint('✅ Raw Response Data: ${response.data}');

      if (response.data['error'] != null) {
        if (response.data['error']['code'] == 100) {
          final err = response.data['error'].toString();
          throw OdooSessionExpiredException(err);
        } else {

          // Other error
          final err = response.data['error'].toString();

          print(err);
          throw OdooException(err);
        }
      }
      // Odoo 11 sets uid to False on failed login without any error message
      // if (response.data['result'].containsKey('uid')) {
      //   if (response.data['result']['uid'] is bool) {
      //     throw OdooException('Authentication failed');
      //   }
      // }

      final setCookieHeader = response.headers['set-cookie'];
      String? extractedSessionId;
      if (setCookieHeader != null && setCookieHeader.isNotEmpty) {
        final cookieString = setCookieHeader.first;
        final cookies = cookieString.split(';');
        for (var cookie in cookies) {
          if (cookie.trim().startsWith('session_id=')) {
            extractedSessionId = cookie.trim().substring('session_id='.length);
            debugPrint('✅ Extracted session_id: $extractedSessionId');
          }
        }
      }

      if (extractedSessionId == null || extractedSessionId.isEmpty) {
        throw Exception('❌ Failed to extract session_id from response cookies');
      }
      SessionManager.instance.saveSessionId(extractedSessionId);

      debugPrint('✅ Saved sessionId to secure storage');

      final result = response.data;
      if (result['error'] != null) {
        throw Exception('❌ Odoo Error: ${result['error']}');
      }

      final uid = result['result']['uid'];
      if (uid == null || uid == 0) {
        throw Exception('❌ Invalid credentials or authentication failed');
      }


      // Save minimal session
      final session = {
        'id': extractedSessionId,
        'uid': uid,
        'db': db,
        'userLogin': username,
      };
      return uid;

    } catch (e) {
      debugPrint('❌ Exception in authenticate: $e');
      rethrow;
    }
  }
  void close() {
    dio.close(force: true);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> params,[bool includeJsonrpc=true]) async {
    try {
      var body = includeJsonrpc?json.encode({
        'jsonrpc': '2.0',
        'method': 'call',
        'params': params,
        'id': sha1.convert(utf8.encode(DateTime.now().toString())).toString()
      }):json.encode(params);


      final response = await dio.post(
        path,
        data: body,
        options: Options(
          headers: {
            'Cookie': 'session_id='+await SessionManager.instance.getSessionId(),
            'Content-Type': 'application/json',
          },
        ),
      );
      var result = response.data;
      response.headers.clear();
      if (result['error'] != null) {
        if (result['error']['code'] == 100) {
          SessionManager.instance.logout(false);

          // final err = result['error']['message'].toString();
          // destroySessionCustom();
          // throw OdooSessionExpiredException(err);
        } else {

          final err = result['error']['data']['message'].toString();
          throw OdooException(err);
        }
      }
      return result['result'];

    } catch (e, stackTrace) {
      // ✅ Log to Sentry with full request context
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          //hint: 'POST $path',
          withScope: (scope) {
            scope.setExtra('path', path);
            scope.setExtra('data', params);
            // scope.setExtra('sessionId', sessionId ?? 'none');
            scope.setTag('api.client', 'CustomOdooClient');
          },
        );
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> data) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        options: Options(
          headers: {
            'Cookie': 'session_id='+await SessionManager.instance.getSessionId(),
            'Content-Type': 'application/json',
          },
        ),
      );

      var result = response.data;

      if (result['error'] != null) {
        if (result['error']['code'] == 100) {
          SessionManager.instance.logout(false);
          // throw OdooSessionExpiredException(result['error']['message'].toString());
        }else if (result['error']['code'] == 500) {
          throw (result['error']['message'].toString());
        } else {
          final err = result['error']['data']['message'].toString();
          throw OdooException(err);
        }
      }


      return response.data;


    } catch (e, stackTrace) {
      // ✅ Log to Sentry with full request context
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          //hint: 'POST $path',
          withScope: (scope) {
            scope.setExtra('path', path);
            scope.setExtra('data', data);
            // scope.setExtra('sessionId', sessionId ?? 'none');
            scope.setTag('api.client', 'CustomOdooClient');
          },
        );
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(String path, [Map<String, dynamic>? queryParams]) async {
    try {
      final Response response = await dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Cookie': 'session_id='+await SessionManager.instance.getSessionId(),
           'Content-Type': 'text/plain'
          },
        ),
      );
      if(response.headers['content-type']?.any((a)=>a.contains('text/html'))==true){
        SessionManager.instance.checkSession();
      }
      else if (response.data['error'] != null) {
        if (response.data['error']['code'] == 100) {
          SessionManager.instance.logout(false);
          // throw OdooSessionExpiredException(response.data['error']['message'].toString());
        }else if (response.data['error']['code'] == 500) {
          throw (response.data['error']['message'].toString());
        } else {
          final err = response.data['error']['data']['message'].toString();
          throw OdooException(err);
        }
      }
      return response.data;

    } catch (e, stackTrace) {
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          withScope: (scope) {
            scope.setExtra('path', path);
            scope.setExtra('queryParams', queryParams ?? {});
            // scope.setExtra('sessionId', sessionId ?? 'none');
            scope.setTag('api.client', 'CustomOdooClient');
          },
        );
      }
      rethrow;
    }
  }


  Future<dynamic> callKwCustom(params) async {
    return callRPCCustom('/web/dataset/call_kw', 'call', params);

  }
  Future<dynamic> checkSessionCustom() async {
    return callRPCCustom('/web/session/check', 'call', {});
  }

  Future<dynamic> callRPCCustom(path, funcName, params) async {
    final stopwatch = Stopwatch()..start();  // ✅ define it!

    var body = json.encode({
      'jsonrpc': '2.0',
      'method': 'funcName',
      'params': params,
      'id': sha1.convert(utf8.encode(DateTime.now().toString())).toString()
    });

    try {

      final response = await dio.post(path, data: body,
        options: Options(
          headers: {
             'Cookie': 'session_id=1'+await SessionManager.instance.getSessionId(),
            'Content-Type': 'application/json',
          },
        ),
      );



      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;
      if (Config.enableSentry && elapsedMs > 15000) {
        await Sentry.captureMessage(
          'Slow RPC: $path took ${elapsedMs}ms',
          withScope: (scope) {
            scope.setTag('rpc_path', path);
            scope.setExtra('params', params);
          },
        );
      }
      var result = response.data;

      response.headers.clear();

      if (result['error'] != null) {
        if (result['error']['code'] == 100) {
          SessionManager.instance.logout(false);
          // throw OdooSessionExpiredException(result['error']['message'].toString());
        } else {
          throw OdooException(result['error']['data']['message'].toString());
        }
      }
      return result['result'];
    } catch (e, stackTrace) {
      stopwatch.stop();
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          withScope: (scope) {
            scope.setExtra('path', path);
            scope.setExtra('data', params);
            // scope.setExtra('sessionId', sessionId ?? 'none');
            scope.setTag('api.client', 'CustomOdooClient');
          },
        );
      }
      rethrow;
    }
  }

  Future<void> destroySessionCustom() async {
    final stopwatch = Stopwatch()..start();  // ✅ define it!

    var body = json.encode({
      'jsonrpc': '2.0',
      'method': 'funcName',
      'params': {},
      'id': sha1.convert(utf8.encode(DateTime.now().toString())).toString()
    });

    String path='/web/session/destroy';

    try {

      final response = await dio.post(path, data: body,
        options: Options(
          headers: {
            'Cookie': 'session_id=1'+await SessionManager.instance.getSessionId(),
            'Content-Type': 'application/json',
          },
        ),
      );



      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;
      if (Config.enableSentry && elapsedMs > 15000) {
        await Sentry.captureMessage(
          'Slow RPC: $path took ${elapsedMs}ms',
          withScope: (scope) {
            scope.setTag('rpc_path', path);
            scope.setExtra('params', {});
          },
        );
      }
      var result = response.data;

      response.headers.clear();

      if (result['error'] != null) {
        if (result['error']['code'] == 100) {
          ///nothing to return
        } else {
          throw OdooException(result['error']['data']['message'].toString());
        }
      }
      return result['result'];
    } catch (e, stackTrace) {
      stopwatch.stop();
      if (Config.enableSentry) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
          withScope: (scope) {
            scope.setExtra('path', path);
            scope.setExtra('data', {});
            // scope.setExtra('sessionId', sessionId ?? 'none');
            scope.setTag('api.client', 'CustomOdooClient');
          },
        );
      }
      rethrow;
    }
  }

  Future<dynamic> searchReadWithPaging({
    required String model,
    required List domain,
    required List<String> fields,
    int pageSize = 10,
    int pageIndex = 1,
  }) async {
    final offset = (pageIndex - 1) * pageSize;

    return await callKwCustom({
      'model': model,
      'method': 'search_read',
      'args': [domain],
      'kwargs': {
        'fields': fields,
        'offset': offset,
        'limit': pageSize,
      },
    });
  }
}
