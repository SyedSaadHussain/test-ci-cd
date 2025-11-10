import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_screen.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class EidPrayerSection extends StatelessWidget {
  const EidPrayerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitEidModel>>() as VisitEidFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppSelectionField(
            title: vm.fields.getField('eid_prayer_board').label,
            value: vm.visitObj.eidPrayerBoard,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('eid_prayer_board'),
            isRequired: vm.visitObj.isRequired('eid_prayer_board'),
            onChanged: (val) {
              vm.updateEidPrayerBoard(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.eidPrayerBoard,
            builder: (context, eidPrayerBoard, __) {
              if (eidPrayerBoard=='yes')
              return AppInputField(
                title: vm.fields.getField('eid_prayer_comment').label,
                value: vm.visitObj.eidPrayerComment,
                isRequired: vm.visitObj.isRequired('eid_prayer_comment'),
                onChanged: (val) {
                  vm.visitObj.eidPrayerComment = val;
                },
              );
              return const SizedBox.shrink();
            },
          ),


          AppSelectionField(
            title: vm.fields.getField('temp_building_prayer').label,
            value: vm.visitObj.tempBuildingPrayer,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('temp_building_prayer'),
            isRequired: vm.visitObj.isRequired('temp_building_prayer'),
            onChanged: (val) {
              vm.updateTempBuildingPrayer(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.tempBuildingPrayer,
            builder: (context, tempBuildingPrayer, __) {
              if (tempBuildingPrayer=='yes')
              return AppSelectionField(
                title: vm.fields.getField('type_temp_building').label,
                value: vm.visitObj.typeTempBuilding,
                type: SingleSelectionFieldType.radio,
                options: vm.fields.getComboList('type_temp_building'),
                isRequired: vm.visitObj.isRequired('type_temp_building'),
                onChanged: (val) {
                  vm.visitObj.typeTempBuilding=val;
                  // setState(() {});
                },
              );
              return const SizedBox.shrink();
            },
          ),


            AppInputField(
              title: vm.fields.getField('type_temp_building_comment').label,
              value: vm.visitObj.typeTempBuildingComment,
              isRequired:  vm.visitObj.isRequired('type_temp_building_comment'),
              onChanged: (val) {
                vm.visitObj.typeTempBuildingComment=val;
              },
            ),

        ],
      ),
    );
  }
}