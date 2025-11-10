import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

class KhutbaDescriptionTab extends StatelessWidget {
  final KhutbaManagement khutba;
  final FieldListData fields;
  final Map<String, String> style;

  const KhutbaDescriptionTab({
    super.key,
    required this.khutba,
    required this.fields,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row (title, new/eid tags)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(khutba.name ?? "", style: AppTextStyles.defaultHeading1),
              ),
              if (khutba.isNewKhutba)
                AppTag(title: 'new', color: AppColors.success),
              if (khutba.isKhutbaEid ?? false)
                AppTag(title: fields.getField('is_khutba_eid').label, color: AppColors.info),
            ],
          ),
          const SizedBox(height: 5),

          /// Date
          Text(khutba.khutbaDate ?? "", style: AppTextStyles.hint),
          const SizedBox(height: 10),

          /// Description content
          Expanded(
            child: SingleChildScrollView(
              child: HtmlWidget(
                khutba.description ?? "",
                customStylesBuilder: (element) {
                  element.attributes.clear();
                  return style;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}