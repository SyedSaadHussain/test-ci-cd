
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/app_visit_list_card.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_stage_selector.dart';
import 'package:mosque_management_system/features/visit/regular/list/visit_regular_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/offline_toggle.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitRegularListScreen extends StatefulWidget {
   final String title;
   const VisitRegularListScreen({super.key,required this.title});

  @override
  State<VisitRegularListScreen> createState() => _VisitRegularListScreenState();
}

 class _VisitRegularListScreenState extends BaseState<VisitRegularListScreen> with TickerProviderStateMixin {


  //region Lifecycle
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VisitListViewModel<RegularVisitModel>>()  as  VisitRegularListViewModel;

    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.title),
        actions: [
          Selector<VisitListViewModel<RegularVisitModel>, bool?>(
              selector: (_, vm) => (vm.isOfflineView),
              builder: (_, val, __) {
              return offlineToggle(
                isOfflineView: vm.isOfflineView,
                onChanged: (value) {
                  vm.onToggleOffilne(value);
                },
              );
            }
          ),
        ],
      ),
      body: Selector<VisitListViewModel<RegularVisitModel>, bool?>(
          selector: (_, vm) => (vm.isOfflineView),
          builder: (_, val, __) {
          return
            vm.isOfflineView?
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Consumer<VisitListViewModel<RegularVisitModel>>(
                    builder: (_, vm, __) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        itemCount: vm.offlineVisits.length,
                        itemBuilder: (context, index) {
                          var visit = vm.offlineVisits[index];

                          return  AppVisitListCard(visit: visit,);

                        }
                      ),
                    );
                  }
                ),
              )
            ]): Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VisitStageSelector<RegularVisitModel>(),
                AppSearchInputField(onSearch: (val){
                  vm.query=val;
                  vm.getVisits(true);
                }),
                Expanded(
                  child: Consumer<VisitListViewModel<RegularVisitModel>>(
                      builder: (_, vm, __) {
                        return
                          PaginatedListView<RegularVisitModel>(
                            paginatedList: vm.paginatedVisits,
                            onLoadMore: vm.getVisits,
                            itemBuilder: (visit) => AppVisitListCard(visit: visit),
                          );
                      }
                  ),
                )
              ],
            );
        }
      ),
    );
  }
}
