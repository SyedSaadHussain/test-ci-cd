import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';



class JsonUtils {
  static int? toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return null;
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  static bool? toBoolean(dynamic value) {
    if (value is bool) {
      return value;
    } else if (value is String) {
      return value.toLowerCase() == 'yes';
    } else if (value is int) {
      return value == 1;
    }
    return null;
  }

  static double? toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  static String? toText(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return '';
    }
    if (value is String) {
      return value;
    }
    return null;
  }

  static String convertToString(dynamic value) {
    if (value == null) {
      return '';
    }
    return value.toString();
  }

  static String? toUniqueId(dynamic value) {

    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return '';
    }
    if (value is String) {
      return value.replaceAll(RegExp(r'[^0-9]'), '');
    }
    return null;
  }

  static DateTime? toDateTime(dynamic value) {

    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return null;
    }
    if (value is String) {
      return DateTime.parse(value);
    }
    return null;
  }

  static DateTime? toLocalDateTime(dynamic value) {

    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return null;
    }
    if (value is String) {
      return DateTime.parse(value+'z').toLocal();
    }
    return null;
  }

  static String? toDateTimeFormat(dynamic value) {

    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return null;
    }
    if (value is String) {
      DateTime? date=DateTime.parse(value);
      return date==null?'':DateFormat('MM/dd/yyyy HH:mm:ss').format(date);
    }
    return null;
  }
  static String? toLocalDateTimeFormat(dynamic value) {

    if (value == null) {
      return null;
    }
    if (value is bool && value == false) {
      return null;
    }
    if (value is String && value!='False') {
      DateTime? date= DateTime.parse(value+'z').toLocal();
      return date==null?'':DateFormat('MM/dd/yyyy HH:mm:ss').format(date.toLocal());
    }
    return null;
  }

  static List<dynamic> toListObject(dynamic value) {

    if (AppUtils.isNullOrEmpty(value)) {
      return [];
    }
    if (value is bool && value == false) {
      return [];
    }
    return value as List<dynamic>;
  }

  static List<int> toList(dynamic value) {

    if (value == null) {
      return [];
    }
    if (value is bool && value == false) {
      return [];
    }
    return List<int>.from(value);
  }

  static List<String>? toStringList(dynamic value) {

    if (value == null) {
      return [];
    }
    if (value is bool && value == false) {
      return [];
    }
    return List<String>.from(value);
    return null;
  }

  static dynamic getKey(dynamic list) {

    dynamic value=((list??false)==false?[]:list as List<dynamic>);

    return value.length>0?value[0]:null;
    return null;
  }

  static int? getId(dynamic list) {

    dynamic value=((list??false)==false?[]:list as List<dynamic>);

    return value.length>0?value[0]:null;
    return null;
  }
  static String? getName(dynamic list) {

    dynamic value=((list??false)==false?[]:list as List<dynamic>);

    return value.length>0?value[1]:null;
    return null;
  }

  static void addField(dynamic value,dynamic field,dynamic newValue,dynamic oldValue) {
    if(newValue!=oldValue)
      value[field] = newValue;
  }
  static String getNameFromKey(dynamic options, dynamic key) {
    if (options == null || key == null) return '';

    if (options is List) {
      for (var item in options) {
        // Handle List like: [id, name]
        if (item is List && item.length >= 2 && item[0] == key) {
          return item[1].toString();
        }

        // If it's ComboItem (fallback, safe for other cases)
        if (item is ComboItem && item.key == key) {
          return item.value ?? '';
        }
      }
    }

    return key.toString(); // fallback
  }
  static Map<String, dynamic>? tryDecodeMap(String raw) {
    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {
      debugPrint("⚠️ Failed to decode char_box: $raw");
    }
    return null;
  }

  static int? getObjectId(dynamic json) {
    return  json == null ? null : JsonUtils.toInt(json['id']);
  }
  static String? getObjectName(dynamic json) {
    return json == null ? null : JsonUtils.toText(json['name']);
  }
  /// Safe string from a payload map by key.
  /// - Accepts String / num / bool
  /// - If the value is a Map, returns its 'name' when present (Odoo-style {id,name})
  static String? textOf(dynamic map, String key) {
    if (map is! Map) return null;
    final v = map[key];
    final s = toText(v);
    if (s != null) return s;
    if (v is num || v is bool) return v.toString();
    if (v is Map) return getObjectName(v); // uses your getObjectName
    return null;
  }

  /// Safe int from a payload map by key.
  /// - Accepts int / numeric string
  /// - If value is a Map, reads its 'id' (Odoo-style {id,name})
  static int? intOf(dynamic map, String key) {
    if (map is! Map) return null;
    final v = map[key];
    final i = toInt(v);
    if (i != null) return i;
    if (v is String) return int.tryParse(v);
    if (v is Map) return getObjectId(v);
    return null;
  }







}


Map<String, dynamic> manuallyParseYakeen(String raw) {
  final Map<String, dynamic> result = {};

  try {
    // 1. Remove outer braces if it's wrapped like: "{...}"
    String cleanedRaw = raw.trim();
    if (cleanedRaw.startsWith('{') && cleanedRaw.endsWith('}')) {
      cleanedRaw = cleanedRaw.substring(1, cleanedRaw.length - 1);
    }

    final pairs = cleanedRaw.split(RegExp(r',(?![^{}]*\})')); // split on commas not inside nested braces

    for (final pair in pairs) {
      final split = pair.split(':');
      if (split.length < 2) continue;

      final rawKey = split[0].trim().replaceAll(RegExp(r'^"|"$'), '');
      final rawValue = split.sublist(1).join(':').trim();

      final key = rawKey;

      String value = rawValue;
      value = value.replaceAll(RegExp(r'^"|"$'), '').trim();

      if (value == 'null') {
        result[key] = null;
      } else if (value == 'true') {
        result[key] = true;
      } else if (value == 'false') {
        result[key] = false;
      } else if (double.tryParse(value) != null) {
        result[key] = double.parse(value);
      } else if (value.startsWith('{') && value.endsWith('}')) {
        // 🔧 [TAGGED RECURSION] Try parsing inner object
        try {
          result[key] = manuallyParseYakeen(value);
        } catch (e) {
          print("! Failed to parse inner string: $e");
          result[key] = {}; // fallback
        }
      } else {
        result[key] = value;
      }
    }

    return result;
  } catch (e) {
    print('❌ manualParseYakeen failed: $e');
    return {};
  }
}


