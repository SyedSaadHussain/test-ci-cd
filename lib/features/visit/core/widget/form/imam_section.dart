import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/mansoob_section.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class ImamSection<T extends RegularVisitModel> extends StatelessWidget {
  const ImamSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text('imam_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),

          vm.visitObj.imamPresent  == 'notapplicable'?
          AppInputView(title:vm.fields.getField('imam_present').label,
              value: vm.visitObj.imamPresent,options: vm.fields.getComboList('imam_present')
          )
              :Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.imamPresent,
            builder: (_, imamPresent, __) {
              return AppSelectionField(
                title: vm.fields.getField('imam_present').label,
                value: vm.visitObj.imamPresent,
                isShowWarning: vm.visitObj.isEscalationField('imam_present'),
                type: SingleSelectionFieldType.selection,
                options: vm.fields
                    .getComboList('imam_present')
                    .where((item) => item.key != 'notapplicable')
                    .toList(),
                isRequired: vm.visitObj.isRequired('imam_present'),
                onChanged: (val) {
                  vm.visitObj.onChangeImamPresent();
                  vm.notifyListeners(); // update UI for hide/show
                  Future.delayed(Duration(milliseconds: 100), () {
                    vm.visitObj.imamPresent = val;
                    vm.notifyListeners();
                  });
                },
              );
            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.imamPresent,
            builder: (_, imamPresent, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vm.visitObj.imamPresent != null  && vm.visitObj.imamPresent != 'notapplicable')
                    Selector<VisitFormViewModel<T>, List<int>?>(
                      selector: (_, vm) => vm.visitObj.imamIds,
                      builder: (_, imamIds, __) {
                        return AppSelectionField(
                          title: vm.fields.getField('imam_ids').label,
                          value: vm.visitObj.imamIds,
                          type: SingleSelectionFieldType.checkBox,
                          options: vm.visitObj.imamIdsArray,
                          isRequired: vm.visitObj.isRequired('imam_ids'),
                          onChanged: (val, isNew) {
                            vm.visitObj.imamIds =AppUtils.updateSelection<int>(
                              currentList: vm.visitObj.imamIds,
                              value: val.key,
                              isNew: isNew,
                              singleSelection: true,
                            );
                            vm.notifyListeners();
                          },
                        );
                      },
                    ),
                  if (vm.visitObj.imamPresent == 'present')
                    Selector<VisitFormViewModel<T>, String?>(
                      selector: (_, vm) => vm.visitObj.imamCommitment,
                      builder: (_, imamCommitment, __) {
                        return AppSelectionField(
                          title: vm.fields.getField('imam_commitment').label,
                          value: vm.visitObj.imamCommitment,
                          type: SingleSelectionFieldType.selection,
                          isShowWarning: vm.visitObj.isEscalationField('imam_commitment'),
                          options: vm.fields.getComboList('imam_commitment'),
                          isRequired: vm.visitObj.isRequired('imam_commitment'),
                          onChanged: (val) {
                            vm.visitObj.imamCommitment = val;
                            vm.notifyListeners();
                          },
                        );
                      },
                    ),
                  if (vm.visitObj.imamPresent == 'notpresent')
                    AppSelectionField(
                      title: vm.fields.getField('imam_off_work').label,
                      value: vm.visitObj.imamOffWork,
                      type: SingleSelectionFieldType.selection,
                      options: vm.fields.getComboList('imam_off_work'),
                      isRequired: vm.visitObj.isRequired('imam_off_work'),
                      onChanged: (val) {
                        vm.visitObj.imamOffWork = val;
                        vm.notifyListeners();
                      },
                    ),
                ],
              );
            },
          ),



          // Text(vm.visitObj.imamOffWorkDate.toString()),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.imamOffWork,
            builder: (_, imamOffWork, __) {
              if (imamOffWork == 'yes') {
                return AppDateField(
                  title: vm.fields.getField('imam_off_work_date').label,
                  value: vm.visitObj.imamOffWorkDate,
                  maxDate: DateTime.now(),
                  isRequired: vm.visitObj.isRequired('imam_off_work_date'),
                  onChanged: (val) {
                    vm.visitObj.imamOffWorkDate = val;
                  },
                );
              } else {
                return Container(); // your else condition
              }
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.imamPresent,
            builder: (_, imamPresent, __) {
              if (imamPresent == 'permission') {
                return AppSelectionField(
                  title: vm.fields.getField('imam_permission_prayer').label,
                  value: vm.visitObj.imamPermissionPrayer,
                  type: SingleSelectionFieldType.selection,
                  options: vm.fields.getComboList('imam_permission_prayer'),
                  isRequired: vm.visitObj.isRequired('imam_permission_prayer'),
                  onChanged: (val) {
                    vm.visitObj.imamPermissionPrayer = val;
                  },
                );
              } else {
                return Container(); // else condition
              }
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.imamPresent,
            builder: (_, imamPresent, __) {
              if (imamPresent == 'leave') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDateField(
                      title: vm.fields.getField('imam_leave_from_date').label,
                      value: vm.visitObj.imamLeaveFromDate,
                      maxDate: DateTime.now(),
                      isRequired: vm.visitObj.isRequired('imam_leave_from_date'),
                      onChanged: (val) {
                        vm.visitObj.imamLeaveFromDate = val;
                        vm.visitObj.imamLeaveToDate = null;
                        vm.notifyListeners(); // trigger rebuild of dependent leave_to field
                      },
                    ),
                    Selector<VisitFormViewModel<RegularVisitModel>, String?>(
                      selector: (_, vm) => vm.visitObj.imamLeaveFromDate,
                      builder: (_, __, ___) {
                        return AppDateField(
                          title: vm.fields.getField('imam_leave_to_date').label,
                          value: vm.visitObj.imamLeaveToDate, // ✅ keep your code as-is
                          minDate: JsonUtils.toDateTime(vm.visitObj.imamLeaveFromDate),
                          isRequired: vm.visitObj.isRequired('imam_leave_to_date'),
                          onChanged: (val) {
                            vm.visitObj.imamLeaveToDate = val; // ✅ unchanged
                          },
                        );
                      },
                    ),
                  ],
                );
              } else {
                return Container(); // else condition
              }
            },
          ),

          // if (vm.visitObj.imamPresent != 'notapplicable')
            AppInputField(
              title: vm.fields.getField('imam_notes').label,
              value: vm.visitObj.imamNotes,
              isRequired: vm.visitObj.isRequired('imam_notes'),
              onChanged: (val) {
                vm.visitObj.imamNotes = val;
                
              },
            ),

           MansoobSection(visit: vm.visitObj, fields: vm.fields)
        ],
      ),
    );
  }
}