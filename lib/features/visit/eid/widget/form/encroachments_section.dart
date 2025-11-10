import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_screen.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class EncroachmentsSection extends StatelessWidget {
  const EncroachmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitEidModel>>() as VisitEidFormViewModel;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppSelectionField(
            title: vm.fields.getField('encroachment_on_prayer_area').label,
            value: vm.visitObj.encroachmentOnPrayerArea,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('encroachment_on_prayer_area'),
            isRequired: vm.visitObj.isRequired('encroachment_on_prayer_area'),
            onChanged: (val) {
              vm.updateEncroachmentOnPrayerArea(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.encroachmentOnPrayerArea,
            builder: (context, encroachmentOnPrayerArea, __) {
              if (encroachmentOnPrayerArea=='yes')
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSelectionField(
                    title: vm.fields.getField('type_of_violation').label,
                    value: vm.visitObj.typeOfViolation,
                    type: SingleSelectionFieldType.radio,
                    options: vm.fields.getComboList('type_of_violation'),
                    isRequired: vm.visitObj.isRequired('type_of_violation'),
                    onChanged: (val) {
                      vm.visitObj.typeOfViolation=val;
                    },
                  ),
                  AppInputField(
                    title: vm.fields.getField('violation_comment').label,
                    value: vm.visitObj.violationComment,
                    isRequired:  vm.visitObj.isRequired('violation_comment'),
                    onChanged: (val) {
                      vm.visitObj.violationComment=val;
                    },
                  ),
                ],
              );
              return const SizedBox.shrink();
            },
          ),
          AppInputView(
            title: vm.fields.getField('is_electricity_meter').label,
            value: vm.visitObj.isElectricityMeter,
            options: vm.fields.getComboList('is_electricity_meter'),
          ),
          if (vm.visitObj.isElectricityMeter=='applicable')
             Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Selector<VisitFormViewModel<VisitEidModel>,( int?, String?)>(
                  selector: (_, vm) => (vm.visitObj.chooseElectricityMeter?.length,vm.visitObj.violationOnElectricity),
                  builder: (context, encroachmentOnPrayerArea, __) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSelectionField(
                          title: vm.fields.getField('violation_on_electricity').label,
                          value: vm.visitObj.violationOnElectricity,
                          type: SingleSelectionFieldType.radio,
                          options: vm.fields.getComboList('violation_on_electricity'),
                          isRequired: vm.visitObj.isRequired('violation_on_electricity'),
                          onChanged: (val) {
                            vm.visitObj.violationOnElectricity=val;
                            vm.visitObj.chooseElectricityMeter=null;
                            vm.notifyListeners();
                          },
                        ),
                        if(vm.visitObj.violationOnElectricity=='yes')
                        AppSelectionField(
                          title: vm.fields.getField('choose_electricity_meter').label,
                          type: SingleSelectionFieldType.checkBox,
                          value: vm.visitObj.chooseElectricityMeter,
                          options: vm.visitObj.chooseElectricityMeterArray,
                          isRequired:  vm.visitObj.isRequired('choose_electricity_meter'),
                          onChanged: (val,isNew) {
                            vm.updateChooseElectricityMeter(val,isNew);
                          },
                        ),
                      ],
                    );
                  }
              ),
            ],
          ),

          AppInputField(
            title: vm.fields.getField('electricity_meter_comment').label,
            value: vm.visitObj.electricityMeterComment,
            isRequired:  vm.visitObj.isRequired('electricity_meter_comment'),
            onChanged: (val) {
              vm.visitObj.electricityMeterComment=val;
            },
          ),


        ],
      ),
    );
  }
}