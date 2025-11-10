

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/action_taken_detail.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_timeline.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_upload_attachment_view.dart';

class ViewBasicInfoSection<T extends VisitModel> extends StatelessWidget {
  final T visit;
  final FieldListData fields;
  final dynamic headersMap;
  final List<Widget>? extraFields;

  const ViewBasicInfoSection({
    Key? key,
    required this.visit,
    required this.fields,
    required this.headersMap,
    this.extraFields,
  }) : super(key: key);


   
   @override
  Widget build(BuildContext context) {
     final List<ComboItem> jummaList = [
       ...fields.getComboList('prayer_name'),
        ComboItem(key: 'jumma', value: VisitMessages.jumma),
     ];
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
           Text(visit.name??"",style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(title: fields.getField('mosque_id').label,value: visit.mosque??""),
          AppInputView(title: fields.getField('employee_id').label,value: visit.employee??""),
          AppInputView(title: fields.getField('priority_value').label,
              value: visit.priorityValue,
              options: fields.getComboList('priority_value')  ),
          AppInputView(title: fields.getField('prayer_name').label,
              value: visit.prayerName,
              options: jummaList  ),
          AppInputView(title: fields.getField('start_datetime').label,value: visit.startDatetimeLocal),
          AppInputView(title: fields.getField('submit_datetime').label,value: visit.submitDatetimeLocal),
          // Add extra fields here
          if (extraFields != null) ...extraFields!,
          ActionTakenDetail(visit: visit,fields: fields,),
          VisitTimeline(items: visit.visitWorkFlow,)

               ],
      ),
    );
  }
}