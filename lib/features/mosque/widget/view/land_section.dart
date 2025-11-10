import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

class LandSection extends StatelessWidget {
  const LandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {


        final m = vm.mosqueObj;
        
        // Use model properties (merged) first, then direct payload keys as fallback
        final p = m.payload ?? const <String, dynamic>{};
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('land_area')?.label ?? 'Land Area', 
              value: (m.mosqueLandArea ?? JsonUtils.toText(p['land_area'])) ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('non_building_area')?.label ?? 'Non Building Area', 
              value: (m.nonBuildingArea ?? JsonUtils.toDouble(p['non_building_area']))?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('roofed_area')?.label ?? 'Roofed Area', 
              value: (m.roofedArea ?? JsonUtils.toDouble(p['roofed_area']))?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('is_free_area')?.label ?? 'Is Free Area', 
              value: (m.isFreeArea ?? JsonUtils.toText(p['is_free_area'])) ?? '',
                options: vm.fields.getComboList('is_free_area')
            ),
            AppInputView(
              title: vm.fields.getField('free_area')?.label ?? 'Free Area', 
              value: (m.freeArea ?? JsonUtils.toDouble(p['free_area']))?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('has_deed')?.label ?? 'Has Deed', 
              value: (m.hasDeed ?? JsonUtils.toText(p['has_deed'])) ?? '',
                options: vm.fields.getComboList('has_deed')
            ),
            AppInputView(
              title: vm.fields.getField('is_there_land_title')?.label ?? 'Is There Land Title', 
              value: (m.isThereLandTitle ?? JsonUtils.toText(p['is_there_land_title'])) ?? '',
                options: vm.fields.getComboList('is_there_land_title')
            ),
            AppInputView(
              title: vm.fields.getField('no_planned')?.label ?? 'No Planned', 
              value: (m.noPlanned ?? JsonUtils.toDouble(p['no_planned']))?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('piece_number')?.label ?? 'Piece Number', 
              value: (m.pieceNumber ?? JsonUtils.toDouble(p['piece_number']))?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('mosque_opening_date')?.label ?? 'Mosque Opening Date', 
              value: (m.mosqueOpeningDate ?? JsonUtils.toText(p['mosque_opening_date'])) ?? '',
              options: vm.fields.getComboList('mosque_opening_date')
            ),
          ],
        );
      },
    );
  }
}
