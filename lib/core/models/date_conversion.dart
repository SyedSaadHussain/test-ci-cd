import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;

class DateConversion {
  String? gregDate;
  String? hijriDate;
  String? formatedGregDate;
  String? dayHijri;
  String? monthHijri;
  String? yearHijri;
  String? dayGreg;
  String? monthGreg;
  String? yearGreg;

  // Getter for yearGreg as an integer
  int? get yearGregAsInt {
    // Return the integer value of yearGreg if it's not null and can be parsed into an integer
    if (yearGreg != null) {
      return int.tryParse(yearGreg!); // Using tryParse to avoid exceptions in case it's not a valid number
    }
    return null; // Return null if yearGreg is null or invalid
  }

  // Getter for yearGreg as an integer
  int? get yearHijriAsInt {
    // Return the integer value of yearGreg if it's not null and can be parsed into an integer
    if (yearHijri != null) {
      return int.tryParse(yearHijri!); // Using tryParse to avoid exceptions in case it's not a valid number
    }
    return null; // Return null if yearGreg is null or invalid
  }


  DateConversion({
    this.gregDate,
    this.hijriDate
   });

  void reset(){
    gregDate=null;
    hijriDate=null;
    formatedGregDate=null;
    dayHijri=null;
    monthHijri=null;
    yearHijri=null;
    dayGreg=null;
    monthGreg=null;
    yearGreg=null;
  }

  factory DateConversion.fromJson(Map<String, dynamic> json){

    return DateConversion(
        gregDate: JsonUtils.toText(json['gregorian']),
        hijriDate: JsonUtils.toText(json['hijri']),
    );
  }

  void triggerValue(){
     if(AppUtils.isNotNullOrEmpty(gregDate)){
       List<String> dateParts = gregDate!.split('-');
       formatedGregDate="${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
       dayGreg=dateParts[0];
       monthGreg=dateParts[1];
       yearGreg=dateParts[2];
     }

     if(AppUtils.isNotNullOrEmpty(hijriDate)){
       List<String> dateParts = hijriDate!.split('-');
       dayHijri=dateParts[0];
       monthHijri=dateParts[1];
       yearHijri=dateParts[2];
     }
  }
}
