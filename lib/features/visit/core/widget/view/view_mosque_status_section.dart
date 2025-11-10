

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewMosqueStatusSection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewMosqueStatusSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewMosqueStatusSection<T>> createState() => _ViewMosqueStatusSectionState<T>();
}

 class _ViewMosqueStatusSectionState<T extends VisitModel> extends State<ViewMosqueStatusSection<T>> {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('mosque_address_status').label,
            value: widget.visit.mosqueAddressStatus,
            options: widget.fields.getComboList('mosque_address_status'),

          ),
          AppInputView(
            title: widget.fields.getField('geolocation_status').label,
            value: widget.visit.geolocationStatus,
            options: widget.fields.getComboList('geolocation_status'),

          ),
          AppInputView(
            title: widget.fields.getField('mosque_details_status').label,
            value: widget.visit.mosqueDetailsStatus,
            options: widget.fields.getComboList('mosque_details_status'),

          ),
          AppInputView(
            title: widget.fields.getField('mosque_images_status').label,
            value: widget.visit.mosqueImagesStatus,
            options: widget.fields.getComboList('mosque_images_status'),

          ),
          AppInputView(
            title: widget.fields.getField('maintenance_contract_status').label,
            value: widget.visit.maintenanceContractStatus,
            options: widget.fields.getComboList('maintenance_contract_status'),

          ),
          AppInputView(
            title: widget.fields.getField('building_details_status').label,
            value: widget.visit.buildingDetailsStatus,
            options: widget.fields.getComboList('building_details_status'),

          ),
          AppInputView(
            title: widget.fields.getField('imam_residence_status').label,
            value: widget.visit.imamResidenceStatus,
            options: widget.fields.getComboList('imam_residence_status'),

          ),
          AppInputView(
            title: widget.fields.getField('prayer_area_status').label,
            value: widget.visit.prayerAreaStatus,
            options: widget.fields.getComboList('prayer_area_status'),

          ),
          AppInputView(
            title: widget.fields.getField('human_resources_status').label,
            value: widget.visit.humanResourcesStatus,
            options: widget.fields.getComboList('human_resources_status'),

          ),
          AppInputView(
            title: widget.fields.getField('mosque_status_notes').label,
            value: widget.visit.mosqueStatusNotes,
          ),
        ],
      ),
    );
  }
}