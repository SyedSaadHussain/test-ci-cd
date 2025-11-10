import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/land/form/visit_land_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:provider/provider.dart';

 class CompletionNotesSection extends StatelessWidget {
  const CompletionNotesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitLandModel>>() as VisitLandFormViewModel;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppInputField(
            title: vm.fields.getField('notes').label,
            value: vm.visitObj.notes,
            isRequired:  vm.visitObj.isRequired('notes'),
            onChanged: (val) {
              vm.visitObj.notes=val;
            },
          ),
        ],
      ),
    );
  }
}