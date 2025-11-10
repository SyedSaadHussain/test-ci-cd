// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:mosque_management_system/features/home/home_screen.dart';
// import 'package:mosque_management_system/core/constants/config.dart';
// import 'package:odoo_rpc/odoo_rpc.dart';
// import 'package:http/http.dart' as http;
// import 'package:sentry_flutter/sentry_flutter.dart';
//
// class CustomOdooClient {
//   //extends OdooClient
//   /// Odoo server URL in format proto://domain:port
//   late String baseURL;
//
//   /// Stores current session_id that is coming from responce cookies.
//   /// Odoo server will issue new session for each call as we do cross-origin requests.
//   /// Session token can be retrived with SessionId getter.
//   OdooSession? _sessionId;
//   static CustomOdooClient? _instance;
//   static CustomOdooClient getInstance(String baseUrl) {
//     // return CustomOdooClient(baseUrl);
//     _instance ??= CustomOdooClient(baseUrl);
//     return _instance!;
//   }
//
//   void dispose() {
//     this.httpClient.close();
//   }
//
//   static void resetInstance() {
//     _instance?.dispose();
//     _instance = null;
//   }
//
//   /// Language used by user on website.
//   /// It may be different from [OdooSession.userLang]
//   String frontendLang = '';
//
//   /// Tells whether we should send session change events to a stream.
//   /// Activates when there are some listeners.
//   bool _sessionStreamActive = false;
//
//   /// Send LoggedIn and LoggedOut events
//   bool _loginStreamActive = false;
//
//   /// Send in request events
//   bool _inRequestStreamActive = false;
//
//   /// Session change events stream controller
//   late StreamController<OdooSession> _sessionStreamController;
//
//   /// Login events stream controller
//   late StreamController<OdooLoginEvent> _loginStreamController;
//
//   /// Sends true while request is executed and false when it's done
//   late StreamController<bool> _inRequestStreamController;
//
//   /// HTTP client instance. By default instantiated with [http.Client].
//   /// Could be overridden for tests or custom client configuration.
//   late http.BaseClient httpClient;
//
//   /// Instantiates [OdooClient] with given Odoo server URL.
//   /// Optionally accepts [sessionId] to reuse existing session.
//   /// It is possible to pass own [httpClient] inherited
//   /// from [http.BaseClient] to override default one.
//   CustomOdooClient(String baseURL,
//       [OdooSession? sessionId, http.BaseClient? httpClient]) {
//     // Restore previous session
//     _sessionId = sessionId;
//     // Take or init HTTP client
//     this.httpClient = httpClient ?? http.Client() as http.BaseClient;
//
//     var baseUri = Uri.parse(baseURL);
//
//     // Take only scheme://host:port
//     print('baseURL..');
//     print(baseURL);
//     this.baseURL = baseUri.origin;
//
//     _sessionStreamController = StreamController<OdooSession>.broadcast(
//         onListen: _startSessionSteam, onCancel: _stopSessionStream);
//
//     _loginStreamController = StreamController<OdooLoginEvent>.broadcast(
//         onListen: _startLoginSteam, onCancel: _stopLoginStream);
//
//     _inRequestStreamController = StreamController<bool>.broadcast(
//         onListen: _startInRequestSteam, onCancel: _stopInRequestStream);
//   }
//
//   Future<void> _logToSentry(Exception error, StackTrace stackTrace,
//       {required String hint, int? elapsedMs}) async {
//     await Sentry.captureException(
//       error,
//       stackTrace: stackTrace,
//       withScope: (scope) {
//         scope.setTag('rpc_hint', hint);
//         if (elapsedMs != null) {
//           scope.setExtra('rpc_elapsed_ms', elapsedMs);
//         }
//       },
//     );
//   }
//
//   void _startSessionSteam() => _sessionStreamActive = true;
//
//   void _stopSessionStream() => _sessionStreamActive = false;
//
//   void _startLoginSteam() => _loginStreamActive = true;
//
//   void _stopLoginStream() => _loginStreamActive = false;
//
//   void _startInRequestSteam() => _inRequestStreamActive = true;
//
//   void _stopInRequestStream() => _inRequestStreamActive = false;
//
//   /// Returns current session
//   OdooSession? get sessionId => _sessionId;
//
//   /// Returns stream of session changed events
//   Stream<OdooSession> get sessionStream => _sessionStreamController.stream;
//
//   /// Returns stream of login events
//   Stream<OdooLoginEvent> get loginStream => _loginStreamController.stream;
//
//   /// Returns stream of inRequest events
//   Stream<bool> get inRequestStream => _inRequestStreamController.stream;
//   Future get inRequestStreamDone => _inRequestStreamController.done;
//
//   /// Frees HTTP client resources
//   void close() {
//     httpClient.close();
//   }
//
//   void _setSessionId(String newSessionId, {bool auth = false}) {
//     // Update session if exists
//     if (_sessionId != null && _sessionId!.id != newSessionId) {
//       final currentSessionId = _sessionId!.id;
//
//       if (currentSessionId == '' && !auth) {
//         // It is not allowed to init new session outside authenticate().
//         // Such may happen when we are already logged out
//         // but received late RPC response that contains session in cookies.
//         return;
//       }
//
//       _sessionId = _sessionId!.updateSessionId(newSessionId);
//
//       if (currentSessionId == '' && _loginStreamActive) {
//         // send logged in event
//         _loginStreamController.add(OdooLoginEvent.loggedIn);
//       }
//
//       if (newSessionId == '' && _loginStreamActive) {
//         // send logged out event
//         _loginStreamController.add(OdooLoginEvent.loggedOut);
//       }
//
//       if (_sessionStreamActive) {
//         // Send new session to listeners
//         _sessionStreamController.add(_sessionId!);
//       }
//     }
//   }
//
//   // Take new session from cookies and update session instance
//   void _updateSessionIdFromCookies(http.Response response,
//       {bool auth = false}) {
//     // see https://github.com/dart-lang/http/issues/362
//     final lookForCommaExpression = RegExp(r'(?<=)(,)(?=[^;]+?=)');
//
//     var cookiesStr = response.headers['set-cookie'];
//
//     if (cookiesStr == null) {
//       return;
//     }
//
//     for (final cookieStr in cookiesStr.split(lookForCommaExpression)) {
//       try {
//         final cookie = Cookie.fromSetCookieValue(cookieStr);
//
//         if (cookie.name == 'session_id') {
//           _setSessionId(cookie.value, auth: auth);
//         }
//       } catch (e) {
//         throw OdooException(e.toString());
//       }
//     }
//   }
//
//   final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
//
//   /// Authenticates user for given database.
//   /// This call receives valid session on successful login
//   /// which we be reused for future RPC calls.
//   Future<OdooSession> authenticate(
//       String db, String login, String password) async {
//     //  final params = {'db': db, 'login': await _secureStorage.read(key: "userName"), 'password': await _secureStorage.read(key: "userName")};
//     var headers = {
//       'Content-type': 'application/json',
//       'APIAccessToken': Config.discoveryApiToken
//     };
//     var uri = Uri.parse('$baseURL/mobile/session/authenticate');
//     var body = json.encode({
//       'jsonrpc': '2.0',
//       'method': 'call',
//       'params': {
//         'db': db,
//         'login': await _secureStorage.read(key: "credentialUserName"),
//         'password': await _secureStorage.read(key: "credentialUserPassword")
//       },
//       'id': sha1.convert(utf8.encode(DateTime.now().toString())).toString()
//     });
//
//     try {
//       if (_inRequestStreamActive) _inRequestStreamController.add(true);
//       var response = await httpClient.post(uri, body: body, headers: headers);
//       //response.headers.clear();
//
//       var result = json.decode(response.body);
//       if (result['error'] != null) {
//         if (result['error']['code'] == 100) {
//           // session expired
//           _setSessionId('');
//           final err = result['error'].toString();
//           throw OdooSessionExpiredException(err);
//         } else {
//           // Other error
//           final err = result['error'].toString();
//           throw OdooException(err);
//         }
//       }
//       // Odoo 11 sets uid to False on failed login without any error message
//       if (result['result'].containsKey('uid')) {
//         if (result['result']['uid'] is bool) {
//           throw OdooException('Authentication failed');
//         }
//       }
//
//       //OdooSession? _sessionIdTemp;
//       //_sessionId = OdooSession.fromSessionInfo(result['result']);
//       // It will notify subscribers
//       _sessionId = OdooSession(
//           id: '',
//           userId: 0,
//           partnerId: 0,
//           userLogin: '',
//           userName: '',
//           userLang: '',
//           userTz: '',
//           isSystem: false,
//           dbName: '',
//           serverVersion: '');
//       _updateSessionIdFromCookies(response, auth: true);
//       if (_inRequestStreamActive) _inRequestStreamController.add(false);
//       await _secureStorage.write(
//           key: "session", value: json.encode(_sessionId!.toJson()));
//       await _secureStorage.write(key: "sessionId", value: _sessionId!.id);
//
//       return _sessionId!;
//     } catch (e) {
//       if (_inRequestStreamActive) _inRequestStreamController.add(false);
//       rethrow;
//     }
//   }
//
//   /// Destroys current session.
//   Future<void> destroySessionCustom() async {
//     try {
//       await callRPCCustom('/web/session/destroy', 'call', {});
//       // RPC call sets expired session.
//       // Need to overwrite it.
//       _setSessionId('');
//     } on Exception {
//       // If session is not cleared due to
//       // unknown error - clear it locally.
//       // Remote session will expire on its own.
//       _setSessionId('');
//     }
//   }
//
//   Future<dynamic> callKwCustom(params) async {
//     return callRPCCustom('/web/dataset/call_kw', 'call', params);
//   }
//
//   Future<dynamic> checkSessionCustom() async {
//     return callRPCCustom('/web/session/check', 'call', {});
//   }
//
//   Future<dynamic> callRPCCustom(path, funcName, params) async {
//     final stopwatch = Stopwatch()..start(); // ✅ define it!
//
//     dynamic headers = {'Content-type': 'application/json'};
//     // dynamic cookie = '';
//     // if (frontendLang.isNotEmpty) {
//     //   if (cookie.isEmpty) {
//     //     cookie = 'frontend_lang=$frontendLang';
//     //   } else {
//     //     cookie += '; frontend_lang=$frontendLang';
//     //   }
//     // }
//     headers['APIAccessToken'] = Config.discoveryApiToken;
//
//     //headers['session_id']=  (await _secureStorage.read(key: "sessionId")??"");
//     headers['Cookie'] = 'session_id=' +
//         (await _secureStorage.read(key: "sessionId") ?? "") +
//         '; frontend_lang=$frontendLang';
//
//     final uri = Uri.parse(baseURL + path);
//     var body = json.encode({
//       'jsonrpc': '2.0',
//       'method': 'funcName',
//       'params': params,
//       'id': sha1.convert(utf8.encode(DateTime.now().toString())).toString()
//     });
//
//     try {
//       if (_inRequestStreamActive) _inRequestStreamController.add(true);
//
//       final response = await httpClient.post(uri, body: body, headers: headers);
//
//       stopwatch.stop();
//       final elapsedMs = stopwatch.elapsedMilliseconds;
//       if (Config.enableSentry && elapsedMs > 15000) {
//         await Sentry.captureMessage(
//           'Slow RPC: $path took ${elapsedMs}ms',
//           withScope: (scope) {
//             scope.setTag('rpc_path', path);
//             scope.setExtra('params', params);
//           },
//         );
//       }
//
//       var result = json.decode(response.body);
//       response.headers.clear();
//
//       if (result['error'] != null) {
//         if (result['error']['code'] == 100) {
//           _setSessionId('');
//           throw OdooSessionExpiredException(
//               result['error']['message'].toString());
//         } else {
//           throw OdooException(result['error']['data']['message'].toString());
//         }
//       }
//
//       if (_inRequestStreamActive) _inRequestStreamController.add(false);
//       return result['result'];
//     } catch (e, stackTrace) {
//       stopwatch.stop();
//       if (Config.enableSentry) {
//         await _logToSentry(
//           e is Exception ? e : Exception(e.toString()),
//           stackTrace,
//           hint: 'callRPCCustom $path',
//           elapsedMs: stopwatch.elapsedMilliseconds,
//         );
//       }
//       if (_inRequestStreamActive) _inRequestStreamController.add(false);
//       rethrow;
//     }
//   }
//
//   //   try {
//   //
//   //     if (_inRequestStreamActive) _inRequestStreamController.add(true);
//   //
//   //
//   //     dynamic response = await httpClient.post(uri, body: body, headers: headers);
//   //
//   //     var result = json.decode(response.body);
//   //     //_updateSessionIdFromCookies(response);
//   //     response.headers.clear();
//   //     headers=null;
//   //     response=null;
//   //
//   //     if (result['error'] != null) {
//   //       if (result['error']['code'] == 100) {
//   //         //final err = result['error'].toString();
//   //         final err = result['error']['message'].toString();
//   //         // session expired
//   //         _setSessionId('');
//   //
//   //         throw OdooSessionExpiredException(err);
//   //       } else {
//   //
//   //         final err = result['error']['data']['message'].toString();
//   //         throw OdooException(err);
//   //       }
//   //     }
//   //     if (_inRequestStreamActive) _inRequestStreamController.add(false);
//   //
//   //     return result['result'];
//   //   } catch (e) {
//   //     if (_inRequestStreamActive) _inRequestStreamController.add(false);
//   //     rethrow;
//   //   }
//   // }
//   Future<dynamic> searchReadWithPaging({
//     required String model,
//     required List domain,
//     required List<String> fields,
//     int pageSize = 10,
//     int pageIndex = 1,
//   }) async {
//     final offset = (pageIndex - 1) * pageSize;
//
//     return await callKwCustom({
//       'model': model,
//       'method': 'search_read',
//       'args': [domain],
//       'kwargs': {
//         'fields': fields,
//         'offset': offset,
//         'limit': pageSize,
//       },
//     });
//   }
//
//   Future<dynamic> post(path, params, [bool includeJsonrpc = true]) async {
//     final stopwatch = Stopwatch()..start();
//     var headers = {'Content-type': 'application/json'};
//     // var cookie;
//     //
//     // if (frontendLang.isNotEmpty) {
//     //   if (cookie.isEmpty) {
//     //     cookie = 'frontend_lang=$frontendLang';
//     //   } else {
//     //     cookie += '; frontend_lang=$frontendLang';
//     //   }
//     // }
//
//     headers['Cookie'] = 'session_id=' +
//         (await _secureStorage.read(key: "sessionId") ?? "") +
//         '; frontend_lang=$frontendLang';
//     //headers['session_id']=(await _secureStorage.read(key: "sessionId")??"");
//
//     headers['APIAccessToken'] = Config.discoveryApiToken;
//     final url = Uri.parse(baseURL + path);
//
//     //var body = json.encode(params);
//     var body = includeJsonrpc
//         ? json.encode({
//             'jsonrpc': '2.0',
//             'method': 'funcName',
//             'params': params,
//             'id':
//                 sha1.convert(utf8.encode(DateTime.now().toString())).toString()
//           })
//         : json.encode(params);
//
//     try {
//       print('aaaaaaaaaaaaaaaaaa12');
//
//       var response = await httpClient.post(url, headers: headers, body: body);
//       print(response);
//       stopwatch.stop();
//       final elapsedMs = stopwatch.elapsedMilliseconds;
//       if (elapsedMs > 15000 && Config.enableSentry) {
//         await Sentry.captureMessage(
//           'Slow RPC: $path took ${elapsedMs}ms',
//           withScope: (scope) {
//             scope.setTag('rpc_path', path);
//             scope.setExtra('params', params);
//           },
//         );
//       }
//
//       //_updateSessionIdFromCookies(response);
//       // return;
//
//       //response.headers.clear();
//       var result = json.decode(response.body);
//       response.headers.clear();
//       if (result['error'] != null) {
//         if (result['error']['code'] == 100) {
//           //final err = result['error'].toString();
//           final err = result['error']['message'].toString();
//           destroySessionCustom();
//           throw OdooSessionExpiredException(err);
//         } else {
//           final err = result['error']['data']['message'].toString();
//           throw OdooException(err);
//         }
//       }
//       return result['result'];
//     } catch (e, stackTrace) {
//       stopwatch.stop();
//       if (Config.enableSentry) {
//         await _logToSentry(
//           e is Exception ? e : Exception(e.toString()),
//           stackTrace,
//           hint: 'callRPCCustom $path',
//           elapsedMs: stopwatch.elapsedMilliseconds,
//         );
//       }
//       rethrow;
//     }
//   }
//
//   Future<dynamic> patch(path, params) async {
//     final stopwatch = Stopwatch()..start();
//     var headers = {'Content-type': 'application/json'};
//     // var cookie;
//     //
//     // if (frontendLang.isNotEmpty) {
//     //   if (cookie.isEmpty) {
//     //     cookie = 'frontend_lang=$frontendLang';
//     //   } else {
//     //     cookie += '; frontend_lang=$frontendLang';
//     //   }
//     // }
//
//     headers['Cookie'] = 'session_id=' +
//         (await _secureStorage.read(key: "sessionId") ?? "") +
//         '; frontend_lang=$frontendLang';
//     //headers['session_id']=(await _secureStorage.read(key: "sessionId")??"");
//
//     headers['APIAccessToken'] = Config.discoveryApiToken;
//     final url = Uri.parse(baseURL + path);
//
//     //var body = json.encode(params);
//     // var body = json.encode({
//     //   'jsonrpc': '2.0',
//     //   'method': 'funcName',
//     //   'params': params,
//     //   'id': sha1.convert(utf8.encode(DateTime.now().toString())).toString()
//     // });
//
//     var body = json.encode(params);
//
//     try {
//       var response = await httpClient.patch(url, headers: headers, body: body);
//
//       stopwatch.stop();
//       final elapsedMs = stopwatch.elapsedMilliseconds;
//       if (elapsedMs > 15000 && Config.enableSentry) {
//         await Sentry.captureMessage(
//           'Slow RPC: $path took ${elapsedMs}ms',
//           withScope: (scope) {
//             scope.setTag('rpc_path', path);
//             scope.setExtra('params', params);
//           },
//         );
//       }
//
//       //_updateSessionIdFromCookies(response);
//       // return;
//
//       //response.headers.clear();
//       var result = json.decode(response.body);
//       response.headers.clear();
//       if (result['error'] != null) {
//         if (result['error']['code'] == 100) {
//           //final err = result['error'].toString();
//           final err = result['error']['message'].toString();
//           destroySessionCustom();
//           throw OdooSessionExpiredException(err);
//         } else {
//           final err = result['error']['data']['message'].toString();
//           throw OdooException(err);
//         }
//       }
//       // print(result['result']);
//       return result;
//     } catch (e, stackTrace) {
//       stopwatch.stop();
//       if (Config.enableSentry) {
//         await _logToSentry(
//           e is Exception ? e : Exception(e.toString()),
//           stackTrace,
//           hint: 'callRPCCustom $path',
//           elapsedMs: stopwatch.elapsedMilliseconds,
//         );
//       }
//       rethrow;
//     }
//   }
//
//   Future<dynamic> get(String path, [Map<String, dynamic>? queryParams]) async {
//     final stopwatch = Stopwatch()..start();
//
//     // ✅ Corrected headers: Removed Content-Type (GET requests don't have body)
//     final headers = {
//       'Cookie':
//           'session_id=${await _secureStorage.read(key: "sessionId") ?? ""}; frontend_lang=$frontendLang',
//       'APIAccessToken': Config.discoveryApiToken,
//     };
//
//     // ✅ Build full URL with query parameters
//     final uri = Uri.parse(baseURL + path).replace(
//       queryParameters: queryParams?.map((k, v) => MapEntry(k, v.toString())),
//     );
//
//     try {
//       print("🌍 Final GET URL: $uri");
//       final response = await httpClient.get(uri, headers: headers);
//
//       // return result['result'];
//
//       stopwatch.stop();
//       final elapsedMs = stopwatch.elapsedMilliseconds;
//       if (Config.enableSentry && elapsedMs > 15000) {
//         await Sentry.captureMessage(
//           'Slow GET: $path took ${elapsedMs}ms',
//           withScope: (scope) {
//             scope.setTag('http_path', path);
//             scope.setExtra('queryParams', queryParams);
//           },
//         );
//       }
//
//       // print("📨 Raw response.statusCode = ${response.statusCode}");
//       // print("📨 Raw response.body = ${response.body}");
//
//       // ✅ Handle non-200 responses
//       if (response.statusCode != 200) {
//         throw Exception('GET request failed: ${response.statusCode}');
//       }
//
//       final result = json.decode(response.body);
//       response.headers.clear();
//
//       // ✅ Handle API-level error format
//       if (result is Map && result['error'] != null) {
//         if (result['error']['code'] == 100) {
//           final err = result['error']['message'].toString();
//           destroySessionCustom();
//           throw OdooSessionExpiredException(err);
//         } else {
//           final err = result['error']['data']['message'].toString();
//           throw OdooException(err);
//         }
//       }
//       return result;
//     } catch (e, stackTrace) {
//       stopwatch.stop();
//       print("❌ get() error: $e");
//       if (Config.enableSentry) {
//         await _logToSentry(
//           e is Exception ? e : Exception(e.toString()),
//           stackTrace,
//           hint: 'callGETCustom $path',
//           elapsedMs: stopwatch.elapsedMilliseconds,
//         );
//       }
//       rethrow;
//     }
//   }
//
// // Add additional customization if needed
// }
