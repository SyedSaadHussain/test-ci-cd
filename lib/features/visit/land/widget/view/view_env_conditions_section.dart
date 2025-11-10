

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewEnvConditionsSection extends StatefulWidget {
  final VisitLandModel visit;
  final FieldListData fields;

  const ViewEnvConditionsSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewEnvConditionsSection> createState() => _ViewEnvConditionsSectionState();
}

 class _ViewEnvConditionsSectionState<T extends VisitModel> extends State<ViewEnvConditionsSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text("environment".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(
            title: widget.fields.getField('has_trees_grass').label,
            value: widget.visit.hasTreesGrass,
            options: widget.fields.getComboList('has_trees_grass'),
          ),
          AppInputView(
            title: widget.fields.getField('is_fenced').label,
            value: widget.visit.isFenced,
            options: widget.fields.getComboList('is_fenced'),
          ),

          AppInputView(
            title: widget.fields.getField('has_water_swamps').label,
            value: widget.visit.hasWaterSwamps,
            options: widget.fields.getComboList('has_water_swamps'),
          ),
          SizedBox(height: 15,),
          Text("safety_cleanliness".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(
            title: widget.fields.getField('has_safety_hazards').label,
            value: widget.visit.hasSafetyHazards,
            options: widget.fields.getComboList('has_safety_hazards'),
          ),
          if(widget.visit.hasSafetyHazards=='yes_describe')
            AppInputView(
              title: widget.fields.getField('safety_hazard_description').label,
              value: widget.visit.safetyHazardDescription,
            ),
          AppInputView(
            title: widget.fields.getField('is_waste_free').label,
            value: widget.visit.isWasteFree,
            options: widget.fields.getComboList('is_waste_free'),
          ),
          AppInputView(
              title: widget.fields.getField('environment_conditional_notes').label,
              value: widget.visit.environmentConditionalNotes
          ),

        ],
      ),
    );
  }
}