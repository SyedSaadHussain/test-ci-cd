import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_screen.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';
 class PublicSafetySection extends StatelessWidget {
  const PublicSafetySection({super.key});
  
  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitEidModel>>() as VisitEidFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppSelectionField(
            title: vm.fields.getField('public_safety_hazard').label,
            value: vm.visitObj.publicSafetyHazard,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('public_safety_hazard'),
            isRequired: vm.visitObj.isRequired('public_safety_hazard'),
            onChanged: (val) {
              vm.updatePublicSafetyHazard(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.publicSafetyHazard,
            builder: (context, publicSafetyHazard, __) {
              if (publicSafetyHazard=='yes')
              return AppInputField(
                title: vm.fields.getField('comment_on_safety_hazard').label,
                value: vm.visitObj.commentOnSafetyHazard,
                isRequired:  vm.visitObj.isRequired('comment_on_safety_hazard'),
                onChanged: (val) {
                  vm.visitObj.commentOnSafetyHazard=val;

                },
              );
              return const SizedBox.shrink();

            },
          ),


          AppSelectionField(
            title: vm.fields.getField('warning_info_panel').label,
            value: vm.visitObj.warningInfoPanel,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('warning_info_panel'),
            isRequired: vm.visitObj.isRequired('warning_info_panel'),
            onChanged: (val) {
              vm.updateWarningInfoPanel(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.warningInfoPanel,
            builder: (context, warningInfoPanel, __) {
              if (warningInfoPanel=='yes')
              return AppInputField(
                title: vm.fields.getField('warning_panel_comment').label,
                value: vm.visitObj.warningPanelComment,
                isRequired:  vm.visitObj.isRequired('warning_panel_comment'),
                onChanged: (val) {
                  vm.visitObj.warningPanelComment=val;

                },
              );
              return const SizedBox.shrink();
            },
          ),



          AppSelectionField(
            title: vm.fields.getField('prayer_hall_free').label,
            value: vm.visitObj.prayerHallFree,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('prayer_hall_free'),
            isRequired: vm.visitObj.isRequired('prayer_hall_free'),
            onChanged: (val) {
              vm.updatePrayerHallFree(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.prayerHallFree,
            builder: (context, prayerHallFree, __) {
              if (prayerHallFree=='no')
              return AppInputField(
                title: vm.fields.getField('prayer_hall_comment').label,
                value: vm.visitObj.prayerHallComment,
                isRequired:  vm.visitObj.isRequired('prayer_hall_comment'),
                onChanged: (val) {
                  vm.visitObj.prayerHallComment=val;

                },
              );
              return const SizedBox.shrink();
            },
          ),



          AppSelectionField(
            title: vm.fields.getField('pollution_near_hall').label,
            value: vm.visitObj.pollutionNearHall,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('pollution_near_hall'),
            isRequired: vm.visitObj.isRequired('pollution_near_hall'),
            onChanged: (val) {
              vm.updatePollutionNearHall(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.pollutionNearHall,
            builder: (context, pollutionNearHall, __) {
              if (pollutionNearHall=='yes')
              return AppInputField(
                title: vm.fields.getField('pollution_hall_comment').label,
                value: vm.visitObj.pollutionHallComment,
                isRequired:  vm.visitObj.isRequired('pollution_hall_comment'),
                onChanged: (val) {
                  vm.visitObj.pollutionHallComment=val;

                },
              );
              return const SizedBox.shrink();
            },
          ),

        ],
      ),
    );
  }
}