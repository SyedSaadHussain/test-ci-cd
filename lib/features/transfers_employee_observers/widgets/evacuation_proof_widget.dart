import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'file_upload_widget.dart';

class EvacuationProofWidget extends StatelessWidget {
  final String? selectedOption;
  final String? selectedFile;
  final Function(String?) onOptionChanged;
  final Function(String?) onFileSelected;

  const EvacuationProofWidget({
    super.key,
    required this.selectedOption,
    required this.selectedFile,
    required this.onOptionChanged,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Evacuation Proof Exists Question
        Text(
          "evacuation_proof_exists".tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        
        // Yes/No Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Yes Button
            SizedBox(
              width: 50,
              child: GestureDetector(
                onTap: () {
                  onOptionChanged("yes");
                },
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: selectedOption == "yes" 
                        ? const Color(0xFF8B4513) // Brown color like in the image
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                    border: selectedOption == "yes" 
                        ? null 
                        : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      "yes".tr(),
                      style: TextStyle(
                        color: selectedOption == "yes" 
                            ? Colors.white 
                            : Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // No Button
            SizedBox(
              width: 50,
              child: GestureDetector(
                onTap: () {
                  onOptionChanged("no");
                  onFileSelected(null); // Clear file if "No" is selected
                },
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: selectedOption == "no" 
                        ? const Color(0xFF8B4513) // Brown color like in the image
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                    border: selectedOption == "no" 
                        ? null 
                        : Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      "no".tr(),
                      style: TextStyle(
                        color: selectedOption == "no" 
                            ? Colors.white 
                            : Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        // File Upload (only show if "Yes" is selected)
        if (selectedOption == "yes") ...[
          const SizedBox(height: 16),
          FileUploadWidget(
            title: "evacuation_proof_attachment".tr(),
            selectedFile: selectedFile,
            onFileSelected: onFileSelected,
          ),
        ],
      ],
    );
  }
}
