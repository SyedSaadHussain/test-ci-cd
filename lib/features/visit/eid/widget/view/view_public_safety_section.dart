import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewPublicSafetySection extends StatefulWidget {
  final VisitEidModel visit;
  final FieldListData fields;

  const ViewPublicSafetySection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewPublicSafetySection> createState() => _ViewPublicSafetySectionState();
}

 class _ViewPublicSafetySectionState<T extends VisitModel> extends State<ViewPublicSafetySection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppInputView(
            title: widget.fields.getField('public_safety_hazard').label,
            value: widget.visit.publicSafetyHazard,
            options: widget.fields.getComboList('public_safety_hazard'),
          ),
          if(widget.visit.publicSafetyHazard=='yes')
            AppInputView(
              title: widget.fields.getField('comment_on_safety_hazard').label,
              value: widget.visit.commentOnSafetyHazard
            ),


          AppInputView(
            title: widget.fields.getField('warning_info_panel').label,
            value: widget.visit.warningInfoPanel,
            options: widget.fields.getComboList('warning_info_panel'),
          ),
          if(widget.visit.warningInfoPanel=='yes')
            AppInputView(
              title: widget.fields.getField('warning_panel_comment').label,
              value: widget.visit.warningPanelComment
            ),


          AppInputView(
            title: widget.fields.getField('prayer_hall_free').label,
            value: widget.visit.prayerHallFree,
            options: widget.fields.getComboList('prayer_hall_free'),
          ),
          if(widget.visit.prayerHallFree=='no')
            AppInputView(
              title: widget.fields.getField('prayer_hall_comment').label,
              value: widget.visit.prayerHallComment
            ),
          AppInputView(
            title: widget.fields.getField('pollution_near_hall').label,
            value: widget.visit.pollutionNearHall,
            options: widget.fields.getComboList('pollution_near_hall'),
          ),
          if(widget.visit.pollutionNearHall=='yes')
            AppInputView(
              title: widget.fields.getField('pollution_hall_comment').label,
              value: widget.visit.pollutionHallComment
            ),


        ],
      ),
    );
  }
}