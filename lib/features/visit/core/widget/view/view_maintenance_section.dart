

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewMaintenanceSection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewMaintenanceSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewMaintenanceSection<T>> createState() => _ViewMaintenanceSectionState<T>();
}

 class _ViewMaintenanceSectionState<T extends VisitModel> extends State<ViewMaintenanceSection<T>> {


  @override
  Widget build(BuildContext context) {
return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('quran_shelves_storage').label,
            value:  widget.visit.quranShelvesStorage,
            options: widget.fields.getComboList('quran_shelves_storage'),

          ),
          AppInputView(
            title: widget.fields.getField('carpets_and_flooring').label,
            value:  widget.visit.carpetsAndFlooring,
            options: widget.fields.getComboList('carpets_and_flooring'),

          ),
          AppInputView(
            title: widget.fields.getField('prayer_area_cleanliness').label,
            value:  widget.visit.prayerAreaCleanliness,
            options: widget.fields.getComboList('prayer_area_cleanliness'),

          ),
          AppInputView(
            title: widget.fields.getField('mosque_courtyards').label,
            value:  widget.visit.mosqueCourtyards,
            options: widget.fields.getComboList('mosque_courtyards'),

          ),
          AppInputView(
            title: widget.fields.getField('mosque_entrances').label,
            value:  widget.visit.mosqueEntrances,
            options: widget.fields.getComboList('mosque_entrances'),

          ),
          AppInputView(
            title: widget.fields.getField('ablution_areas').label,
            value:  widget.visit.ablutionAreas,
            options: widget.fields.getComboList('ablution_areas'),

          ),
          AppInputView(
            title: widget.fields.getField('toilets').label,
            value:  widget.visit.toilets,
            options: widget.fields.getComboList('toilets'),

          ),
          AppInputView(
            title: widget.fields.getField('windows_doors_walls').label,
            value:  widget.visit.windowsDoorsWalls,
            options: widget.fields.getComboList('windows_doors_walls'),

          ),
          AppInputView(
            title: widget.fields.getField('storage_rooms').label,
            value:  widget.visit.storageRooms,
            options: widget.fields.getComboList('storage_rooms'),

          ),
          AppInputView(
            title: widget.fields.getField('mosque_carpet_quality').label,
            value:  widget.visit.mosqueCarpetQuality,
            options: widget.fields.getComboList('mosque_carpet_quality'),

          ),
          AppInputView(
            title: widget.fields.getField('maintenance_execution').label,
            value:  widget.visit.maintenanceExecution,
            options: widget.fields.getComboList('maintenance_execution'),

          ),
          AppInputView(
            title: widget.fields.getField('maintenance_response_speed').label,
            value:  widget.visit.maintenanceResponseSpeed,
            options: widget.fields.getComboList('maintenance_response_speed'),

          ),
           widget.visit.hasMaintenanceContractor == 'notapplicable'?
          AppInputView(title:widget.fields.getField('has_maintenance_contractor').label,
              value:  widget.visit.hasMaintenanceContractor,
              options: widget.fields.getComboList('has_maintenance_contractor')
          ):
          AppInputView(
            title: widget.fields.getField('has_maintenance_contractor').label,
            value:  widget.visit.hasMaintenanceContractor,
            options: widget.fields.getComboList('has_maintenance_contractor'),

          ),
          if( widget.visit.hasMaintenanceContractor!=null &&  widget.visit.hasMaintenanceContractor != 'notapplicable')
            AppInputView(
              title: widget.fields.getField('maintenance_contractor_ids').label,
              options:  widget.visit.maintenanceContractorIdsArray,
              type:ListType.multiSelect,

            ),
          AppInputView(
            title: widget.fields.getField('clean_maintenance_notes').label,
            value:  widget.visit.cleanMaintenanceNotes,
          ),
        ],
      ),
    );
  }
}