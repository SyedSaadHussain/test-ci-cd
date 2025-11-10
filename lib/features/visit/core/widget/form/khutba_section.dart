
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/data/services/network_service.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_khutba_detail_section.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_view_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class KhutbaSection<T extends VisitJummaModel> extends StatelessWidget {
   KhutbaSection({super.key});



  @override
  Widget build(BuildContext context) {
    final   vm = context.read<VisitFormViewModel<T>>() as VisitJummaFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField(
            title: vm.fields.getField('khutbah_commitment').label,
            value: vm.visitObj.khutbahCommitment,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('khutbah_commitment'),
            isRequired: vm.visitObj.isRequired('khutbah_commitment'),
            onChanged: (val) {
              vm.visitObj.khutbahCommitment = val;

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('sermon_duration').label,
            value: vm.visitObj.sermonDuration,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('sermon_duration'),
            isRequired: vm.visitObj.isRequired('sermon_duration'),
            onChanged: (val) {
              vm.visitObj.sermonDuration = val;

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('sermon_delivery_feedback').label,
            value: vm.visitObj.sermonDeliveryFeedback,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('sermon_delivery_feedback'),
            isRequired: vm.visitObj.isRequired('sermon_delivery_feedback'),
            onChanged: (val) {
              vm.visitObj.sermonDeliveryFeedback = val;
              vm.notifyListeners();

            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.sermonDeliveryFeedback,
            builder: (context, sermonDeliveryFeedback, __) {

              if (vm.visitObj.sermonDeliveryFeedback == 'yes') {
                return AppInputField(
                  title: vm.fields.getField('sermon_delivery_feedback_notes').label,
                  value: vm.visitObj.sermonDeliveryFeedbackNotes, // ✅ kept same
                  isRequired: vm.visitObj.isRequired('sermon_delivery_feedback_notes'),
                  onChanged: (val) {
                    vm.visitObj.sermonDeliveryFeedbackNotes = val; // ✅ kept same
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('content_feedback').label,
            value: vm.visitObj.contentFeedback,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('content_feedback'),
            isRequired: vm.visitObj.isRequired('content_feedback'),
            onChanged: (val) {
              vm.visitObj.contentFeedback = val;
              vm.notifyListeners();

            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.contentFeedback,
            builder: (context, contentFeedback, __) {

              if (vm.visitObj.contentFeedback == 'yes') {
                return AppInputField(
                  title: vm.fields.getField('sermoin_content_notes').label,
                  value: vm.visitObj.sermoinContentNotes, // ✅ unchanged
                  isRequired: vm.visitObj.isRequired('sermoin_content_notes'),
                  onChanged: (val) {
                    vm.visitObj.sermoinContentNotes = val; // ✅ unchanged
                    // vm.notifyListeners(); // 🔔 optional if you want reactive rebuilds
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('included_prayers_for_rulers').label,
            value: vm.visitObj.includedPrayersForRulers,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('included_prayers_for_rulers'),
            isRequired: vm.visitObj.isRequired('included_prayers_for_rulers'),
            onChanged: (val) {
              vm.visitObj.includedPrayersForRulers = val;

            },
          ),
          AppSelectionField(
            title: vm.fields.getField('occupancy').label,
            value: vm.visitObj.occupancy,
            type: SingleSelectionFieldType.selection,
            options: vm.fields.getComboList('occupancy'),
            isRequired: vm.visitObj.isRequired('occupancy'),
            onChanged: (val) {
              vm.visitObj.occupancy = val;
            },
          ),
          AppInputField(
            title: vm.fields.getField('khutba_notes').label,
            value: vm.visitObj.khutbaNotes,
            isRequired: vm.visitObj.isRequired('khutba_notes'),
            onChanged: (val) {
              vm.visitObj.khutbaNotes = val;
            },
          ),
          ViewKhutbaDetailSection(visit:vm.visitObj ,)
        ],
      ),
    );
  }
}