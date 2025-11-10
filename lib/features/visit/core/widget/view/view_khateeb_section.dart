import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_mansoob_section.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewKhateebSection<T extends VisitJummaModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewKhateebSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewKhateebSection<T>> createState() => _ViewKhateebSectionState<T>();
}

 class _ViewKhateebSectionState<T extends VisitJummaModel> extends State<ViewKhateebSection<T>> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text('khateeb_section'.tr(), style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),
          AppInputView(title:widget.fields.getField('khatib_present').label,
              value: widget.visit.khatibPresent,options: widget.fields.getComboList('khatib_present')
          ),
          if (widget.visit.khatibPresent == 'present')
            AppInputView(title:widget.fields.getField('khatib_punctuality').label,
                value: widget.visit.khatibPunctuality,options: widget.fields.getComboList('khatib_punctuality')),

          if (widget.visit.khatibApplicable)
            AppInputView(title:widget.fields.getField('khatib_ids').label,
                options: widget.visit.khatibIdsArray,type:ListType.multiSelect),

          if (widget.visit.khatibPresent == 'notpresent')
            AppInputView(title:widget.fields.getField('khatib_off_work').label,
                value: widget.visit.khatibOffWork,options: widget.fields.getComboList('khatib_off_work')),

          if (widget.visit.khatibOffWork == 'yes')
            AppInputView(title:widget.fields.getField('khatib_off_work_date').label,
                type: ListType.date,
                value: widget.visit.khatibOffWorkDate),

          if (widget.visit.khatibOffWork == 'permission')
            AppInputView(title:widget.fields.getField('khatib_permission_prayer').label,
                value: widget.visit.khatibPermissionPrayer,options: widget.fields.getComboList('khatib_permission_prayer')),

          if (widget.visit.khatibPresent == 'leave') ...[
            AppInputView(title:widget.fields.getField('khatib_leave_from_date').label,
                type: ListType.date,
                value: widget.visit.khatibLeaveFromDate),
            AppInputView(title:widget.fields.getField('khatib_leave_to_date').label,
                type: ListType.date,
                value: widget.visit.khatibLeaveToDate),
          ],

          if(widget.visit.showKhatibDetail)
            Column(
              children: [
                AppInputView(
                  title: widget.fields.getField('khatib_permission_prayer').label,
                  value: widget.visit.khatibPermissionPrayer,
                  options: widget.fields.getComboList('khatib_permission_prayer')
                ),
                AppInputView(
                    title: widget.fields.getField('khatib_relationship').label,
                    value: widget.visit.khatibRelationship,
                    options: widget.fields.getComboList('khatib_relationship')
                ),
                AppInputView(
                    title: widget.fields.getField('khatib_identification_id').label,
                    value: widget.visit.khatibIdentificationId,
                ),
                AppInputView(
                  title: widget.fields.getField('dob_khatib').label,
                  value: widget.visit.dobKhatib,
                  type: ListType.date
                ),
                AppInputView(
                  title: widget.fields.getField('khateeb_name_yakeen').label,
                  value: widget.visit.khateebNameYakeen,
                ),
              ],
            ),
           // if (widget.visit.khatibApplicable)
             AppInputView(title:widget.fields.getField('khatib_notes').label,
                 value: widget.visit.khatibNotes
             ),
          ViewMansoobSection(visit: widget.visit, fields: widget.fields)
        ],
      ),
    );
  }
}