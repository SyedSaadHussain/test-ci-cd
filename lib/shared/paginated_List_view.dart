import 'package:flutter/material.dart';
import 'package:mosque_management_system/shared/widgets/no_data.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import '../core/utils/paginated_list.dart';

class PaginatedListView<T> extends StatelessWidget {
  final PaginatedList<T> paginatedList;
  final Future<void> Function(bool isRefresh) onLoadMore;
  final Widget Function(T item) itemBuilder;
  final EdgeInsetsGeometry padding;
  final double loadingHeight;

  const PaginatedListView({
    Key? key,
    required this.paginatedList,
    required this.onLoadMore,
    required this.itemBuilder,
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.loadingHeight = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child:  (paginatedList.noRecord)?
      Column(
        children: [
          NoDataFound(),
        ],
      ):ListView.builder(
        itemCount: paginatedList.list.length + (paginatedList.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= paginatedList.list.length) {
            // Trigger loading more items
            if (!paginatedList.isLoading) {
              paginatedList.pageIndex=paginatedList.pageIndex+1;
              onLoadMore(false);
            }
            return SizedBox(
              height: loadingHeight,
              child:
                        Container(
                            height: 100,
                            child: ProgressBar(opacity: 0))
              // const Center(child: CircularProgressIndicator()),
            );
          } else {
            final item = paginatedList.list[index];
            return itemBuilder(item);
          }
        },
      ),
    );
  }
}