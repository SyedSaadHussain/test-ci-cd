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

 class SecuritySection<T extends VisitModel> extends StatelessWidget {
  const SecuritySection({super.key});
  
  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.securityViolationType,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('security_violation_type').label,
                value: vm.visitObj.securityViolationType,
                type: SingleSelectionFieldType.selection,
                isShowWarning:
                vm.visitObj.isEscalationField('security_violation_type'),
                options: vm.fields.getComboList('security_violation_type'),
                isRequired:
                vm.visitObj.isRequired('security_violation_type'),
                onChanged: (val) {
                  vm.visitObj.securityViolationType = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.adminViolationType,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('admin_violation_type').label,
                value: vm.visitObj.adminViolationType,
                type: SingleSelectionFieldType.selection,
                isShowWarning:
                vm.visitObj.isEscalationField('admin_violation_type'),
                options: vm.fields.getComboList('admin_violation_type'),
                isRequired: vm.visitObj.isRequired('admin_violation_type'),
                onChanged: (val) {
                  vm.visitObj.adminViolationType = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.operationalViolationType,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('operational_violation_type').label,
                value: vm.visitObj.operationalViolationType,
                type: SingleSelectionFieldType.selection,
                isShowWarning: vm.visitObj
                    .isEscalationField('operational_violation_type'),
                options: vm.fields.getComboList('operational_violation_type'),
                isRequired:
                vm.visitObj.isRequired('operational_violation_type'),
                onChanged: (val) {
                  vm.visitObj.operationalViolationType = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.unauthorizedPublications,
            builder: (_, unauthorizedPublications, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSelectionField(
                    title: vm.fields.getField('unauthorized_publications').label,
                    value: vm.visitObj.unauthorizedPublications,
                    type: SingleSelectionFieldType.selection,
                    isShowWarning: vm.visitObj
                        .isEscalationField('unauthorized_publications'),
                    options: vm.fields.getComboList('unauthorized_publications'),
                    isRequired: vm.visitObj.isRequired(
                        'unauthorized_publications'),
                    onChanged: (val) {
                      vm.visitObj.unauthorizedPublications = val;
                      if (val != 'yes') vm.visitObj.publicationSource = null;
                      vm.notifyListeners();
                    },
                  ),
                  if (unauthorizedPublications == 'yes')
                    AppInputField(
                      title: vm.fields.getField('publication_source').label,
                      value: vm.visitObj.publicationSource,
                      type: InputFieldType.textArea,
                      isRequired:
                      vm.visitObj.isRequired('publication_source'),
                      onChanged: (val) {
                        vm.visitObj.publicationSource = val;
                      },
                    ),
                ],
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.religiousSocialViolationType,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('religious_social_violation_type').label,
                value: vm.visitObj.religiousSocialViolationType,
                type: SingleSelectionFieldType.selection,
                isShowWarning: vm.visitObj
                    .isEscalationField('religious_social_violation_type'),
                options: vm.fields.getComboList('religious_social_violation_type'),
                isRequired: vm.visitObj
                    .isRequired('religious_social_violation_type'),
                onChanged: (val) {
                  vm.visitObj.religiousSocialViolationType = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.unauthorizedQuranPresence,
            builder: (_, __, ___) {
              return AppSelectionField(
                title: vm.fields.getField('unauthorized_quran_presence').label,
                value: vm.visitObj.unauthorizedQuranPresence,
                type: SingleSelectionFieldType.selection,
                isShowWarning:
                vm.visitObj.isEscalationField('unauthorized_quran_presence'),
                options: vm.fields.getComboList('unauthorized_quran_presence'),
                isRequired: vm.visitObj.isRequired('unauthorized_quran_presence'),
                onChanged: (val) {
                  vm.visitObj.unauthorizedQuranPresence = val;
                  vm.notifyListeners();
                },
              );
            },
          ),

          AppInputField(
            title: vm.fields.getField('security_violation_notes').label,
            value: vm.visitObj.securityViolationNotes,
            isRequired: vm.visitObj.isRequired('security_violation_notes'),
            onChanged: (val) {
              vm.visitObj.securityViolationNotes = val;
            },
          ),
        ],
      ),
    );
  }
}