import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class MosqueEditRequest {
  String? empty;
  int id;
  String? name;
  String? displayName;
  int? mosqueId;
  String? mosque;
  int? regionId;
  String? region;
  int? supervisorId;
  String? supervisor;
  String? number;
  String? dateSubmit;
  String? createDate;
  String? description;
  String? refuseText;
  String? state;
  bool? isObserver;
  bool? isSupervisor;

   bool get canTakeAction=> (isSupervisor??false)==true && state=='submit';

   bool get canSubmit=> state=='draft';


  // Shallow copy constructor
  // Shallow copy constructor
  MosqueEditRequest.shallowCopy(MosqueEditRequest other)
      : id = other.id,
        name = other.name,
        displayName = other.displayName,
        state = other.state,
        refuseText = other.refuseText,
        region = other.region,
        mosque = other.mosque,
        number = other.number,
        supervisorId = other.supervisorId,
        supervisor = other.supervisor,
        regionId = other.regionId,
        mosqueId = other.mosqueId,
        dateSubmit = other.dateSubmit,
        createDate = other.createDate,
        isObserver = other.isObserver,
        isSupervisor = other.isSupervisor,
        description = other.description;


  MosqueEditRequest({
    required this.id,
    this.name,
    this.displayName,
    this.mosqueId,
    this.mosque,
    this.region,
    this.regionId,
    this.supervisor,
    this.supervisorId,
    this.createDate,
    this.dateSubmit,
    this.description,
    this.number,
    this.state,
    this.refuseText,
    this.isObserver,
    this.isSupervisor
  });
  factory MosqueEditRequest.fromJson(Map<String, dynamic> json) {
    //json['no_planned']=false;
    return MosqueEditRequest(
      id: JsonUtils.toInt(json['id'])??0,
      name: JsonUtils.toText(json['name']),
      displayName: JsonUtils.toText(json['display_name']),
      mosqueId: JsonUtils.getId(json['mosque_id']),
      mosque: JsonUtils.getName(json['mosque_id']),
      regionId: JsonUtils.getId(json['region_id']),
      region: JsonUtils.getName(json['region_id']),
      supervisorId: JsonUtils.getId(json['supervisor_id']),
      supervisor: JsonUtils.getName(json['supervisor_id']),
      state: JsonUtils.toText(json['state']),
      refuseText: JsonUtils.toText(json['refuse_text']),
      number: JsonUtils.toText(json['number']),
      isSupervisor: JsonUtils.toBoolean(json['is_supervisor']),
      isObserver: JsonUtils.toBoolean(json['is_observer']),
      description: JsonUtils.toText(json['description']),
      dateSubmit: JsonUtils.toDateTimeFormat(json['date_submit']),
      createDate: JsonUtils.toDateTimeFormat(json['create_date']),
    );
  }
}

class MosqueEditRequestData extends PagedData<MosqueEditRequest>{

}

