

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewBuildingSection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewBuildingSection({
    Key? key,
    required this.visit,
    required this.fields,
    required this.headersMap,
  }) : super(key: key);

  @override
  State<ViewBuildingSection<T>> createState() => _ViewBuildingSectionState<T>();
}

 class _ViewBuildingSectionState<T extends VisitModel> extends State<ViewBuildingSection<T>> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('is_encroachment_building').label,
            value: widget.visit.isEncroachmentBuilding,
            isShowWarning:widget.visit.isEscalationField('is_encroachment_building'),
            options: widget.fields.getComboList('is_encroachment_building'),

          ),
          widget.visit.isEncroachmentBuilding == 'yes'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImageView(
                  title: widget.fields.getField('encroachment_building_attachment').label,
                  value: '${TestDatabase.baseUrl}/web/image?model=${widget.visit.modelName}&field=encroachment_building_attachment&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                  headersMap: widget.headersMap
              ),
              AppInputView(
                title: widget.fields.getField('case_encroachment_building').label,
                value: widget.visit.caseEncroachmentBuilding,
                options: widget.fields.getComboList('case_encroachment_building'),

              ),
            ],
          )
              : Container(),
          AppInputView(
            title: widget.fields.getField('is_encroachment_vacant_land').label,
            isShowWarning:widget.visit.isEscalationField('is_encroachment_vacant_land'),
            value: widget.visit.isEncroachmentVacantLand,
            options: widget.fields.getComboList('is_encroachment_vacant_land'),

          ),
          widget.visit.isEncroachmentVacantLand == 'yes'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImageView(
                  title: widget.fields.getField('encroachment_vacant_attachment').label,
                  value: '${TestDatabase.baseUrl}/web/image?model=${widget.visit.modelName}&field=encroachment_vacant_attachment&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                  headersMap: widget.headersMap
              ),
              AppInputView(
                title: widget.fields.getField('case_encroachment_vacant_land').label,
                value: widget.visit.caseEncroachmentVacantLand,
                options: widget.fields.getComboList('case_encroachment_vacant_land'),

              ),
            ],
          )
              : Container(),
          AppInputView(
            title: widget.fields.getField('is_violation_building').label,
            value: widget.visit.isViolationBuilding,
            isShowWarning:widget.visit.isEscalationField('is_violation_building'),
            options: widget.fields.getComboList('is_violation_building'),

          ),
          widget.visit.isViolationBuilding == 'yes'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImageView(
                  title: widget.fields.getField('violation_building_attachment').label,
                  value: '${TestDatabase.baseUrl}/web/image?model=${widget.visit.modelName}&field=violation_building_attachment&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                  headersMap: widget.headersMap
              ),
              AppInputView(
                title: widget.fields.getField('case_violation_building').label,
                value: widget.visit.caseViolationBuilding,
                options: widget.fields.getComboList('case_violation_building'),

              ),

            ],
          )
              : Container(),
          AppInputView(
            title: widget.fields.getField('building_notes').label,
            value: widget.visit.buildingNotes,
            options: widget.fields.getComboList('building_notes'),

          ),
        ],
      ),
    );
  }
}