import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/action_taken_detail.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_timeline.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_upload_attachment_view.dart';

 class ViewEidBasicInfoSection extends StatefulWidget {
  final VisitEidModel visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewEidBasicInfoSection({
    Key? key,
    required this.visit,
    required this.fields,
    this.headersMap
  }) : super(key: key);

  @override
  State<ViewEidBasicInfoSection> createState() => _ViewEidBasicInfoSectionState();
}

 class _ViewEidBasicInfoSectionState extends State<ViewEidBasicInfoSection> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text(widget.visit.name??"",style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(title: widget.fields.getField('mosque_id').label,value: widget.visit.mosque??""),
          AppInputView(title: widget.fields.getField('employee_id').label,value: widget.visit.employee),
          AppInputView(title: widget.fields.getField('priority_value').label,
            value: widget.visit.priorityValue,
            options: widget.fields.getComboList('priority_value')  ),
          AppInputView(title: widget.fields.getField('start_datetime').label,value: widget.visit.startDatetimeLocal),
          AppInputView(title: widget.fields.getField('submit_datetime').label,value: widget.visit.submitDatetimeLocal),
          ActionTakenDetail(visit: widget.visit,fields: widget.fields,),
          VisitTimeline(items: widget.visit.visitWorkFlow,)
        ],
      ),
    );
  }
}