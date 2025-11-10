import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
Widget violationGuidelinesSection() {
  final guidelines = [
    {
      'icon': Icons.camera_alt_outlined,
      'text': 'يجب أن تكون صورة التعدي أو المخالفة واضحة ومن زوايا مختلفة',
    },
    {
      'icon': Icons.light_mode_outlined,
      'text': 'ضمان جودة الصورة من حيث الإضاءة والتركيز',
    },
    {
      'icon': Icons.visibility_off_outlined,
      'text': 'تجنب العوائق البصرية مثل الظلال والانعكاسات أو تغطية عنصر المخالفة',
    },
  ];

  return Container(
    margin: const EdgeInsets.only(bottom: 0,top: 15),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppColors.info.withOpacity(.1),
      borderRadius: BorderRadius.circular(16),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.05),
      //     blurRadius: 8,
      //     offset: const Offset(0, 2),
      //   ),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إرشادات تصوير المخالفة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.info
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 10),
        ...guidelines.map((item) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl, // important for Arabic layout
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: AppColors.gray,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['text'] as String,
                      style: AppTextStyles.formLabel,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          );
        }).toList(),
      ],
    ),
  );
}