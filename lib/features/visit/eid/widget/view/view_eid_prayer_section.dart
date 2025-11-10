import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';

 class ViewEidPrayerSection extends StatefulWidget {
  final VisitEidModel visit;
  final FieldListData fields;

  const ViewEidPrayerSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewEidPrayerSection> createState() => _ViewEidPrayerSectionState();
}

 class _ViewEidPrayerSectionState<T extends VisitModel> extends State<ViewEidPrayerSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppInputView(
            title: widget.fields.getField('eid_prayer_board').label,
            value: widget.visit.eidPrayerBoard,
            options: widget.fields.getComboList('eid_prayer_board'),
          ),
          if(widget.visit.eidPrayerBoard=='yes')
            AppInputView(
              title: widget.fields.getField('eid_prayer_comment').label,
              value: widget.visit.eidPrayerComment
            ),

          AppInputView(
            title: widget.fields.getField('temp_building_prayer').label,
            value: widget.visit.tempBuildingPrayer,
            options: widget.fields.getComboList('temp_building_prayer'),
          ),
          if(widget.visit.tempBuildingPrayer=='yes')
            AppInputView(
              title: widget.fields.getField('type_temp_building').label,
              value: widget.visit.typeTempBuilding,
              options: widget.fields.getComboList('type_temp_building'),
            ),
            // AppInputView(
            //   title: widget.fields.getField('temp_building_prayer_comment').label,
            //   value: widget.visit.tempBuildingPrayerComment
            // ),

            AppInputView(
              title: widget.fields.getField('type_temp_building_comment').label,
              value: widget.visit.typeTempBuildingComment
            ),

        ],
      ),
    );
  }
}