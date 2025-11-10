import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/khutba_management.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/paginated_list.dart';
import 'package:mosque_management_system/data/services/user_service.dart';

class KhutbaListViewModel extends ChangeNotifier {
  final UserService userService;
  Function?  showDialogCallback;
  // KhutbaManagementData khutbaData = KhutbaManagementData();
  final PaginatedList<KhutbaManagement> khutbaData =PaginatedList<KhutbaManagement>();

  KhutbaListViewModel(this.userService,this.showDialogCallback);

  Future<void> getAllKhutbas({bool isReload = false}) async {

    if (isReload) {
      khutbaData.reset();
    }

    khutbaData.init();
    notifyListeners();

    try {
      final value = await userService.getAllKhutbas(
        khutbaData.pageSize,
        khutbaData.pageIndex,
        "",
      );

      khutbaData.isLoading = false;
      if (value.list.isEmpty) {
        khutbaData.hasMore = false;
      } else {
        khutbaData.list!.addAll(value.list!.toList());
      }
    } catch (e) {
      khutbaData.isLoading = false;
      khutbaData.hasMore = false;
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));

    } finally {
      notifyListeners();
    }
  }
}