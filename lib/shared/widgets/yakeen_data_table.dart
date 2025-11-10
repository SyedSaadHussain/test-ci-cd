import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';


class YakeenDataTable extends StatelessWidget {
  final YakeenData data;

  const YakeenDataTable({Key? key, required this.data}) : super(key: key);

  // 🔧 [TAG 1] Helper to safely parse nested maps from strings
  Map<String, dynamic> tryParseMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is String) {
      try {
        // Try standard JSON decode first
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        // Manual fix attempt
        try {
          // 🩹 Fix unquoted keys and values like {birthCity: الرياض,...}
          final fixed = value
              .replaceAllMapped(RegExp(r'(\w+):'), (m) => '"${m[1]}":') // quote keys
              .replaceAllMapped(RegExp(r':\s*([^",{}\[\]]+)(?=[,\}])'), (m) {
            final val = m[1]!;
            if (val == 'null' || val == 'true' || val == 'false' || num.tryParse(val) != null) {
              return ': $val'; // leave valid JSON types unquoted
            } else {
              return ': "$val"'; // quote plain words like الرياض
            }
          })
              .replaceAll('"{', '{')
              .replaceAll('}"', '}')
              .replaceAll('"{', '{')
              .replaceAll('}"', '}');

          final decoded = jsonDecode(fixed);
          if (decoded is Map<String, dynamic>) return decoded;
        } catch (e) {
          print("❌ Manual fix also failed: $e");
        }
      }
    }

    print("⚠️ Empty map fallback for: $value");
    return {};
  }





  @override
  Widget build(BuildContext context) {
    print("🟡 ra_mahru json value: ${data.json}");

    if (data.json == null || data.json!.isEmpty) {
      return const Text('❌ لا توجد بيانات يقين');
    }

    late Map<String, dynamic> parsed;

    try {
      // ✅ Use manual parser instead of jsonDecode
      parsed = manuallyParseYakeen(data.json!); // <- use yours
      print("✅ Parsed JSON: $parsed");
    } catch (e) {
      return Text('❌ خطأ في قراءة بيانات يقين\n$e');
    }

    print("✅ Parsed JSON: $parsed");


    final person = {
      ...tryParseMap(parsed['personBasicInfo']),
      ...parsed, // fallback to top-level keys
    };
    final sponsor = tryParseMap(parsed['personAlienSponsorInfo']);
    final idInfo = tryParseMap(parsed['personIdInfo']);
    final result = tryParseMap(parsed['result']);


    final fields = {
      "الاسم الأول": person['firstName'],
      "اسم الأب": person['fatherName'],
      "اسم الجد": person['grandFatherName'],
      "اسم العائلة": person['familyName'],
      "مدينة الميلاد": person['birthCity'] ?? parsed['birthCity'] ?? 'غير متوفر', // ✅ fallback from root
      "الجنس": person['sexDescAr'],         // ✅ FIXED
      "الحالة": person['statusDescAR'],
      "رمز المهنة": person['occupationCode'], // ✅ FIXED
      "تاريخ الدخول في الإسلام": person['convertDate']?['dateString'], // ✅ FIXED nested
      "تاريخ انتهاء الهوية": idInfo['idExpirationDate'],
      "تاريخ الإصدار السابق": idInfo['preSamisIssueDate'],
      "الجهة الراعية": sponsor['sponsorName'], // still null, expected
    };


    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      border: TableBorder.all(color: Colors.grey.shade300),
      children: fields.entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (entry.value?.toString().trim().isNotEmpty ?? false)
                    ? entry.value.toString().trim()
                    : 'غير متوفر',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),

            ),
          ],
        );
      }).toList(),
    );
  }
}
