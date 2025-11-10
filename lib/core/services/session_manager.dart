import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  // Private constructor
  SessionManager._privateConstructor();

  // Single global instance
  static final SessionManager instance = SessionManager._privateConstructor();

  final _secureStorage = FlutterSecureStorage();
  final EncryptionHelper _encryptionUtil = EncryptionHelper();

  Future<void> login(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", _encryptionUtil.encrypt(userId.toString()));
  }

  /// if session already expired like in api call
  Future<void> logout([bool isSessionOut=true]) async {
    if(isSessionOut){
      final client = CustomOdooClient();
      client.destroySessionCustom();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
    _secureStorage.delete(key: "sessionId");
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
          (Route<dynamic> route) => false,
    );
  }
  void checkSession() async {
    try {
      var repository = CommonRepository(CustomOdooClient());
      bool isLoggedIn = !(await repository.ischeckSessionExpire());
      if (!isLoggedIn) {
        logout(false);
      }
    } catch (e) {

    }

  }
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final userId =await prefs.getString("userId");
    if (AppUtils.isNullOrEmpty(userId)) {
      return false;
    }
    return true;
  }

  Future<User> getUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userId = prefs.getString("userId");
      String? proxy = prefs.getString("proxy");


      return User(
          userId: int.tryParse(_encryptionUtil.decrypt(userId ?? "") ?? "0") ??
              0,
          proxy: proxy
      );
    } catch (e) {
      // Handle platform exceptions here
      throw Exception();
    }
  }
  Future<String> getSessionId() async {
    try {
      final sid = await _secureStorage.read(key: 'sessionId');
      return sid??'';
    } catch (_) {
      return '';
    }
  }



  Future<void> saveProxy(String? proxy) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("proxy", proxy??"");
  }

  Future<void> saveSessionId(String sessionId) async {
    try {
      await _secureStorage.write(key: "sessionId", value: sessionId);
    } catch (e) {
      // Handle platform exceptions here
      throw Exception();
    }


  }
}