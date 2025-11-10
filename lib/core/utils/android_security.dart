import 'dart:io';

import 'package:flutter/services.dart';

class RootDetection {
  static const platform = MethodChannel('com.example.root_detection');

  static Future<bool> isDeviceRooted() async {
    try {
      final bool isRooted = await platform.invokeMethod('checkRoot');
      return isRooted;
    } on PlatformException catch (e) {
      print("Failed to check root: '${e.message}'.");
      return false;
    }
  }
  static Future<bool> isBootloaderUnlocked() async {
    try {
      final bool result = await platform.invokeMethod('checkBootloader');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check bootloader status: '${e.message}'.");
      return false;
    }
  }


  static Future<void> roothayanahi() async {
    bool isRooted = await RootDetection.isDeviceRooted();
    bool isBootloaderUnlocked = await RootDetection.isBootloaderUnlocked();
    Map<String, dynamic> securityProps = await RootDetection.getSecurityProperties();

    // ✅ Extract key security properties
    String knoxStatus = securityProps["Knox Status"] ?? "Unknown";
    String selinuxStatus = securityProps["SELinux Status"] ?? "Unknown";
    String oemUnlockSupported = securityProps["OEM Unlock Supported"] ?? "Unknown";
    String rootAccessEnabled = securityProps["Root Access Enabled"] ?? "Unknown";

    // 🚨 Strict Security Check: Exit the app if any condition fails
    if (isRooted || isBootloaderUnlocked || knoxStatus == "1" || rootAccessEnabled == "1") {
      print("🚨 Device is compromised! Exiting app.");
      exit(0);  // ✅ Forcefully close the app
    }

    // if (isRooted || isBootloaderUnlocked) {
    //   print("⚠️ Device is compromised! Exiting app.");
    //   exit(0);
    // }

    // ✅ Check Root Before Anything Else
    await checkRootAndExitIfRooted();

  }

  static Future<void> checkRootAndExitIfRooted() async {
    bool isRooted = await RootDetection.isDeviceRooted();

    if (isRooted) {
      print("⚠️ Device is Rooted! Exiting app.");
      exit(0); // ✅ Prevent the app from running
    }
  }
  // ✅ Get multiple security properties at once
  static Future<Map<String, dynamic>> getSecurityProperties() async {
    try {
      final Map<dynamic, dynamic> result =
      await platform.invokeMethod('getSystemProperties');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Failed to get security properties: '${e.message}'");
      return {};
    }
  }

}