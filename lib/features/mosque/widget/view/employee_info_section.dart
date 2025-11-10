import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/widget/mosque_mosnoob_card.dart';
import 'package:mosque_management_system/features/mosque/widget/view/mansoob_groups_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class EmployeeInfoSection extends StatelessWidget {
  const EmployeeInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;

        // Handle is_employee field - can be "yes", "no", or false
        final isEmployeeValue = m.isEmployee ?? m.payload?['is_employee'];
        String isEmployeeDisplay;
        if (isEmployeeValue == false) {
          isEmployeeDisplay = ''; // Show empty placeholder for false
        } else {
          isEmployeeDisplay =
              isEmployeeValue?.toString() ?? ''; // Show "yes" or "no" or empty
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Always show the main question
            AppInputView(
              title: vm.fields
                  .getField('is_employee')
                  ?.label ?? 'Is Employee',
              value: isEmployeeDisplay,
                options: vm.fields.getComboList('is_employee')
            ),


            MansoobGroupsView(
              fields: vm.fields,
              imams: vm.mosqueObj.imamIdsArray ?? const [],
              muezzins: vm.mosqueObj.muezzinIdsArray ?? const [],
              khatibs: vm.mosqueObj.khatibIdsArray ?? const [],
              khadems: vm.mosqueObj.khademIdsArray ?? const [],
            ),
          ],
        );
      },
    );
  }
}