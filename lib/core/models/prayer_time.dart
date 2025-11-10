import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

part 'prayer_time.g.dart';

@HiveType(typeId: HiveTypeIds.PrayerTime)
class PrayerTime {
  @HiveField(0)
  DateTime? fajarTime;
  @HiveField(1)
  DateTime? duharTime;
  @HiveField(2)
  DateTime? asarTime;
  @HiveField(3)
  DateTime? magribTime;
  @HiveField(4)
  DateTime? ishaTime;
  @HiveField(5)
  int? cityId;
  @HiveField(6)
  String? cityName;


  PrayerTime({
    this.fajarTime,
    this.duharTime,
    this.asarTime,
    this.magribTime,
    this.ishaTime,
    this.cityId,
    this.cityName,
  });
  factory PrayerTime.fromJsonFile(Map<String, dynamic> json) {
    return PrayerTime(
      fajarTime: AppUtils.parseTimeWithTodayDate(json['fajr']),
      duharTime: AppUtils.parseTimeWithTodayDate(json['dhuhr']),
      asarTime: AppUtils.parseTimeWithTodayDate(json['asr']),
      magribTime: AppUtils.parseTimeWithTodayDate(json['maghrib']),
      ishaTime: AppUtils.parseTimeWithTodayDate(json['isha']),
      cityId: JsonUtils.toInt(json['city_id']),
      cityName: JsonUtils.toText(json['city_name']),
    );
  }

  /// Returns prayer name (fajar, duhar, asar, magrib, isha) if [time] is within 1 hour of any prayer time
  String? getPrayerNameByTime() {
    DateTime time=DateTime.now();
    final prayers = {
      'fajar': fajarTime,
      'duhar': duharTime,
      'asar': asarTime,
      'magrib': magribTime,
      'isha': ishaTime,
    };


    for (final entry in prayers.entries) {
      final start = entry.value;
      if (start == null) continue;
      final end = start.add(const Duration(hours: VisitDefaults.allowPrayerHours));
      if (time.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
          time.isBefore(end)) {
        return entry.key;
      }
    }

    return null;
  }
  bool isJumma(String prayer) {
    if (prayer == 'duhar' && DateTime.now().weekday == DateTime.friday) {
      return true;
    } else {
      return false;
    }
  }

  String getHiveId(String? id){
    return '${id ?? DateFormat('yyyy-MM-dd').format(DateTime.now())}_${cityId.toString()}';
  }

  static String getCurrentDateHiveId(int? cityId){
    return '${DateFormat('yyyy-MM-dd').format(DateTime.now())}_${cityId.toString()}';
  }
}
