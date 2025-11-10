import 'dart:io';

import 'package:flutter/services.dart';

class Security {
  static const MethodChannel _channel = MethodChannel('com.example.mosque_management_system/debugger');

  static Future<String> isDebuggerAttached() async {
    try {
      final String result = await _channel.invokeMethod('isDebuggerAttached');
      return result;
    } on PlatformException catch (e) {
      return "";
    }
  }

  static Future<String> isDebuggerAttached2() async {
    try {
      final String result = await _channel.invokeMethod('isDebuggerAttached2');
      return result;
    } on PlatformException catch (e) {
      return "";
    }
  }


}