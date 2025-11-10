// scroll_helper.dart
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const String _userInfoAPI = 'userInfoAPI';

  static Future<bool> saveUserInfoApi(dynamic userInfo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("localAuth", userInfo);
   return prefs.commit();
  }
}