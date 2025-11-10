import 'dart:convert';

import 'package:flutter/services.dart';

class AssetJsonUtils {
  static Future<List<T>?> loadList<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
    bool Function(Map<String, dynamic>)? filter,
  }) async {
    print('sssssss');
    try{
      final String jsonString = await rootBundle.loadString(path);

      final dynamic jsonData = json.decode(jsonString);

      if (jsonData is List) {
        final filtered = filter != null
            ? jsonData.where((e) => filter(e as Map<String, dynamic>)).toList()
            : jsonData;
        return filtered.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw FormatException('Expected a list in "$path", got ${jsonData.runtimeType}');
      }
    }catch(e){
      print(e);
    }

  }


  static Future<List<T>?> loadListArray<T>({
    required String path,
    required T Function(List<dynamic>) fromJson,
  }) async {
    try {

      final String jsonString = await rootBundle.loadString(path);

      final dynamic jsonData = json.decode(jsonString);

      if (jsonData is List) {

        // each element is expected to be a List<dynamic>
        return jsonData.map((e) {
          if (e is List<dynamic>) {

            return fromJson(e);
          } else {
            throw FormatException('Expected inner list, got ${e.runtimeType}');
          }
        }).toList();
      } else {
        throw FormatException('Expected a list in "$path", got ${jsonData.runtimeType}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<T>> loadView<T>({
    required String path,
    required T Function(String key, dynamic value) fromKeyValue,
  }) async {
    final String jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return jsonMap.entries.map((e) => fromKeyValue(e.key, e.value)).toList();
  }

  }