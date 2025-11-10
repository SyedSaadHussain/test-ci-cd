import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';

class AudioElectronicsSection extends StatefulWidget {
  const AudioElectronicsSection({super.key});

  @override
  State<AudioElectronicsSection> createState() => _AudioElectronicsSectionState();
}

class _AudioElectronicsSectionState extends State<AudioElectronicsSection> {
  Map<int, String> _acTypeMap = {};

  @override
  void initState() {
    super.initState();
    _loadAcTypeOptions();
  }

  Future<void> _loadAcTypeOptions() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/mosque/ac_type.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        _acTypeMap = {for (var item in jsonList) item['id']: item['name']};
      });
    } catch (e) {
      debugPrint('Error loading ac_type.json: $e');
    }
  }

  String _getAcTypeDisplay(dynamic acTypeValue) {
    if (acTypeValue == null) return '';
    
    List<int> acTypeIds = [];
    if (acTypeValue is List) {
      acTypeIds = acTypeValue.whereType<int>().toList();
    } else if (acTypeValue is String && acTypeValue.isNotEmpty) {
      // Try to parse if it's a string representation
      try {
        final parsed = json.decode(acTypeValue);
        if (parsed is List) {
          acTypeIds = parsed.whereType<int>().toList();
        }
      } catch (_) {}
    }
    
    if (acTypeIds.isEmpty) return '';
    
    final names = acTypeIds.map((id) => _acTypeMap[id] ?? '').where((name) => name.isNotEmpty).toList();
    return names.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        final m = vm.mosqueObj;
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppInputView(
              title: vm.fields.getField('has_air_conditioners')?.label ?? 'Has Air Conditioners', 
              value: m.hasAirConditioners ?? '',
              options: vm.fields.getComboList('has_air_conditioners')
            ),
            AppInputView(
              title: vm.fields.getField('num_air_conditioners')?.label ?? 'Number of Air Conditioners', 
              value: m.numAirConditioners?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('ac_type')?.label ?? 'AC Type', 
              value: _getAcTypeDisplay(m.acType)
            ),
            AppInputView(
              title: vm.fields.getField('has_internal_camera')?.label ?? 'Has Internal Camera', 
              value: m.hasInternalCamera ?? '',
              options: vm.fields.getComboList('has_internal_camera')
            ),
            AppInputView(
              title: vm.fields.getField('has_external_camera')?.label ?? 'Has External Camera', 
              value: m.hasExternalCamera ?? '',
              options: vm.fields.getComboList('has_external_camera')
            ),
            AppInputView(
              title: vm.fields.getField('num_lighting_inside')?.label ?? 'Number of Lighting Inside', 
              value: m.numLightingInside?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('internal_speaker_number')?.label ?? 'Internal Speaker Number', 
              value: m.internalSpeakerNumber?.toString() ?? ''
            ),
            AppInputView(
              title: vm.fields.getField('external_headset_number')?.label ?? 'External Headset Number', 
              value: m.externalHeadsetNumber?.toString() ?? ''
            ),
          ],
        );
      },
    );
  }
}
