import 'dart:io';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';


class CurrentDate {

  String? nowPrayer;
  String? upcomingPrayer;
  late HijriCalendar todayHijri;
  late DateTime todayGreg;
  CurrentDate() {
    nowPrayer="Fajar";
    upcomingPrayer="Isha";
    HijriCalendar.setLocal('ar');
    todayHijri = HijriCalendar.now();


    todayGreg = DateTime.now();
  }




  String get hijriDay => todayHijri.hDay.toString();

  String get hijriMonthYear => todayHijri.hDay.toString()+'${todayHijri.getShortMonthName()}, ${todayHijri.hYear.toString()}';

  String get gregDateFormat => DateFormat('dd, MMM yyyy').format(todayGreg);
}



