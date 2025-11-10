

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewCompletionNotesSection extends StatefulWidget {
  final VisitLandModel visit;
  final FieldListData fields;

  const ViewCompletionNotesSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewCompletionNotesSection> createState() => _ViewCompletionNotesSectionState();
}

 class _ViewCompletionNotesSectionState<T extends VisitModel> extends State<ViewCompletionNotesSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Data Accuracy Pledge",style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          // AppInputView(
          //   title: widget.fields.getField('data_accuracy_pledge').label,
          //   value: widget.visit.dataAccuracyPledge,
          //   options: widget.fields.getComboList('data_accuracy_pledge'),
          // ),
          AppInputView(
            title: widget.fields.getField('notes').label,
            value: widget.visit.notes
          ),
        ],
      ),
    );
  }
}