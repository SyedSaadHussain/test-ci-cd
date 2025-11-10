import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class MaintenanceSection extends StatelessWidget {
  const MaintenanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        final m = vm.mosqueObj;

        // Get maintenance data from payload if available, otherwise from model
        final maintenanceData = m.payload?['maintenance'] ?? m.payload?['data'];
        final maintenanceResponsible = maintenanceData?['maintenance_responsible'] ?? m.maintenanceResponsible;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('maintenance_responsible')?.label ?? 'Maintenance Responsible',
              value: maintenanceResponsible?.toString() ?? '',
              options: vm.fields.getComboList('maintenance_responsible')
            ),
          ],
        );
      },
    );
  }
}
