import 'dart:convert';

import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/device_info.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_edit_request.dart';
import 'package:mosque_management_system/core/models/mosque_region.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;


class MosqueRepository {
  late CustomOdooClient client;
  late UserProfile _userProfile;

  MosqueRepository(client,{UserProfile? userProfile}){
    this.client = client;
    if(userProfile!=null)
      this._userProfile=userProfile!;
  }
  set userProfile(UserProfile user) {
    _userProfile = user;
  }

  // Getter for age
  UserProfile get userProfile => _userProfile;

  //region For Mosque Service
  Future<List<dynamic>> getBuildingTypes() async {

    try{

      dynamic _payload={
        "args": [
          "",
          []
        ],
        "model": "building.types",
        "method": "name_search",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };


      dynamic response = await client.callKwCustom(_payload);

      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){

      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getInstrumentEntities() async {

    try{

      dynamic _payload={
        "args": [],
        "model": "instrument.entity",
        "method": "name_search",
        "kwargs": {
          "name": "",
          "args": [],
          "operator": "ilike",
          // "limit": 8,
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };


      dynamic response = await client.callKwCustom(_payload);

      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){

      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getAllMosques(dynamic domain,int pageSize,int pageIndex) async {

    try {
      dynamic _payload={
        'model': 'mosque.mosque',
        'method': 'search_read',
        'args': [],
        "kwargs": {
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          'context': {
            "lang":_userProfile.language,
            // "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true,
          },
          'domain': domain,
          'fields': [
            "id",
            "name",
            "city_id",
            "state",
            "stage_id",
            "classification_id",
            // "space_number",
            // "component_number",
            // "mosque_type_id",
            //"image_128",
            "__last_update",
            // "program_number",
            // "service_number"
          ],
        },
      };
      print(_payload);
      var response = await client.callKwCustom(_payload);
      print(response);
      return response.toList();
    }catch (e) {

      throw e;
    }
  }

  Future<dynamic> getMosqueDetail(int id) async {
    try {

      dynamic _payload={
        "args": [
          [
            id
          ],
          [
            "meter_ids",
            "water_meter_ids",
            "observation_text",
            "refuse_reason",
            "declaration_note",
            "state",
            "mosque_land_area",
            "carrying_capacity",
            "has_qr_code_panel",
            "building_area",
            "building_status",
            "is_required",
            "display_button_send",
            "display_button_set_to_draft",
            "display_button_accept",
            "display_button_refuse",
            "request_type_id",
            "stage_id",
            "validate_required",
            "evaluation_percent",
            "notice_number",
            // "maintenance_tasks_number",
            "hygiene_tasks_number",
            "realestate_building_number",
            "abuses_number",
            // "visits_number",
            "related_employee",
            "qr_code",
            "__last_update",
            //"image_128",
            "name",
            "number",
            "observer_ids",
            "supervisor_id",
            "old_sequence",
            "region_id",
            "moia_center_id",
            "city_id",
            "street",
            "district",
            "is_another_neighborhood",
            "another_neighborhood_char",
            "classification_id",
            "mosque_type_id",
            "establishment_date",
            "date_maintenance_last",
            "mosque_state",
            "relate_employee_ids",
            "imam_ids",
            "muezzin_ids",
            "khadem_ids",
            "khatib_ids",
            "is_observer_editable",
            "land_owner",
            //"space_number",
           // "component_number",
           // "program_number",
          //  "service_number",
           // "chart_values",
            "land_area",
            "country_id",
            "capacity",
            "roofed_area",
            "urban_condition",
            "is_qr_code_exist",
            "qr_code_notes",
            // "plate_legible",
            "is_panel_readable",
            "code_readable",
            "mosque_data_correct",
            "qr_code_match",
            "num_qr_code_panels",
            "has_electricity_meter",
            "is_mosque_electric_meter_new",
            "mosque_electricity_meter_ids",
            "has_water_meter",
            "mosque_water_meter_ids",
            "non_building_area",
            "free_area",
            "mosque_size",
            "is_free_area",
            "mosque_rooms",
            "cars_parking",
            "have_washing_room",
            "lectures_hall",
            "library_exist",
            "stood_on_ground_mosque",
            "vacancies_spaces",
            "other_companions",
            "description",
            "no_planned",
            "piece_number",
            "national_address",
            "mosque_opening_date",
            "is_employee",
            "mosque_owner_name",
            "mosque_qr_attachment_ids",
            "declaration_note",
            "observer_supervisor_comment",
            "qr_panel_numbers",
            "observer_commit",
            "honor_name",
            "image",
            "outer_image",
            "qr_image",
            "mosque_edit_request_number",
            "mosque_name_qr",
            "maintainer",
            "company_name",
            "contract_number",
            "has_washing_machine",
            "has_other_facilities",
            "other_facilities_notes",
            "has_internal_camera",
            "has_air_conditioners",
            "num_air_conditioners",
            "ac_type",
            "has_fire_extinguishers",
            "has_fire_system_pumps",
            "maintenance_responsible",
            "maintenance_person",
            "has_deed",
            "electronic_instrument_up_to_date",
            "instrument_number",
            "instrument_date",
            "instrument_notes",
            //"issuing_entity",
            "old_instrument_date",
            "is_electronic_instrument",
            "is_there_land_title",
            "instrument_attachment_ids",
            "instrument_entity_id",
            "endowment_on_land",
            "has_basement",
            "building_material",
            "occupancy_rate",
            "buildings_on_land",
            // "recall_notes",
            "is_there_structure_buildings",
            "building_type_ids",
            "endowment_type",
            "permitted_from_ministry",
            "is_other_attachment",
            "other_attachment",
            "notes_for_other",
            "external_headset_number",
            "internal_speaker_number",
            "external_speaker_number",
            "num_lighting_inside",
            "num_minarets",
            "num_floors",
            "residence_for_imam",
            "imam_residence_type",
            "imam_residence_land_area",
            "is_imam_electric_meter",
            "is_imam_electric_meter_new",
            "imam_electricity_meter_type",
            "imam_electricity_meter_ids",
            "imam_water_meter_type",
            "is_imam_water_meter",
            "imam_water_meter_ids",
            "is_imam_house_private",
            "residence_for_mouadhin",
            "muezzin_residence_type",
            "muezzin_residence_land_area",
            "is_muezzin_electric_meter",
            "is_muezzin_electric_meter_new",
            "muezzin_electricity_meter_type",
            "muezzin_electricity_meter_ids",
            "muezzin_water_meter_type",
            "is_muezzin_water_meter",
            "muezzin_water_meter_ids",
            "muezzin_house_type",
            "is_muezzin_house_private",
            "has_women_prayer_room",
            "length_row_women_praying",
            "row_women_praying_number",
            //"number_women_rows",
            "women_prayer_room_capacity",
            "toilet_woman_number",
            "is_women_toilets",
            // "num_womens_bathrooms",
            "friday_prayer_rows",
            "row_men_praying_number",
            "length_row_men_praying",
            "internal_doors_number",
            "toilet_men_number",
            "latitude",
            "longitude",
            //"message_follower_ids",
            //"activity_ids",
            //"message_ids",
            "display_name"
          ]
        ],
        "model": "mosque.mosque",
        "method": "read",
        "kwargs": {
          "context": {
            "lang":_userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true,
          }
        }
      };
      var response = await client.callKwCustom(_payload);


      return response;
    }catch (e) {
      throw e;
    }
  }

  Future<dynamic> getDisclaimer(int id) async {

 
    try{
      dynamic _payload={
        "args": [
          [],
          {},
          [],
          {
            "text": "",
            "accept_terms": "",
            "refuse_boolean": "",
            "observation_boolean": "",
            "refuse_text": "",
            "observation_text": ""
          }
        ],
        "model": "mosque.confirmation.wizard",
        "method": "onchange",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ],
            "current_id": id
          }
        }
      };
     
      dynamic response = await client.callKwCustom(_payload);
    


      return response;
    }catch(e){
    

      throw e;

    }

  }

  Future<dynamic> getRefuseMosqueDisclaimer(int id) async {
    try{
      dynamic _payload={
        "args": [
          [],
          {},
          [],
          {
            "message": "",
            "text": "",
            "accept_terms": ""
          }
        ],
        "model": "refuse.wizard",
        "method": "onchange",
        "kwargs": {
          "context": {
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "action_name": "action_refuse",
            "field_name": "refuse_reason",
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ]
          }
        }
      };
      dynamic response = await client.callKwCustom(_payload);
      return response;
    }catch(e){
      throw e;
    }
  }

  Future<dynamic> refuseMosqueTerms(int id,dynamic obj) async {
    try {
      dynamic payload={
        "args": [
          {
            "message": obj,
            "accept_terms": true
          }
        ],
        "model": "refuse.wizard",
        "method": "create",
        "kwargs": {
          "context": {
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "action_name": "action_refuse",
            "field_name": "refuse_reason",
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ]
          }
        }
      };
      print(payload);
      var response = await client.callKwCustom(payload);
      dynamic final_payload={
        "args": [
          [
            response
          ]
        ],
        "kwargs": {
          "context": {
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "action_name": "action_refuse",
            "field_name": "refuse_reason",
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ]
          }
        },
        "method": "button_refuse",
        "model": "refuse.wizard"
      };
      var responseConfirm = await client.callKwCustom(final_payload);
      return true;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> getSetDraftDisclaimer(int id) async {


    try{
      dynamic _payload={
        "args": [
          [],
          {},
          [],
          {
            "text": "",
            "accept_terms": "",
            "refuse_boolean": "",
            "observation_boolean": "",
            "refuse_text": "",
            "observation_text": ""
          }
        ],
        "model": "mosque.confirmation.wizard",
        "method": "onchange",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ],
            "current_id": id,
            "set_draft_observation": true
          }
        }
      };

