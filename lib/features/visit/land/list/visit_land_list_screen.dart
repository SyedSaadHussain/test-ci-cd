import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/app_visit_list_card.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_stage_selector.dart';
import 'package:mosque_management_system/features/visit/land/list/visit_land_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/offline_toggle.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitLandListScreen extends StatefulWidget {
   final String title;
   const VisitLandListScreen({super.key,required this.title});

  @override
  State<VisitLandListScreen> createState() => _VisitLandListScreenState();
}

 class _VisitLandListScreenState extends BaseState<VisitLandListScreen> with TickerProviderStateMixin {


   @override
   void initState() {
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VisitListViewModel<VisitLandModel>>()  as  VisitLandListViewModel;

    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.title),
        actions: [
          offlineToggle(
            isOfflineView: vm.isOfflineView,
            onChanged: (value) {
              vm.onToggleOffilne(value);
            },
          ),
        ],
      ),
      body: vm.isOfflineView?
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer<VisitListViewModel<VisitLandModel>>(
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
          VisitStageSelector<VisitLandModel>(),
          AppSearchInputField(onSearch: (val){
            vm.query=val;
            vm.getVisits(true);
          }),
          Expanded(
            child: PaginatedListView<VisitLandModel>(
              paginatedList: vm.paginatedVisits,
              onLoadMore: vm.getVisits,
              itemBuilder: (visit) => AppVisitListCard(visit: visit),
            ),
          )
        ],
      ),
    );
  }
}
