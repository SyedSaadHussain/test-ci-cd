import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_mansoob_section.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewImamSection<T extends RegularVisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewImamSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewImamSection<T>> createState() => _ViewImamSectionState<T>();
}

 class _ViewImamSectionState<T extends RegularVisitModel> extends State<ViewImamSection<T>> {
  @override
  Widget build(BuildContext context) {

    return   SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text('imam_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),

          widget.visit.imamPresent == 'notapplicable'?
          AppInputView(title:widget.fields.getField('imam_present').label,
                  value: widget.visit.imamPresent,options: widget.fields.getComboList('imam_present')
           )
          :AppInputView(
            title: widget.fields.getField('imam_present').label,
            isShowWarning:widget.visit.isEscalationField('imam_present'),
            value: widget.visit.imamPresent,
            options: widget.fields.getComboList('imam_present').where((item) => item.key != 'notapplicable')
                .toList(),

          ),
          if (widget.visit.imamPresent != null  && widget.visit.imamPresent != 'notapplicable')
            AppInputView(
              title: widget.fields.getField('imam_ids').label,
              type:ListType.multiSelect,
              options: widget.visit.imamIdsArray,
            ),

          if (widget.visit.imamPresent == 'present')
            AppInputView(
              title: widget.fields.getField('imam_commitment').label,
              isShowWarning:widget.visit.isEscalationField('imam_commitment'),
              value: widget.visit.imamCommitment,

              options: widget.fields.getComboList('imam_commitment'),

            ),

          if (widget.visit.imamPresent == 'notpresent')
            AppInputView(
              title: widget.fields.getField('imam_off_work').label,
              value: widget.visit.imamOffWork,

              options: widget.fields.getComboList('imam_off_work'),

            ),

          if (widget.visit.imamOffWork == 'yes')
            AppInputView(
              title: widget.fields.getField('imam_off_work_date').label,
              value: widget.visit.imamOffWorkDate,
              type:ListType.date
            ),

          if (widget.visit.imamPresent == 'permission')
            AppInputView(
              title: widget.fields.getField('imam_permission_prayer').label,
              value: widget.visit.imamPermissionPrayer,

              options: widget.fields.getComboList('imam_permission_prayer'),

            ),

          if (widget.visit.imamPresent == 'leave') ...[
            AppInputView(
              title: widget.fields.getField('imam_leave_from_date').label,
              value: widget.visit.imamLeaveFromDate,
              type:ListType.date
            ),
            AppInputView(
              title: widget.fields.getField('imam_leave_to_date').label,
              value: widget.visit.imamLeaveToDate,
               type:ListType.date
            ),
          ],

          // if (widget.visit.imamPresent != null  && widget.visit.imamPresent != 'notapplicable')
            AppInputView(
              title: widget.fields.getField('imam_notes').label,
              value: widget.visit.imamNotes,

            ),

           ViewMansoobSection(visit: widget.visit, fields: widget.fields)


        ],
      ),
    );
  }
}