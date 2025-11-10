import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class SafetySection<T extends VisitModel> extends StatelessWidget {
  const SafetySection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.architecturalStructure,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('architectural_structure').label,
                value: vm.visitObj.architecturalStructure,
                type: SingleSelectionFieldType.radio,
                isShowWarning: vm.visitObj.isEscalationField('architectural_structure'),
                options: vm.fields.getComboList('architectural_structure'),
                isRequired: vm.visitObj.isRequired('architectural_structure'),
                onChanged: (val) {
                  vm.visitObj.architecturalStructure = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.electricalInstallations,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('electrical_installations').label,
                value: vm.visitObj.electricalInstallations,
                type: SingleSelectionFieldType.radio,
                isShowWarning: vm.visitObj.isEscalationField('electrical_installations'),
                options: vm.fields.getComboList('electrical_installations'),
                isRequired: vm.visitObj.isRequired('electrical_installations'),
                onChanged: (val) {
                  vm.visitObj.electricalInstallations = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.ablutionAndToilets,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('ablution_and_toilets').label,
                value: vm.visitObj.ablutionAndToilets,
                type: SingleSelectionFieldType.radio,
                isShowWarning: vm.visitObj.isEscalationField('ablution_and_toilets'),
                options: vm.fields.getComboList('ablution_and_toilets'),
                isRequired: vm.visitObj.isRequired('ablution_and_toilets'),
                onChanged: (val) {
                  vm.visitObj.ablutionAndToilets = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.ventilationAndAirQuality,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('ventilation_and_air_quality').label,
                value: vm.visitObj.ventilationAndAirQuality,
                type: SingleSelectionFieldType.radio,
                isShowWarning: vm.visitObj.isEscalationField('ventilation_and_air_quality'),
                options: vm.fields.getComboList('ventilation_and_air_quality'),
                isRequired: vm.visitObj.isRequired('ventilation_and_air_quality'),
                onChanged: (val) {
                  vm.visitObj.ventilationAndAirQuality = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.equipmentAndFurnitureSafety,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('equipment_and_furniture_safety').label,
                value: vm.visitObj.equipmentAndFurnitureSafety,
                type: SingleSelectionFieldType.radio,
                isShowWarning: vm.visitObj.isEscalationField('equipment_and_furniture_safety'),
                options: vm.fields.getComboList('equipment_and_furniture_safety'),
                isRequired: vm.visitObj.isRequired('equipment_and_furniture_safety'),
                onChanged: (val) {
                  vm.visitObj.equipmentAndFurnitureSafety = val;
                  vm.notifyListeners();
                },
              );
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('doors_and_locks').label,
            value: vm.visitObj.doorsAndLocks,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('doors_and_locks'),
            isRequired: vm.visitObj.isRequired('doors_and_locks'),
            onChanged: (val) {
              vm.visitObj.doorsAndLocks = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('water_tank_covers').label,
            value: vm.visitObj.waterTankCovers,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('water_tank_covers'),
            isRequired: vm.visitObj.isRequired('water_tank_covers'),
            onChanged: (val) {
              vm.visitObj.waterTankCovers = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('mosque_entrances_security').label,
            value: vm.visitObj.mosqueEntrancesSecurity,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('mosque_entrances_security'),
            isRequired: vm.visitObj.isRequired('mosque_entrances_security'),
            onChanged: (val) {
              vm.visitObj.mosqueEntrancesSecurity = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('fire_extinguishers').label,
            value: vm.visitObj.fireExtinguishers,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('fire_extinguishers'),
            isRequired: vm.visitObj.isRequired('fire_extinguishers'),
            onChanged: (val) {
              vm.visitObj.fireExtinguishers = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('fire_alarms').label,
            value: vm.visitObj.fireAlarms,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('fire_alarms'),
            isRequired: vm.visitObj.isRequired('fire_alarms'),
            onChanged: (val) {
              vm.visitObj.fireAlarms = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('first_aid_kits').label,
            value: vm.visitObj.firstAidKits,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('first_aid_kits'),
            isRequired: vm.visitObj.isRequired('first_aid_kits'),
            onChanged: (val) {
              vm.visitObj.firstAidKits = val;
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('emergency_exits').label,
            value: vm.visitObj.emergencyExits,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('emergency_exits'),
            isRequired: vm.visitObj.isRequired('emergency_exits'),
            onChanged: (val) {
              vm.visitObj.emergencyExits = val;
            },
          ),

          AppInputField(
            title: vm.fields.getField('saftey_standard_notes').label,
            value: vm.visitObj.safteyStandardNotes,
            isRequired: vm.visitObj.isRequired('saftey_standard_notes'),
            onChanged: (val) {
              vm.visitObj.safteyStandardNotes = val;
            },
          ),
        ],
      ),
    );
  }
}