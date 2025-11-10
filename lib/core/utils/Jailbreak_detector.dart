import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class JailbreakDetector {
  bool? _jailbroken;
  bool? _developerMode;

  // Getter methods to access the state
  bool get isJailbroken => (_jailbroken??false);
  bool get isDeveloperMode => (_developerMode??false);

  // Method to initialize the state
  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    _jailbroken = jailbroken;
    _developerMode = developerMode;
  }
}