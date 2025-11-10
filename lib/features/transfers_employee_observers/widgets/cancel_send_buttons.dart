import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'send_condition.dart';
import 'cancel_condition.dart';

class CancelSendButtons extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final String? trasulTransactionNumber;
  final String? transferLetterFile;
  final String? evacuationProofOption;
  final String? evacuationProofFile;

  const CancelSendButtons({
    super.key,
    this.onCancel,
    this.onSave,
    this.trasulTransactionNumber,
    this.transferLetterFile,
    this.evacuationProofOption,
    this.evacuationProofFile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        children: [
          // Cancel button
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showExitDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF8B4513), // Brown color like upload button
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "cancel".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Save button
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showTermsDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "send".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TermsConditionsDialog(
          onAccept: () {
            Navigator.of(context).pop(); // Close dialog
            onSave?.call(); // Call the original save callback
          },
          onReject: () {
            Navigator.of(context).pop(); // Close dialog
          },
        );
      },
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ExitConfirmationDialog(
          onConfirm: () {
            Navigator.of(context).pop(); // Close dialog
            onCancel?.call(); // Call the original cancel callback
          },
          onCancel: () {
            Navigator.of(context).pop(); // Close dialog
          },
        );
      },
    );
  }
}
