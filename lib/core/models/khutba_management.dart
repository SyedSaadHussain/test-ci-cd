import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

class KhutbaManagement {
  int? id;
  String? name;
  String? khutbaDate;
  String? state;
  String? attachment;
  bool? isPublished;
  bool? isKhutbaEid;
  String? description;
  String? guideline_1;
  String? guideline_2;
  String? guideline_3;
  String? guideline_4;
  String? guideline_5;
  String? uniqueId;

  bool get isNewKhutba {
    final date = JsonUtils.toDateTime(khutbaDate);
    if (date == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final khutba = DateTime(date.year, date.month, date.day);

    return khutba.isBefore(today)==false;
  }

  String get guideline1Text {
    try{
      dom.Document document = html_parser.parse(guideline_1);
      return document.body?.text ?? '';
    }
    catch(e){
      return guideline_1??"";
    }
  }
  String get guideline2Text {
    try{
      dom.Document document = html_parser.parse(guideline_2);
      return document.body?.text ?? '';
    }
    catch(e){
      return guideline_2??"";
    }
  }
  String get guideline3Text {
    try{
      dom.Document document = html_parser.parse(guideline_3);
      return document.body?.text ?? '';
    }
    catch(e){
      return guideline_3??"";
    }
  }
  String get guideline4Text {
    try{
      dom.Document document = html_parser.parse(guideline_4);
      return document.body?.text ?? '';
    }
    catch(e){
      return guideline_4??"";
    }
  }
  String get guideline5Text {
    try{
      dom.Document document = html_parser.parse(guideline_5);
      return document.body?.text ?? '';
    }
    catch(e){
      return guideline_5??"";
    }
  }

  String get text {
    try{
      dom.Document document = html_parser.parse(description);
      return document.body?.text ?? '';
    }
    catch(e){
        return description??"";
    }

  }

  KhutbaManagement.shallowCopy(KhutbaManagement other)
      : id = other.id,
        name = other.name,
        khutbaDate = other.khutbaDate,
        state = other.state,
        attachment = other.attachment,
        isKhutbaEid = other.isKhutbaEid,
        isPublished = other.isPublished,
        description = other.description,
        guideline_1 = other.guideline_1,
        guideline_2 = other.guideline_2,
        guideline_3 = other.guideline_3,
        guideline_4 = other.guideline_4,
        guideline_5 = other.guideline_5
  ;


  // Default constructor
  KhutbaManagement({
    this.id,
    this.name,
    this.state,
    this.attachment,
    this.description,
    this.guideline_1,
    this.khutbaDate,
    this.isPublished,
    this.guideline_2,
    this.guideline_3,
    this.guideline_4,
    this.guideline_5,
    this.uniqueId,
    this.isKhutbaEid,
  });

  factory KhutbaManagement.fromJson(Map<String, dynamic> json) {

    return KhutbaManagement(
      id: JsonUtils.toInt(json['id']),
      name: JsonUtils.toText(json['name']),
      isPublished: JsonUtils.toBoolean(json['is_published']),
      isKhutbaEid: JsonUtils.toBoolean(json['is_khutba_eid']),
      khutbaDate: JsonUtils.toText(json['khutba_date']),
      state: JsonUtils.toText(json['state']),
      attachment: JsonUtils.toText(json['attachment']),
      description: JsonUtils.toText(json['description']),
      guideline_1: JsonUtils.toText(json['guideline_1']),
      guideline_2: JsonUtils.toText(json['guideline_2']),
      guideline_3: JsonUtils.toText(json['guideline_3']),
      guideline_4: JsonUtils.toText(json['guideline_4']),
      guideline_5: JsonUtils.toText(json['guideline_5']),
      uniqueId: JsonUtils.toUniqueId(json['write_date']),
    );
  }
}
//
class KhutbaManagementData extends PagedData<KhutbaManagement>{

}

