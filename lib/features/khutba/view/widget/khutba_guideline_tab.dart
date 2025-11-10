import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';

class KhutbaGuidelineTab extends StatelessWidget {
  final KhutbaManagement khutba;
  final Map<String, String> style;

  const KhutbaGuidelineTab({
    super.key,
    required this.khutba,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    final guidelines = [
      khutba.guideline_1,
      khutba.guideline_2,
      khutba.guideline_3,
      khutba.guideline_4,
      khutba.guideline_5,
    ].where((e) => AppUtils.isNotNullOrEmpty(e)).toList();

    // If all guidelines are empty, don't show anything
    if (guidelines.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: guidelines.length,
      itemBuilder: (context, index) {
        final text = guidelines[index]!;

        return AppListItemBorder(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.backgroundColor,
                child: Text("${index + 1}", style: AppTextStyles.heading1),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: HtmlWidget(
                  text,
                  customStylesBuilder: (element) {
                    element.attributes.clear();
                    return style;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}