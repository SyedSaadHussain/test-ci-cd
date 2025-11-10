import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class SafetySection extends StatelessWidget {
  const SafetySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;
        
        // Get safety data from payload or fallback to model fields
        final safetyData = m.payload?['safety'] ?? m.payload?['data'];
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('has_fire_extinguishers')?.label ?? 'Has Fire Extinguishers', 
              value: safetyData?['has_fire_extinguishers']?.toString() ?? m.hasFireExtinguishers?.toString() ?? '',
                options: vm.fields.getComboList('has_fire_extinguishers')
            ),
            AppInputView(
              title: vm.fields.getField('has_fire_system_pumps')?.label ?? 'Has Fire System Pumps', 
              value: safetyData?['has_fire_system_pumps']?.toString() ?? m.hasFireSystemPumps?.toString() ?? '',
                options: vm.fields.getComboList('has_fire_system_pumps')
            ),
          ],
        );
      },
    );
  }
}
