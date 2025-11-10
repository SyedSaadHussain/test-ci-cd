

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/services/network_service.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_khutba_detail_section.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_view_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class ViewKhutbaSection<T extends VisitJummaModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewKhutbaSection({
    Key? key,
    required this.visit,
    required this.fields
  }) : super(key: key);

  @override
  State<ViewKhutbaSection<T>> createState() => _ViewKhutbaSectionState<T>();
}

 class _ViewKhutbaSectionState<T extends VisitJummaModel> extends State<ViewKhutbaSection<T>> {

  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('khutbah_commitment').label,
            value:  widget.visit.khutbahCommitment,
            options: widget.fields.getComboList('khutbah_commitment'),

          ),
          AppInputView(
            title: widget.fields.getField('sermon_duration').label,
            value:  widget.visit.sermonDuration,
            options: widget.fields.getComboList('sermon_duration'),

          ),
          AppInputView(
            title: widget.fields.getField('sermon_delivery_feedback').label,
            value:  widget.visit.sermonDeliveryFeedback,
            options: widget.fields.getComboList('sermon_delivery_feedback'),

          ),
          if(widget.visit.sermonDeliveryFeedback=='yes')
            AppInputView(
              title: widget.fields.getField('sermon_delivery_feedback_notes').label,
              value:  widget.visit.sermonDeliveryFeedbackNotes
            ),
          AppInputView(
            title: widget.fields.getField('content_feedback').label,
            value:  widget.visit.contentFeedback,
            options: widget.fields.getComboList('content_feedback'),

          ),
          if(widget.visit.contentFeedback=='yes')
            AppInputView(
              title: widget.fields.getField('sermoin_content_notes').label,
              value:  widget.visit.sermoinContentNotes,
            ),
          AppInputView(
            title: widget.fields.getField('included_prayers_for_rulers').label,
            value:  widget.visit.includedPrayersForRulers,
            options: widget.fields.getComboList('included_prayers_for_rulers'),
          ),
          AppInputView(
            title: widget.fields.getField('occupancy').label,
            value:  widget.visit.occupancy,
            options: widget.fields.getComboList('occupancy'),
          ),
          AppInputView(title:widget.fields.getField('khutba_notes').label,
              value: widget.visit.khutbaNotes
          ),
          ViewKhutbaDetailSection(visit:  widget.visit,)
        ],
      ),
    );
  }
}