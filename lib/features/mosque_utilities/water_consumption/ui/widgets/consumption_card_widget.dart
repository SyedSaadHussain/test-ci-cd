import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../screens/water_mosque_details_screen.dart';
import 'invoice_display_widget.dart';

class ConsumptionCardWidget extends StatelessWidget {
  final String consumption;
  final String mosqueName;
  final String? mosqueNumber;
  final String? invoiceAmount;
  final String? meterNumber;
  final int? meterId;

  const ConsumptionCardWidget({
    super.key,
    required this.consumption,
    required this.mosqueName,
    this.mosqueNumber,
    this.invoiceAmount,
    this.meterNumber,
    this.meterId,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WaterMosqueDetailsScreen(
              mosqueName: mosqueName,
              consumption: consumption,
              meterId: meterId,
              meterNumber: meterNumber,
              mosqueNumber: mosqueNumber,
            ),
          ),
        );
      },
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryContainer.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primaryContainer.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.water_drop,
              color: AppColors.primaryContainer,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      consumption,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (invoiceAmount != null)
                      InvoiceDisplayWidget(amount: invoiceAmount!),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  mosqueName,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (mosqueNumber != null)
                      _InfoChip(
                        icon: Icons.confirmation_number_outlined,
                        label: 'رقم المسجد التسلسلي',
                        value: mosqueNumber!,
                      ),
                    if (meterNumber != null)
                      _InfoChip(
                        icon: Icons.speed_outlined,
                        label: 'رقم العداد',
                        value: meterNumber!,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryContainer.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryContainer),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.9),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.primaryContainer.withOpacity(0.15)),
            ),
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

