import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/FullImageViewer.dart';

class AppImageView extends StatelessWidget {
  final Function? onTab;
  final String title;
  final dynamic value;
  final dynamic headersMap;

  const AppImageView({
    Key? key,
    this.onTab,
    this.title = "",
    this.value,
    this.headersMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text = (value ?? '').toString();

    return Column(
      children: [
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    style: AppTextStyles.formLabel.copyWith(
                      color: Colors.black.withOpacity(.3),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    // print('ssssss');
                    if (onTab != null) {
                      onTab!();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(
                            title: title,
                            imageUrl: value,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: AppColors.backgroundColor,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        value ?? '',
                        headers: headersMap,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (BuildContext context, Object error, StackTrace? stackTrace) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey.shade300,
                              size: 65,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: Colors.grey.shade200, height: 1),
      ],
    );
  }
}