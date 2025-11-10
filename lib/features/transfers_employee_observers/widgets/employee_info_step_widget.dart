import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'labeled_input_field.dart';
import 'employee_info_card.dart';

class EmployeeInfoStepWidget extends StatelessWidget {
  final String? selectedEmployee;
  final Function(String?) onEmployeeChanged;

  const EmployeeInfoStepWidget({
    super.key,
    required this.selectedEmployee,
    required this.onEmployeeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Employee dropdown
          LabeledInputField(
            title: "employee".tr(),
            hint: "select_employee".tr(),
            isDropdown: true,
            value: selectedEmployee,
            options: const ["عزام اسامه", "محمد الرشيدي", "cx", "sdfsdf"],
            onChanged: onEmployeeChanged,
          ),

          if (selectedEmployee != null) ...[
            const SizedBox(height: 16),
            EmployeeInfoCard(
              name: selectedEmployee!,
              role: selectedEmployee == "عزام اسامه" ? "Manager" : "موظف",
              id: "12345",
              region: "الرياض",
              city: "الرياض",
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
