import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class HistoricalSection extends StatelessWidget {
  const HistoricalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;
        
        // Get historical data from payload or fallback to model fields
        final historicalData = m.payload?['historical'] ?? m.payload?['data'];
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('mosque_historical')?.label ?? 'Historical Mosque',
              value: historicalData?['mosque_historical']?.toString() ?? m.mosqueHistorical?.toString() ?? '',
              options: vm.fields.getComboList('mosque_historical'),
            ),
            AppInputView(
              title: vm.fields.getField('prince_project_historic_mosque')?.label ?? 'Prince Project Historic Mosque', 
              value: historicalData?['prince_project_historic_mosque']?.toString() ?? m.princeProjectHistoricMosque?.toString() ?? '',
                options: vm.fields.getComboList('prince_project_historic_mosque')
            ),
          ],
        );
      },
    );
  }
}
