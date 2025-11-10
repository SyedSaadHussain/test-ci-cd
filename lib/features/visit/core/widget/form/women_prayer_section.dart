import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class WomenPrayerSection<T extends VisitFemaleModel> extends StatelessWidget {
  const WomenPrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          AppSelectionField(
            title: vm.fields.getField('women_prayer_signboard').label,
            value: vm.visitObj.womenPrayerSignboard,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('women_prayer_signboard'),
            isRequired: vm.visitObj.isRequired('women_prayer_signboard'),
            onChanged: (val) {
              vm.visitObj.womenPrayerSignboard=val;

              

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('clean_free_block').label,
            value: vm.visitObj.cleanFreeBlock,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('clean_free_block'),
            isRequired: vm.visitObj.isRequired('clean_free_block'),
            onChanged: (val) {
              vm.visitObj.cleanFreeBlock=val;

              

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('door_work_fine').label,
            value: vm.visitObj.doorWorkFine,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('door_work_fine'),
            isRequired: vm.visitObj.isRequired('door_work_fine'),
            onChanged: (val) {
              vm.visitObj.doorWorkFine=val;

              

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('privacy_women_area').label,
            value: vm.visitObj.privacyWomenArea,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('privacy_women_area'),
            isRequired: vm.visitObj.isRequired('privacy_women_area'),
            onChanged: (val) {
              vm.visitObj.privacyWomenArea=val;

              

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('woman_prayer_area_size').label,
            value: vm.visitObj.womanPrayerAreaSize,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('woman_prayer_area_size'),
            isRequired: vm.visitObj.isRequired('woman_prayer_area_size'),
            onChanged: (val) {
              vm.visitObj.womanPrayerAreaSize=val;

              

            },
          ),
          AppInputField(
            title: vm.fields.getField('female_section_notes').label,
            value: vm.visitObj.securityViolationNotes,
            isRequired: vm.visitObj.isRequired('female_section_notes'),
            onChanged: (val) {
              vm.visitObj.securityViolationNotes = val;
              
            },
          ),

        ],
      ),
    );
  }
}