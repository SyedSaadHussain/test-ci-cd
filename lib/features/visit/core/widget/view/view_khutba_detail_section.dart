import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_view_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

class ViewKhutbaDetailSection extends StatelessWidget {
  final VisitJummaModel visit;

  ViewKhutbaDetailSection({
    super.key,
    required this.visit,
  });

   final dynamic style = {'color': '#696f72 !important'};



  @override
  Widget build(BuildContext context) {

    return  SingleChildScrollView(
      child: (visit.jummaKhutbaId!=null)?
             Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20,),
        Text('Khutba Detail', style: AppTextStyles.headingLG.copyWith(color: AppColors.primary)),

        AppInputView(title:'Khutba Name',
          child: HtmlWidget(
            visit.jummaKhutbaName ??
                "",
            customStylesBuilder:
                (element) {
              element.attributes
                  .clear();
              // AppColors.formText
              return style;
            },
          ),
        ),
        AppInputView(title:'Khutba Description',
          child: HtmlWidget(
            visit.jummaKhutbaDescription ??
                "",
            customStylesBuilder:
                (element) {
              element.attributes
                  .clear();
              // AppColors.formText
              return style;
            },
          ),
        ),
        (AppUtils.extractTextFromHtml(visit.jummaKhutbaGuideline_1 ?? '').isEmpty==false)?AppInputView(title:'Khutba Guideline 1',
          child: HtmlWidget(
            visit.jummaKhutbaGuideline_1 ??
                "",
            customStylesBuilder:
                (element) {
              element.attributes
                  .clear();
              // AppColors.formText
              return style;
            },
          ),
        ):Container(),
        (AppUtils.extractTextFromHtml(visit.jummaKhutbaGuideline_2 ?? '').isEmpty==false)?AppInputView(title:'Khutba Guideline 2',
          child: HtmlWidget(
            visit.jummaKhutbaGuideline_2 ??
                "",
            customStylesBuilder:
                (element) {
              element.attributes
                  .clear();
              // AppColors.formText
              return style;
            },
          ),
        ):Container(),
        (AppUtils.extractTextFromHtml(visit.jummaKhutbaGuideline_3 ?? '').isEmpty==false)?AppInputView(title:'Khutba Guideline 3',
          child: HtmlWidget(
            visit.jummaKhutbaGuideline_3 ??
                "",
            customStylesBuilder:
                (element) {
              element.attributes
                  .clear();
              // AppColors.formText
              return style;
            },
          ),
        ):Container(),
        (AppUtils.extractTextFromHtml(visit.jummaKhutbaGuideline_4 ?? '').isEmpty==false)?AppInputView(title:'Khutba Guideline 4',
          child: HtmlWidget(
            visit.jummaKhutbaGuideline_4 ??
                "",
            customStylesBuilder:
                (element) {
              element.attributes
                  .clear();
              // AppColors.formText
              return style;
            },
          ),
        ):Container(),
      ],
    ):Container(),
    );
  }
}