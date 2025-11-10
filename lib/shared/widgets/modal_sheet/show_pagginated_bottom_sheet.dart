import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';


Future<T?> showPaginatedBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Function onChange,
  required PaginatedList<T> list,
  required Widget Function(T item) itemBuilder,
  required Function onLoadMore,
}) async {
  try {

    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return SafeArea(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---- Title ----
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        bottom: 10,
                        right: 15,
                        top: 10,
                      ),
                      child: Text(
                        title,
                        style: AppTextStyles.headingLG,
                      ),
                    ),

                    // ---- Search Field ----
                    AppSearchInputField(
                      onSearch: (val) {
                        // setState(() {
                        //   filteredItems = items
                        //       .where((item) => searchFilter(item, val))
                        //       .toList();
                        // });
                      },
                    ),

                    // ---- List ----
                    Expanded(
                      child: PaginatedListView<T>(
                        paginatedList: list,
                        onLoadMore:(isReload)=> onLoadMore(isReload),
                        itemBuilder: (T item) => ListTile(
                          title: itemBuilder(item),
                          onTap: () {
                            onChange(item);
                            Navigator.of(ctx).pop(item); // Return selected
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  } catch (e) {
    debugPrint("Error in showSelectionSheet: $e");
    return null;
  }
}