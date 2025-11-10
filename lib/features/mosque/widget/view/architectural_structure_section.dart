import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';

class ArchitecturalStructureSection extends StatelessWidget {
  const ArchitecturalStructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;
        
        // Use mergeJson pattern - get data directly from model fields
        // Helper function to get values and handle translations
        String _getValue(dynamic value) {
          if (value == null) return '';
          
          // Handle specific translations
          String stringValue = value.toString();
          switch (stringValue.toLowerCase()) {
            case 'yes':
              return 'نعم';
            case 'no':
              return 'لا';
            case 'true':
              return 'نعم';
            case 'false':
              return 'لا';
            default:
              return stringValue;
          }
        }
        
        // Extract data directly from model properties
        final externalDoorsNumbers = _getValue(m.externalDoorsNumbers);
        final internalDoorsNumber = _getValue(m.internalDoorsNumber);
        final numMinarets = _getValue(m.numMinarets);
        final numFloors = _getValue(m.numFloors);
        final hasBasement = _getValue(m.hasBasement);
        final mosqueRooms = _getValue(m.mosqueRooms);
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('external_doors_numbers')?.label ?? 'External Doors Numbers', 
              value: externalDoorsNumbers
            ),
            AppInputView(
              title: vm.fields.getField('internal_doors_number')?.label ?? 'Internal Doors Numbers', 
              value: internalDoorsNumber
            ),
            AppInputView(
              title: vm.fields.getField('num_minarets')?.label ?? 'Number of Minarets', 
              value: numMinarets
            ),
            AppInputView(
              title: vm.fields.getField('num_floors')?.label ?? 'Number of Floors', 
              value: numFloors
            ),
            AppInputView(
              title: vm.fields.getField('has_basement')?.label ?? 'Has Basement', 
              value: hasBasement
            ),
            AppInputView(
              title: vm.fields.getField('mosque_rooms')?.label ?? 'Mosque Rooms', 
              value: mosqueRooms
            ),
          ],
        );
      },
    );
  }
}
