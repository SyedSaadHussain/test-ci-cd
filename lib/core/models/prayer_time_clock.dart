import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:intl/intl.dart';

class PrayerTimeClock {
  // final String?  date;
  final String  city;
  final DateTime  fajarTime;
  final DateTime  dhuhrTime;
  final DateTime  asrTime;
  final DateTime  maghribTime;
  final DateTime  ishaTime;
  int currentPrayerIndex;


  // Add more fields as needed

  String get currentPrayerName {
    switch (currentPrayerIndex) {
      case 0:
        return "isha";
      case 1:
        return "fajr";
      case 2:
        return "dhuhr";
      case 3:
        return "asr";
      case 4:
        return "maghrib";
      case 5:
        return "isha";
      default:
        return "";
    }
  }



  String get upComingPrayerName {
    switch (currentPrayerIndex) {
      case 0:
        return "fajr";
      case 1:
        return "dhuhr";
      case 2:
        return "asr";
      case 3:
        return "maghrib";
      case 4:
        return "isha";
      case 5:
        return "fajr";
      default:
        return "";
    }
  }

  IconData get upComingPrayerIcon {
    return getIcon(upComingPrayerName);
  }
  IconData get currentPrayerIcon {
    return getIcon(currentPrayerName);
  }
  String get currentPrayerTime {
    try{
      DateTime parsedTime = getTime(currentPrayerName);
      // DateTime parsedTime = DateFormat("hh:mm a").parse(timeString);
      String formattedTime = DateFormat("HH:mm").format(parsedTime);
      return formattedTime ;
    }catch(e){
      return '';
    }

  }
  String get upComingPrayerTime {
    try{
      DateTime parsedTime = getTime(upComingPrayerName);
      // DateTime parsedTime = DateFormat("hh:mm a").parse(timeString);
      String formattedTime = DateFormat("HH:mm").format(parsedTime);
      return formattedTime ;
    }catch(e){
      return '';
    }

  }
  DateTime get upComingPrayerDateTime {
    return getTime(upComingPrayerName) ;
  }
  IconData getIcon(String prayer){
    switch (prayer) {
      case "fajr":
        return Icons.sunny_snowing;//"fajr";
      case "dhuhr":
        return Icons.sunny;//"fajr";
      case "asr":
        return FontAwesomeIcons.cloudSun;//"fajr";
      case "maghrib":
        return Icons.wb_twilight;//"fajr";
      case "isha":
        return AppIcons.moonStar;//"fajr";
      default:
        return Icons.punch_clock;
    }
  }
  //
  DateTime getTime(String prayer){
    switch (prayer) {
      case "fajr":
        return fajarTime;
      case "dhuhr":
        return dhuhrTime;
      case "asr":
        return asrTime;
      case "maghrib":
        return maghribTime;
      case "isha":
        return ishaTime;
      default:
        return DateTime.now();
    }
  }


  PrayerTimeClock({
    // this.date,
    required this.city,
    required this.fajarTime,
    required this.dhuhrTime,
    required this.asrTime,
    required this.maghribTime,
    required this.ishaTime,
    this.currentPrayerIndex=5
  });

  factory PrayerTimeClock.fromPrayerTime(PrayerTime prayer) {

    return PrayerTimeClock(
        // date: JsonUtils.toText(date),
        city: prayer.cityName??"",
        fajarTime: prayer!.fajarTime??DateTime.now(),
        dhuhrTime: prayer!.duharTime??DateTime.now(),
        asrTime: prayer!.asarTime??DateTime.now(),
        maghribTime: prayer!.magribTime??DateTime.now(),
        ishaTime: prayer!.ishaTime??DateTime.now()
    );
  }

  // factory PrayerTimeClock.fromJson(Map<String, dynamic> json,String date) {
  //   return PrayerTimeClock(
  //       date: JsonUtils.toText(date),
  //       fajarTime: JsonUtils.toText(json['fajar']),
  //       dhuhrTime: JsonUtils.toText(json['dhuhr']),
  //       asrTime: JsonUtils.toText(json['asr']),
  //       maghribTime: JsonUtils.toText(json['maghrib']),
  //       ishaTime: JsonUtils.toText(json['isha'])
  //   );
  // }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd hh:mm");
  // DateTime getDateTime(String? time){
  //   print((date??"")+" "+(time??"00:00 AM"));
  //   return dateFormat.parse((date??"")+" "+(time??"00:00"));
  // }
  void setCurrentPrayerTime(){

    List<DateTime> dates=[];

    dates.add(fajarTime);
    dates.add(dhuhrTime);
    dates.add(asrTime);
    dates.add(maghribTime);
    dates.add(ishaTime);
    DateTime now = DateTime.now();

    for (int i = 0; i < dates.length; i++) {

      if (now.isBefore(dates[i])) {
        currentPrayerIndex=i;
        break;
      }
    }


  }


}


