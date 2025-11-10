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

 class UtilitiesSection extends StatelessWidget {
  const UtilitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitLandModel>>() as VisitLandFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text("electricity_meter".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppSelectionField(
            title: vm.fields.getField('has_electricity_meter').label,
            value: vm.visitObj.hasElectricityMeter,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('has_electricity_meter'),
            isRequired: vm.visitObj.isRequired('has_electricity_meter'),
            onChanged: (val) {
              vm.updateHasElectricityMeter(val);
              
            },
          ),
          Selector<VisitFormViewModel<VisitLandModel>, String?>(
            selector: (_, vm) => vm.visitObj.hasElectricityMeter,
            builder: (context, hasElectricityMeter, __) {

              if (vm.visitObj.hasElectricityMeter == 'yes') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInputField(
                      title: vm.fields.getField('electricity_meter_number').label,
                      value: vm.visitObj.electricityMeterNumber,
                      isRequired: vm.visitObj.isRequired('electricity_meter_number'),
                      onChanged: (val) {
                        vm.visitObj.electricityMeterNumber=val;

                      },
                    ),
                    AppSelectionField(
                      title: vm.fields.getField('has_meter_encroachment').label,
                      value: vm.visitObj.hasMeterEncroachment,
                      type: SingleSelectionFieldType.selection,
                      options: vm.fields.getComboList('has_meter_encroachment'),
                      isRequired: vm.visitObj.isRequired('has_meter_encroachment'),
                      onChanged: (val) {
                        vm.updateMeterEncroachment(val);
                      },
                    ),

                      Selector<VisitFormViewModel<VisitLandModel>, String?>(
                          selector: (_, vm) => vm.visitObj.hasMeterEncroachment,
                          builder: (context, hasMeterEncroachment, __) {
                          if(vm.visitObj.hasMeterEncroachment=='yes')
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                violationGuidelinesSection(),
                                AppAttachmentField(
                                  title: vm.fields.getField('meter_encroachment_photo').label,
                                  value: vm.visitObj.meterEncroachmentPhoto,
                                  isRequired: vm.visitObj.isRequired('meter_encroachment_photo'),
                                  isMemory:true,
                                  onChanged: (val) {
                                    vm.visitObj.meterEncroachmentPhoto = val;

                                  },
                                ),
                              ],
                            );
                           return const SizedBox.shrink();
                        }
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),

          AppInputField(
            title: vm.fields.getField('electricity_meters_notes').label,
            value: vm.visitObj.electricityMetersNotes,
            isRequired:  vm.visitObj.isRequired('electricity_meters_notes'),
            onSave: (val) {
              vm.visitObj.electricityMetersNotes=val;
              
            },
          ),


        ],
      ),
    );
  }
}