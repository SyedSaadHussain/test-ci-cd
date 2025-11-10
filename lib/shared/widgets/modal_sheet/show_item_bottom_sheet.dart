import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/no_data.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';

Future<ComboItem?> showItemBottomSheet({
  required BuildContext context,
  String? title,
  String? emptyLabel,
  required Function(ComboItem) onChange,
  List<ComboItem>? items,
  Future<List<ComboItem>> Function()? onLoadItems, // <-- optional async loader
}) async {
  try {
    return await showModalBottomSheet<ComboItem>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return _BottomSheetContent(
          title: title,
          emptyLabel: emptyLabel,
          initialItems: items,
          onChange: onChange,
          onLoadItems: onLoadItems,
        );
      },
    );
  } catch (e) {
    debugPrint("Error in showItemBottomSheet: $e");
    return null;
  }
}

class _BottomSheetContent extends StatefulWidget {
  final String? title;
  final String? emptyLabel;
  final List<ComboItem>? initialItems;
  final Future<List<ComboItem>> Function()? onLoadItems;
  final Function(ComboItem) onChange;

  const _BottomSheetContent({
    required this.onChange,
    this.title,
    this.emptyLabel,
    this.initialItems,
    this.onLoadItems,
  });

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  List<ComboItem> items = [];
  List<ComboItem> filteredItems = [];
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
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(
                  left: 15, bottom: 10, right: 15, top: 0,
                ),
                child: Text(widget.title!, style: AppTextStyles.headingLG),
              ),

            AppSearchInputField(
              onSearch: (val) {
                setState(() {
                  filteredItems = items
                      .where((item) => (item.value ?? "")
                      .toLowerCase()
                      .contains(val.toLowerCase()))
                      .toList();
                });
              },
              onChange: (val) {
                setState(() {
                  filteredItems = items
                      .where((item) => (item.value ?? "")
                      .toLowerCase()
                      .contains(val.toLowerCase()))
                      .toList();
                });
              },
            ),

            Expanded(
              child: isLoading?Center(child: WaveLoader()):
               filteredItems.length>0?
              ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (itemCtx, i) {
                  final item = filteredItems[i];
                  return ListTile(
                    title: Text(item.value ?? "", style: AppTextStyles.cardTitle),
                    onTap: () {
                      widget.onChange(item);
                      Navigator.of(context).pop(item);
                    },
                  );
                },
              ):Column(
                 children: [
                   NoDataFound(label: widget.emptyLabel,),
                 ],
               ),
            ),
          ],
        ),
      ),
    );
  }
}