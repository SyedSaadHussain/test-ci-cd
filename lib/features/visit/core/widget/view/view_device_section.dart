import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewDeviceSection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewDeviceSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewDeviceSection<T>> createState() => _ViewDeviceSectionState<T>();
}

 class _ViewDeviceSectionState<T extends VisitModel> extends State<ViewDeviceSection<T>> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputView(
                  title: widget.fields.getField('inner_devices').label,
                  value:  widget.visit.innerDevices,
                  options: widget.fields.getComboList('inner_devices'),

                ),
                 widget.visit.innerDevices!='notapplicable'?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInputView(
                      title: widget.fields.getField('inner_audio_devices').label,
                      value:  widget.visit.innerAudioDevices,
                      options: widget.fields.getComboList('inner_audio_devices'),

                    ),

                  ],
                ):Container(),
                AppInputView(
                  title: widget.fields.getField('outer_devices').label,
                  value:  widget.visit.outerDevices,
                  options: widget.fields.getComboList('outer_devices'),

                ),


                 widget.visit.outerDevices!='notapplicable'? AppInputView(
                  title: widget.fields.getField('outer_audio_devices').label,
                  value:  widget.visit.outerAudioDevices,

                  options: widget.fields.getComboList('outer_audio_devices'),

                ):Container(),
                 widget.visit.outerDevices!='notapplicable'? AppInputView(
                  title: widget.fields.getField('speaker_on_prayer').label,
                  value:  widget.visit.speakerOnPrayer,
                  isShowWarning: widget.visit.isEscalationField('speaker_on_prayer'),
                  options: widget.fields.getComboList('speaker_on_prayer'),

                ):Container(),
                AppInputView(
                  title: widget.fields.getField('air_condition').label,
                  value:  widget.visit.airCondition,

                  options: widget.fields.getComboList('air_condition'),

                ),
                AppInputView(
                  title: widget.fields.getField('lightening').label,
                  value:  widget.visit.lightening,

                  options: widget.fields.getComboList('lightening'),

                ),
                AppInputView(
                  title: widget.fields.getField('electicity_performance').label,
                  value:  widget.visit.electicityPerformance,

                  options: widget.fields.getComboList('electicity_performance'),

                ),
                AppInputView(
                  title: widget.fields.getField('device_notes').label,
                  value:  widget.visit.deviceNotes,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}