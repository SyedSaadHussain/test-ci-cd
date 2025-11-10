

import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

 class ViewSecuritySection<T extends VisitModel> extends StatefulWidget {
  final T visit;
  final FieldListData fields;

  const ViewSecuritySection({
    Key? key,
    required this.visit,
    required this.fields,
  }) : super(key: key);

  @override
  State<ViewSecuritySection<T>> createState() => _ViewSecuritySectionState<T>();
}

 class _ViewSecuritySectionState<T extends VisitModel> extends State<ViewSecuritySection<T>> {
  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputView(
            title: widget.fields.getField('security_violation_type').label,
            value:  widget.visit.securityViolationType,
            isShowWarning: widget.visit.isEscalationField('security_violation_type'),
            options: widget.fields.getComboList('security_violation_type'),

          ),
          AppInputView(
            title: widget.fields.getField('admin_violation_type').label,
            value:  widget.visit.adminViolationType,
            isShowWarning: widget.visit.isEscalationField('admin_violation_type'),
            options: widget.fields.getComboList('admin_violation_type'),

          ),
          AppInputView(
            title: widget.fields.getField('operational_violation_type').label,
            value:  widget.visit.operationalViolationType,
            isShowWarning: widget.visit.isEscalationField('operational_violation_type'),
            options: widget.fields.getComboList('operational_violation_type'),

          ),
          AppInputView(
            title: widget.fields.getField('unauthorized_publications').label,
            value:  widget.visit.unauthorizedPublications,
            isShowWarning: widget.visit.isEscalationField('unauthorized_publications'),
            options: widget.fields.getComboList('unauthorized_publications'),

          ),
           widget.visit.unauthorizedPublications == 'yes'
              ? AppInputView(
            title: widget.fields.getField('publication_source').label,
            value:  widget.visit.publicationSource,

          )
              : Container(),
          AppInputView(
            title: widget.fields.getField('religious_social_violation_type').label,
            value:  widget.visit.religiousSocialViolationType,
            isShowWarning: widget.visit.isEscalationField('religious_social_violation_type'),
            options: widget.fields.getComboList('religious_social_violation_type'),

          ),
          AppInputView(
            title: widget.fields.getField('unauthorized_quran_presence').label,
            value:  widget.visit.unauthorizedQuranPresence,
            isShowWarning: widget.visit.isEscalationField('unauthorized_quran_presence'),
            options: widget.fields.getComboList('unauthorized_quran_presence'),

          ),
          AppInputView(
            title: widget.fields.getField('security_violation_notes').label,
            value:  widget.visit.securityViolationNotes,
          ),
        ],
      ),
    );
  }
}