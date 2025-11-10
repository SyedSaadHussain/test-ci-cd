import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as keyObj;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/database.dart';
import 'package:mosque_management_system/core/models/user_credential.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/main.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

import 'package:shared_preferences/shared_preferences.dart';
class EncryptionHelper {
  final keyObj.Key _val = keyObj.Key.fromUtf8('12345678901234567890123456789012'); // 32-byte key for AES-256

  // Encrypt a message
  String encrypt(String plainText) {
    final iv = keyObj.IV.fromLength(16); // Generate a random IV
    final encrypter = keyObj.Encrypter(keyObj.AES(_val));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Prepend the IV to the ciphertext (base64 encoded)
    return '${iv.base64}:${encrypted.base64}';
  }

  // Decrypt a message
  String decrypt(String encryptedText) {
    if(encryptedText=='')
      return '';
    // Split the IV and the ciphertext
    final parts = encryptedText.split(':');
    final iv = keyObj.IV.fromBase64(parts[0]);
    final encryptedData = parts[1];

    final encrypter = keyObj.Encrypter(keyObj.AES(_val));
    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

    return decrypted;
  }
}

class UserPreferences {

  final EncryptionHelper _encryptionUtil;


  UserPreferences()
      : _encryptionUtil = EncryptionHelper();

  Future<bool> isAllowLocalAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isAllow = prefs.getBool("localAuth")??true;

    return isAllow;
  }

  Future<bool> setAllowLocalAuth(bool isAllow) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("localAuth", isAllow);
    return true;
  }

  Future<int> getNotificationCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int count = prefs.getInt("notificationCount")??0;
    return count;
  }
  Future<int> incNotificationCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int count = prefs.getInt('notificationCount') ?? 0;
    count++;
    prefs.setInt("notificationCount", count);
    prefs.commit();
    return count;
  }
  Future<bool> setNotificationCount(int token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("notificationCount", token);
    return prefs.commit();
  }

  Future<bool> saveFcmToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("fcmToken", token);
    return prefs.commit();
  }

  // Future<UserCredential> getUserCredential() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // String? userName = prefs.getString("credentialUserName");
  //   // String? password = prefs.getString("credentialUserPassword");
  //   return UserCredential(
  //       userName: "" ,
  //       password: "" ,
  //   );
  // }
}