import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_date_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewWomenPrayerSection<T extends VisitFemaleModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewWomenPrayerSection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewWomenPrayerSection<T>> createState() => _ViewWomenPrayerSectionState<T>();
}

 class _ViewWomenPrayerSectionState<T extends VisitFemaleModel> extends State<ViewWomenPrayerSection<T>> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          AppInputView(
            title: widget.fields.getField('women_prayer_signboard').label,
            value:  widget.visit.womenPrayerSignboard,
            options: widget.fields.getComboList('women_prayer_signboard'),
          ),
          AppInputView(
            title: widget.fields.getField('clean_free_block').label,
            value:  widget.visit.cleanFreeBlock,
            options: widget.fields.getComboList('clean_free_block'),
          ),
          AppInputView(
            title: widget.fields.getField('door_work_fine').label,
            value:  widget.visit.doorWorkFine,
            options: widget.fields.getComboList('door_work_fine'),
          ),
          AppInputView(
            title: widget.fields.getField('privacy_women_area').label,
            value:  widget.visit.privacyWomenArea,
            options: widget.fields.getComboList('privacy_women_area'),
          ),
          AppInputView(
            title: widget.fields.getField('woman_prayer_area_size').label,
            value:  widget.visit.womanPrayerAreaSize,
            options: widget.fields.getComboList('woman_prayer_area_size'),
          ),
          AppInputView(
            title: widget.fields.getField('female_section_notes').label,
            value:  widget.visit.femaleSectionNotes,
            options: widget.fields.getComboList('female_section_notes'),
          ),

        ],
      ),
    );
  }
}