import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class MaintenanceSection<T extends VisitModel> extends StatelessWidget {
  const MaintenanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField(
            title: vm.fields.getField('quran_shelves_storage').label,
            value: vm.visitObj.quranShelvesStorage,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('quran_shelves_storage'),
            isRequired: vm.visitObj.isRequired('quran_shelves_storage'),
            onChanged: (val) {
              vm.visitObj.quranShelvesStorage = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('carpets_and_flooring').label,
            value: vm.visitObj.carpetsAndFlooring,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('carpets_and_flooring'),
            isRequired: vm.visitObj.isRequired('carpets_and_flooring'),
            onChanged: (val) {
              vm.visitObj.carpetsAndFlooring = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('prayer_area_cleanliness').label,
            value: vm.visitObj.prayerAreaCleanliness,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('prayer_area_cleanliness'),
            isRequired: vm.visitObj.isRequired('prayer_area_cleanliness'),
            onChanged: (val) {
              vm.visitObj.prayerAreaCleanliness = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('mosque_courtyards').label,
            value: vm.visitObj.mosqueCourtyards,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_courtyards'),
            isRequired: vm.visitObj.isRequired('mosque_courtyards'),
            onChanged: (val) {
              vm.visitObj.mosqueCourtyards = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('mosque_entrances').label,
            value: vm.visitObj.mosqueEntrances,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_entrances'),
            isRequired: vm.visitObj.isRequired('mosque_entrances'),
            onChanged: (val) {
              vm.visitObj.mosqueEntrances = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('ablution_areas').label,
            value: vm.visitObj.ablutionAreas,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('ablution_areas'),
            isRequired: vm.visitObj.isRequired('ablution_areas'),
            onChanged: (val) {
              vm.visitObj.ablutionAreas = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('toilets').label,
            value: vm.visitObj.toilets,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('toilets'),
            isRequired: vm.visitObj.isRequired('toilets'),
            onChanged: (val) {
              vm.visitObj.toilets = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('windows_doors_walls').label,
            value: vm.visitObj.windowsDoorsWalls,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('windows_doors_walls'),
            isRequired: vm.visitObj.isRequired('windows_doors_walls'),
            onChanged: (val) {
              vm.visitObj.windowsDoorsWalls = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('storage_rooms').label,
            value: vm.visitObj.storageRooms,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('storage_rooms'),
            isRequired: vm.visitObj.isRequired('storage_rooms'),
            onChanged: (val) {
              vm.visitObj.storageRooms = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('mosque_carpet_quality').label,
            value: vm.visitObj.mosqueCarpetQuality,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_carpet_quality'),
            isRequired: vm.visitObj.isRequired('mosque_carpet_quality'),
            onChanged: (val) {
              vm.visitObj.mosqueCarpetQuality = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('maintenance_execution').label,
            value: vm.visitObj.maintenanceExecution,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('maintenance_execution'),
            isRequired: vm.visitObj.isRequired('maintenance_execution'),
            onChanged: (val) {
              vm.visitObj.maintenanceExecution = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('maintenance_response_speed').label,
            value: vm.visitObj.maintenanceResponseSpeed,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('maintenance_response_speed'),
            isRequired: vm.visitObj.isRequired('maintenance_response_speed'),
            onChanged: (val) {
              vm.visitObj.maintenanceResponseSpeed = val;
            },
          ),

          AppInputView(
            title: vm.fields.getField('has_maintenance_contractor').label,
            value: vm.visitObj.hasMaintenanceContractor,
            options: vm.fields.getComboList('has_maintenance_contractor'),
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.hasMaintenanceContractor,
            builder: (_, __, ___) {
              if (vm.visitObj.hasMaintenanceContractor != null &&
                  vm.visitObj.hasMaintenanceContractor != 'notapplicable') {
                return AppSelectionField(
                  title: vm.fields.getField('maintenance_contractor_ids').label,
                  value: vm.visitObj.maintenanceContractorIds,
                  type: SingleSelectionFieldType.checkBox,
                  options: vm.visitObj.maintenanceContractorIdsArray,
                  isRequired:
                  vm.visitObj.isRequired('maintenance_contractor_ids'),
                  onChanged: (val, isNew) {
                    if (isNew) {
                      if (vm.visitObj.maintenanceContractorIds == null) {
                        vm.visitObj.maintenanceContractorIds = [];
                      }
                      if (!vm.visitObj.maintenanceContractorIds!
                          .contains(val.key)) {
                        vm.visitObj.maintenanceContractorIds!.add(val.key);
                      }
                    } else {
                      vm.visitObj.maintenanceContractorIds!
                          .removeWhere((key) => key == val.key);
                    }
                    vm.notifyListeners();
                  },
                );
              }
              return Container();
            },
          ),

          AppInputField(
            title: vm.fields.getField('clean_maintenance_notes').label,
            value: vm.visitObj.cleanMaintenanceNotes,
            isRequired: vm.visitObj.isRequired('clean_maintenance_notes'),
            onChanged: (val) {
              vm.visitObj.cleanMaintenanceNotes = val;
            },
          ),
        ],
      ),
    );
  }
}