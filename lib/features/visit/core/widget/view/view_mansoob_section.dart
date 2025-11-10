import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/mansoob_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewMansoobSection<T extends MansoobVisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewMansoobSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewMansoobSection<T>> createState() => _ViewMansoobSectionState<T>();
}

 class _ViewMansoobSectionState<T extends MansoobVisitModel> extends State<ViewMansoobSection<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text('muazzin_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),
            //
            // Text(widget.visit.muezzinPresent.toString()),
          widget.visit.muezzinPresent == 'notapplicable'?
          AppInputView(title:widget.fields.getField('muezzin_present').label,

              value: widget.visit.muezzinPresent,options: widget.fields.getComboList('muezzin_present')
          )
              :AppInputView(
            title: widget.fields.getField('muezzin_present').label,
            isShowWarning:widget.visit.isEscalationField('muezzin_present'),
            value: widget.visit.muezzinPresent,

            options: widget.fields.getComboList('muezzin_present').where((item) => item.key != 'notapplicable')
                .toList(),

          ),

          if (widget.visit.muezzinPresent !=null && widget.visit.muezzinPresent != 'notapplicable')
            AppInputView(
                title: widget.fields.getField('muezzin_ids').label,
                options: widget.visit.muezzinIdsArray,
                type:ListType.multiSelect
            ),

          if (widget.visit.muezzinPresent == 'present')
            AppInputView(
              title: widget.fields.getField('muezzin_commitment').label,
              value: widget.visit.muezzinCommitment,
              isShowWarning:widget.visit.isEscalationField('muezzin_commitment'),

              options: widget.fields.getComboList('muezzin_commitment'),

            ),

          if (widget.visit.muezzinPresent == 'notpresent')
            AppInputView(
              title: widget.fields.getField('muezzin_off_work').label,
              value: widget.visit.muezzinOffWork,

              options: widget.fields.getComboList('muezzin_off_work'),

            ),

          if (widget.visit.muezzinOffWork == 'yes')
            AppInputView(
                title: widget.fields.getField('muezzin_off_work_date').label,
                value: widget.visit.muezzinOffWorkDate,
                type:ListType.date
            ),

          if (widget.visit.muezzinPresent == 'permission')
            AppInputView(
              title: widget.fields.getField('muezzin_permission_prayer').label,
              value: widget.visit.muezzinPermissionPrayer,

              options: widget.fields.getComboList('muezzin_permission_prayer'),

            ),

          if (widget.visit.muezzinPresent == 'leave') ...[
            AppInputView(
                title: widget.fields.getField('muezzin_leave_from_date').label,
                value: widget.visit.muezzinLeaveFromDate,
                type:ListType.date
            ),
            AppInputView(
                title: widget.fields.getField('muezzin_leave_to_date').label,
                value: widget.visit.muezzinLeaveToDate,
                type:ListType.date
            ),
          ],

          // if (widget.visit.muezzinPresent !=null && widget.visit.muezzinPresent != 'notapplicable')
            AppInputView(
              title: widget.fields.getField('muezzin_notes').label,
              value: widget.visit.muezzinNotes,

            ),
          SizedBox(height: 15),
          Text('khadim_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),

          widget.visit.khademPresent == 'notapplicable'?
          AppInputView(title:widget.fields.getField('khadem_present').label,

              value: widget.visit.khademPresent,
              options: widget.fields.getComboList('khadem_present')
          ):
          AppInputView(
            title: widget.fields.getField('khadem_present').label,
            isShowWarning:widget.visit.isEscalationField('khadem_present'),
            value: widget.visit.khademPresent,
            options: widget.fields.getComboList('khadem_present').where((item) => item.key != 'notapplicable')
                .toList(),

          ),
          if(widget.visit.khadimApplicable)
            AppInputView(
              title: widget.fields.getField('khadem_ids').label,
              type:ListType.multiSelect,
              options: widget.visit.khademIdsArray,

            ),
          if(widget.visit.khademPresent !=null && widget.visit.khademPresent == 'notpresent')
            AppInputView(
              title: widget.fields.getField('khadem_off_work').label,
              value: widget.visit.khademOffWork,
              options: widget.fields.getComboList('khadem_off_work'),

            ),
          if(widget.visit.khademOffWork == 'yes')
            AppInputView(
                title: widget.fields.getField('khadem_off_work_date').label,
                value: widget.visit.khademOffWorkDate,
                type:ListType.date
            ),
          if (widget.visit.khademPresent == 'permission')
            AppInputView(
              title: widget.fields.getField('khadem_permission_prayer').label,
              value: widget.visit.khademPermissionPrayer,
              options: widget.fields.getComboList('khadem_permission_prayer'),

            ),
          if (widget.visit.khademPresent == 'leave')
            AppInputView(
                title: widget.fields.getField('khadem_leave_from_date').label,
                value: widget.visit.khademLeaveFromDate,
                type:ListType.date
            ),
          if (widget.visit.khademPresent == 'leave')
            AppInputView(
                title: widget.fields.getField('khadem_leave_to_date').label,
                value: widget.visit.khademLeaveToDate,
                type:ListType.date
            ),
          if (widget.visit.khademPresent !=null  && widget.visit.khademPresent != 'notapplicable')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                AppInputView(
                  title: widget.fields.getField('quality_of_work').label,
                  value: widget.visit.qualityOfWork,
                  options: widget.fields.getComboList('quality_of_work'),

                ),
                AppInputView(
                  title: widget.fields.getField('clean_maintenance_mosque').label,
                  value: widget.visit.cleanMaintenanceMosque,
                  options: widget.fields.getComboList('clean_maintenance_mosque'),

                ),
                AppInputView(
                  title: widget.fields.getField('organized_and_arranged').label,
                  value: widget.visit.organizedAndArranged,
                  options: widget.fields.getComboList('organized_and_arranged'),

                ),
                AppInputView(
                  title: widget.fields.getField('takecare_property').label,
                  value: widget.visit.takecareProperty,
                  options: widget.fields.getComboList('takecare_property'),

                ),
                AppInputView(
                  title: widget.fields.getField('service_task').label,
                  value: widget.visit.serviceTask,
                  options: widget.fields.getComboList('service_task'),
                ),

              ],
            ),
          AppInputView(
            title: widget.fields.getField('khadem_notes').label,
            value: widget.visit.khademNotes,

          ),
          AppInputView(
            title: widget.fields.getField('mansoob_notes').label,
            value: widget.visit.mansoobNotes,

          ),
        ]
      )
    ;
  }
}