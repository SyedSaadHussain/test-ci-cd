import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'labeled_input_field.dart';

class NewRoleSelectionWidget extends StatelessWidget {
  final String? selectedRole;
  final Function(String?) onChanged;

  const NewRoleSelectionWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LabeledInputField(
      title: "new_employee_role".tr(),
      hint: "select_new_employee_role".tr(),
      isDropdown: true,
      value: selectedRole,
      options: const [
        "imam",
        "muezzin",
        "khatib", 
        "khadem"
      ],
      onChanged: onChanged,
    );
  }
}
