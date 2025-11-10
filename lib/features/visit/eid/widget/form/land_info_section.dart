import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_screen.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_attachment_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';
import 'package:provider/provider.dart';

 class LandInfoSection extends StatelessWidget {
  const LandInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<VisitEidModel>>() as VisitEidFormViewModel;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15,),
          AppSelectionField(
            title: vm.fields.getField('land_fenced').label,
            value: vm.visitObj.landFenced,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('land_fenced'),
            isRequired: vm.visitObj.isRequired('land_fenced'),
            onChanged: (val) {
              vm.updateLandFenced(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.landFenced,
            builder: (context, landFenced, __) {
              if (landFenced=='yes')
              return AppInputField(
                title: vm.fields.getField('land_fenced_comment').label,
                value: vm.visitObj.landFencedComment,
                isRequired:  vm.visitObj.isRequired('land_fenced_comment'),
                onChanged: (val) {
                  vm.visitObj.landFencedComment=val;
                },
              );
              return const SizedBox.shrink();
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('tree_tall_grass').label,
            value: vm.visitObj.treeTallGrass,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('tree_tall_grass'),
            isRequired: vm.visitObj.isRequired('tree_tall_grass'),
            onChanged: (val) {
              vm.updateTreeTallGrass(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.treeTallGrass,
            builder: (context, treeTallGrass, __) {
              if (treeTallGrass=='yes')
              return AppInputField(
                title: vm.fields.getField('tree_tall_grass_comment').label,
                value: vm.visitObj.treeTallGrassComment,
                isRequired:  vm.visitObj.isRequired('tree_tall_grass_comment'),
                onChanged: (val) {
                  vm.visitObj.treeTallGrassComment=val;
                  
                },
              );
              return const SizedBox.shrink();
            },
          ),
          AppSelectionField(
            title: vm.fields.getField('there_any_swamps').label,
            value: vm.visitObj.thereAnySwamps,
            type: SingleSelectionFieldType.radio,
            options: vm.fields.getComboList('there_any_swamps'),
            isRequired: vm.visitObj.isRequired('there_any_swamps'),
            onChanged: (val) {
              vm.updateThereAnySwamps(val);
            },
          ),
          Selector<VisitFormViewModel<VisitEidModel>, String?>(
            selector: (_, vm) => vm.visitObj.thereAnySwamps,
            builder: (context, thereAnySwamps, __) {
              if (thereAnySwamps=='yes')
              return AppInputField(
                title: vm.fields.getField('comment_swamps').label,
                value: vm.visitObj.commentSwamps,
                isRequired:  vm.visitObj.isRequired('comment_swamps'),
                onChanged: (val) {
                  vm.visitObj.commentSwamps=val;
                  
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