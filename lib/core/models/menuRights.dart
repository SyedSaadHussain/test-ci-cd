import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/service_menu.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
class Menu{
   bool isRights=false;
  final dynamic filter;

  Menu({this.isRights = false, this.filter=null});

   factory Menu.fromJson(Map<String, dynamic>? json) {

     if(json==null){
       return Menu(
         isRights: false,
         filter:  '',
       );
     }else{
       return Menu(
         isRights: (JsonUtils.toBoolean(json!['value'])??false),
         filter:  json!['filters'],
       );
     }

   }
}

class MenuRights {
  final bool? createMosque;
  final Menu? searchVisit;
  final Menu? searchNewVisit;
  final Menu? mosqueList;
  final bool? createVisit;
  final bool? createNewVisit;
  final bool? khutbaRights;
  final bool? kpiRights;
  MenuRights({
    this.createMosque,
    this.mosqueList,
    this.createVisit,
    this.searchVisit,
    this.searchNewVisit,
    this.createNewVisit,
    this.khutbaRights,
    this.kpiRights
  });

  factory MenuRights.fromJson(Map<String, dynamic> json) {
    return MenuRights(
      searchVisit: Menu.fromJson(json['SEARCH_VISIT']),
      searchNewVisit: Menu.fromJson(json['SEARCH_NEW_VISIT']),
      createMosque:  JsonUtils.toBoolean(json['CREATE_MOSQUE'])??false,
      createVisit:  JsonUtils.toBoolean(json['CREATE_VISIT'])??false,
      createNewVisit:  JsonUtils.toBoolean(json['CREATE_NEW_VISIT'])??false,
      khutbaRights:  JsonUtils.toBoolean(json['KHUTBA_READ'])??false,
      kpiRights:  JsonUtils.toBoolean(json['kpi_view'])??false,
      mosqueList: Menu.fromJson(json['MOSQUE_LIST']),
    );
  }

  List<ServiceMenu> getAllMenus(){
    List<ServiceMenu> menu=[];


    if(createMosque??false)
      menu.add(ServiceMenu(name: 'create_new_mosque', menuUrl: 'NEW_MOSQUE',icon: Icons.add_home_sharp ,color: AppColors.primary,imagePath: 'assets/images/add_mosque.png',isImageColor: true));
    if(mosqueList!.isRights)
      menu.add(ServiceMenu(name: 'mosques', menuUrl: 'MOSQUES',icon: AppIcons.mosque,color: AppColors.primary,filter:mosqueList!.filter ));
    //menu.add(ServiceMenu(name: 'Visit', menuUrl: 'NEW_VISIT',icon: Icons.person_pin_circle_outlined,color: AppColors.primary));
    if(searchNewVisit!.isRights)
      menu.add(ServiceMenu(name: 'main_survey_screen', menuUrl: 'SURVEY_VISITS',icon: AppIcons.groupUsers,color: AppColors.primary));
    if(searchVisit!.isRights)
      menu.add(ServiceMenu(name: 'search_visits', menuUrl: 'TODAY_VISIT',icon: AppIcons.groupUsers,color: AppColors.primary,filter:mosqueList!.filter));
    if(createVisit!)
      menu.add(ServiceMenu(name: 'create_new_visit', menuUrl: 'CREATE_VISIT',icon: AppIcons.mosqueLocation,color: AppColors.primary));
    if(createNewVisit!)
      menu.add(ServiceMenu(name: 'assign_visit', menuUrl: 'ASSIGN_VISIT',icon: AppIcons.mosqueLocation,color: AppColors.primary));
    if(khutbaRights!)
      menu.add(ServiceMenu(name: 'all_khutbas', menuUrl: 'KHUTBA_MANAGEMENT',icon: Icons.mic,color: AppColors.primary,imagePath: 'assets/images/khutba.png',isImageColor: true));

    if(createMosque??false)
      menu.add(ServiceMenu(name: 'mosque_edit_request', menuUrl: 'MOSQUE_EDIT_REQUEST',icon: Icons.edit_note_rounded,color: AppColors.primary));

    if(kpiRights??false)
      menu.add(ServiceMenu(name: 'kpi', menuUrl: 'KPI',icon: Icons.bar_chart,color: AppColors.primary));
    // menu.add(ServiceMenu(name: 'profile', menuUrl: 'MY_PROFILE',icon: AppIcons.userReload,color: AppColors.primary));
    menu.add(ServiceMenu(name: 'visit', menuUrl: 'VISIT',icon: AppIcons.groupUsers,color: AppColors.primary));
    return menu;
  }

}