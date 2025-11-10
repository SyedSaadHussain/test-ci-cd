import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class Meter extends EditableGrid {
  String? name;
  String? attachmentId;
  bool? mosqueShared;
  String? uniqueId;
  int id;

  Meter.shallowCopy(Meter other)
      : id = other.id,
        name = other.name,
        mosqueShared = other.mosqueShared,
        attachmentId=other.attachmentId,
        uniqueId=other.uniqueId;


  Meter({
    required this.id,
    this.name,
    this.attachmentId,
    this.mosqueShared,
    this.uniqueId
  });
  factory Meter.fromJsonObject(Map<String, dynamic> json) {
  

    //json['no_planned']=false;
    return Meter(
      id: JsonUtils.toInt(json['id'])!.toInt(),
      name: JsonUtils.toText(json['name']),
      attachmentId: JsonUtils.toText(json['attachment_id']),
      mosqueShared: JsonUtils.toBoolean(json['mosque_shared']),
      uniqueId: JsonUtils.toUniqueId(json['__last_update']),
    );
  }
}



class MosqueMeter extends EditableGrid {
  String? meterNumber;
  String? meterType;
  bool? meterNew;
  bool? imam;
  bool? muezzin;
  bool? mosque;
  bool? facility;
  String? attachmentId;
  int id;
  String? uniqueId;

  MosqueMeter.shallowCopy(MosqueMeter other)
      : id = other.id,
        meterNumber = other.meterNumber,
        meterType = other.meterType,
        attachmentId=other.attachmentId,
        muezzin=other.muezzin,
        mosque=other.mosque,
        facility=other.facility,
        meterNew=other.meterNew,
        uniqueId=other.uniqueId,
        imam=other.imam;


  MosqueMeter({
    required this.id,
    this.meterNumber,
    this.meterType,
    this.attachmentId,
    this.muezzin=false,
    this.mosque=false,
    this.facility=false,
    this.meterNew=false,
    this.uniqueId,
    this.imam=false
  });
  factory MosqueMeter.fromJsonObject(Map<String, dynamic> json) {


    //json['no_planned']=false;
    return MosqueMeter(
      id: JsonUtils.toInt(json['id'])!.toInt(),
      meterNumber: JsonUtils.toText(json['meter_number']),
      attachmentId: JsonUtils.toText(json['attachment_id']),
      meterType: JsonUtils.toText(json['meter_type']),
      muezzin: JsonUtils.toBoolean(json['muezzin']),
      mosque: JsonUtils.toBoolean(json['mosque']),
      facility: JsonUtils.toBoolean(json['facility']),
      meterNew: JsonUtils.toBoolean(json['meter_new']),
      imam: JsonUtils.toBoolean(json['imam']),
      uniqueId: JsonUtils.toUniqueId(json['__last_update']),
    );
  }
}
