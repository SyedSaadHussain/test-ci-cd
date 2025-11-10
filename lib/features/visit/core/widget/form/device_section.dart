

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class DeviceSection<T extends VisitModel> extends StatelessWidget {
  const DeviceSection({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<T>>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelectionField(
            title: vm.fields.getField('inner_devices').label,
            value: vm.visitObj.innerDevices,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('inner_devices'),
            isRequired: vm.visitObj.isRequired('inner_devices'),
            onChanged: (val) {
              vm.visitObj.innerDevices = val;
              if (val == 'notapplicable') vm.visitObj.innerAudioDevices = null;
              vm.notifyListeners();
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.innerDevices,
            builder: (_, __, ___) {
              if (vm.visitObj.innerDevices == 'notapplicable') return Container();
              return AppSelectionField(
                title: vm.fields.getField('inner_audio_devices').label,
                value: vm.visitObj.innerAudioDevices,
                type: SingleSelectionFieldType.radio,
                options: vm.fields.getComboList('inner_audio_devices'),
                isRequired: vm.visitObj.isRequired('inner_audio_devices'),
                onChanged: (val) {
                  vm.visitObj.innerAudioDevices = val;
                },
              );
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('outer_devices').label,
            value: vm.visitObj.outerDevices,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('outer_devices'),
            isRequired: vm.visitObj.isRequired('outer_devices'),
            onChanged: (val) {
              vm.visitObj.outerDevices = val;
              if (val == 'notapplicable') {
                vm.visitObj.outerAudioDevices = null;
                vm.visitObj.speakerOnPrayer = null;
              }
              vm.notifyListeners();
            },
          ),

          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.outerDevices,
            builder: (_, __, ___) {
              if (vm.visitObj.outerDevices == 'notapplicable') return Container();
              return AppSelectionField(
                title: vm.fields.getField('outer_audio_devices').label,
                value: vm.visitObj.outerAudioDevices,
                type: SingleSelectionFieldType.radio,
                options: vm.fields.getComboList('outer_audio_devices'),
                isRequired: vm.visitObj.isRequired('outer_audio_devices'),
                onChanged: (val) {
                  vm.visitObj.outerAudioDevices = val;
                },
              );
            },
          ),
          Selector<VisitFormViewModel<T>, String?>(
            selector: (_, vm) => vm.visitObj.outerDevices,
            builder: (_, __, ___) {
              if (vm.visitObj.outerDevices == 'notapplicable') return Container();
              return Selector<VisitFormViewModel<T>, String?>(
                  selector: (_, vm) => vm.visitObj.speakerOnPrayer,
                  builder: (_, __, ___) {
                  return AppSelectionField(
                    title: vm.fields.getField('speaker_on_prayer').label,
                    value: vm.visitObj.speakerOnPrayer,
                    type: SingleSelectionFieldType.radio,
                    isShowWarning: vm.visitObj.isEscalationField('speaker_on_prayer'),
                    options: vm.fields.getComboList('speaker_on_prayer'),
                    isRequired: vm.visitObj.isRequired('speaker_on_prayer'),
                    onChanged: (val) {
                      vm.visitObj.speakerOnPrayer = val;
                      vm.notifyListeners();
                    },
                  );
                }
              );
            },
          ),

          AppSelectionField(
            title: vm.fields.getField('air_condition').label,
            value: vm.visitObj.airCondition,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('air_condition'),
            isRequired: vm.visitObj.isRequired('air_condition'),
            onChanged: (val) => vm.visitObj.airCondition = val,
          ),

          AppSelectionField(
            title: vm.fields.getField('lightening').label,
            value: vm.visitObj.lightening,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('lightening'),
            isRequired: vm.visitObj.isRequired('lightening'),
            onChanged: (val) => vm.visitObj.lightening = val,
          ),

          AppSelectionField(
            title: vm.fields.getField('electicity_performance').label,
            value: vm.visitObj.electicityPerformance,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('electicity_performance'),
            isRequired: vm.visitObj.isRequired('electicity_performance'),
            onChanged: (val) => vm.visitObj.electicityPerformance = val,
          ),

          AppInputField(
            title: vm.fields.getField('device_notes').label,
            value: vm.visitObj.deviceNotes,
            isRequired: vm.visitObj.isRequired('device_notes'),
            onChanged: (val) => vm.visitObj.deviceNotes = val,
          ),
        ],
      ),
    );
  }
}