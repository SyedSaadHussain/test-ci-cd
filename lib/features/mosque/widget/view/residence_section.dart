import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class ResidenceSection extends StatelessWidget {
  const ResidenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;
        
        // Get residence data from payload or fallback to model fields
        final residenceData = m.payload?['residence'] ?? m.payload?['data'];
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('residence_for_imam')?.label ?? 'Residence for Imam', 
              value: residenceData?['residence_for_imam']?.toString() ?? m.residenceForImam?.toString() ?? '',

                options: vm.fields.getComboList('residence_for_imam')
            ),
            AppInputView(
              title: vm.fields.getField('imam_residence_type')?.label ?? 'Imam Residence Type', 
              value: residenceData?['imam_residence_type']?.toString() ?? m.imamResidenceType?.toString() ?? '',
        options: vm.fields.getComboList('imam_residence_type')
            ),
            AppInputView(
              title: vm.fields.getField('imam_residence_land_area')?.label ?? 'Imam Residence Land Area', 
              value: residenceData?['imam_residence_land_area']?.toString() ?? m.imamResidenceLandArea?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('residence_for_mouadhin')?.label ?? 'Residence for Muezzin', 
              value: residenceData?['residence_for_mouadhin']?.toString() ?? m.residenceForMouadhin?.toString() ?? '',
        options: vm.fields.getComboList('residence_for_mouadhin')
            ),
            AppInputView(
              title: vm.fields.getField('muezzin_residence_type')?.label ?? 'Muezzin Residence Type', 
              value: residenceData?['muezzin_residence_type']?.toString() ?? m.muezzinResidenceType?.toString() ?? '',
        options: vm.fields.getComboList('muezzin_residence_type')
            ),
            AppInputView(
              title: vm.fields.getField('muezzin_residence_land_area')?.label ?? 'Muezzin Residence Land Area', 
              value: residenceData?['muezzin_residence_land_area']?.toString() ?? m.muezzinResidenceLandArea?.toString() ?? ''
            ),
          ],
        );
      },
    );
  }
}
