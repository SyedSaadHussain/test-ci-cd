import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/FullImageViewer.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/location_picker_page.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/config.dart';

class MosqueConditionSection extends StatelessWidget {
  const MosqueConditionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, child) {


        final m = vm.mosqueObj;

        // Get condition data from payload or fallback to model fields
        final conditionData = m.payload?['condition'];

        // Check if mosque condition allows dependent tabs
        final bool showDependentTabs = m.mosqueCondition == 'existing_mosque' ||
            m.mosqueCondition == 'abandoned_mosque';
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // Mosque Condition
              AppInputView(
                  title: vm.fields
                      .getField('mosque_condition')
                      ?.label ?? 'Mosque Condition',
                  value: m.mosqueCondition ?? '',
                  options: vm.fields.getComboList('mosque_condition')
              ),

              // Building Material
              AppInputView(
                  title: vm.fields
                      .getField('building_material')
                      ?.label ?? 'Building Material',
                  value: m.buildingMaterial ?? '',
                  options: vm.fields.getComboList('building_material')
              ),

              // Urban Condition
              AppInputView(
                  title: vm.fields
                      .getField('urban_condition')
                      ?.label ?? 'Urban Condition',
                  value: m.urbanCondition ?? '',
                  options: vm.fields.getComboList('urban_condition')

              ),

              // Date Maintenance Last
              AppInputView(
                  title: vm.fields
                      .getField('date_maintenance_last')
                      ?.label ?? 'Date of Last Maintenance',
                  value: m.dateMaintenanceLast ?? '',
                  type: ListType.date
              ),

              // Outer Image - always show with placeholder if empty
              // Image - always show with placeholder if empty
              //  Unified image URL for both flows
              if (vm.modelName != null && vm.idForImage != null)
                AppImageView(
                  title: vm.fields
                      .getField('outer_image')
                      ?.label ?? 'Outer Mosque Photo',
                  value:
                  '${EnvironmentConfig.baseUrl}/web/image'
                      '?model=${vm.modelName}'
                      '&field=outer_image'
                      '&id=${vm.idForImage}'
                      '&unique=${m.uniqueId ?? ''}',
                  headersMap: vm.headerMap,
                  // onTab: () async{
                  //   // final selectedLocation = await Navigator.push(
                  //   //   context,
                  //   //   MaterialPageRoute(builder: (_) => OsmLocationPicker()),
                  //   // );
                  //   //
                  //   // if (selectedLocation != null) {
                  //   //   print("User selected: ${selectedLocation.latitude}, ${selectedLocation.longitude}");
                  //   // }
                  // }
                ),


              // ✅ Unified image URL for both flows
              if (vm.modelName != null && vm.idForImage != null)
                AppImageView(
                  title: vm.fields
                      .getField('image')
                      .label ?? 'Inner Mosque Photo',
                  value:
                  '${EnvironmentConfig.baseUrl}/web/image'
                      '?model=${vm.modelName}'
                      '&field=image'
                      '&id=${vm.idForImage}'
                      '&unique=${m.uniqueId ?? ''}',
                  headersMap: vm.headerMap,
                ),
            ],
          ),
        );
      },
      );

    }
  }



