import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/violation_guidelines_section.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class BuildingSection<T extends VisitModel> extends StatelessWidget {
  const BuildingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Encroachment Building
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.isEncroachmentBuilding,
            builder: (_, value, __) {
              final vm = context.read<VisitFormViewModel<T>>();
              return AppSelectionField(
                title: vm.fields.getField('is_encroachment_building').label,
                value: vm.visitObj.isEncroachmentBuilding,
                type: SingleSelectionFieldType.radio,
                options: vm.fields.getComboList('is_encroachment_building'),
                isRequired: vm.visitObj.isRequired('is_encroachment_building'),
                isShowWarning: vm.visitObj.isEscalationField('is_encroachment_building'),
                onChanged: (val) {
                  vm.visitObj.onChangeIsEncroachmentBuilding(val);
                  vm.notifyListeners();
                },
              );
            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.isEncroachmentBuilding,
            builder: (_, value, __) {
              if (value == 'yes') {
                final vm = context.read<VisitFormViewModel<T>>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    violationGuidelinesSection(),
                    AppAttachmentField(
                      title: vm.fields.getField('encroachment_building_attachment').label,
                      value: vm.visitObj.encroachmentBuildingAttachment,
                      isRequired: vm.visitObj.isRequired('encroachment_building_attachment'),
                      onChanged: (val) {
                        vm.visitObj.encroachmentBuildingAttachment = val;
                      },
                    ),
                    AppSelectionField(
                      title: vm.fields.getField('case_encroachment_building').label,
                      value: vm.visitObj.caseEncroachmentBuilding,
                      type: SingleSelectionFieldType.radio,
                      options: vm.fields.getComboList('case_encroachment_building'),
                      isRequired: vm.visitObj.isRequired('case_encroachment_building'),
                      onChanged: (val) {
                        vm.visitObj.caseEncroachmentBuilding = val;
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Encroachment Vacant Land
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.isEncroachmentVacantLand,
            builder: (_, value, __) {
              final vm = context.read<VisitFormViewModel<T>>();
              return AppSelectionField(
                title: vm.fields.getField('is_encroachment_vacant_land').label,
                value: vm.visitObj.isEncroachmentVacantLand,
                type: SingleSelectionFieldType.radio,
                options: vm.fields.getComboList('is_encroachment_vacant_land'),
                isRequired: vm.visitObj.isRequired('is_encroachment_vacant_land'),
                isShowWarning: vm.visitObj.isEscalationField('is_encroachment_vacant_land'),
                onChanged: (val) {
                  vm.visitObj.onChangeIsEncroachmentVacantLand(val);
                  vm.notifyListeners();
                },
              );
            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.isEncroachmentVacantLand,
            builder: (_, value, __) {
              if (value == 'yes') {
                final vm = context.read<VisitFormViewModel<T>>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    violationGuidelinesSection(),
                    AppAttachmentField(
                      title: vm.fields.getField('encroachment_vacant_attachment').label,
                      value: vm.visitObj.encroachmentVacantAttachment,
                      isRequired: vm.visitObj.isRequired('encroachment_vacant_attachment'),
                      onChanged: (val) {
                        vm.visitObj.encroachmentVacantAttachment = val;
                      },
                    ),
                    AppSelectionField(
                      title: vm.fields.getField('case_encroachment_vacant_land').label,
                      value: vm.visitObj.caseEncroachmentVacantLand,
                      type: SingleSelectionFieldType.radio,
                      options: vm.fields.getComboList('case_encroachment_vacant_land'),
                      isRequired: vm.visitObj.isRequired('case_encroachment_vacant_land'),
                      onChanged: (val) {
                        vm.visitObj.caseEncroachmentVacantLand = val;
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Violation Building
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.isViolationBuilding,
            builder: (_, value, __) {
              final vm = context.read<VisitFormViewModel<T>>();
              return AppSelectionField(
                title: vm.fields.getField('is_violation_building').label,
                value: vm.visitObj.isViolationBuilding,
                type: SingleSelectionFieldType.radio,
                options: vm.fields.getComboList('is_violation_building'),
                isRequired: vm.visitObj.isRequired('is_violation_building'),
                isShowWarning: vm.visitObj.isEscalationField('is_violation_building'),
                onChanged: (val) {
                  vm.visitObj.onChangeIsViolationBuilding(val);
                  vm.notifyListeners();
                },
              );
            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.isViolationBuilding,
            builder: (_, value, __) {
              if (value == 'yes') {
                final vm = context.read<VisitFormViewModel<T>>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    violationGuidelinesSection(),
                    AppAttachmentField(
                      title: vm.fields.getField('violation_building_attachment').label,
                      value: vm.visitObj.violationBuildingAttachment,
                      isRequired: vm.visitObj.isRequired('violation_building_attachment'),
                      onChanged: (val) {
                        vm.visitObj.violationBuildingAttachment = val;
                      },
                    ),
                    AppSelectionField(
                      title: vm.fields.getField('case_violation_building').label,
                      value: vm.visitObj.caseViolationBuilding,
                      type: SingleSelectionFieldType.radio,
                      options: vm.fields.getComboList('case_violation_building'),
                      isRequired: vm.visitObj.isRequired('case_violation_building'),
                      onChanged: (val) {
                        vm.visitObj.caseViolationBuilding = val;
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Building Notes
          AppInputField(
            title: vm.fields.getField('building_notes').label,
            value: vm.visitObj.buildingNotes,
            isRequired: vm.visitObj.isRequired('building_notes'),
            onChanged: (val) {
              vm.visitObj.buildingNotes = val;
            },
          ),
        ],
      ),
    );
  }
}