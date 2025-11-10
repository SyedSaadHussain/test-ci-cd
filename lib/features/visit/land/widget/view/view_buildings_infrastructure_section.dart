

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewBuildingsInfrastructureSection extends StatefulWidget {
  final VisitLandModel visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewBuildingsInfrastructureSection({
    Key? key,
    required this.visit,
    required this.fields,
    required this.headersMap,
  }) : super(key: key);

  @override
  State<ViewBuildingsInfrastructureSection> createState() => _ViewBuildingsInfrastructureSectionState();
}

 class _ViewBuildingsInfrastructureSectionState<T extends VisitModel> extends State<ViewBuildingsInfrastructureSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("temporary_buildings".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(
            title: widget.fields.getField('has_temporary_buildings').label,
            value: widget.visit.hasTemporaryBuildings,
            options: widget.fields.getComboList('has_temporary_buildings'),
          ),
          if(widget.visit.hasTemporaryBuildings=='yes')
            AppInputView(
              title: widget.fields.getField('temporary_building_type').label,
              value: widget.visit.temporaryBuildingType,
            ),
          Text("land_encroachment".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),

          AppInputView(
            title: widget.fields.getField('has_encroachment').label,
            value: widget.visit.hasEncroachment,
            options: widget.fields.getComboList('has_encroachment'),

          ),
          if(widget.visit.hasEncroachment=='yes')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputView(
                  title: widget.fields.getField('encroachment_type').label,
                  value: widget.visit.encroachmentType,
                  options: widget.fields.getComboList('encroachment_type'),
                ),
                AppImageView(
                    title: widget.fields.getField('encroachment_photo').label,
                    value: '${TestDatabase.baseUrl}/web/image?model=land.visit&field=encroachment_photo&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                    headersMap: widget.headersMap
                ),
              ],
            ),
          AppInputView(
            title: widget.fields.getField('temp_building_notes').label,
            value: widget.visit.tempBuildingNotes
          ),

        ],
      ),
    );
  }
}