

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/action_taken_detail.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_timeline.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/maps_launcher.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_image_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_upload_attachment_view.dart';

 class ViewLandBasicInfoSection extends StatefulWidget {
  final VisitLandModel visit;
  final FieldListData fields;
  final dynamic headersMap;

  const ViewLandBasicInfoSection({
    Key? key,
    required this.visit,
    required this.fields,
    this.headersMap
  }) : super(key: key);

  @override
  State<ViewLandBasicInfoSection> createState() => _ViewLandBasicInfoSectionState();
}

 class _ViewLandBasicInfoSectionState<T extends VisitModel> extends State<ViewLandBasicInfoSection> {
  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          Text(widget.visit.name??"",style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(title: widget.fields.getField('land_id').label,value: widget.visit.land??""),
          AppInputView(title: widget.fields.getField('employee_id').label,value: widget.visit.employee),
          AppInputView(title: widget.fields.getField('priority_value').label,
              value: widget.visit.priorityValue,
              options: widget.fields.getComboList('priority_value')  ),
          AppInputView(title: widget.fields.getField('start_datetime').label,value: widget.visit.startDatetimeLocal),
          AppInputView(title: widget.fields.getField('submit_datetime').label,value: widget.visit.submitDatetimeLocal),
          Text("land_location_information".tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
          AppInputView(title: widget.fields.getField('land_address').label,value: widget.visit.landAddress??""),
          AppInputView(title: widget.fields.getField('region_id').label,value: widget.visit.region??""),
          AppInputView(title: widget.fields.getField('city_id').label,value: widget.visit.city??""),
          AppInputView(title: widget.fields.getField('moia_center_id').label,value: widget.visit.moiaCenter??""),
          AppInputView(title: '${  widget.fields.getField('latitude').label}/${  widget.fields.getField('longitude').label}',
              value: widget.visit.coordinates??"",
              action: widget.visit.coordinates!=null?AppButtonSmall(text: 'view Map',isOutline: true,icon: Icons.map,
                  onTab: (){
                    MapsLauncher.openMap(   widget.visit.latitude,    widget.visit.longitude);
                  }
              ):Container()
          ),
          ActionTakenDetail(visit: widget.visit,fields: widget.fields,),
            VisitTimeline(items: widget.visit.visitWorkFlow,)

        ],
      ),
    );
  }
}