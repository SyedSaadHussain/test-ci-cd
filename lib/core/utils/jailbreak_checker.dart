import 'dart:io';
import 'package:flutter/services.dart';
import 'package:mosque_management_system/core/utils/Jailbreak_detector.dart';
import 'package:mosque_management_system/core/utils/security.dart'; // Example import for JailbreakDetector
import 'package:mosque_management_system/core/utils/android_security.dart';

class JailbreakChecker {
  final JailbreakDetector _jailbreakDetector = JailbreakDetector();

  Future<void> checkSecurity() async {
    return;
    await _jailbreakDetector.initPlatformState();

    if (Platform.isIOS  && (await Security.isDebuggerAttached()=="true")) {
     
      exit(0);
    }

    if (_jailbreakDetector.isDeveloperMode || _jailbreakDetector.isJailbroken) {
      
      exit(0);
    }
    if (Platform.isAndroid  ) {

      RootDetection.roothayanahi();

    }

  }

}