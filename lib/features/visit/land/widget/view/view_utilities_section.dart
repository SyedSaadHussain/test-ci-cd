

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

import '../../../../../shared/widgets/form_controls/app_image_view.dart';

 class ViewUtilitiesSection extends StatefulWidget {
  final VisitLandModel visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewUtilitiesSection({
    Key? key,
    required this.visit,
    required this.fields,
    required this.headersMap,
  }) : super(key: key);

  @override
  State<ViewUtilitiesSection> createState() => _ViewUtilitiesSectionState();
}

 class _ViewUtilitiesSectionState<T extends VisitModel> extends State<ViewUtilitiesSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text("electricity_meter".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(
            title: widget.fields.getField('has_electricity_meter').label,
            value: widget.visit.hasElectricityMeter,
            options: widget.fields.getComboList('has_electricity_meter'),
          ),
          if(widget.visit.hasElectricityMeter=='yes')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputView(
                title: widget.fields.getField('electricity_meter_number').label,
                value: widget.visit.electricityMeterNumber,
              ),
              AppInputView(
                title: widget.fields.getField('has_meter_encroachment').label,
                value: widget.visit.hasMeterEncroachment,
                options: widget.fields.getComboList('has_meter_encroachment'),
              ),
              if(widget.visit.hasMeterEncroachment=='yes')
                AppImageView(
                    title: widget.fields.getField('meter_encroachment_photo').label,
                    value: '${TestDatabase.baseUrl}/web/image?model=land.visit&field=meter_encroachment_photo&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                    headersMap: widget.headersMap
                ),
            ],
          ),
          AppInputView(
              title: widget.fields.getField('electricity_meters_notes').label,
              value: widget.visit.electricityMetersNotes
          ),


        ],
      ),
    );
  }
}