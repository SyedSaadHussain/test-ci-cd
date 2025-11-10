import 'package:flutter/material.dart';

class LabeledInputField extends StatelessWidget {
  final String title; // Title above the field
  final String? hint; // Hint inside the textfield
  final bool isDropdown; // If true → show dropdown instead of textfield
  final List<String>? options; // Dropdown choices
  final String? value; // Selected value (for dropdown)
  final ValueChanged<String?>? onChanged;

  const LabeledInputField({
    super.key,
    required this.title,
    this.hint,
    this.isDropdown = false,
    this.options,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          // Field
          DropdownButtonFormField<String>(
            value: value,
            hint: hint != null ? Text(hint!) : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            items: options?.map((opt) {
              return DropdownMenuItem(
                value: opt,
                child: Text(opt),
              );
            }).toList(),
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}
