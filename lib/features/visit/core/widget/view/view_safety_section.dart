

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewSafetySection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewSafetySection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewSafetySection<T>> createState() => _ViewSafetySectionState<T>();
}

 class _ViewSafetySectionState<T extends VisitModel> extends State<ViewSafetySection<T>> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('architectural_structure').label,
            value:  widget.visit.architecturalStructure,
            isShowWarning: widget.visit.isEscalationField('architectural_structure'),
            options: widget.fields.getComboList('architectural_structure'),

          ),
          AppInputView(
            title: widget.fields.getField('electrical_installations').label,
            value:  widget.visit.electricalInstallations,
            isShowWarning: widget.visit.isEscalationField('electrical_installations'),
            options: widget.fields.getComboList('electrical_installations'),

          ),
          AppInputView(
            title: widget.fields.getField('ablution_and_toilets').label,
            value:  widget.visit.ablutionAndToilets,
            isShowWarning: widget.visit.isEscalationField('ablution_and_toilets'),
            options: widget.fields.getComboList('ablution_and_toilets'),

          ),
          AppInputView(
            title: widget.fields.getField('ventilation_and_air_quality').label,
            value:  widget.visit.ventilationAndAirQuality,
            isShowWarning: widget.visit.isEscalationField('ventilation_and_air_quality'),
            options: widget.fields.getComboList('ventilation_and_air_quality'),

          ),
          AppInputView(
            title: widget.fields.getField('equipment_and_furniture_safety').label,
            value:  widget.visit.equipmentAndFurnitureSafety,
            isShowWarning: widget.visit.isEscalationField('equipment_and_furniture_safety'),
            options: widget.fields.getComboList('equipment_and_furniture_safety'),

          ),
          AppInputView(
            title: widget.fields.getField('doors_and_locks').label,
            value:  widget.visit.doorsAndLocks,
            options: widget.fields.getComboList('doors_and_locks'),

          ),
          AppInputView(
            title: widget.fields.getField('water_tank_covers').label,
            value:  widget.visit.waterTankCovers,
            options: widget.fields.getComboList('water_tank_covers'),
          ),

          AppInputView(
            title: widget.fields.getField('mosque_entrances_security').label,
            value:  widget.visit.mosqueEntrancesSecurity,
            options: widget.fields.getComboList('mosque_entrances_security'),
          ),

          AppInputView(
            title: widget.fields.getField('fire_extinguishers').label,
            value:  widget.visit.fireExtinguishers,
            options: widget.fields.getComboList('fire_extinguishers'),

          ),
          AppInputView(
            title: widget.fields.getField('fire_alarms').label,
            value:  widget.visit.fireAlarms,
            options: widget.fields.getComboList('fire_alarms'),

          ),
          AppInputView(
            title: widget.fields.getField('first_aid_kits').label,
            value:  widget.visit.firstAidKits,
            options: widget.fields.getComboList('first_aid_kits'),

          ),
          AppInputView(
            title: widget.fields.getField('emergency_exits').label,
            value:  widget.visit.emergencyExits,
            options: widget.fields.getComboList('emergency_exits'),

          ),
          AppInputView(
            title: widget.fields.getField('saftey_standard_notes').label,
            value:  widget.visit.safteyStandardNotes,
          ),
        ],
      ),
    );
  }
}