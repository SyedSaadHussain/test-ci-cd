import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'labeled_input_field.dart';
import 'mosque_info_card.dart';
import 'current_role_selection_widget.dart';

class CurrentMosqueStepWidget extends StatelessWidget {
  final String? selectedCurrentMosque;
  final String? selectedCurrentRole;
  final Map<String, Map<String, String>> mosqueData;
  final Function(String?) onCurrentMosqueChanged;
  final Function(String?) onCurrentRoleChanged;

  const CurrentMosqueStepWidget({
    super.key,
    required this.selectedCurrentMosque,
    required this.selectedCurrentRole,
    required this.mosqueData,
    required this.onCurrentMosqueChanged,
    required this.onCurrentRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current Mosque dropdown
          LabeledInputField(
            title: "current_mosque".tr(),
            hint: "select_current_mosque".tr(),
            isDropdown: true,
            value: selectedCurrentMosque,
            options: mosqueData.keys.toList(),
            onChanged: onCurrentMosqueChanged,
          ),

          if (selectedCurrentMosque != null) ...[
            const SizedBox(height: 16),
            MosqueInfoCard(
              name: selectedCurrentMosque!,
              code: mosqueData[selectedCurrentMosque]!["code"]!,
              region: mosqueData[selectedCurrentMosque]!["region"]!,
              city: mosqueData[selectedCurrentMosque]!["city"]!,
              classification: mosqueData[selectedCurrentMosque]!["classification"]!,
              observers: mosqueData[selectedCurrentMosque]!["observers"] ?? "غير محدد",
            ),
          ],

          const SizedBox(height: 20),

          // Current Employee Role
          CurrentRoleSelectionWidget(
            selectedRole: selectedCurrentRole,
            onChanged: onCurrentRoleChanged,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
