import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewMosqueMeterSection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewMosqueMeterSection({
    Key? key,
    required this.visit,
    required this.fields,
    required this.headersMap,
  }) : super(key: key);

  @override
  State<ViewMosqueMeterSection<T>> createState() => _MansoobSectionState<T>();
}

 class _MansoobSectionState<T extends VisitModel> extends State<ViewMosqueMeterSection<T>> {

  bool isRequired(field){
    return widget.visit.isRequired(field);
  }
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            'mosque_electricity_meters'.tr(),
            style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),
          ),
          AppInputView(title:widget.fields.getField('has_electric_meter').label,
              value: widget.visit.hasElectricMeter,
              options: widget.fields.getComboList('has_electric_meter')
          ),
          if (widget.visit.hasElectricMeter == 'applicable')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputView(
                    title: widget.fields.getField('electric_meter_ids').label,
                    options: widget.visit.electricMeterIdsArray,
                    type:ListType.multiSelect
                ),
                AppInputView(
                  title: widget.fields.getField('electric_meter_data_updated').label,
                  value: widget.visit.electricMeterDataUpdated,
                  options: widget.fields.getComboList('electric_meter_data_updated'),

                ),

                AppInputView(
                  title: widget.fields.getField('electric_meter_violation').label,
                  value: widget.visit.electricMeterViolation,
                  isShowWarning:widget.visit.isEscalationField('electric_meter_violation'),
                  options: widget.fields.getComboList('electric_meter_violation'),

                ),
                if (widget.visit.electricMeterViolation == 'yes')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppInputView(
                          title: widget.fields.getField('violation_electric_meter_ids').label,
                          options: widget.visit.violationElectricMeterIdsArray,
                          type:ListType.multiSelect

                      ),
                      AppImageView(
                          title: widget.fields.getField('violation_electric_meter_attachment').label,
                          value: '${TestDatabase.baseUrl}/web/image?model=${widget.visit.modelName}&field=violation_electric_meter_attachment&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                          headersMap: widget.headersMap
                      ),
                      AppInputView(
                        title: widget.fields.getField('case_infringement_elec_meter').label,
                        value: widget.visit.caseInfringementElecMeter,

                        options: widget.fields.getComboList('case_infringement_elec_meter'),

                      ),
                    ],
                  ),
              ],
            ),

          SizedBox(height: 15),
          Text(
            'mosque_water_meters'.tr(),
            style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),
          ),

          AppInputView(title:widget.fields.getField('has_water_meter').label,
              value: widget.visit.hasWaterMeter,
              options: widget.fields.getComboList('has_water_meter')
          ),
          if (widget.visit.hasWaterMeter == 'applicable')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputView(
                  title: widget.fields.getField('water_meter_ids').label,
                  type:ListType.multiSelect,

                  options: widget.visit.waterMeterIdsArray,
                ),
                AppInputView(
                  title: widget.fields.getField('water_meter_data_updated').label,
                  value: widget.visit.waterMeterDataUpdated,
                  options: widget.fields.getComboList('water_meter_data_updated'),

                ),
                AppInputView(
                  title: widget.fields.getField('water_meter_violation').label,
                  value: widget.visit.waterMeterViolation,
                  isShowWarning:widget.visit.isEscalationField('water_meter_violation'),
                  options: widget.fields.getComboList('water_meter_violation'),
                ),
                if (widget.visit.waterMeterViolation == 'yes')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppInputView(
                        title: widget.fields.getField('violation_water_meter_ids').label,
                        options: widget.visit.violationWaterMeterIdsArray,
                        type:ListType.multiSelect,
                      ),
                      AppImageView(
                          title: widget.fields.getField('violation_water_meter_attachment').label,
                          value: '${TestDatabase.baseUrl}/web/image?model=${widget.visit.modelName}&field=violation_water_meter_attachment&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                          headersMap: widget.headersMap
                      ),
                      AppInputView(
                        title: widget.fields.getField('case_infringement_water_meter').label,
                        value: widget.visit.caseInfringementWaterMeter,
                        options: widget.fields.getComboList('case_infringement_water_meter'),

                      ),

                    ],
                  ),
                AppInputView(
                  title: widget.fields.getField('meter_notes').label,
                  value: widget.visit.meterNotes,

                ),
              ],
            ),
        ],
      ),
    );
  }
}