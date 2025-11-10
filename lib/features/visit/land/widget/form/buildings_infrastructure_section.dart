import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/violation_guidelines_section.dart';
import 'package:mosque_management_system/features/visit/land/form/visit_land_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class BuildingsInfrastructureSection extends StatelessWidget {
  const BuildingsInfrastructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitLandModel>>() as VisitLandFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("temporary_buildings".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppSelectionField(
            title: vm.fields.getField('has_temporary_buildings').label,
            value: vm.visitObj.hasTemporaryBuildings,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('has_temporary_buildings'),
            isRequired: vm.visitObj.isRequired('has_temporary_buildings'),
            onChanged: (val) {
              vm.updateHasTemporaryBuildings(val);
            },
          ),
          Selector<VisitFormViewModel<VisitLandModel>, String?>(
            selector: (_, vm) => vm.visitObj.hasTemporaryBuildings,
            builder: (context, hasTemporaryBuildings, __) {

              if (vm.visitObj.hasTemporaryBuildings == 'yes') {
                return AppInputField(
                  title: vm.fields.getField('temporary_building_type').label,
                  value: vm.visitObj.temporaryBuildingType,
                  type: InputFieldType.textArea,
                  isRequired: vm.visitObj.isRequired('temporary_building_type'),
                  onChanged: (val) {
                    vm.visitObj.temporaryBuildingType = val; 
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
          Text("land_encroachment".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),

          AppSelectionField(
            title: vm.fields.getField('has_encroachment').label,
            value: vm.visitObj.hasEncroachment,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('has_encroachment'),
            isRequired: vm.visitObj.isRequired('has_encroachment'),
            onChanged: (val) {
              vm.updateHasEncroachment(val);
            },
          ),
          Selector<VisitFormViewModel<VisitLandModel>, String?>(
            selector: (_, vm) => vm.visitObj.hasEncroachment,
            builder: (context, hasEncroachment, __) {

              if (vm.visitObj.hasEncroachment == 'yes') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSelectionField(
                      title: vm.fields.getField('encroachment_type').label,
                      value: vm.visitObj.encroachmentType,
                      type: SingleSelectionFieldType.radio,
                      options: vm.fields.getComboList('encroachment_type'),
                      isRequired: vm.visitObj.isRequired('encroachment_type'),
                      onChanged: (val) {
                        vm.visitObj.encroachmentType = val; // ✅ keep your code
                      },
                    ),
                    violationGuidelinesSection(),
                    AppAttachmentField(
                      title: vm.fields.getField('encroachment_photo').label,
                      value: vm.visitObj.encroachmentPhoto,
                      isRequired: vm.visitObj.isRequired('encroachment_photo'),
                      isMemory: true,
                      onChanged: (val) {
                        vm.visitObj.encroachmentPhoto = val; // ✅ keep your code
                      },
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          AppInputField(
            title: vm.fields.getField('temp_building_notes').label,
            value: vm.visitObj.tempBuildingNotes,
            isRequired:  vm.visitObj.isRequired('temp_building_notes'),
            onSave: (val) {
              vm.visitObj.tempBuildingNotes=val;
            },
          ),

        ],
      ),
    );
  }
}