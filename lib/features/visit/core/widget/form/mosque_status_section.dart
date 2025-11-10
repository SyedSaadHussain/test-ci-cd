import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class MosqueStatusSection<T extends VisitModel> extends StatelessWidget {
  const MosqueStatusSection({super.key});

  bool isRequired(T visit, String field) {
    return visit.isRequired(field);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField(
            title: vm.fields.getField('mosque_address_status').label,
            value: vm.visitObj.mosqueAddressStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_address_status'),
            isRequired: isRequired(vm.visitObj, 'mosque_address_status'),
            onChanged: (val) {
              vm.visitObj.mosqueAddressStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('geolocation_status').label,
            value: vm.visitObj.geolocationStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('geolocation_status'),
            isRequired: isRequired(vm.visitObj, 'geolocation_status'),
            onChanged: (val) {
              vm.visitObj.geolocationStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('mosque_details_status').label,
            value: vm.visitObj.mosqueDetailsStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_details_status'),
            isRequired: isRequired(vm.visitObj, 'mosque_details_status'),
            onChanged: (val) {
              vm.visitObj.mosqueDetailsStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('mosque_images_status').label,
            value: vm.visitObj.mosqueImagesStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_images_status'),
            isRequired: isRequired(vm.visitObj, 'mosque_images_status'),
            onChanged: (val) {
              vm.visitObj.mosqueImagesStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('maintenance_contract_status').label,
            value: vm.visitObj.maintenanceContractStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('maintenance_contract_status'),
            isRequired: isRequired(vm.visitObj, 'maintenance_contract_status'),
            onChanged: (val) {
              vm.visitObj.maintenanceContractStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('building_details_status').label,
            value: vm.visitObj.buildingDetailsStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('building_details_status'),
            isRequired: isRequired(vm.visitObj, 'building_details_status'),
            onChanged: (val) {
              vm.visitObj.buildingDetailsStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('imam_residence_status').label,
            value: vm.visitObj.imamResidenceStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('imam_residence_status'),
            isRequired: isRequired(vm.visitObj, 'imam_residence_status'),
            onChanged: (val) {
              vm.visitObj.imamResidenceStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('prayer_area_status').label,
            value: vm.visitObj.prayerAreaStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('prayer_area_status'),
            isRequired: isRequired(vm.visitObj, 'prayer_area_status'),
            onChanged: (val) {
              vm.visitObj.prayerAreaStatus = val;
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('human_resources_status').label,
            value: vm.visitObj.humanResourcesStatus,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('human_resources_status'),
            isRequired: isRequired(vm.visitObj, 'human_resources_status'),
            onChanged: (val) {
              vm.visitObj.humanResourcesStatus = val;
            },
          ),
          AppInputField(
            title: vm.fields.getField('mosque_status_notes').label,
            value: vm.visitObj.mosqueStatusNotes,
            isRequired: isRequired(vm.visitObj, 'mosque_status_notes'),
            onChanged: (val) {
              vm.visitObj.mosqueStatusNotes = val;
            },
          ),
        ],
      ),
    );
  }
}