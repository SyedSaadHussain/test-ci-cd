import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'additional_fields_widget.dart';
import 'cancel_send_buttons.dart';

class DocumentsStepWidget extends StatelessWidget {
  final String? trasulTransactionNumber;
  final String? transferLetterFile;
  final String? evacuationProofOption;
  final String? evacuationProofFile;
  final Function(String?) onTrasulNumberChanged;
  final Function(String?) onTransferLetterChanged;
  final Function(String?) onEvacuationProofOptionChanged;
  final Function(String?) onEvacuationProofFileChanged;
  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  const DocumentsStepWidget({
    super.key,
    required this.trasulTransactionNumber,
    required this.transferLetterFile,
    required this.evacuationProofOption,
    required this.evacuationProofFile,
    required this.onTrasulNumberChanged,
    required this.onTransferLetterChanged,
    required this.onEvacuationProofOptionChanged,
    required this.onEvacuationProofFileChanged,
    this.onCancel,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Additional Fields
          AdditionalFieldsWidget(
            trasulTransactionNumber: trasulTransactionNumber,
            transferLetterFile: transferLetterFile,
            evacuationProofOption: evacuationProofOption,
            evacuationProofFile: evacuationProofFile,
            onTrasulNumberChanged: onTrasulNumberChanged,
            onTransferLetterChanged: onTransferLetterChanged,
            onEvacuationProofOptionChanged: onEvacuationProofOptionChanged,
            onEvacuationProofFileChanged: onEvacuationProofFileChanged,
          ),

          const SizedBox(height: 20),

          // Cancel and Send Buttons
          CancelSendButtons(
            onCancel: onCancel,
            onSave: onSave,
            trasulTransactionNumber: trasulTransactionNumber,
            transferLetterFile: transferLetterFile,
            evacuationProofOption: evacuationProofOption,
            evacuationProofFile: evacuationProofFile,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
