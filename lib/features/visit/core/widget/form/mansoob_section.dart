import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/mansoob_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class MansoobSection<T extends MansoobVisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const MansoobSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<MansoobSection<T>> createState() => _MansoobSectionState<T>();
}

 class _MansoobSectionState<T extends MansoobVisitModel> extends State<MansoobSection<T>> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          SizedBox(height: 15),
          Text('muazzin_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),

          vm.visitObj.muezzinPresent == 'notapplicable'?
          AppInputView(title:vm.fields.getField('muezzin_present').label,
              value: vm.visitObj.muezzinPresent,options: vm.fields.getComboList('muezzin_present')
          )
              :Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.muezzinPresent,
            builder: (_, muezzinPresent, __) {
              return AppSelectionField(
                title: vm.fields.getField('muezzin_present').label,
                value: vm.visitObj.muezzinPresent,
                isShowWarning: vm.visitObj.isEscalationField('muezzin_present'),
                type: SingleSelectionFieldType.selection,
                options: vm.fields
                    .getComboList('muezzin_present')
                    .where((item) => item.key != 'notapplicable')
                    .toList(),
                isRequired: vm.visitObj.isRequired('muezzin_present'),
                onChanged: (val) {
                  vm.visitObj.onChangeMuezzinPresent();
                  vm.notifyListeners(); // rebuild reactive UI
                  Future.delayed(Duration(milliseconds: 100), () {
                    vm.visitObj.muezzinPresent = val;
                    vm.notifyListeners();
                  });
                },
              );
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.muezzinPresent,
            builder: (_, muezzinPresent, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vm.visitObj.muezzinPresent !=null && vm.visitObj.muezzinPresent != 'notapplicable')
                    Selector<VisitFormViewModel<T>, List<int>?>(
                      selector: (_, vm) => vm.visitObj.muezzinIds,
                      builder: (_, __, ___) {
                        return AppSelectionField(
                          title: vm.fields.getField('muezzin_ids').label,
                          value: vm.visitObj.muezzinIds,
                          type: SingleSelectionFieldType.checkBox,
                          options: vm.visitObj.muezzinIdsArray,
                          isRequired: vm.visitObj.isRequired('muezzin_ids'),
                          onChanged: (val, isNew) {
                            vm.visitObj.muezzinIds =AppUtils.updateSelection<int>(
                              currentList: vm.visitObj.muezzinIds,
                              value: val.key,
                              isNew: isNew,
                              singleSelection: true,
                            );
                            vm.notifyListeners();
                          },
                        );
                      },
                    ),

                  if (vm.visitObj.muezzinPresent == 'present')
                    Selector<VisitFormViewModel<T>, String?>(
                      selector: (_, vm) => vm.visitObj.muezzinCommitment,
                      builder: (_, muezzinCommitment, __) {
                        return AppSelectionField(
                          title: vm.fields.getField('muezzin_commitment').label,
                          value: vm.visitObj.muezzinCommitment,
                          type: SingleSelectionFieldType.selection,
                          isShowWarning: vm.visitObj.isEscalationField('muezzin_commitment'),
                          options: vm.fields.getComboList('muezzin_commitment'),
                          isRequired: vm.visitObj.isRequired('muezzin_commitment'),
                          onChanged: (val) {
                            vm.visitObj.muezzinCommitment = val;
                            vm.notifyListeners();
                          },
                        );
                      },
                    ),

                  if (vm.visitObj.muezzinPresent == 'notpresent')
                    AppSelectionField(
                      title: vm.fields.getField('muezzin_off_work').label,
                      value: vm.visitObj.muezzinOffWork,
                      type: SingleSelectionFieldType.selection,
                      options: vm.fields.getComboList('muezzin_off_work'),
                      isRequired: vm.visitObj.isRequired('muezzin_off_work'),
                      onChanged: (val) {
                        vm.visitObj.muezzinOffWork = val;
                        vm.notifyListeners();
                      },
                    ),
                ],
              );
            },
          ),



          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.muezzinOffWork,
            builder: (_, muezzinOffWork, __) {
              if (muezzinOffWork == 'yes') {
                return AppDateField(
                  title: vm.fields.getField('muezzin_off_work_date').label,
                  value: vm.visitObj.muezzinOffWorkDate,
                  maxDate: DateTime.now(),
                  isRequired: vm.visitObj.isRequired('muezzin_off_work_date'),
                  onChanged: (val) {
                    vm.visitObj.muezzinOffWorkDate = val;
                  },
                );
              } else {
                return Container();
              }
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.muezzinPresent,
            builder: (_, muezzinPresent, __) {
              if (muezzinPresent == 'permission') {
                return AppSelectionField(
                  title: vm.fields.getField('muezzin_permission_prayer').label,
                  value: vm.visitObj.muezzinPermissionPrayer,
                  type: SingleSelectionFieldType.selection,
                  options: vm.fields.getComboList('muezzin_permission_prayer'),
                  isRequired: vm.visitObj.isRequired('muezzin_permission_prayer'),
                  onChanged: (val) {
                    vm.visitObj.muezzinPermissionPrayer = val;
                  },
                );
              } else {
                return Container();
              }
            },
          ),

          Selector<VisitFormViewModel<T>, (String?,String?)>(
            selector: (_, vm) => (vm.visitObj.muezzinPresent,vm.visitObj.muezzinLeaveFromDate),
            builder: (_, values, __)  {
              if (vm.visitObj.muezzinPresent == 'leave') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppDateField(
                      title: vm.fields.getField('muezzin_leave_from_date').label,
                      value: vm.visitObj.muezzinLeaveFromDate,
                      maxDate: DateTime.now(),
                      isRequired: vm.visitObj.isRequired('muezzin_leave_from_date'),
                      onChanged: (val) {
                        vm.visitObj.muezzinLeaveFromDate = val;
                        vm.visitObj.muezzinLeaveToDate = null;
                         vm.notifyListeners();
                      },
                    ),
                    AppDateField(
                      title: vm.fields.getField('muezzin_leave_to_date').label,
                      value: vm.visitObj.muezzinLeaveToDate, // ✅ unchanged
                      minDate: JsonUtils.toDateTime(vm.visitObj.muezzinLeaveFromDate),
                      isRequired: vm.visitObj.isRequired('muezzin_leave_to_date'),
                      onChanged: (val) {
                        vm.visitObj.muezzinLeaveToDate = val;
                      },
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),

          // if (vm.visitObj.muezzinPresent != 'notapplicable')
            AppInputField(
              title: vm.fields.getField('muezzin_notes').label,
              value: vm.visitObj.muezzinNotes,
              isRequired: vm.visitObj.isRequired('muezzin_notes'),
              onChanged: (val) {
                vm.visitObj.muezzinNotes = val;
                
              },
            ),
          SizedBox(height: 15),
          Text('khadim_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),

          vm.visitObj.khademPresent == 'notapplicable'?
          AppInputView(title:vm.fields.getField('khadem_present').label,
              value: vm.visitObj.khademPresent,
              options: vm.fields.getComboList('khadem_present')
          ):
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.khademPresent,
            builder: (_, khademPresent, __) {
              return AppSelectionField(
                title: vm.fields.getField('khadem_present').label,
                value: vm.visitObj.khademPresent,
                isShowWarning: vm.visitObj.isEscalationField('khadem_present'),
                type: SingleSelectionFieldType.selection,
                options: vm.fields
                    .getComboList('khadem_present')
                    .where((item) => item.key != 'notapplicable')
                    .toList(),
                isRequired: vm.visitObj.isRequired('khadem_present'),
                onChanged: (val) {
                  vm.visitObj.onChangeKhademPresent();

                  Future.delayed(Duration(milliseconds: 100), () {
                    vm.visitObj.khademPresent = val;
                    vm.notifyListeners();
                  });
                },
              );
            },
          ),
          Selector<VisitFormViewModel<T>, int?>(
            selector: (_, vm) => vm.visitObj.khademIds?.length,
            builder: (_, khademIdsLength, __) {
              if (vm.visitObj.khadimApplicable) {
                return Selector<VisitFormViewModel<T>, List<int>?>(
                  selector: (_, vm) => vm.visitObj.khademIds,
                  builder: (_, khademIdsLength, __) {
                    return AppSelectionField(
                      title: vm.fields.getField('khadem_ids').label,
                      value: vm.visitObj.khademIds,
                      type: SingleSelectionFieldType.checkBox,
                      options: vm.visitObj.khademIdsArray,
                      isRequired: vm.visitObj.isRequired('khadem_ids'),
                      onChanged: (val, isNew) {

                        vm.visitObj.khademIds =AppUtils.updateSelection<int>(
                          currentList: vm.visitObj.khademIds,
                          value: val.key,
                          isNew: isNew,
                          singleSelection: true,
                        );
                        vm.notifyListeners();
                      },
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          // if(vm.visitObj.khademPresent !=null && vm.visitObj.khademPresent == 'notpresent')
          //   AppSingleSelectionField(
          //     title: vm.fields.getField('khadem_ids').label,
          //     value: vm.visitObj.khademIds,
          //     isRequired: vm.visitObj.isRequired('khadem_ids'),
          //     options: vm.visitObj.khademIdsArray,
          //     onChanged: (val) {
          //       vm.visitObj.khademIds = val;
          //       
          //     },
          //   ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.khademPresent,
            builder: (_, khademOffWork, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(vm.visitObj.khademPresent !=null && vm.visitObj.khademPresent == 'notpresent')
                    AppSelectionField(
                      title: vm.fields.getField('khadem_off_work').label,
                      value: vm.visitObj.khademOffWork,
                      isRequired: vm.visitObj.isRequired('khadem_off_work'),
                      options: vm.fields.getComboList('khadem_off_work'),
                      onChanged: (val) {
                        vm.visitObj.khademOffWork = val;
                        vm.notifyListeners();
                      },
                    ),

                  if (vm.visitObj.khademPresent == 'permission')
                    AppSelectionField(
                      title: vm.fields.getField('khadem_permission_prayer').label,
                      value: vm.visitObj.khademPermissionPrayer,
                      isRequired: vm.visitObj.isRequired('khadem_permission_prayer'),
                      options: vm.fields.getComboList('khadem_permission_prayer'),
                      onChanged: (val) {
                        vm.visitObj.khademPermissionPrayer = val;

                      },
                    ),
                  if (vm.visitObj.khademPresent == 'leave')
                    AppDateField(
                      title: vm.fields.getField('khadem_leave_from_date').label,
                      value: vm.visitObj.khademLeaveFromDate,
                      maxDate: DateTime.now(),
                      isRequired: vm.visitObj.isRequired('khadem_leave_from_date'),
                      onChanged: (val) {
                        vm.visitObj.khademLeaveFromDate = val;
                        vm.visitObj.khademLeaveToDate = null;
                        vm.notifyListeners();

                      },
                    ),
                  if (vm.visitObj.khademPresent == 'leave')
                    Selector<VisitFormViewModel<T>, String?>(
                      selector: (_, vm) => vm.visitObj.khademLeaveFromDate,
                      builder: (_, __, ___) {
                        return AppDateField(
                          title: vm.fields.getField('khadem_leave_to_date').label,
                          value: vm.visitObj.khademLeaveToDate, // ✅ unchanged
                          minDate: JsonUtils.toDateTime(vm.visitObj.khademLeaveFromDate),
                          isRequired: vm.visitObj.isRequired('khadem_leave_to_date'),
                          onChanged: (val) {
                            vm.visitObj.khademLeaveToDate = val; // ✅ unchanged

                          },
                        );
                      },
                    ),
                  if (vm.visitObj.khademPresent !=null  && vm.visitObj.khademPresent != 'notapplicable')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        AppSelectionField(
                          title: vm.fields.getField('quality_of_work').label,
                          value: vm.visitObj.qualityOfWork,
                          isRequired: vm.visitObj.isRequired('quality_of_work'),
                          options: vm.fields.getComboList('quality_of_work'),
                          onChanged: (val) {
                            vm.visitObj.qualityOfWork = val;

                          },
                        ),
                        AppSelectionField(
                          title: vm.fields.getField('clean_maintenance_mosque').label,
                          value: vm.visitObj.cleanMaintenanceMosque,
                          isRequired: vm.visitObj.isRequired('clean_maintenance_mosque'),
                          options: vm.fields.getComboList('clean_maintenance_mosque'),
                          onChanged: (val) {
                            vm.visitObj.cleanMaintenanceMosque = val;

                          },
                        ),
                        AppSelectionField(
                          title: vm.fields.getField('organized_and_arranged').label,
                          value: vm.visitObj.organizedAndArranged,
                          isRequired: vm.visitObj.isRequired('organized_and_arranged'),
                          options: vm.fields.getComboList('organized_and_arranged'),
                          onChanged: (val) {
                            vm.visitObj.organizedAndArranged = val;

                          },
                        ),
                        AppSelectionField(
                          title: vm.fields.getField('takecare_property').label,
                          value: vm.visitObj.takecareProperty,
                          isRequired: vm.visitObj.isRequired('takecare_property'),
                          options: vm.fields.getComboList('takecare_property'),
                          onChanged: (val) {
                            vm.visitObj.takecareProperty = val;

                          },
                        ),
                        AppSelectionField(
                          title: vm.fields.getField('service_task').label,
                          value: vm.visitObj.serviceTask,
                          isRequired: vm.visitObj.isRequired('service_task'),
                          options: vm.fields.getComboList('service_task'),
                          onChanged: (val) {
                            vm.visitObj.serviceTask = val;

                          },
                        ),


                      ],
                    ),
                ],
              );
            },
          ),


          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.khademOffWork,
            builder: (_, khademOffWork, __) {
              if (vm.visitObj.khademOffWork == 'yes') {
                return AppDateField(
                  title: vm.fields.getField('khadem_off_work_date').label,
                  value: vm.visitObj.khademOffWorkDate,
                  maxDate: DateTime.now(),
                  isRequired: vm.visitObj.isRequired('khadem_off_work_date'),
                  onChanged: (val) {
                    vm.visitObj.khademOffWorkDate = val;
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          // if(vm.visitObj.khademPresent != 'notapplicable')
            AppInputField(
              title: vm.fields.getField('khadem_notes').label,
              value: vm.visitObj.khademNotes,
              isRequired: vm.visitObj.isRequired('khadem_notes'),
              onChanged: (val) {
                vm.visitObj.khademNotes = val;
                
              },
            ),

          AppInputField(
            title: vm.fields.getField('mansoob_notes').label,
            value: vm.visitObj.mansoobNotes,
            isRequired: vm.visitObj.isRequired('mansoob_notes'),
            onChanged: (val) {
              vm.visitObj.mansoobNotes = val;
              
            },
          ),
        ],
      ),
    );
  }
}