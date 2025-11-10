import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/data/services/yakeen_service.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/mansoob_section.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class KhateebSection<T extends VisitJummaModel> extends StatelessWidget {
   KhateebSection({super.key});
  final GlobalKey<FormState> formPreacherKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>() as VisitJummaFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
        Text('khateeb_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),
          Selector<VisitFormViewModel<VisitJummaModel>, String?>(
              selector: (_, vm) => vm.visitObj.khatibPresent,
              builder: (_, khatibPresent, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vm.visitObj.khatibPresent  == 'notapplicable'?
                  AppInputView(title:vm.fields.getField('khatib_present').label,
                      value: vm.visitObj.khatibPresent,options: vm.fields.getComboList('khatib_present')
                  )
                      :AppSelectionField(
                    title: vm.fields.getField('khatib_present').label,
                    value: vm.visitObj.khatibPresent,
                    isShowWarning:vm.visitObj.isEscalationField('khatib_present'),
                    type: SingleSelectionFieldType.selection,
                    options: vm.fields.getComboList('khatib_present').where((item) => item.key != 'notapplicable')
                        .toList(),
                    isRequired: vm.visitObj.isRequired('imam_present'),
                    onChanged: (val) {
                      vm.visitObj.onChangekhatibPresent();
                      vm.notifyListeners();
                      Future.delayed(Duration(milliseconds: 100), () {
                        vm.visitObj.khatibPresent = val;
                        vm.notifyListeners();
                      });


                    },
                  ),
                  if (vm.visitObj.khatibPresent == 'present')
                    Selector<VisitFormViewModel<VisitJummaModel>, String?>(
                      selector: (_, vm) => vm.visitObj.khatibPunctuality,
                      builder: (_, khatibPunctuality, __) {
                        return AppSelectionField(
                          title: vm.fields.getField('khatib_punctuality').label,
                          value: vm.visitObj.khatibPunctuality,
                           type: SingleSelectionFieldType.selection,
                          options: vm.fields.getComboList('khatib_punctuality'),
                          isRequired: vm.visitObj.isRequired('khatib_punctuality'),
                          onChanged: (val) {
                            vm.visitObj.khatibPunctuality = val;
                            vm.notifyListeners();
                          },
                        );
                      },
                    ),

                  if (vm.visitObj.khatibApplicable)
                    Selector<VisitFormViewModel<VisitJummaModel>, List<int>?>(
                        selector: (_, vm) => vm.visitObj.khatibIds,
                        builder: (_, khatibPunctuality, __) {
                        return AppSelectionField(
                          title: vm.fields.getField('khatib_ids').label,
                          value: vm.visitObj.khatibIds,
                          type: SingleSelectionFieldType.checkBox,
                          options: vm.visitObj.khatibIdsArray,
                          isRequired: vm.visitObj.isRequired('khatib_ids'),
                          onChanged: (val,isNew) {

                            vm.visitObj.khatibIds =AppUtils.updateSelection<int>(
                              currentList: vm.visitObj.khatibIds,
                              value: val.key,
                              isNew: isNew,
                              singleSelection: true,
                            );
                            vm.notifyListeners();

                          },
                        );
                      }
                    ),

                  if (vm.visitObj.khatibPresent == 'notpresent')
                    AppSelectionField(
                      title: vm.fields.getField('khatib_off_work').label,
                      value: vm.visitObj.khatibOffWork,
                      type: SingleSelectionFieldType.selection,
                      options: vm.fields.getComboList('khatib_off_work'),
                      isRequired: vm.visitObj.isRequired('khatib_off_work'),
                      onChanged: (val) {
                        vm.visitObj.khatibOffWork = val;
                        vm.notifyListeners();
                      },
                    ),
                  //

                  Selector<VisitFormViewModel<VisitJummaModel>, String?>(
                    selector: (_, vm) => vm.visitObj.khatibOffWork,
                    builder: (_, khatibOffWork, __) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (khatibOffWork == 'yes')
                           AppDateField(
                              title: vm.fields.getField('khatib_off_work_date').label,
                              value: vm.visitObj.khatibOffWorkDate,
                              maxDate: DateTime.now(),
                              isRequired: vm.visitObj.isRequired('khatib_off_work_date'),
                              onChanged: (val) {
                              vm.visitObj.khatibOffWorkDate = val;
                              // No need for setState; Selector will rebuild if khatibOffWork changes
                              },
                            ),
                          if (vm.visitObj.khatibOffWork == 'permission')
                            AppSelectionField(
                              title: vm.fields.getField('khatib_permission_prayer').label,
                              value: vm.visitObj.khatibPermissionPrayer,
                              type: SingleSelectionFieldType.selection,
                              options: vm.fields.getComboList('khatib_permission_prayer'),
                              isRequired: vm.visitObj.isRequired('khatib_permission_prayer'),
                              onChanged: (val) {
                                vm.visitObj.khatibPermissionPrayer = val;
                              },
                            ),
                        ],
                      );
                    },
                  ),

                  //
                  if (vm.visitObj.khatibPresent == 'leave') ...[
                    AppDateField(
                      title: vm.fields.getField('khatib_leave_from_date').label,
                      value: vm.visitObj.khatibLeaveFromDate,
                      maxDate: DateTime.now(),
                      isRequired: vm.visitObj.isRequired('khatib_leave_from_date'),
                      onChanged: (val) {
                        vm.visitObj.khatibLeaveFromDate = val;
                        vm.visitObj.khatibLeaveToDate = null;
                        vm.notifyListeners();
                      },
                    ),
                    Selector<VisitFormViewModel<VisitJummaModel>, String?>(
                      selector: (_, vm) => vm.visitObj.khatibLeaveFromDate,
                      builder: (_, __, ___) {
                        return AppDateField(
                          title: vm.fields.getField('khatib_leave_to_date').label,
                          value: vm.visitObj.khatibLeaveToDate, // ✅ keep your code as-is
                          minDate: JsonUtils.toDateTime(vm.visitObj.khatibLeaveFromDate),
                          isRequired: vm.visitObj.isRequired('khatib_leave_to_date'),
                          onChanged: (val) {
                            vm.visitObj.khatibLeaveToDate = val; // ✅ keep your code as-is
                          },
                        );
                      },
                    ),
                  ],

                  if(vm.visitObj.showKhatibDetail)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSelectionField(
                          title: vm.fields.getField('khatib_permission_prayer').label,
                          value: vm.visitObj.khatibPermissionPrayer,
                          type: SingleSelectionFieldType.selection,
                          options: vm.fields.getComboList('khatib_permission_prayer'),
                          isRequired: vm.visitObj.isRequired('khatib_permission_prayer'),
                          onChanged: (val) {
                            vm.visitObj.khatibPermissionPrayer = val;
                            
                          },
                        ),
                        AppSelectionField(
                          title: vm.fields.getField('khatib_relationship').label,
                          value: vm.visitObj.khatibRelationship,
                          type: SingleSelectionFieldType.selection,
                          options: vm.fields.getComboList('khatib_relationship'),
                          isRequired: vm.visitObj.isRequired('khatib_relationship'),
                          onChanged: (val) {
                            vm.visitObj.khatibRelationship = val;
                            
                          },
                        ),
                        Selector<VisitFormViewModel<VisitJummaModel>, String?>(
                            selector: (_, vm) => vm.visitObj.khateebNameYakeen,
                            builder: (_, khateebNameYakeen, __) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key:formPreacherKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppInputField(
                                        title: vm.fields.getField('khatib_identification_id').label,
                                        value: vm.visitObj.khatibIdentificationId,
                                        isDisable:    vm.visitObj.khateebNameYakeen!=null,
                                        validationRegex: RegExp(r'^[1-3]\d{9}$'),
                                        validationError: 'Must start with 1,2 or 3 and be 10 digits long',
                                        isRequired: vm.visitObj.isRequired('khatib_identification_id'),
                                        onChanged: (val) {
                                          vm.visitObj.khatibIdentificationId = val;
                                        },
                                      ),
                                      AppDateField(
                                        title: vm.fields.getField('dob_khatib').label,
                                        isDisable:  vm.visitObj.khateebNameYakeen!=null,
                                        value: vm.visitObj.dobKhatib,
                                        maxDate: DateTime.now(),
                                        isRequired: vm.visitObj.isRequired('dob_khatib'),
                                        onChangedDetail: (val,DateConversion? dateConversion) {
                                          vm.visitObj.dobKhatib = val;
                                          if(dateConversion!=null){
                                            vm.visitObj.dobKhatibHijri=(dateConversion!.yearHijri??"")+"-"+(dateConversion!.monthHijri??"");
                                          }else{
                                            vm.visitObj.dobKhatibHijri=null;
                                          }
                                        },
                                      ),

                                    ],
                                  ),
                                ),
                                AppInputField(
                                  title: vm.fields.getField('khateeb_name_yakeen').label,
                                  value: vm.visitObj.khateebNameYakeen,
                                  isDisable: true,
                                  isRequired: vm.visitObj.isRequired('khateeb_name_yakeen'),
                                  onChanged: (val) {
                                    vm.visitObj.khateebNameYakeen = val;
                                  },
                                ),
                                SizedBox(height:10),
                                Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment :MainAxisAlignment.start,
                                  children: [
                                    Expanded(child:   FormField<String>(
                                      validator: (value) {
                                        if ((vm.visitObj.khateebNameYakeen == null)) {
                                          return VisitMessages.yakeenRequiredError;
                                        }
                                        return null;
                                      },
                                      initialValue: vm.visitObj.khateebNameYakeen, // assuming you pass _visit.yaqeenStatus here
                                      builder: (FormFieldState<String> field) {
                                        return Column(
                                          children: [
                                            if (field.hasError)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Text(
                                                  field.errorText ?? '',
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),),
                                    // Container(
                                    //
                                    //   child: AppNewTagButton(title: 'clear',onChange:() async{
                                    //     vm.visitObj.khateebNameYakeen=null;
                                    //     vm.notifyListeners();
                                    //
                                    //   } ),
                                    // ),

                                    Container(
                                      child: AppNewTagButton(title: VisitMessages.verifyYakeen,

                                          icon:AppUtils.isNotNullOrEmpty(vm.visitObj.khateebNameYakeen)?Icon(Icons.check_circle, size: 16, color: Colors.green):Container(),
                                          onChange:vm.visitObj.khateebNameYakeen ==null?() async{
                                            if(formPreacherKey.currentState!.validate()){
                                              vm.khateebVerification();
                                            }


                                          }:null ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        ),

                      ],
                    ),
                ],
              );
            }
          ),





          // if (vm.visitObj.khatibApplicable)
            AppInputField(
              title: vm.fields.getField('khatib_notes').label,
              value: vm.visitObj.khatibNotes,
              isRequired: vm.visitObj.isRequired('khatib_notes'),
              onChanged: (val) {
                vm.visitObj.khatibNotes = val;

              },
            ),


           MansoobSection(visit: vm.visitObj, fields: vm.fields)
        ],
      ),
    );
  }
}