import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';

import 'dart:math';

class AppUtils{
  static String getErrorMessage(dynamic e) {
    if (e is FormatException) {
      return e.message;
    } else {
      return e.toString();
    }
  }
  static String addZero(your_number) {
    // return your_number.toString();
    var num = '' + your_number.toString();
    if (your_number < 10) {
      num = '0' + num;
    }
    return num;
  }
  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  static String convertToDisplayString(String status) {
    List<String> parts = status.split('_'); // Split by underscores
    List<String> capitalizedParts = parts.map((part) => capitalize(part)).toList();
    return capitalizedParts.join(' '); // Join parts with spaces
  }

  static bool isNotNullOrEmpty(String? value) {
    return value != null && value.isNotEmpty;
  }

  static DateTime minGregDate() {
    return DateTime(1938,03,02);
  }
  static bool isOldDate(selectedDate) {
    if(AppUtils.isNotNullOrEmpty(selectedDate)){
      DateTime? _selectedDate=DateTime.tryParse(selectedDate!);
      return _selectedDate!.isBefore(AppUtils.minGregDate());
    }else{
      return false;
    }
  }


  static DateTime? parseTimeWithTodayDate(String? timeString) {
    if (timeString == null || timeString.trim().isEmpty) return null;

    try {
      final cleanedTime = timeString.replaceAll(RegExp(r'\s*:\s*'), ':').trim();
      final today = DateTime.now();
      final fullDateTimeString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')} $cleanedTime';
      final parsed = DateFormat("yyyy-MM-dd h:mm a").parse(fullDateTimeString);
      return parsed;
    } catch (e) {
      print("Invalid time format: $e");
      return null;
    }
  }

  static Future<dynamic> getHeadersMap()  async{
    String sessionId = await SessionManager.instance.getSessionId();
    return {
      'Cookie':  'session_id=${sessionId}',
    };
  }

  static int getUniqueId() {
    final random = Random();
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int randomPart = random.nextInt(10000); // 0–9999
    return int.parse('$timestamp$randomPart');
  }

  static String extractTextFromHtml(String html) {
    final document = html_parser.parse(html);
    return document.body?.text.trim() ?? '';
  }

  static bool isNullOrEmpty(dynamic value) {
    return value == null || value.isEmpty;
  }

  static List<T> updateSelection<T>({
    required List<T>? currentList,
    required T value,
    required bool isNew,
    bool singleSelection = true,
  }) {
    // Clone the current list to a new instance
    final newList = List<T>.from(currentList ?? []);

    if (isNew) {
      if (!newList.contains(value)) newList.add(value);

      if (singleSelection) {
        // Keep only the newly added value
        newList.removeWhere((item) => item != value);
      }
    } else {
      // Remove value if deselected
      newList.removeWhere((item) => item == value);
    }

    return newList;
  }

  static bool isInnerException(Map<String, dynamic>? data) {
    if (data == null) return false;

    final result = data['result'];
    if (result is Map<String, dynamic>) {
      if (result['success'] == false && result['message'] != null) {
        return true;
      } else if (result['error'] != null && result['message'] != null) {
        return true;
      }
    }
    return false;
  }
  static bool isException(Map<String, dynamic>? data) {
    if (data == null) return false;

    if (data['success'] == false && data['message'] != null) {
      return true;
    } else if (data['error'] != null && data['message'] != null) {
      return true;
    }else if (data['status'] != null && (data['status'] == 'error' || data['status'] == false) && data['message'] != null) {
      return true;
    }
    return false;
  }


}
