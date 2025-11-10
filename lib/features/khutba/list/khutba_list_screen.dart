import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/khutba/view/khutba_detail_screen.dart';
import 'package:mosque_management_system/features/khutba/list/khutba_list_view_model.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';
import 'package:mosque_management_system/shared/widgets/no_data.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:provider/provider.dart';

class KhutbaListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userService = UserService(
      context.read<UserProvider>().client!,
      userProfile: context.read<UserProvider>().userProfile,
    );

    return ChangeNotifierProvider(
      create: (_) => KhutbaListViewModel(userService,
          ((DialogMessage dialogMessage){
            AppNotifier.showDialog(context,dialogMessage);
          })
      )
        // ..getAllKhutbas(isReload: true)
      ,
      child: const _KhutbaListBody(),
    );
  }
}

class _KhutbaListBody extends StatelessWidget {
  const _KhutbaListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<KhutbaListViewModel>();;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          AppBackground(),
          Column(
            children: [
              AppCustomBar(title: 'all_khutbas'.tr(), actions: []),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: AppBoxDecoration.mainBody,
                  child: PaginatedListView<KhutbaManagement>(
                                paginatedList: vm.khutbaData,
                                // onLoadMore: (isReload) =>
                                onLoadMore: (isReload) async {

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    vm.getAllKhutbas(isReload: isReload);
                                  });
                                },
                                itemBuilder: (KhutbaManagement khutba) => AppListItem(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KhutbaDetail(id: khutba.id!),
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                khutba.name ?? "",
                                style: AppTextStyles.cardTitleHeading,
                                softWrap: true, // allow wrapping
                                maxLines: null, // unlimited lines (text can expand)
                              ),
                            ),
                            if (khutba.isNewKhutba)
                              AppTagSm(
                                title: 'new'.tr(),
                                color: AppColors.success,
                              ),
                          ],
                        ),
                        Text(
                          khutba.khutbaDate ?? "",
                          style: AppTextStyles.hint.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          khutba.text ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.cardTitle,
                        ),
                      ],
                    ),
                  ),
                                ),
                                ),
                )

                //
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   decoration: AppBoxDecoration.mainBody,
                //   child: khutbaData.list!.isEmpty && !khutbaData.isloading
                //       ? NoDataFound()
                //       : ListView.builder(
                //     itemCount: khutbaData.list!.length +
                //         (khutbaData.hasMore ? 1 : 0),
                //     itemBuilder: (context, index) {
                //       if (index >= khutbaData.list!.length) {
                //         if (!khutbaData.isloading) {
                //           vm.getAllKhutbas();
                //         }
                //         return Container(
                //             height: 10,
                //             child: ProgressBar(opacity: 0));
                //       }
                //       final khutba = khutbaData.list![index];
                //       return ;
                //     },
                //   ),
                // ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}