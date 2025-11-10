import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/location_picker_page.dart';

import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_item_bottom_sheet.dart';
import '../../../core/models/userProfile.dart';
import '../core/models/mosque_local.dart';
import '../../../data/repositories/common_repository.dart';
import '../../../data/services/custom_odoo_client.dart';
import '../../../data/services/user_service.dart';
import '../../../core/constants/config.dart';
import 'geo_capture.dart';
import 'logic/validation_scope.dart';

// FIX: use base controls and provider/mode like BasicInfoTab
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';              // FIX
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';        // FIX
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';   // FIX
import 'package:provider/provider.dart';                                                  // FIX
                                            // FIX
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';                                                         // FIX
import 'package:latlong2/latlong.dart';

class MosqueAddressTab extends StatelessWidget {
  final MosqueLocal local;
  final bool editing;

  MosqueAddressTab({
    super.key,
    required this.local,
    required this.editing,
  });



  String _k(String field) => field;

  void _onRegionSelected(ComboItem region) { /* unchanged */
    vm.mosqueObj.region=region.value;
    vm.mosqueObj.regionId=region.key;
    vm.mosqueObj.cityId=null;
    vm.mosqueObj.city=null;
    vm.mosqueObj.moiaCenter=null;
    vm.mosqueObj.moiaCenterId=null;
    vm.updateAgreeField(_k('region_id'), true);
    vm.notifyListeners();
    // updateLocal((m) {
    //   m.region = region.name; m.regionId = region.id;
    //   m.city = null; m.cityId = null; m.moiaCenter = null; m.moiaCenterId = null;
    //   (m.payload ??= {})['region_id'] = region.id;
    //   m.payload!['city_id'] = null; m.payload!['moia_center_id'] = null;
    //   m.updatedAt = DateTime.now();
    // });
  }

  void _onCitySelected(ComboItem city) { /* unchanged */
    vm.mosqueObj.cityId=city.key;
    vm.mosqueObj.city=city.value;
    vm.mosqueObj.moiaCenter=null;
    vm.mosqueObj.moiaCenterId=null;
    vm.updateAgreeField(_k('city_id'), true);
    vm.notifyListeners();
    // updateLocal((m) {
    //   m.city = city.name; m.cityId = city.id;
    //   m.moiaCenter = null; m.moiaCenterId = null;
    //   (m.payload ??= {})['city_id'] = city.id; m.payload!['moia_center_id'] = null;
    //   m.updatedAt = DateTime.now();
    // });
  }

  void _onCenterSelected(dynamic centerId, String centerName) { /* unchanged */
    vm.mosqueObj.moiaCenter=centerName;
    vm.mosqueObj.moiaCenterId=centerId;
    vm.updateAgreeField(_k('moia_center_id'), true);
    vm.notifyListeners();
    // updateLocal((m) {
    //   m.moiaCenter = centerName; m.moiaCenterId = centerId;
    //   (m.payload ??= {})['moia_center_id'] = centerId;
    //   m.updatedAt = DateTime.now();
    // });
  }


  late CreateMosqueBaseViewModel vm;
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = context.read<UserProvider>();

     vm = context.watch<CreateMosqueBaseViewModel>();
     final isEditReq = vm.mode == FormMode.editRequest;

     final vs = ValidationScope.of(context);
    final canPickCity   = vm.mosqueObj.regionId != null;
    final canPickCenter = vm.mosqueObj.cityId   != null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        // ---------------- REGION ----------------
        AppInputField(                                                                     // FIX
          title: vm.fields.getField('region_id').label,
          //title: 'Region'.tr(),                                                                 // FIX
          value: vm.mosqueObj.region ?? '',     // FIX
          isReadonly: true,                                                                // FIX
          isRequired: true,                                                                // FIX
          isDisable: !editing || isEditReq,                                                // FIX (read-only + clickable via onTab, disabled in edit request)

          onTab: (editing && !isEditReq) ? () async{
            List<ComboItem> items=await vm.getRegion();
            showItemBottomSheet(
                title: vm.fields.getField('region_id').label,
                context: context,
                items: items,
                onChange: (ComboItem item){
                  _onRegionSelected(item);
                }
            );
          }  : null,        // FIX (keep your picker, but disable in edit request)
        ),
        // if (vs?.errorOf('region_id') != null)
        //   Padding(
        //     padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
        //     child: Text(vs!.errorOf('region_id')!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        //   ),
        const SizedBox(height: 10),

