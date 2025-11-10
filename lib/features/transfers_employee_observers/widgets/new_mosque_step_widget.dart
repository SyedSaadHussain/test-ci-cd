import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'labeled_input_field.dart';
import 'mosque_info_card.dart';
import 'new_role_selection_widget.dart';

class NewMosqueStepWidget extends StatelessWidget {
  final String? selectedNewMosque;
  final String? selectedNewRole;
  final Map<String, Map<String, String>> mosqueData;
  final Function(String?) onNewMosqueChanged;
  final Function(String?) onNewRoleChanged;

  const NewMosqueStepWidget({
    super.key,
    required this.selectedNewMosque,
    required this.selectedNewRole,
    required this.mosqueData,
    required this.onNewMosqueChanged,
    required this.onNewRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // New Mosque dropdown
          LabeledInputField(
            title: "new_mosque".tr(),
            hint: "select_new_mosque".tr(),
            isDropdown: true,
            value: selectedNewMosque,
            options: mosqueData.keys.toList(),
            onChanged: onNewMosqueChanged,
          ),

          if (selectedNewMosque != null) ...[
            const SizedBox(height: 16),
            MosqueInfoCard(
              name: selectedNewMosque!,
              code: mosqueData[selectedNewMosque]!["code"]!,
              region: mosqueData[selectedNewMosque]!["region"]!,
              city: mosqueData[selectedNewMosque]!["city"]!,
              classification: mosqueData[selectedNewMosque]!["classification"]!,
              observers: mosqueData[selectedNewMosque]!["observers"] ?? "غير محدد",
            ),
          ],

          const SizedBox(height: 20),

          // New Employee Role
          NewRoleSelectionWidget(
            selectedRole: selectedNewRole,
            onChanged: onNewRoleChanged,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
