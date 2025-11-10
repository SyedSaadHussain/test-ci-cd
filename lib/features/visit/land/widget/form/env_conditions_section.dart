import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/land/form/visit_land_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class EnvConditionsSection extends StatelessWidget {
  const EnvConditionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitLandModel>>() as VisitLandFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text("environment".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppSelectionField(
            title: vm.fields.getField('has_trees_grass').label,
            value: vm.visitObj.hasTreesGrass,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('has_trees_grass'),
            isRequired: vm.visitObj.isRequired('has_trees_grass'),
            onChanged: (val) {
              vm.visitObj.hasTreesGrass=val;
              
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('is_fenced').label,
            value: vm.visitObj.isFenced,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('is_fenced'),
            isRequired: vm.visitObj.isRequired('is_fenced'),
            onChanged: (val) {
              vm.visitObj.isFenced=val;
              
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('has_water_swamps').label,
            value: vm.visitObj.hasWaterSwamps,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('has_water_swamps'),
            isRequired: vm.visitObj.isRequired('has_water_swamps'),
            onChanged: (val) {
              vm.visitObj.hasWaterSwamps=val;
              
            },
          ),
          SizedBox(height: 15,),
          Text("safety_cleanliness".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppSelectionField(
            title: vm.fields.getField('has_safety_hazards').label,
            value: vm.visitObj.hasSafetyHazards,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('has_safety_hazards'),
            isRequired: vm.visitObj.isRequired('has_safety_hazards'),
            onChanged: (val) {
              vm.updateHasSafetyHazards(val);
            },
          ),
          Selector<VisitFormViewModel<VisitLandModel>, String?>(
            selector: (_, vm) => vm.visitObj.hasSafetyHazards,
            builder: (context, hasElectricityMeter, __) {
              return vm.visitObj.hasSafetyHazards == 'yes_describe'
                  ? AppInputField(
                title: vm.fields.getField('safety_hazard_description').label,
                value: vm.visitObj.safetyHazardDescription,
                type: InputFieldType.textArea,
                isRequired: vm.visitObj.isRequired('safety_hazard_description'),
                onChanged: (val) {
                  vm.visitObj.safetyHazardDescription = val;
                },
              )
                  : SizedBox.shrink();
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('is_waste_free').label,
            value: vm.visitObj.isWasteFree,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('is_waste_free'),
            isRequired: vm.visitObj.isRequired('is_waste_free'),
            onChanged: (val) {
              vm.visitObj.isWasteFree=val;

              
            },
          ),
          AppInputField(
            title: vm.fields.getField('environment_conditional_notes').label,
            value: vm.visitObj.environmentConditionalNotes,
            isRequired:  vm.visitObj.isRequired('environment_conditional_notes'),
            onSave: (val) {
              vm.visitObj.environmentConditionalNotes=val;
              
            },
          ),



        ],
      ),
    );
  }
}