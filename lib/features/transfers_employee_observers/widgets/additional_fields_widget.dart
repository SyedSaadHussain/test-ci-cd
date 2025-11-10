import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'file_upload_widget.dart';
import 'evacuation_proof_widget.dart';

class AdditionalFieldsWidget extends StatefulWidget {
  final String? trasulTransactionNumber;
  final String? transferLetterFile;
  final String? evacuationProofOption;
  final String? evacuationProofFile;
  final Function(String?) onTrasulNumberChanged;
  final Function(String?) onTransferLetterChanged;
  final Function(String?) onEvacuationProofOptionChanged;
  final Function(String?) onEvacuationProofFileChanged;

  const AdditionalFieldsWidget({
    super.key,
    required this.trasulTransactionNumber,
    required this.transferLetterFile,
    required this.evacuationProofOption,
    required this.evacuationProofFile,
    required this.onTrasulNumberChanged,
    required this.onTransferLetterChanged,
    required this.onEvacuationProofOptionChanged,
    required this.onEvacuationProofFileChanged,
  });

  @override
  State<AdditionalFieldsWidget> createState() => _AdditionalFieldsWidgetState();
}

class _AdditionalFieldsWidgetState extends State<AdditionalFieldsWidget> {
  final TextEditingController _trasulController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _trasulController.text = widget.trasulTransactionNumber ?? '';
  }

  @override
  void dispose() {
    _trasulController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Trasul Transaction Number
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "trasul_transaction_number".tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _trasulController,
                decoration: InputDecoration(
                  hintText: "enter_transaction_number".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  widget.onTrasulNumberChanged(value.isEmpty ? null : value);
                },
              ),
            ],
          ),
        ),
        
        // Transfer Letter Attachment
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: FileUploadWidget(
            title: "transfer_letter_attachment".tr(),
            selectedFile: widget.transferLetterFile,
            onFileSelected: widget.onTransferLetterChanged,
          ),
        ),
        
        // Evacuation Proof
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: EvacuationProofWidget(
            selectedOption: widget.evacuationProofOption,
            selectedFile: widget.evacuationProofFile,
            onOptionChanged: widget.onEvacuationProofOptionChanged,
            onFileSelected: widget.onEvacuationProofFileChanged,
          ),
        ),
      ],
    );
  }
}
