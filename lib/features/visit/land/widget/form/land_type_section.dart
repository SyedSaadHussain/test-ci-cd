

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class LandTypeSection extends StatelessWidget {
  const LandTypeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitLandModel>>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text("land_type_ownership_sign".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppSelectionField(
            title:   vm.fields.getField('land_type').label,
            value: vm.visitObj.landType,
            type: SingleSelectionFieldType.selection,
            options:   vm.fields.getComboList('land_type'),
            isRequired: vm.visitObj.isRequired('land_type'),
            onChanged: (val) {
              vm.visitObj.landType=val;
              
            },
          ),
          AppSelectionField(
            title:   vm.fields.getField('has_ownership_sign').label,
            value: vm.visitObj.hasOwnershipSign,
            type: SingleSelectionFieldType.radio,
            options:   vm.fields.getComboList('has_ownership_sign'),
            isRequired: vm.visitObj.isRequired('has_ownership_sign'),
            onChanged: (val) {
              vm.visitObj.hasOwnershipSign=val;
              vm.visitObj.ownershipSignPhoto=null;
              vm.notifyListeners();
              
            },
          ),
          Selector<VisitFormViewModel<VisitLandModel>, String?>(
            selector: (_, vm) => vm.visitObj.hasOwnershipSign,
            builder: (_, hasOwnershipSign, __) {

              if (vm.visitObj.hasOwnershipSign == 'yes') {
                return AppAttachmentField(
                  title: vm.fields.getField('ownership_sign_photo').label,
                  value: vm.visitObj.ownershipSignPhoto,
                  isRequired: vm.visitObj.isRequired('ownership_sign_photo'),
                  isMemory: true,
                  onChanged: (val) {
                    vm.visitObj.ownershipSignPhoto = val; // ✅ unchanged
                  },
                );
              }

              return const SizedBox.shrink(); // nothing if not "yes"
            },
          ),
          Text("location_information".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),

          AppSelectionField(
            title:   vm.fields.getField('easy_access').label,
            value: vm.visitObj.easyAccess,
            type: SingleSelectionFieldType.radio,
            options:   vm.fields.getComboList('easy_access'),
            isRequired: vm.visitObj.isRequired('easy_access'),
            onChanged: (val) {
              vm.visitObj.easyAccess=val;
              
            },
          ),
          AppSelectionField(
            title:   vm.fields.getField('paved_roads').label,
            value: vm.visitObj.pavedRoads,
            type: SingleSelectionFieldType.radio,
            options:   vm.fields.getComboList('paved_roads'),
            isRequired: vm.visitObj.isRequired('paved_roads'),
            onChanged: (val) {
              vm.visitObj.pavedRoads=val;
              
            },
          ),

          AppInputField(
            title:   vm.fields.getField('land_type_notes').label,
            value: vm.visitObj.landTypeNotes,
            isRequired:  vm.visitObj.isRequired('land_type_notes'),
            onSave: (val) {
              vm.visitObj.landTypeNotes=val;
              
            },
          ),

        ],
      ),
    );
  }
}