        // ---------------- CITY ----------------
        // Text(vm.mosqueObj.city.toString()),
        AppInputField(                                                                     // FIX
          title: vm.fields.getField('city_id').label,
          //title: 'City'.tr(),                                                                   // FIX
          value: vm.mosqueObj.city ?? '',           // FIX
          isReadonly: true,                                                                // FIX
          isRequired: true,                                                                // FIX
          isDisable: !canPickCity,                                                         // FIX
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('city_id')),
            onChanged: (v) => vm.updateAgreeField(_k('city_id'), v),
          )
              : null,
          onTab: (editing && canPickCity)
              ? () async{
                  List<ComboItem> items=await vm.getCity();
                  showItemBottomSheet(
                      title: vm.fields.getField('city_id').label,
                      context: context,
                      items: items,
                      onChange: (ComboItem item){
                        _onCitySelected(item);
                      }
                  );
             }                          // FIX
              : null,
        ),
        // if (vs?.errorOf('city_id') != null)
        //   Padding(
        //     padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
        //     child: Text(vs!.errorOf('city_id')!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        //   ),
        const SizedBox(height: 10),

        // ---------------- MOIA CENTER ----------------
        AppInputField(                                                                     // FIX
          title: vm.fields.getField('moia_center_id').label,
          //title: 'MOIA Center'.tr(),                                                            // FIX
          value: vm.mosqueObj.moiaCenter ?? '', // FIX
          isReadonly: true,                                                                // FIX
          isRequired: true,                                                                // FIX
          isDisable: !canPickCenter,                                                       // FIX
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('moia_center_id')),
            onChanged: (v) => vm.updateAgreeField(_k('moia_center_id'), v),
          )
              : null,
          onTab: (editing && canPickCenter)
              ? () async{
                 List<ComboItem> centers=await vm.getCenter();
                 showItemBottomSheet(
                     title: vm.fields.getField('moia_center_id').label,
                     context: context,
                     items: centers,
                     onChange: (ComboItem item){
                       _onCenterSelected(item.key,item.value??"");
                     }
                 );
            }// FIX
              : null,
                                  // FIX (keep same callback)
        ),
        if (vs?.errorOf('moia_center_id') != null)                                         // (optional, like basic info)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
            child: Text(vs!.errorOf('moia_center_id')!, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
        const SizedBox(height: 10),

        // ---------------- DISTRICT (independent, REQUIRED) ----------------
        AppInputField(                                                                     // FIX
          title: vm.fields.getField('district').label,
          //title: 'District'.tr(),                                                               // FIX
          value: vm.mosqueObj.district ?? '', // FIX
          isReadonly: true,                                                                // FIX
          isRequired: true,                                                                // FIX
          isDisable: !editing,                                                             // FIX
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree(_k('district_id')),
            onChanged: (v) => vm.updateAgreeField(_k('district_id'), v),
          )
              : null,
          onTab: editing
              ? () async {
            List<ComboItem> items=[];
            items=await vm.getDistricts();
            showItemBottomSheet(
                title: vm.fields.getField('district').label,
                context: context,
                items: items,
                onChange: (ComboItem item){
                  vm.mosqueObj.districtId = item.key;
                  vm.mosqueObj.district = item.value;
                  vm.updateAgreeField(_k('district_id'), true);
                  vm.notifyListeners();
                  // ValidationScope.of(context)?.clearError('district_id');
                  // if (isEditReq) vm.updateAgreeField(('district_id'), true); // FIX auto-check
                }
            );
            // final picked = await showDistrictModal();                                   // FIX (same picker)
            // if (picked == null) return;
            // final int? id = picked['id'] as int?;
            // final String? name = (picked['name'])?.trim();
            // if (id != null) {
            //   print(name);
            //   vm.mosqueObj.districtId = id;
            //   vm.mosqueObj.district =name;
            //   vm.updateAgreeField(_k('district_id'), true);
            //   vm.notifyListeners();
            //   ValidationScope.of(context)?.clearError('district_id');
            //   if (isEditReq) vm.updateAgreeField(('district_id'), true); // FIX auto-check
            // }
          }
              : null,
        ),
        if (ValidationScope.of(context)?.errorOf('district_id') != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 6, start: 4),
            child: Text(
              ValidationScope.of(context)!.errorOf('district_id')!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 10),

        // ---------------- STREET ----------------
        AppInputField(                                                                     // FIX
          title: vm.fields.getField('street').label,
          //title: 'Street'.tr(),                                                            // FIX
          value: vm.mosqueObj.street ?? '',                                                       // FIX
          isReadonly: !editing,                                                            // FIX
          isRequired: true,                                                                // FIX
          action: isEditReq
              ? AppDeclarationField(
            value: vm.getAgree('street'),
            onChanged: (v) => vm.updateAgreeField('street', v),
          )
              : null,
          onChanged: editing
              ? (v) {
                  vm.mosqueObj.street = v;
                  if (isEditReq && vm.getAgree('street')==false){
                    vm.updateAgreeField('street', true);
                  }
          }
              : null,
        ),

        // ---------------- HARAM LOCATION FIELDS (Conditional based on moia_center_id) ----------------
        // Show Makkah fields if moia_center_id is 37459
        if (vm.mosqueObj.moiaCenterId == 37459 || vm.mosqueObj.moiaCenter == "مركز مدينة مكة المكرمة") ...[
          const SizedBox(height: 10),
          AppSelectionField(
            title: vm.fields.getField('is_inside_haram_makkah').label,
            value: vm.mosqueObj.isInsideHaramMakkah,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('is_inside_haram_makkah'),
            isRequired: false,
            action: isEditReq
                ? AppDeclarationField(
                    value: vm.getAgree(_k('is_inside_haram_makkah')),
                    onChanged: (v) => vm.updateAgreeField(_k('is_inside_haram_makkah'), v),
                  )
                : null,
            onChanged: editing
                ? (value) {
                    vm.mosqueObj.isInsideHaramMakkah = value;
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_inside_haram_makkah'), true);
                    }
                    vm.notifyListeners();
                  }
                : null,
          ),
          
          const SizedBox(height: 10),
          AppSelectionField(
            title: vm.fields.getField('is_in_pilgrim_housing_makkah').label,
            value: vm.mosqueObj.isInPilgrimHousingMakkah,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('is_in_pilgrim_housing_makkah'),
            isRequired: false,
            action: isEditReq
                ? AppDeclarationField(
                    value: vm.getAgree(_k('is_in_pilgrim_housing_makkah')),
                    onChanged: (v) => vm.updateAgreeField(_k('is_in_pilgrim_housing_makkah'), v),
                  )
                : null,
            onChanged: editing
                ? (value) {
                    vm.mosqueObj.isInPilgrimHousingMakkah = value;
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_in_pilgrim_housing_makkah'), true);
                    }
                    vm.notifyListeners();
                  }
                : null,
          ),
        ],
        
        // Show Madinah fields if moia_center_id is 37582
        if (vm.mosqueObj.moiaCenterId == 37582 || vm.mosqueObj.moiaCenter == "مركز مدينة المدينة المنورة") ...[
          const SizedBox(height: 10),
          AppSelectionField(
            title: vm.fields.getField('is_inside_haram_madinah').label,
            value: vm.mosqueObj.isInsideHaramMadinah,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('is_inside_haram_madinah'),
            isRequired: false,
            action: isEditReq
                ? AppDeclarationField(
                    value: vm.getAgree(_k('is_inside_haram_madinah')),
                    onChanged: (v) => vm.updateAgreeField(_k('is_inside_haram_madinah'), v),
                  )
                : null,
            onChanged: editing
                ? (value) {
                    vm.mosqueObj.isInsideHaramMadinah = value;
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_inside_haram_madinah'), true);
                    }
                    vm.notifyListeners();
                  }
                : null,
          ),

          const SizedBox(height: 10),
          AppSelectionField(
            title: vm.fields.getField('is_in_visitor_housing_madinah').label,
            value: vm.mosqueObj.isInVisitorHousingMadinah,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('is_in_visitor_housing_madinah'),
            isRequired: false,
            action: isEditReq
                ? AppDeclarationField(
                    value: vm.getAgree(_k('is_in_visitor_housing_madinah')),
                    onChanged: (v) => vm.updateAgreeField(_k('is_in_visitor_housing_madinah'), v),
                  )
                : null,
            onChanged: editing
                ? (value) {
                    vm.mosqueObj.isInVisitorHousingMadinah = value;
                    if (isEditReq) {
                      vm.updateAgreeField(_k('is_in_visitor_housing_madinah'), true);
                    }
                    vm.notifyListeners();
                  }
                : null,
          ),
        ],

        const SizedBox(height: 16),
        GeoCaptureSection(local: vm.mosqueObj, editing: editing),
       //Text(vm.mosqueObj.latitude.toString()),

        if(vm.mosqueObj.latitude!=null)
          OsmLocationPicker(
            location: LatLng(vm.mosqueObj.latitude??0, vm.mosqueObj.longitude??0), // Riyadh
          ),
          ],
        ),
      ),
    );
  }
}
