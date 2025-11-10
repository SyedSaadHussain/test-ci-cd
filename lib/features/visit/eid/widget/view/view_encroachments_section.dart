import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewEncroachmentsSection extends StatefulWidget {
  final VisitEidModel visit;
  final FieldListData fields;

  const ViewEncroachmentsSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewEncroachmentsSection> createState() => _ViewEncroachmentsSectionState();
}

 class _ViewEncroachmentsSectionState<T extends VisitModel> extends State<ViewEncroachmentsSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppInputView(
            title: widget.fields.getField('encroachment_on_prayer_area').label,
            value: widget.visit.encroachmentOnPrayerArea,
            options: widget.fields.getComboList('encroachment_on_prayer_area'),

          ),
          if(widget.visit.encroachmentOnPrayerArea=='yes')
            Column(
              children: [
                AppInputView(
                  title: widget.fields.getField('type_of_violation').label,
                  value: widget.visit.typeOfViolation,
                  options: widget.fields.getComboList('type_of_violation'),

                ),
                AppInputView(
                    title: widget.fields.getField('violation_comment').label,
                    value: widget.visit.violationComment
                ),
              ],
            ),
            // AppInputView(
            //   title: widget.fields.getField('encroachment_comment').label,
            //   value: widget.visit.encroachmentComment,
            //
            // ),


          AppInputView(
            title: widget.fields.getField('is_electricity_meter').label,
            value: widget.visit.isElectricityMeter,
            options: widget.fields.getComboList('is_electricity_meter'),
          ),
          if(widget.visit.isElectricityMeter=='applicable')
            Column(
              children: [
                AppInputView(
                  title: widget.fields.getField('violation_on_electricity').label,
                  value: widget.visit.violationOnElectricity,
                  options: widget.fields.getComboList('violation_on_electricity'),

                ),
                if(widget.visit.violationOnElectricity=='yes')
                AppInputView(
                  title: widget.fields.getField('choose_electricity_meter').label,
                  value: widget.visit.chooseElectricityMeter,
                ),
              ],
            ),
            AppInputView(
              title: widget.fields.getField('electricity_meter_comment').label,
              value: widget.visit.electricityMeterComment
            ),






        ],
      ),
    );
  }
}