      dynamic response = await client.callKwCustom(_payload);



      return response;
    }catch(e){


      throw e;

    }

  }


  Future<dynamic> loadMosque() async {
    try {

      dynamic payload={
        "args": [
          [],
          {},
          [],
          {
            "country_id": "",
            // "evaluation_percent": "",
            // "notice_number": "",
            // "maintenance_tasks_number": "",
            // "hygiene_tasks_number": "",
            // "realestate_building_number": "",
            // "abuses_number": "",
            // "visits_number": "",
            // "related_employee": "",
            // "qr_code": "",
            // "__last_update": "",
            // "image_128": "",
            // "name": "",
            // "number": "",
            // "classification_id": "",
            // "street": "",
            // "district": "",
            // "region_id": "",
            // "center_id": "",
            // "city_id": "",
            // "establishment_date": "",
            // "date_maintenance_last": "",
            // "mosque_state": "",
            // "alimam": "",
            // "almudhin": "",
            // "alkhatib": "",
            // "land_owner": "",
            // "surface": "",
            // "unit_id": "",
            // "land_area": "",
            // "default_imam": "",
            // "default_muezzin": "",
            // "default_khadem": "",
            // "default_khatib": "",
            // "imam_ids": "",
            // "muezzin_ids": "",
            // "khadem_ids": "",
            // "khatib_ids": "",
            //
            // "capacity": "",
            // "electricity_meter_numero": "",
            // "water_meter_numero": "",
            // "space_number": "",
            // "component_number": "",
            // "program_number": "",
            // "service_number": "",
            // "chart_values": "",
            // "observer_id": "",
            // "no_planned": "",
            // "piece_number": "",
            // "national_address": "",
            // "has_deed": "",
            // "electronic_instrument_up_to_date": "",
            // "instrument_number": "",
            // "instrument_date": "",
            // "instrument_notes": "",
            // "issuing_entity": "",
            // "has_women_prayer_room": "",
            // "mosque_land_area": "",
            // "roofed_area": "",
            // "urban_condition": "",
            // "carrying_capacity": "",
            // "friday_prayer_rows": "",
            // "has_qr_code_panel": "",
            // "qr_code_notes": "",
            // "plate_legible": "",
            // "code_readable": "",
            // "mosque_data_correct": "",
            // "qr_code_match": "",
            // "num_qr_code_panels": "",
            // "has_electricity_meter": "",
            // "has_water_meter": "",
            // "maintainer": "",
            // "company_name": "",
            // "contract_number": "",
            // "has_washing_machine": "",
            // "has_other_facilities": "",
            // "other_facilities_notes": "",
            // "has_internal_camera": "",
            // "has_air_conditioners": "",
            // "num_air_conditioners": "",
            // "ac_type": "",
            // "has_fire_extinguishers": "",
            // "has_fire_system_pumps": "",
            // "imam_residence_type": "",
            // "imam_residence_land_area": "",
            // "imam_electricity_meter_type": "",
            // "imam_electricity_meter_number": "",
            // "imam_water_meter_type": "",
            // "imam_water_meter_number": "",
            // "muezzin_residence_type": "",
            // "muezzin_residence_land_area": "",
            // "muezzin_electricity_meter_type": "",
            // "muezzin_electricity_meter_number": "",
            // "muezzin_water_meter_type": "",
            // "muezzin_water_meter_number": "",
            // "endowment_on_land": "",
            // "has_basement": "",
            // "building_material": "",
            // "occupancy_rate": "",
            // "buildings_on_land": "",
            // "recall_notes": "",
            // "ministry_authorized": "",
            // "num_mens_bathrooms": "",
            // "num_womens_bathrooms": "",
            // "num_internal_speakers": "",
            // "num_external_speakers": "",
            // "num_lighting_inside": "",
            // "num_minarets": "",
            // "num_floors": "",
            // "mosque_size": "",
            // "human_staff_ids": "",
            // "human_staff_ids.id": "",
            // "human_staff_ids.color": "",
            // "human_staff_ids.name": "1",
            // "human_staff_ids.title": "",
            // "human_staff_ids.type": "1",
            // "human_staff_ids.email": "1",
            // "human_staff_ids.parent_id": "1",
            // "human_staff_ids.is_company": "1",
            // "human_staff_ids.function": "",
            // "human_staff_ids.phone": "1",
            // "human_staff_ids.street": "",
            // "human_staff_ids.street2": "",
            // "human_staff_ids.zip": "1",
            // "human_staff_ids.city": "",
            // "human_staff_ids.country_id": "1",
            // "human_staff_ids.mobile": "1",
            // "human_staff_ids.state_id": "1",
            // "human_staff_ids.image_128": "1",
            // "human_staff_ids.avatar_128": "",
            // "human_staff_ids.lang": "",
            // "human_staff_ids.comment": "",
            // "human_staff_ids.display_name": "1",
            // "human_staff_ids.company_id": "1",
            // "human_staff_ids.user_id": "",
            // "supervision_partner_ids": "",
            // "supervision_partner_ids.id": "",
            // "supervision_partner_ids.color": "",
            // "supervision_partner_ids.name": "1",
            // "supervision_partner_ids.title": "",
            // "supervision_partner_ids.type": "1",
            // "supervision_partner_ids.email": "1",
            // "supervision_partner_ids.parent_id": "1",
            // "supervision_partner_ids.is_company": "1",
            // "supervision_partner_ids.function": "",
            // "supervision_partner_ids.phone": "1",
            // "supervision_partner_ids.street": "",
            // "supervision_partner_ids.street2": "",
            // "supervision_partner_ids.zip": "1",
            // "supervision_partner_ids.city": "",
            // "supervision_partner_ids.country_id": "1",
            // "supervision_partner_ids.mobile": "1",
            // "supervision_partner_ids.state_id": "1",
            // "supervision_partner_ids.image_128": "1",
            // "supervision_partner_ids.avatar_128": "",
            // "supervision_partner_ids.lang": "",
            // "supervision_partner_ids.comment": "",
            // "supervision_partner_ids.display_name": "1",
            // "supervision_partner_ids.company_id": "1",
            // "supervision_partner_ids.user_id": "",
            // "partner_ids": "",
            // "partner_ids.id": "",
            // "partner_ids.color": "",
            // "partner_ids.name": "1",
            // "partner_ids.title": "",
            // "partner_ids.type": "1",
            // "partner_ids.email": "1",
            // "partner_ids.parent_id": "1",
            // "partner_ids.is_company": "1",
            // "partner_ids.function": "",
            // "partner_ids.phone": "1",
            // "partner_ids.street": "",
            // "partner_ids.street2": "",
            // "partner_ids.zip": "1",
            // "partner_ids.city": "",
            // "partner_ids.country_id": "1",
            // "partner_ids.mobile": "1",
            // "partner_ids.state_id": "1",
            // "partner_ids.image_128": "1",
            // "partner_ids.avatar_128": "",
            // "partner_ids.lang": "",
            // "partner_ids.comment": "",
            // "partner_ids.display_name": "1",
            // "partner_ids.company_id": "1",
            // "partner_ids.user_id": "",
            // "residence_for_imam": "",
            // "residence_for_mouadhin": "",
            // "cars_parking": "",
            // "have_washing_room": "",
            // "lectures_hall": "",
            // "library_exist": "",
            // "stood_on_ground_mosque": "",
            // "vacancies_spaces": "",
            // "other_companions": "",
            // "description": "",
            // "length_row_women_praying": "",
            // "row_men_praying_number": "",
            // "length_row_men_praying": "",
            // "internal_doors_number": "",
            // "toilet_men_number": "",
            // "toilet_woman_number": "",
            // "internal_speaker_number": "",
            // "external_speaker_number": "",
            // "street2": "",
            // "city": "",
            // "zip": "",
            // "location": "",
            // "hub_id": "",
            // "monitor_id": "",
            // "phone_number": "",
            // "twitter": "",
            // "youtube": "",
            // "website": "",
            // "latitude": "",
            // "longitude": "",
            // "note": "",
            // "region_ids": "",
            // "region_ids.number": "",
            // "region_ids.name": "",
            // "region_ids.mosque_id": "",
            // "region_ids.code": "",
            // "space_ids": "1",
            // "space_ids.number": "",
            // "space_ids.name": "",
            // "space_ids.mosque_id": "1",
            // "space_ids.space_id": "1",
            // "space_ids.capacity": "",
            // "space_ids.surface": "",
            // "space_ids.numeral": "",
            // "space_ids.unit_id": "",
            // "space_ids.gender_usage": "",
            // "space_ids.component_number": "",
            // "space_ids.component_ids": "1",
            // "space_ids.component_ids.component_number": "",
            // "space_ids.component_ids.mosque_id": "1",
            // "space_ids.component_ids.space_id": "",
            // "space_ids.component_ids.space_line_id": "1",
            // "space_ids.component_ids.component_id": "1",
            // "space_ids.component_ids.unit_id": "",
            // "space_ids.component_ids.number": "",
            // "component_ids": "1",
            // "component_ids.component_number": "",
            // "component_ids.mosque_id": "1",
            // "component_ids.space_line_id": "1",
            // "component_ids.name": "",
            // "component_ids.space_id": "",
            // "component_ids.component_id": "1",
            // "component_ids.number": "",
            // "component_ids.unit_id": "",
            // "mosque_contractor_ids": "",
            // "mosque_contractor_ids.partner_id": "",
            // "mosque_contractor_ids.contract_number": "",
            // "mosque_contractor_ids.date_contract_start": "",
            // "mosque_contractor_ids.date_contract_end": "",
            // "mosque_contractor_ids.contract_amount": "",
            // "mosque_contractor_ids.employee_number": "1",
            // "mosque_contractor_ids.mosque_id": "",
            // "mosque_contractor_ids.worker_price": "1",
            // "mosque_contractor_ids.attachment_ids": "",
            // "mosque_contractor_ids.workers_ids": "1",
            // "mosque_contractor_ids.workers_ids.mosque_id": "",
            // "mosque_contractor_ids.workers_ids.contractor_id": "1",
            // "mosque_contractor_ids.workers_ids.worker_id": "",
            // "mosque_contractor_ids.workers_ids.workers_calendar_ids": "",
            // "mosque_contractor_ids.workers_ids.workers_calendar_ids.worker_id": "",
            // "mosque_contractor_ids.workers_ids.workers_calendar_ids.week_day": "",
            // "mosque_contractor_ids.workers_ids.workers_calendar_ids.time_from": "",
            // "mosque_contractor_ids.workers_ids.workers_calendar_ids.time_to": "",
            // "maintenance_staff_ids": "",
            // "maintenance_staff_ids.member_id": "",
            // "maintenance_staff_ids.role_id": "",
            // "maintenance_staff_ids.mosque_id": "1",
            // "maintenance_staff_ids.type": "1",
            // "hygiene_staff_ids": "",
            // "hygiene_staff_ids.member_id": "",
            // "hygiene_staff_ids.role_id": "",
            // "hygiene_staff_ids.mosque_id": "1",
            // "hygiene_staff_ids.type": "1",
            // "program_ids": "1",
            // "program_ids.number": "",
            // "program_ids.program_id": "",
            // "program_ids.mosque_id": "1",
            // "service_ids": "1",
            // "service_ids.number": "",
            // "service_ids.service_id": "",
            // "service_ids.mosque_id": "1",
            // "system_ids": "",
            // "system_ids.number": "",
            // "system_ids.system_id": "",
            // "system_ids.mosque_id": "",
            // "system_ids.system_unit_number": "",
            // "system_ids.system_unit_ids": "1",
            // "system_ids.system_unit_ids.number": "",
            // "system_ids.system_unit_ids.system_unit_id": "",
            // "system_ids.system_unit_ids.mosque_id": "",
            // "system_ids.system_unit_ids.system_id": "1",
            // "system_ids.system_unit_ids.unit_component_number": "",
            // "system_ids.system_unit_ids.unit_component_ids": "1",
            // "system_ids.system_unit_ids.unit_component_ids.number": "",
            // "system_ids.system_unit_ids.unit_component_ids.component_id": "",
            // "system_ids.system_unit_ids.unit_component_ids.mosque_id": "",
            // "system_ids.system_unit_ids.unit_component_ids.system_unit_id": "1",
            // "mosque_device_ids": "",
            // "mosque_device_ids.name": "",
            // "mosque_device_ids.number": "",
            // "mosque_device_ids.state": "",
            // "attachment_ids": "",
            // "supervisor": "",
            // "waiting_room": "",
            // "basin_ids": "",
            // "basin_ids.code": "",
            // "basin_ids.name": "",
            // "basin_ids.for_gender_ids": "",
            // "basin_ids.mosque_id": "",
            // "farewell_room_ids": "",
            // "farewell_room_ids.name": "",
            // "washer_staff_ids": "",
            // "washer_staff_ids.member_id": "",
            // "washer_staff_ids.gender_ids": "",
            // "washer_staff_ids.type": "1",
            // "washer_staff_ids.mosque_id": "1",
            // "washer_staff_ids.death_reason_ids": "",
            // "driver_staff_ids": "",
            // "driver_staff_ids.member_id": "",
            // "driver_staff_ids.type": "1",
            // "driver_staff_ids.mosque_id": "1",
            // "driver_staff_ids.fleet_vehicle_ids": ""
          }
        ],
        "model": "mosque.mosque",
        "method": "onchange",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid":  _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
          }
        }
      };

      var response = await client.callKwCustom(payload);

      return response;
    }on OdooException catch (e) {

      return [];
    } catch (e) {

      return [];
    }
  }

  Future<dynamic> acceptTerms(int id) async {
    try {
      dynamic payload={
        "args": [
          {
            "accept_terms": true
          }
        ],
        "model": "mosque.confirmation.wizard",
        "method": "create",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ],
            "current_id": id
          }
        }
      };

      var response = await client.callKwCustom(payload);

     
      dynamic final_payload={
        "args": [
          [
            response
          ]
        ],
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ],
            "current_id": id
          }
        },
        "method": "action_confirm",
        "model": "mosque.confirmation.wizard"
      };
    
      var responseConfirm = await client.callKwCustom(final_payload);
  
      return true;
    } catch (e) {
  
      throw e;
    }
  }


  Future<dynamic> acceptTermsSetDraft(int id,dynamic obj) async {
    try {
      dynamic payload={
        "args": [
          obj
        ],
        "model": "mosque.confirmation.wizard",
        "method": "create",
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ],
            "current_id": id,
            "set_draft_observation": true
          }
        }
      };

      var response = await client.callKwCustom(payload);


      dynamic final_payload={
        "args": [
          [
            response
          ]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ],
            "current_id": id,
            "set_draft_observation": true
          }
        },
        "method": "action_confirm",
        "model": "mosque.confirmation.wizard"
      };

      var responseConfirm = await client.callKwCustom(final_payload);

      return true;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> sendMosque(int id) async {
    try {

      dynamic payload={
        "args": [
          [
            id
          ],"mobile"
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        },
        "method": "action_send",
        "model": "mosque.mosque"
      };

      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {
    
      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> setDraftMosque(int id) async {
    try {

      dynamic payload={
        "args": [
          [
            id
          ]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],

          }
        },
        "method": "set_to_draft",
        "model": "mosque.mosque"
      };

      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> submitMosqueChanges(int id) async {
    try {

      dynamic payload={
        "args": [
          [
            id
          ]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            // "tz": "Asia/Riyadh",
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        },
        "method": "submit_request_changes",
        "model": "mosque.mosque"
      };

      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  // Future<dynamic> acceptMosque(int id) async {
  //   try {
  //
  //     dynamic payload={
  //       "args": [
  //         [
  //           id
  //         ]
  //       ],
  //       "kwargs": {
  //         "context": {
  //           "lang": _userProfile.language,
  //           "tz": _userProfile.tz,
  //           "uid": _userProfile.userId,
  //           "allowed_company_ids": [
  //             _userProfile.companyId
  //           ]
  //         }
  //       },
  //       "method": "action_accept",
  //       "model": "mosque.mosque"
  //     };
  //     var response = await client.callKwCustom(payload);
  //
  //     return response;
  //   }on Exception catch (e) {
  //
  //     throw e;
  //   } catch (e) {
  //
  //     throw e;
  //   }
  // }

  Future<dynamic> refuseMosque(int id,String message) async {
    try {

      dynamic payload={
        "args": [
          {
            "message": message??""
          }
        ],
        "model": "refuse.wizard",
        "method": "create",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "action_name": "action_refuse",
            "field_name": "refuse_reason",
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ]
          }
        }
      };

      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> callRefuseMosque(int id,int messageId) async {
    try {

      dynamic payload={
        "args": [
          [
            messageId
          ]
        ],
        "kwargs": {
          "context": {
            "lang":  _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "params": {
              "id": id,
              "model": "mosque.mosque",
              "view_type": "form"
            },
            "action_name": "action_refuse",
            "field_name": "refuse_reason",
            "active_model": "mosque.mosque",
            "active_id": id,
            "active_ids": [
              id
            ]
          }
        },
        "method": "button_refuse",
        "model": "refuse.wizard"
      };

      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> createMosque(Mosque newMosque) async {
    try {

      dynamic payload={
        "args": [
          {
            // "imam_ids": [
            //   [
            //     6,
            //     false,
            //     newMosque.imamIds
            //   ]
            // ],
            // "muezzin_ids": [
            //   [
            //     6,
            //     false,
            //     newMosque.muezzinIds
            //   ]
            // ],
            // "khadem_ids": [
            //   [
            //     6,
            //     false,
            //     newMosque.khademIds
            //   ]
            // ],
            // "khatib_ids": [
            //   [
            //     6,
            //     false,
            //     newMosque.khatibIds
            //   ]
            // ],
            "name": newMosque.name,
            "moia_center_id": newMosque.moiaCenterId,
            "district": newMosque.districtId,
            "is_another_neighborhood": newMosque.isAnotherNeighborhood,
            "another_neighborhood_char": newMosque.anotherNeighborhoodChar,
            "classification_id": newMosque.classificationId,
            "mosque_type_id": newMosque.mosqueTypeId,
            "observer_ids": [_userProfile.employeeId],
            "street": newMosque.street,
            "city_id": newMosque.cityId,
            "region_id": newMosque.regionId,
            "establishment_date": newMosque.establishmentDate,
            "country_id": newMosque.countryId,
            "latitude": newMosque.latitude,
            "longitude": newMosque.longitude,
          }
        ],
        "model": "mosque.mosque",
        "method": "create",
        "kwargs": {
          "context": {
            "lang":_userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }

      };
      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  // Future<dynamic> loadMosqueView() async {
  //   try {
  //
  //     dynamic payload={
  //       "model": "mosque.mosque",
  //       "method": "load_views",
  //       "args": [],
  //       "kwargs": {
  //         "views": [
  //           [
  //             false,
  //             "form"
  //           ]
  //         ],
  //         "context": {
  //           "lang": _userProfile.language,
  //           "allowed_company_ids": [
  //             _userProfile.companyId
  //           ]
  //         }
  //       }
  //     };
  //     var response = await client.callKwCustom(payload);
  //     try{
  //       return response['fields_views']["form"]["fields"];
  //     }catch(e){
  //       return response['fields'];
  //     }
  //   }on Exception catch (e) {
  //
  //     throw e;
  //   } catch (e) {
  //
  //     throw e;
  //   }
  // }

  Future<dynamic> getMosqueFilter(String field,{dynamic domain}) async {
    try {

      dynamic payload={
        "context": {
          "lang":_userProfile.language,
          "allowed_company_ids": [
            _userProfile.companyId
          ]
        },
        "args": [
          field
        ],
        "model": "mosque.mosque",
        "method": "search_panel_select_range",
        "kwargs": {
          "category_domain": [],
          "enable_counters": false,
          "expand": false,
          "filter_domain": [],
          "hierarchize": true,
          "limit": 200,
          "search_domain": domain??[],
          "context": {
            "lang":_userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };
      var response = await client.callKwCustom(payload);

      try{
        return response['values'];
      }catch(e){
        return [];
      }
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> updateMosque(Mosque newMosque,dynamic pram) async {
    try {

      dynamic payload={
        "args": [
          [
            newMosque.id
          ],
          pram
        ],
        "model": "mosque.mosque",
        "method": "write",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };

     

      var response = await client.callKwCustom(payload);
     

      return response;
    }catch (e) {


      throw e;
    }
  }
  Future<dynamic> getMosqueCoordinate(int id) async {
    try {
      var _payload={
        "args": [
          [
            id
          ],
          [
            "id",
            "latitude",
            "longitude",
          ]
        ],
        "model": "mosque.mosque",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true,
          }
        }
      };

      var response = await client.callKwCustom(_payload);

      return response;
    }catch (e) {

      throw e;
    }
  }

//endregion

  //region for  Mosque childs table
  Future<List<dynamic>> getRegionsByIds(List<int> ids) async {

    try{
      dynamic response = await client.callKwCustom({
        "args": [
          ids,
          [
            "number",
            "name",
            "mosque_id",
            "code"
          ]
        ],
        "model": "mosque.region",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
          }
        }
      });
      return response;
    }on OdooSessionExpiredException {
      throw Response("error", 408);
    }catch(e){
      throw Response("error", 408);

    }

  }

  Future<List<dynamic>> getMetersByIds(List<int> ids) async {

    try{
      dynamic _payload={
        "args": [
          ids,
          [
            "name",
            "attachment_id",//this is required  don't commit, issue in edit meter form
            "mosque_shared",
            "__last_update"
          ]
        ],
        "model": "meter.meter",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
          }
        }
      };
      dynamic response = await client.callKwCustom(_payload);
  

      return response;
    }catch(e){

      throw e;

    }

  }

  Future<List<dynamic>> getMosqueMetersByIds(List<int> ids) async {

    try{
      dynamic _payload={
        "args": [
          ids,
          [
            "meter_number",
            "meter_type",
            "meter_new",
            "imam",
            "attachment_id",
            "muezzin",
            "mosque",
            "__last_update",
            "facility"
          ]
        ],
        "model": "mosque.meter",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };
      dynamic response = await client.callKwCustom(_payload);


      return response;
    }catch(e){

      throw e;

    }

  }

  Future<List<dynamic>> getWaterMetersByIds(List<int> ids) async {

    try{
      dynamic _payload={
        "args": [
          ids,
          [
            "meter_number",
            "meter_type",
            "imam",
            "attachment_id",
            "muezzin",
            "mosque",
            "__last_update",
            "facility"
          ]
        ],
        "model": "water.meter",
        "method": "read",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };
      dynamic response = await client.callKwCustom(_payload);


      return response;
    }catch(e){

      throw e;

    }

  }

  Future<dynamic> createMosqueRegion(MosqueRegion region,int mosqueId) async {
    try {

      dynamic payload={
        "args": [
          [
            mosqueId
          ],
          {
            "region_ids": [
              [
                0,
                "virtual_900",
                {
                  "number": 0,
                  "name": region.name,
                  "mosque_id": mosqueId,
                  "code": region.code
                }
              ]
            ]
          }
        ],
        "model": "mosque.mosque",
        "method": "write",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };
      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> updateMosqueRegion(MosqueRegion region,int mosqueId) async {
    try {

      dynamic payload={
        "args": [
          [
            mosqueId
          ],
          {
            "region_ids": [
              [
                1,
                region.id,
                {
                  "code": region.code,
                  "name": region.name,
                  "number": region.number,
                }
              ]
            ]
          }
        ],
        "model": "mosque.mosque",
        "method": "write",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz":  _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        }
      };


      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }
//endregion

  //region for Edit Mosque Request
  Future<List<dynamic>> getEditMosqueRequest(dynamic domain,int pageSize,int pageIndex) async {

    try {
      dynamic _payload={
        'model': 'mosque.edit.request',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'limit': pageSize,
          "offset" :  ((pageIndex-1)*pageSize),
          'context': {
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true
          },
          'domain': domain,
          'fields': [
            "name",
            "mosque_id",
            "date_submit",
            "state"
          ],

        },
      };
      var response = await client.callKwCustom(_payload);
      return response.toList();
    }catch (e) {

      throw e;
    }
  }

  Future<dynamic> loadEditMosqueReqView() async {
    try {

      dynamic payload={
        "model": "mosque.edit.request",
        "method": "load_views",
        "args": [],
        "kwargs": {
          "views": [
            [
              false,
              "kanban"
            ],
            [
              false,
              "list"
            ],
            [
              false,
              "form"
            ],
            [
              false,
              "search"
            ]
          ],
          "options": {
            "action_id": 380,
            "load_filters": true,
            "toolbar": true
          },
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            // "uid": _userProfile.userId,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
          }
        }
      };
      var response = await client.callKwCustom(payload);

      return response['fields'];
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> getMosqueRequestDetail(int id) async {
    try {

      dynamic _payload={
        "args": [
          [
            id
          ],
          [
            "state",
            "refuse_text",
            "is_observer",
            "is_supervisor",
            "name",
            "mosque_id",
            "number",
            "supervisor_id",
            "date_submit",
            "create_date",
            "region_id",
            "description",
            // "message_follower_ids",
            // "activity_ids",
            // "message_ids",
            "display_name"
          ]
        ],
        "model": "mosque.edit.request",
        "method": "read",
        "kwargs": {
          "context": {
            "lang":_userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
            "bin_size": true,

          }
        }
      };
      var response = await client.callKwCustom(_payload);


      return response;
    }catch (e) {
      throw e;
    }
  }

  Future<dynamic> onChangeMosqueReq(int mosqueId) async {


    try{
      dynamic _payload={
        "args": [
          [],
          {
            "state": "draft",
            "is_observer": false,
            "is_supervisor": false,
            "name": "New",
            "mosque_id": mosqueId,
            "number": false,
            "supervisor_id": false,
            "date_submit": false,
            "create_date": false,
            "region_id": false,
            "description": false,
            "message_follower_ids": [],
            "activity_ids": [],
            "message_ids": []
          },
          "mosque_id",
          {
            "state": "",
            "is_observer": "",
            "is_supervisor": "",
            "name": "",
            "mosque_id": "1",
            "number": "",
            "supervisor_id": "",
            "date_submit": "",
            "create_date": "",
            "region_id": "",
            "description": "",
            "message_follower_ids": "",
            "message_follower_ids.res_model": "",
            "message_follower_ids.res_id": "",
            "message_follower_ids.partner_id": "",
            "activity_ids": "",
            "activity_ids.res_name": "",
            "activity_ids.active": "",
            "activity_ids.activity_type_id": "1",
            "activity_ids.summary": "",
            "activity_ids.date_deadline": "",
            "message_ids": "",
            "message_ids.date": "",
            "message_ids.subject": "",
            "message_ids.author_id": "",
            "message_ids.model": "",
            "message_ids.res_id": ""
          }
        ],
        "model": "mosque.edit.request",
        "method": "onchange",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],

          }
        }
      };

      dynamic response = await client.callKwCustom(_payload);



      return response;
    }catch(e){


      throw e;

    }

  }

  Future<dynamic> createMosqueRequest(MosqueEditRequest newMosque) async {
    try {

      dynamic payload={
        "args": [
          {
            "state": "draft",
            "mosque_id": newMosque.mosqueId,
            "description":  newMosque.description
          }
        ],
        "model": "mosque.edit.request",
        "method": "create",
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ],
          }
        }
      };
      
      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }

  Future<dynamic> takeActionMosqueRequest(int requestId,String action) async {
    try {

      dynamic payload={
        "args": [
          [
            requestId
          ]
        ],
        "kwargs": {
          "context": {
            "lang": _userProfile.language,
            "tz": _userProfile.tz,
            "allowed_company_ids": [
              _userProfile.companyId
            ]
          }
        },
        "method": action,
        "model": "mosque.edit.request"
      };
      var response = await client.callKwCustom(payload);

      return response;
    }on Exception catch (e) {

      throw e;
    } catch (e) {

      throw e;
    }
  }
  //endregion



}