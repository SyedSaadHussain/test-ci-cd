import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/dawah_book.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/services/yakeen_service.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_sub_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_generic_bottom_sheet.dart';
import 'package:mosque_management_system/shared/widgets/modal_sheet/show_item_bottom_sheet.dart';
import 'package:provider/provider.dart';

 class DawahSection<T extends VisitModel> extends StatelessWidget {
   DawahSection({super.key});


  final GlobalKey<FormState> formPreacherKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
     final vm = context.read<VisitFormViewModel<T>>() as VisitFormSubViewModel<T>;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.hasReligiousActivity,
            builder: (_, hasReligiousActivity, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSelectionField(
                    title: vm.fields.getField('has_religious_activity').label,
                    value: vm.visitObj.hasReligiousActivity,
                    type: SingleSelectionFieldType.selection,
                    isShowWarning: vm.visitObj.isEscalationField('has_religious_activity'),
                    options: vm.fields.getComboList('has_religious_activity'),
                    isRequired: vm.visitObj.isRequired('has_religious_activity'),
                    onChanged: (val) {

                        vm.visitObj.hasReligiousActivity = val;
                        vm.visitObj.activityType = null;
                        vm.visitObj.onChangeHasReligiousActivity();
                        vm.notifyListeners();

                    },
                  ),
                  if (hasReligiousActivity == 'yes')
                    Selector<VisitFormViewModel<T>, String?>(
                      selector: (_, vm) => vm.visitObj.activityType,
                      builder: (_, activityType, __) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSelectionField(
                              title: vm.fields.getField('activity_type').label,
                              value: vm.visitObj.activityType,
                              type: SingleSelectionFieldType.selection,
                              options: vm.fields.getComboList('activity_type'),
                              isRequired: vm.visitObj.isRequired('activity_type'),
                              onChanged: (val) {
                                vm.visitObj.activityType = val;
                                vm.visitObj.onChangeHasReligiousActivity();
                                vm.notifyListeners();
},
                            ),
                            // Text(vm.visitObj.bookNameId.toString()??""),
                            if (activityType == 'external_preacher')
                              Selector<VisitFormViewModel<T>, String?>(
                                selector: (_, vm) => vm.visitObj.hasTayseerPermission,
                                builder: (_, hasTayseerPermission, __) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppSelectionField(
                                        title: vm.fields.getField('has_tayseer_permission').label,
                                        value: vm.visitObj.hasTayseerPermission,
                                        type: SingleSelectionFieldType.selection,
                                        options: vm.fields.getComboList('has_tayseer_permission'),
                                        isRequired: vm.visitObj.isRequired('has_tayseer_permission'),
                                        onChanged: (val) {
                                          vm.visitObj.hasTayseerPermission = val;
                                          vm.visitObj.onChangeHasTayseerPermission();
                                          vm.notifyListeners();
                                        },
                                      ),
                                      if (hasTayseerPermission == 'yes')
                                        AppInputField(
                                          title: vm.fields.getField('tayseer_permission_number').label,
                                          value: vm.visitObj.tayseerPermissionNumber,
                                          isRequired: vm.visitObj.isRequired('tayseer_permission_number'),
                                          onChanged: (val) {
                                            vm.visitObj.tayseerPermissionNumber = val;
                                          },
                                        ),
                                      AppInputField(
                                        title: vm.fields.getField('activity_title').label,
                                        value: vm.visitObj.activityTitle,
                                        isRequired: vm.visitObj.isRequired('activity_title'),
                                        onChanged: (val) {
                                          vm.visitObj.activityTitle = val;
                                        },
                                      ),
                                      AppInputField(
                                        title: vm.fields.getField('activity_details').label,
                                        value: vm.visitObj.activityDetails,
                                        type: InputFieldType.textArea,
                                        isRequired: vm.visitObj.isRequired('activity_details'),
                                        onChanged: (val) {
                                          vm.visitObj.activityDetails = val;
                                        },
                                      ),
                                      if (hasTayseerPermission == 'no')
                                        Selector<VisitFormViewModel<T>, String?>(
                                            selector: (_, vm) => vm.visitObj.yaqeenStatus,
                                            builder: (_, yaqeenStatus, __) {
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Form(
                                                  key: formPreacherKey,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      AppInputField(
                                                        title: vm.fields.getField('preacher_identification_id').label,
                                                        value: vm.visitObj.preacherIdentificationId,
                                                        isDisable: vm.visitObj.yaqeenStatus != null,
                                                        validationRegex: RegExp(r'^[1-3]\d{9}$'),
                                                        validationError: VisitMessages.iqamaValidationError,
                                                        isRequired: vm.visitObj.isRequired('preacher_identification_id'),
                                                        onChanged: (val) {
                                                          vm.visitObj.preacherIdentificationId = val;
                                                        },
                                                      ),
                                                      AppDateField(
                                                        title: vm.fields.getField('dob_preacher').label,
                                                        isDisable: vm.visitObj.yaqeenStatus != null,
                                                        value: vm.visitObj.dobPreacher,
                                                        maxDate: DateTime.now(),
                                                        isRequired: vm.visitObj.isRequired('dob_preacher'),
                                                        onChangedDetail: (val, DateConversion? dateConversion) {
                                                          vm.visitObj.dobPreacher = val;
                                                          vm.visitObj.dobPreacherHijri = dateConversion != null
                                                              ? "${dateConversion.yearHijri ?? ""}-${dateConversion.monthHijri ?? ""}"
                                                              : null;
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              if (vm.visitObj.yaqeenStatus != null)
                                               AppInputField(
                                                  title: vm.fields.getField('yaqeen_status').label,
                                                  value: yaqeenStatus,
                                                  isDisable: true,
                                                  isRequired: vm.visitObj.isRequired('yaqeen_status'),
                                                  onChanged: (val) {
                                                    vm.visitObj.yaqeenStatus = val;
                                                    vm.notifyListeners();
                                                  },
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: FormField<String>(
                                                        validator: (value) {
                                                          if (vm.visitObj.yaqeenStatus == null) {
                                                            return VisitMessages.yakeenRequiredError;
                                                          }
                                                          return null;
                                                        },
                                                        initialValue: vm.visitObj.yaqeenStatus,
                                                        builder: (field) {
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
                                                      ),
                                                    ),
                                                    Container(
                                                      child: AppNewTagButton(title: VisitMessages.verifyYakeen,

                                                          icon:AppUtils.isNotNullOrEmpty(vm.visitObj.yaqeenStatus)?Icon(Icons.check_circle, size: 16, color: Colors.green):Container(),
                                                          onChange:() async{
                                                            if(formPreacherKey.currentState!.validate()){
                                                              vm.preacherYakeenVerification();
                                                            }

                                                          } ),
                                                    ),
                                                  ],
                                                ),
                                                AppInputField(
                                                  title: vm.fields.getField('phone_preacher').label,
                                                  value: vm.visitObj.phonePreacher,
                                                  validationRegex: RegExp(r'^9665\d{8}$'),
                                                  validationError:
                                                  VisitMessages.phoneValidationError,
                                                  isRequired: vm.visitObj.isRequired('phone_preacher'),
                                                  onChanged: (val) {
                                                    vm.visitObj.phonePreacher = val;
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        ),
                                    ],
                                  );
                                },
                              ),
                            if( activityType == 'imam_reading')
                                Selector<VisitFormViewModel<T>, String?>(
                                selector: (_, vm) => vm.visitObj.readAllowedBook,
                                builder: (context, readAllowedBook, _) {
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                    AppSelectionField(
                                      title: vm.fields.getField('read_allowed_books').label,
                                      value:  vm.visitObj.readAllowedBook,
                                      type: SingleSelectionFieldType.selection,
                                      options: vm.fields.getComboList('read_allowed_books'),
                                      isRequired: vm.visitObj.isRequired('read_allowed_books'),
                                      onChanged: (val) {
                                        vm.visitObj.onChangeReadAllowedBook(val);
                                        vm.notifyListeners();
                                      },
                                    ),
                                     if (readAllowedBook == 'yes')
                                       Selector<VisitFormViewModel<T>, String?>(
                                           selector: (_, vmSelector) => vmSelector.visitObj.bookName, // use the selector parameter
                                           builder: (context, readAllowedBook, _) {
                                              return AppInputField(
                                             title: vm.fields.getField('book_name_id').label,
                                             value: vm.visitObj.bookName,
                                             isRequired: vm.visitObj.isRequired('book_name_id'),
                                             onTab: () {
                                               showGenericBottomSheet<DawahBook>(
                                                   context: context, title: vm.fields.getField('book_name_id').label,
                                                   onChange: (DawahBook book){
                                                     vm.visitObj.bookName = book.name;
                                                     vm.visitObj.bookNameId = book.id;
                                                     vm.notifyListeners();
                                                   },
                                                   itemBuilder: (item) => Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     children: [
                                                       Text(item.name ?? "",style: AppTextStyles.cardTitle,),
                                                       Text(item.auther ?? "",style: AppTextStyles.cardSubTitle,),
                                                     ],
                                                   ),
                                                   // --- How to filter search ---
                                                   searchFilter: (item, query) {
                                                     return (item.name ?? '')
                                                         .toLowerCase()
                                                         .contains(query.toLowerCase());
                                                   },
                                                   onLoadItems:() => vm.loadBooks(),
                                                   // items: vm.books??[]
                                               );
                                             },
                                           );
                                         }
                                       ),
                                      if (readAllowedBook == 'no')
                                        AppInputField(
                                          title: vm.fields.getField('other_book_name').label,
                                          value: vm.visitObj.otherBookName,
                                          isRequired: vm.visitObj.isRequired('other_book_name'),
                                          onChanged: (val) {
                                            vm.visitObj.otherBookName = val;
                                          },
                                        )

                                  ],
                                                                );
                                  }
                                ),
                          ],
                        );
                      },
                    ),

                  //  Imam reading books

                ],
              );
            },
          ),
          AppInputField(
            title: vm.fields.getField('dawah_activities_notes').label,
            value: vm.visitObj.dawahActivitiesNotes,
            isRequired: vm.visitObj.isRequired('dawah_activities_notes'),
            onChanged: (val) {
              vm.visitObj.dawahActivitiesNotes = val;
            },
          ),
        ],
      ),
    );
  }
}