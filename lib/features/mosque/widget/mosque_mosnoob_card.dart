import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';

import 'package:mosque_management_system/core/styles/app_text_styles.dart';

import 'package:mosque_management_system/shared/widgets/cards/app_card.dart';
import 'package:provider/provider.dart';

class MosqueMansoobCard extends StatelessWidget {
  final UserProfile user ;
  final Widget? footer; // optional extra content inside the card (below default info)

  const MosqueMansoobCard({
    super.key,
    required this.user,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // tighter
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // smaller radius
          border: Border.all(color: Colors.black12, width: 0.8), // thin border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Compact name row
            Row(
              children: [
                CircleAvatar(
                  radius: 14, // smaller avatar
                  backgroundColor: AppColors.primary.withOpacity(0.08),
                  foregroundColor: AppColors.primary,
                  child: const Icon(Icons.person, size: 16),
                ),
                const SizedBox(width: 8), // tighter gap
                Expanded(
                  child: Text(
                    (user.name ?? '').isNotEmpty ? user.name! : '—',
                    style: AppTextStyles.cardTitle.copyWith(height: 1.1), // tighter line-height
                    maxLines: 1, // one line only
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8), // tighter
            Divider(height: 1, thickness: 0.6, color: Colors.black12),
            const SizedBox(height: 6), // tighter

            // ===== One-line rows: "Label: Value"
            _kvRowOneLine('رقم الهوية', user.identificationId?.toString() ?? ''),
            const SizedBox(height: 4), // tighter
            _kvRowOneLine('رقم الجوال', user.phone?.toString() ?? ''),
            if (footer != null) ...[
              const SizedBox(height: 8),
              Divider(height: 1, thickness: 0.6, color: Colors.black12),
              const SizedBox(height: 6),
              footer!,
            ]
          ],
        ),
      ),
    );  }
}

Widget _kvRow(String label, String value) {
  final v = value.trim().isEmpty ? '—' : value.trim();
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Optional icon (remove if you want pure text)
      // const Icon(Icons.label_outline, size: 16, color: Colors.grey),
      // const SizedBox(width: 6),

      // Use RichText to keep label+value on the SAME line
      Expanded(
        child: RichText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$label: ',
                style: AppTextStyles.cardSubTitle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
              TextSpan(
                text: v,
                style: AppTextStyles.cardSubTitle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
Widget _kvRowOneLine(String label, String value) {
  final v = value.trim().isEmpty ? '—' : value.trim();
  return RichText(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(
      children: [
        TextSpan(
          text: '$label: ',
          style: AppTextStyles.cardSubTitle.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade700,
            height: 1.1, // tighter
          ),
        ),
        TextSpan(
          text: v,
          style: AppTextStyles.cardSubTitle.copyWith(
            fontWeight: FontWeight.w500,
            height: 1.1, // tighter
          ),
        ),
      ],
    ),
  );
}
