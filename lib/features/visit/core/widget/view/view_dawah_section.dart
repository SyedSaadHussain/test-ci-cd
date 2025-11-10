

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/services/network_service.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewDawahSection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewDawahSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewDawahSection<T>> createState() => _ViewDawahSectionState<T>();
}

 class _ViewDawahSectionState<T extends VisitModel> extends State<ViewDawahSection<T>> {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('has_religious_activity').label,
            value:  widget.visit.hasReligiousActivity,
            isShowWarning: widget.visit.isEscalationField('has_religious_activity'),
            options: widget.fields.getComboList('has_religious_activity'),

          ),

           widget.visit.hasReligiousActivity == 'yes'
              ? AppInputView(
            title: widget.fields.getField('activity_type').label,
            value:  widget.visit.activityType,
            options: widget.fields.getComboList('activity_type'),

          )
              : Container(),

           widget.visit.activityType == 'external_preacher'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputView(
                title: widget.fields.getField('has_tayseer_permission').label,
                value:  widget.visit.hasTayseerPermission,
                options: widget.fields.getComboList('has_tayseer_permission'),

              ),
               widget.visit.hasTayseerPermission == 'yes'
                  ? AppInputView(
                title: widget.fields.getField('tayseer_permission_number').label,
                value:  widget.visit.tayseerPermissionNumber,

              )
                  : Container(),
              AppInputView(
                title: widget.fields.getField('activity_title').label,
                value:  widget.visit.activityTitle,

              ),
              AppInputView(
                title: widget.fields.getField('activity_details').label,
                value:  widget.visit.activityDetails,

              ),
              AppInputView(
                title: widget.fields.getField('preacher_identification_id').label,
                value:  widget.visit.preacherIdentificationId,

              ),
              AppInputView(
                  title: widget.fields.getField('dob_preacher').label,
                  value:  widget.visit.dobPreacher,
                  type:ListType.date
              ),
              AppInputView(
                title: widget.fields.getField('yaqeen_status').label,
                value:  widget.visit.yaqeenStatus,
              ),

              //  AppInputView(
              //   title: widget.fields.getField('gender_preacher').label,
              //   value:  widget.visit.genderPreacher,
              //
              // ),
              AppInputView(
                title: widget.fields.getField('phone_preacher').label,
                value:  widget.visit.phonePreacher,
              ),

              // AppInputView(
              //   title: widget.fields.getField('yaqeen_status').label,
              //   value:  widget.visit.yaqeenStatus,
              //
              // ),
            ],
          )
              : Container(),
          widget.visit.activityType == 'imam_reading'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputView(
                title: widget.fields.getField('read_allowed_books').label,
                value:  widget.visit.readAllowedBook,
                options: widget.fields.getComboList('read_allowed_books'),

              ),
              widget.visit.readAllowedBook == 'yes'
                  ? AppInputView(
                title: widget.fields.getField('book_name_id').label,
                value:  widget.visit.bookName,
              )
                  :  AppInputView(
                title: widget.fields.getField('other_book_name').label,
                value:  widget.visit.otherBookName,

              ),
            ],
          )
              : Container(),
          AppInputView(
            title: widget.fields.getField('dawah_activities_notes').label,
            value:  widget.visit.dawahActivitiesNotes,
          ),
        ],
      ),
    );
  }
}