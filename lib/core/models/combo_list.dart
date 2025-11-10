import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/hive/hive_typeIds.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

part 'combo_list.g.dart';

@HiveType(typeId: HiveTypeIds.comboItem)
class ComboItem extends EditableGrid {
  @HiveField(0)
  String? value;
  @HiveField(1)
  dynamic key;


  ComboItem({
    required this.key,
    this.value,
  });
  factory ComboItem.fromJsonObject(Map<String, dynamic> json) {
  
    //json['no_planned']=false;
    return ComboItem(
      key: JsonUtils.toInt(json['id'])!.toInt(),
      value: JsonUtils.toText(json['name']),
    );
  }
  factory ComboItem.fromJsonObjectWithName(Map<String, dynamic> json,keyName,valueName) {

    //json['no_planned']=false;
    return ComboItem(
      key: JsonUtils.toInt(json[keyName])!.toInt(),
      value: JsonUtils.toText(json[valueName]),
    );
  }
  factory ComboItem.fromJsonFilter(Map<String, dynamic> json) {
    return ComboItem(
      key: json['id'],
      value: JsonUtils.toText(json['display_name']),
    );
  }
  factory ComboItem.fromJsonTitle(Map<String, dynamic> json) {
    return ComboItem(
      key: json['id'],
      value: JsonUtils.toText(json['title']),
    );
  }
  factory ComboItem.fromJson(List<dynamic> json) {

    //json['no_planned']=false;
    return ComboItem(
      key: JsonUtils.toInt(json[0])!.toInt(),
      value: JsonUtils.toText(json[1]),
    );
  }
  factory ComboItem.fromStringJson(List<dynamic> json) {
   
    //json['no_planned']=false;
    return ComboItem(
      key: JsonUtils.toText(json[0]),
      value: JsonUtils.toText(json[1]),
    );
  }
  factory ComboItem.fromJsonDynamic(List<dynamic> json) {

    //json['no_planned']=false;
    return ComboItem(
      key: json[0],
      value: JsonUtils.toText(json[1]),
    );
  }

  factory ComboItem.fromJsonForMeters(Map<String, dynamic> json) {
    return ComboItem(
      key: json['id'],
      value: JsonUtils.toText(json['meter_number']),
    );
  }
  factory ComboItem.fromJsonContractor(Map<String, dynamic> json) {

    //json['no_planned']=false;
    return ComboItem(
      key: JsonUtils.toInt(json['id'])!.toInt(),
      value:'${JsonUtils.toText(json['name'])}  (رقم الجوال ${JsonUtils.toText(json['mobile'])} - رقم الهاتف ${JsonUtils.toText(json['phone'])})' ,
    );
  }
}

class ComboItemData extends PagedData<ComboItem>{

}



class TabItem  {
  String? value;
  dynamic key;
  dynamic globalKey;


  TabItem({
    required this.key,
    this.value,
    this.globalKey
  });
  factory TabItem.fromJsonObject(Map<String, dynamic> json) {
    return TabItem(
      key: JsonUtils.toInt(json['id'])!.toInt(),
      value: JsonUtils.toText(json['name']),
      globalKey: GlobalKey(),
    );
  }
}





