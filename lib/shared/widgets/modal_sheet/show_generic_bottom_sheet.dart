import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';

Future<T?> showGenericBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Function(T) onChange,
  List<T>? items, // optional preloaded items
  Future<List<T>> Function()? onLoadItems, // optional async loader
  required Widget Function(T item) itemBuilder,
  required bool Function(T item, String query) searchFilter,
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
        return _GenericBottomSheetContent<T>(
          title: title,
          initialItems: items,
          onLoadItems: onLoadItems,
          onChange: onChange,
          itemBuilder: itemBuilder,
          searchFilter: searchFilter,
        );
      },
    );
  } catch (e) {
    debugPrint("Error in showGenericBottomSheet: $e");
    return null;
  }
}

class _GenericBottomSheetContent<T> extends StatefulWidget {
  final String title;
  final List<T>? initialItems;
  final Future<List<T>> Function()? onLoadItems;
  final Function(T) onChange;
  final Widget Function(T item) itemBuilder;
  final bool Function(T item, String query) searchFilter;

  const _GenericBottomSheetContent({
    required this.title,
    required this.onChange,
    required this.itemBuilder,
    required this.searchFilter,
    this.initialItems,
    this.onLoadItems,
  });

  @override
  State<_GenericBottomSheetContent<T>> createState() =>
      _GenericBottomSheetContentState<T>();
}

class _GenericBottomSheetContentState<T>
    extends State<_GenericBottomSheetContent<T>> {
  List<T> items = [];
  List<T> filteredItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    if (widget.initialItems != null) {
      items = widget.initialItems!;
      filteredItems = items;
      setState(() {});
    } else if (widget.onLoadItems != null) {
      setState(() => isLoading = true);
      try {
        items = await widget.onLoadItems!();
        filteredItems = items;
      } catch (e) {
        debugPrint("Error loading items: $e");
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Title ----
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, bottom: 10, right: 15, top: 10),
              child: Text(widget.title, style: AppTextStyles.headingLG),
            ),

            // ---- Search Field ----
            AppSearchInputField(
              onSearch: _filterItems,
              onChange: _filterItems,
            ),

            // ---- List ----
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final item = filteredItems[i];
                  return ListTile(
                    title: widget.itemBuilder(item),
                    onTap: () {
                      widget.onChange(item);
                      Navigator.of(context).pop(item);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems =
          items.where((item) => widget.searchFilter(item, query)).toList();
    });
  }
}