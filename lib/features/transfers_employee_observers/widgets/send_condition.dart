import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class TermsConditionsDialog extends StatefulWidget {
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const TermsConditionsDialog({
    super.key,
    this.onAccept,
    this.onReject,
  });

  @override
  State<TermsConditionsDialog> createState() => _TermsConditionsDialogState();
}

class _TermsConditionsDialogState extends State<TermsConditionsDialog> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "terms_and_conditions".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Declaration Text
            Text(
              "data_review_declaration".tr(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),

            const SizedBox(height: 24),

            // Toggle Switch and Acceptance Text
            Row(
              children: [
                // Toggle Switch
                Switch(
                  value: isAccepted,
                  onChanged: (value) {
                    setState(() {
                      isAccepted = value;
                    });
                  },
                  // activeThumbColor: AppColors.primary,
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[300],
                ),

                const SizedBox(width: 12),

                // Acceptance Text
                Expanded(
                  child: Text(
                    "accept_terms_and_conditions".tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                // Reject Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "reject".tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Accept Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAccepted ? widget.onAccept : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isAccepted ? AppColors.primary : Colors.grey[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "accept".tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
