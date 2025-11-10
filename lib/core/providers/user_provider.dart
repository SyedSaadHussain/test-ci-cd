import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/menuRights.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/user_roles.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_roles.dart';
class UserProvider with ChangeNotifier {
  UserProfile _userProfile = UserProfile(userId: 0);
  MenuRights? _menuRights;
  String? _baseUrl;
  int _pendingApproval = 0;
  // bool _isDeviceVerify = false;
  CustomOdooClient? _client;
  int _totalNotification = 0;

  int get TotalNotification => _totalNotification;

  CustomOdooClient? get client => _client;
  UserProfile get userProfile => _userProfile;
  MenuRights? get menuRights => _menuRights;
  int get totalPendingApproval => _pendingApproval;
  bool get isDeviceVerify =>
      userProfile.isDeviceVerify ?? false; // _isDeviceVerify;
  String get baseUrl => _baseUrl ?? "";
  List<List<double>> _coordinates = [];
  List<List<double>> get coordinates => _coordinates;



  // You may want to add methods to initialize and update the client
  Future<void> initializeClient(String baseUrl,
      [dynamic sessionId, http.BaseClient? httpClient]) async {
    _client = CustomOdooClient.getInstance(baseUrl);
    print(_client!.baseURL);
    notifyListeners(); // Notify listeners that client has been updated
  }

  // You may want to add methods to initialize and update the client
  Future<void> init(context) async {
    setLanguage(LocalizeAndTranslate.getLanguageCode());
    _client = CustomOdooClient();
    isSessionExpired(context);
  }

  @override
  void dispose() {
    // _client!.close();
    // _client = null; // Clear the client reference
    super.dispose(); // Always call super.dispose()
  }


 bool isLoadingProfile=false;
  ///Set user profile from hive then call from API, if no internet so system can continue its operation
  Future<UserProfile>  getUserProfile() async{
    UserService userService=UserService(client!,userProfile: userProfile);
    try{
      UserProfile? hiveProfile=await HiveRegistry.crmUserInfo.get(_userProfile.userId);
      if(hiveProfile!=null)
        setUserProfile(hiveProfile);

      isLoadingProfile=true;
      notifyListeners();
      //if profile return successfully from the API so set isDeviceVerify should set the last state
      final profile = await userService.fetchAndCacheCrmUserInfo(hiveProfile?.isDeviceVerify);
      isLoadingProfile=false;
      notifyListeners();
      setUserProfile(profile);
      return profile;
    } catch (e) {
      isLoadingProfile=false;
      notifyListeners();
      throw e;
    }
  }

  void isSessionExpired(context) {
    final _client = CustomOdooClient();
    var repository = CommonRepository(_client);
    repository
        .ischeckSessionExpire()
        .then((value) {
      if (value) {
        SessionManager.instance.logout(false);
      }
    });
  }

  void setDatabaseUrl(String? url) {
    _baseUrl = url;
    notifyListeners();
  }

  void setMenu(MenuRights menu) {
    _menuRights = menu;
    notifyListeners();
  }

  void setCoordinates(List<List<double>> pramCoordinates) {
    _coordinates = pramCoordinates;
    notifyListeners();
  }

  void setLanguage(String language) {
    _userProfile.language =
        language == 'ar' ? Language.arabic : Language.english;
    notifyListeners();
  }

  void setDeviceStatus(bool isVerify) async {
    // _isDeviceVerify = isVerify;
    userProfile.isDeviceVerify = isVerify;
    notifyListeners();
    print('userProfile.isDeviceVerify');
    print(userProfile.userId);
    await HiveRegistry.crmUserInfo.put(userProfile.userId, userProfile);
    UserProfile? aa = await HiveRegistry.crmUserInfo.get(userProfile.userId);
  }

  void setUserProfile(UserProfile user) {
    _userProfile = user;
    notifyListeners();
  }

  void setPendingApproval(int value) {
    _pendingApproval = value;
    notifyListeners();
  }

  void setNotificationCount(int value) {
    _totalNotification = value;
    notifyListeners();
    UserPreferences().setNotificationCount(value);
  }

  void resetNotificationCount() async {
    UserPreferences().getNotificationCount().then((response) {
      _totalNotification = response;
      notifyListeners();
    });
  }

  void decrementNotifiCount() async {
    _totalNotification = _totalNotification - 1;
    if (_totalNotification < 0) _totalNotification = 0;
    await UserPreferences().setNotificationCount(_totalNotification);
    notifyListeners();
  }


  void clear() {

    if (_client != null) {
      _client!.close();
      _client = null;
    }
    // _isDeviceVerify = false;
    _pendingApproval = 0;
    _menuRights = null;
    _baseUrl = null;
    _userProfile = UserProfile(userId: 0);
    notifyListeners();
  }

  bool hasRole(UserRole role) {
    final codes = (userProfile.roleNames ?? const [])
        .map((r) => r.trim().toUpperCase())
        .toSet();
    return codes.contains(role.name.toUpperCase());
  }

  bool get isLevelA => userProfile.hasLevelA();
  bool get isLevelB => userProfile.hasLevelB();
  bool get isLevelC => userProfile.hasLevelC();
}


