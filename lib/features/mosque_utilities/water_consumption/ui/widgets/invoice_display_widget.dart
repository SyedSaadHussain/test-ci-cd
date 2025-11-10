import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class InvoiceDisplayWidget extends StatelessWidget {
  final String amount;
  final bool isCompact;
  final Color? textColor;

  const InvoiceDisplayWidget({
    super.key,
    required this.amount,
    this.isCompact = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.primaryContainer.withOpacity(0.8),
            width: 1,
          ),
        ),
        child: Text(
          amount,
          style: TextStyle(
            color: textColor ?? AppColors.primaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.receipt_outlined,
            color: AppColors.accent,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            'Invoice: $amount',
            style: TextStyle(
              color: textColor ?? AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }
  }
}


