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

 class ViewLandInfoSection extends StatefulWidget {
  final VisitEidModel visit;
  final FieldListData fields;

  const ViewLandInfoSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewLandInfoSection> createState() => _ViewLandInfoSectionState();
}

 class _ViewLandInfoSectionState<T extends VisitModel> extends State<ViewLandInfoSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppInputView(
            title: widget.fields.getField('land_fenced').label,
            value: widget.visit.landFenced,
            options: widget.fields.getComboList('land_fenced')
          ),
          if(widget.visit.landFenced=='yes')
            AppInputView(
              title: widget.fields.getField('land_fenced_comment').label,
              value: widget.visit.landFencedComment
            ),

          AppInputView(
            title: widget.fields.getField('tree_tall_grass').label,
            value: widget.visit.treeTallGrass,
            options: widget.fields.getComboList('tree_tall_grass'),
          ),
          if(widget.visit.treeTallGrass=='yes')
            AppInputView(
              title: widget.fields.getField('tree_tall_grass_comment').label,
              value: widget.visit.treeTallGrassComment,
            ),


          AppInputView(
            title: widget.fields.getField('there_any_swamps').label,
            value: widget.visit.thereAnySwamps,
            options: widget.fields.getComboList('there_any_swamps'),
          ),
          if(widget.visit.thereAnySwamps=='yes')
            AppInputView(
              title: widget.fields.getField('comment_swamps').label,
              value: widget.visit.commentSwamps,
            ),

        ],
      ),
    );
  }
}