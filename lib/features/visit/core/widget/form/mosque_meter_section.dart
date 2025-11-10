import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/violation_guidelines_section.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';
 class MosqueMeterSection<T extends VisitModel> extends StatelessWidget {
  const MosqueMeterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            'mosque_electricity_meters'.tr(),
            style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),
          ),
          AppInputView(title:vm.fields.getField('has_electric_meter').label,
              value: vm.visitObj.hasElectricMeter,
              options: vm.fields.getComboList('has_electric_meter')
          ),
          if (vm.visitObj.hasElectricMeter == 'applicable')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelectionField(
                  title: vm.fields.getField('electric_meter_ids').label,
                  isDisable: true,
                  type: SingleSelectionFieldType.radio,
                  options: vm.visitObj.electricMeterIdsArray,
                ),
                AppSelectionField(
                  title: vm.fields.getField('electric_meter_data_updated').label,
                  value: vm.visitObj.electricMeterDataUpdated,
                  type: SingleSelectionFieldType.radio,
                  options: vm.fields.getComboList('electric_meter_data_updated'),
                  isRequired: vm.visitObj.isRequired('electric_meter_data_updated'),
                  onChanged: (val) {
                    vm.visitObj.electricMeterDataUpdated = val;

                  },
                ),

                Selector<VisitFormViewModel<T>, String?>(
                  selector: (_, vm) => vm.visitObj.electricMeterViolation,
                  builder: (_, electricMeterViolation, __) {
                    return AppSelectionField(
                      title: vm.fields.getField('electric_meter_violation').label,
                      value: vm.visitObj.electricMeterViolation,
                      type: SingleSelectionFieldType.radio,
                      isShowWarning: vm.visitObj.isEscalationField('electric_meter_violation'),
                      options: vm.fields.getComboList('electric_meter_violation'),
                      isRequired: vm.visitObj.isRequired('electric_meter_violation'),
                      onChanged: (val) {
                        vm.visitObj.electricMeterViolation = val;
                        vm.visitObj.onChangeElectricMeterViolation();
                        vm.notifyListeners();
                      },
                    );
                  },
                ),
                Selector<VisitFormViewModel<T>, String?>(
                  selector: (_, vm) => vm.visitObj.electricMeterViolation,
                  builder: (_, __, ___) {
                     if (vm.visitObj.electricMeterViolation == 'yes') {
                       return Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [

                           Selector<VisitFormViewModel<T>, dynamic>(
                             selector: (_, vm) => vm.visitObj.violationElectricMeterIds?.length,
                             builder: (_, violationElectricMeterIds, __) {
                              return AppSelectionField(
                                 title: vm.fields.getField('violation_electric_meter_ids').label,
                                 value: vm.visitObj.violationElectricMeterIds,
                                 type: SingleSelectionFieldType.checkBox,
                                 options: vm.visitObj.electricMeterIdsArray,
                                 isRequired: vm.visitObj.isRequired('violation_electric_meter_ids'),
                                 onChanged: (val, isNew) {
                                if (isNew) {
                                     if (vm.visitObj.violationElectricMeterIds == null) {
                                       vm.visitObj.violationElectricMeterIds = [];
                                     }
                                     if (!vm.visitObj.violationElectricMeterIds!.contains(val.key)) {
                                       vm.visitObj.violationElectricMeterIds!.add(val.key);
                                     }
                                   } else {
                                     vm.visitObj.violationElectricMeterIds!.removeWhere((key) => key == val.key);
                                   }
vm.notifyListeners();
                                 },
                               );
                             },
                           ),
                           violationGuidelinesSection(),
                           AppAttachmentField(
                             title: vm.fields
                                 .getField(
                                 'violation_electric_meter_attachment')
                                 .label,
                             value: vm.visitObj
                                 .violationElectricMeterAttachment,
                             isRequired: vm.visitObj.isRequired(
                                 'violation_electric_meter_attachment'),
                             isMemory: true,
                             onChanged: (val) {
                               vm.visitObj.violationElectricMeterAttachment =
                                   val;
                               
                             },
                           ),
                           AppSelectionField(
                             title: vm.fields
                                 .getField('case_infringement_elec_meter')
                                 .label,
                             value: vm.visitObj.caseInfringementElecMeter,
                             type: SingleSelectionFieldType.radio,
                             options: vm.fields.getComboList(
                                 'case_infringement_elec_meter'),
                             isRequired: vm.visitObj.isRequired(
                                 'case_infringement_elec_meter'),
                             onChanged: (val) {
                               vm.visitObj.caseInfringementElecMeter = val;
                               
                             },
                           ),
                         ],
                       );
                     }
                    else return Container();
                  },
                ),

              ],
            ),


          SizedBox(height: 15),
          Text(
            'mosque_water_meters'.tr(),
            style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),
          ),

          AppInputView(title:vm.fields.getField('has_water_meter').label,
              value: vm.visitObj.hasWaterMeter,
              options: vm.fields.getComboList('has_water_meter')
          ),
          if (vm.visitObj.hasWaterMeter == 'applicable')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelectionField(
                    title: vm.fields.getField('water_meter_ids').label,
                    // value: vm.visitObj.waterMeterIds,
                    isDisable: true,
                    type: SingleSelectionFieldType.radio,
                    options: vm.visitObj.waterMeterIdsArray
                ),
                AppSelectionField(
                  title: vm.fields.getField('water_meter_data_updated').label,
                  value: vm.visitObj.waterMeterDataUpdated,
                  type: SingleSelectionFieldType.radio,
                  options: vm.fields.getComboList('water_meter_data_updated'),
                  isRequired: vm.visitObj.isRequired('water_meter_data_updated'),
                  onChanged: (val) {
                    vm.visitObj.waterMeterDataUpdated = val;
                    
                  },
                ),
                Selector<VisitFormViewModel<T>, String?>(
                  selector: (_, vm) => vm.visitObj.waterMeterViolation,
                  builder: (_, waterMeterViolation, __) {
                    return AppSelectionField(
                      title: vm.fields.getField('water_meter_violation').label,
                      value: waterMeterViolation,
                      type: SingleSelectionFieldType.radio,
                      isShowWarning: vm.visitObj.isEscalationField('water_meter_violation'),
                      options: vm.fields.getComboList('water_meter_violation'),
                      isRequired: vm.visitObj.isRequired('water_meter_violation'),
                      onChanged: (val) {
                        vm.visitObj.waterMeterViolation = val;
                        vm.visitObj.onChangeWaterMeterViolation();
                        vm.notifyListeners();
                      },
                    );
                  },
                ),
                Selector<VisitFormViewModel<T>, String?>(
                  selector: (_, vm) => vm.visitObj.waterMeterViolation,
                  builder: (_, showViolationFields, __) {
                    if (vm.visitObj.waterMeterViolation == 'yes') {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Selector<VisitFormViewModel<T>, dynamic>(
                            selector: (_, vm) => vm.visitObj.violationWaterMeterIds?.length,
                            builder: (_, violationWaterMeterIds, __) {
                              return AppSelectionField(
                                title: vm.fields.getField('violation_water_meter_ids').label,
                                value: vm.visitObj.violationWaterMeterIds,
                                type: SingleSelectionFieldType.checkBox,
                                options: vm.visitObj.waterMeterIdsArray,
                                isRequired: vm.visitObj.isRequired('violation_water_meter_ids'),
                                onChanged: (val, isNew) {
                                  vm.visitObj.onChangeViolationWaterMeterIds(val, isNew);
                                  vm.notifyListeners();
                                },
                              );
                            },
                          ),
                          violationGuidelinesSection(),
                          AppAttachmentField(
                            title: vm.fields.getField('violation_water_meter_attachment').label,
                            value: vm.visitObj.violationWaterMeterAttachment,
                            isRequired: vm.visitObj.isRequired('violation_water_meter_attachment'),
                            onChanged: (val) {
                              vm.visitObj.violationWaterMeterAttachment = val;
                            },
                          ),
                          AppSelectionField(
                            title: vm.fields.getField('case_infringement_water_meter').label,
                            value: vm.visitObj.caseInfringementWaterMeter,
                            type: SingleSelectionFieldType.radio,
                            options: vm.fields.getComboList('case_infringement_water_meter'),
                            isRequired: vm.visitObj.isRequired('case_infringement_water_meter'),
                            onChanged: (val) {
                              vm.visitObj.caseInfringementWaterMeter = val;

                            },
                          ),
                        ],
                      );
                    } else return Container();

                  },
                ),
              ],
            ),

          AppInputField(
            title: vm.fields.getField('meter_notes').label,
            value: vm.visitObj.meterNotes,
            isRequired: vm.visitObj.isRequired('meter_notes'),
            onChanged: (val) {
              vm.visitObj.meterNotes = val;
              
            },
          ),
        ],
      ),
    );
  }
}