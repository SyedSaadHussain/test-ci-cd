import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/hive/hive_boxes.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_workflow.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_edit_request_model.dart';
import 'package:mosque_management_system/features/mosque/core/widget/mosque_timeline.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

import '../../../../core/models/combo_list.dart';

class MosqueBasicInfoSection extends StatelessWidget {
  const MosqueBasicInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        final m = vm.mosqueObj;

        // Fallbacks so fields never render empty if VM getters are null
        final name = vm.displayMosqueName ?? m.name ?? '';
        final number = m.number ?? '';
        final classificationName = m.classification ?? '';
        final mosqueTypeName = m.mosqueType ?? '';
        final lastUpdateText = m.lastUpdateDate ?? '';

        // Unified observer/requester list → String
        final List<ComboItem> observerList = vm.observerName ?? const <ComboItem>[];
        final String observerNames = observerList
            .map((e) => (e.value ?? '').trim())
            .where((s) => s.isNotEmpty)
            .join(', ');
        
        // Get observation_text and refuse_reason from payload or model property
        final String? observationText = m.observationText ?? 
            (m.payload?['observation_text'] as String?);
        final String? refuseReason = m.refuseReason ?? 
            (m.payload?['refuse_reason'] as String?);
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Show refuse reason at the top if available
            if ((refuseReason ?? '').toString().trim().isNotEmpty)
              AppInputView(
                title: vm.fields.getField('refuse_reason')?.label ?? 'Refuse reason',
                value: refuseReason?.trim(),
                isShowWarning: true
              ),
            // Show observation text if available
            if ((observationText ?? '').toString().trim().isNotEmpty)
              AppInputView(
                title: vm.fields.getField('observation_text')?.label ?? 'Observation Text',
                value: observationText?.trim(),
                isShowWarning: true
              ),
            if (m is MosqueEditRequestModel && (m.description ?? '').toString().trim().isNotEmpty)
              AppInputView(title: vm.fields.getField('description')?.label ?? 'Description', value: m.description),
            AppInputView(title: vm.fields.getField('observer_ids')?.label ?? 'Observers', value: observerNames),
            AppInputView(title: vm.fields.getField('name')?.label ?? 'Mosque Name', value: name),
            AppInputView(title: vm.fields.getField('number')?.label ?? 'Mosque Number', value: number),
            AppInputView(title: vm.fields.getField('classification_id')?.label ?? 'Classification', value: classificationName),
            AppInputView(title: vm.fields.getField('mosque_type_id')?.label ?? 'Mosque Type', value: mosqueTypeName),
            // COMMENTED OUT: mosque_in_military_zone field
            // AppInputView(
            //   title: vm.fields.getField('mosque_in_military_zone')?.label ?? 'Military Zone',
            //   value: m.mosqueInMilitaryZone,
            //   options: vm.fields.getComboList('mosque_in_military_zone'),
            // ),
            
            // New location fields - always visible (using mosque_view.json)
            AppInputView(
              title: vm.fields.getField('is_inside_prison')?.label ?? 'Is Inside Prison',
              value: m.isInsidePrison ?? '',
              options: vm.fields.getComboList('is_inside_prison'),
            ),
            AppInputView(
              title: vm.fields.getField('is_inside_hospital')?.label ?? 'Is Inside Hospital',
              value: m.isInsideHospital ?? '',
              options: vm.fields.getComboList('is_inside_hospital'),
            ),
            AppInputView(
              title: vm.fields.getField('is_inside_government_housing')?.label ?? 'Is Inside Government Housing',
              value: m.isInsideGovernmentHousing ?? '',
              options: vm.fields.getComboList('is_inside_government_housing'),
            ),
            AppInputView(
              title: vm.fields.getField('is_inside_restricted_gov_entity')?.label ?? 'Is Inside Restricted Gov Entity',
              value: m.isInsideRestrictedGovEntity ?? '',
              options: vm.fields.getComboList('is_inside_restricted_gov_entity'),
            ),
            AppInputView(
              title: vm.fields.getField('land_owner')?.label ?? 'Land Owner',
              value: m.landOwner ?? '—',
              options: vm.fields.getComboList('land_owner'),
            ),
            if ((m.lastUpdateDate ?? '').toString().trim().isNotEmpty)
            AppInputView(title: vm.fields.getField('mosque_last_update')?.label ?? 'Last Update', value: lastUpdateText),


            // Display timeline - check both mosque creation and edit request workflows
            _buildTimeline(m),
          ],
        );
      },
    );
  }

  // Helper method to build timeline for both mosque creation and edit request
  Widget _buildTimeline(dynamic mosque) {
    List<Map<String, dynamic>>? workflowData;

    // Check if it's an edit request (has workflowEditRequest property)
    if (mosque is MosqueEditRequestModel && mosque.workflowEditRequest != null && mosque.workflowEditRequest!.isNotEmpty) {

      workflowData = mosque.workflowEditRequest;
    } 
    // Check if it's a regular mosque (has workflow property)
    else if (mosque.workflow != null && mosque.workflow!.isNotEmpty) {
      workflowData = mosque.workflow;
    }

    if (workflowData == null || workflowData.isEmpty) {
      return const SizedBox.shrink();
    }

    return MosqueTimeline(
      items: workflowData
          .map((json) => MosqueWorkflow.fromJson(json))
          .toList(),
    );
  }
}
