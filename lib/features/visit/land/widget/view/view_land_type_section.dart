

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

 class ViewLandTypeSection extends StatefulWidget {
  final VisitLandModel visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewLandTypeSection({
    Key? key,
    required this.visit,
    required this.fields,
    required this.headersMap,
  }) : super(key: key);

  @override
  State<ViewLandTypeSection> createState() => _ViewLandTypeSectionState();
}

 class _ViewLandTypeSectionState<T extends VisitModel> extends State<ViewLandTypeSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text("land_type_ownership_sign".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(
            title: widget.fields.getField('land_type').label,
            value: widget.visit.landType,
            options: widget.fields.getComboList('land_type'),
          ),
          AppInputView(
            title: widget.fields.getField('has_ownership_sign').label,
            value: widget.visit.hasOwnershipSign,
            options: widget.fields.getComboList('has_ownership_sign'),
          ),
          if(widget.visit.hasOwnershipSign=='yes')
            AppImageView(
              title: widget.fields.getField('ownership_sign_photo').label,
                value: '${TestDatabase.baseUrl}/web/image?model=land.visit&field=ownership_sign_photo&id=${this.widget.visit.id}&unique=${widget.visit.uniqueId}',
                headersMap: widget.headersMap
            ),
          Text("location_information".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),

          AppInputView(
            title: widget.fields.getField('easy_access').label,
            value: widget.visit.easyAccess,
            options: widget.fields.getComboList('easy_access'),
          ),
          AppInputView(
            title: widget.fields.getField('paved_roads').label,
            value: widget.visit.pavedRoads,
            options: widget.fields.getComboList('paved_roads'),
          ),
          AppInputView(
              title: widget.fields.getField('land_type_notes').label,
              value: widget.visit.landTypeNotes
          ),

        ],
      ),
    );
  }
}