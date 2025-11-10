
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/app_visit_list_card.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_stage_selector.dart';
import 'package:mosque_management_system/features/visit/ondemand/list/visit_ondemand_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/offline_toggle.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitOndemandListScreen extends StatefulWidget {
   final String title;
   const VisitOndemandListScreen({super.key,required this.title});

  @override
  State<VisitOndemandListScreen> createState() => _VisitOndemandListScreenState();
}

 class _VisitOndemandListScreenState extends BaseState<VisitOndemandListScreen> with TickerProviderStateMixin {

   @override
   void initState() {
     super.initState();

   }


  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitListViewModel<VisitOndemandModel>>()  as  VisitOndemandListViewModel;
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.title),
        actions: [
          Selector<VisitListViewModel<VisitOndemandModel>, bool?>(
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
      body: Selector<VisitListViewModel<VisitOndemandModel>, bool?>(
          selector: (_, vm) => (vm.isOfflineView),
          builder: (_, val, __) {
            return
              vm.isOfflineView?
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Consumer<VisitListViewModel<VisitOndemandModel>>(
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
                  VisitStageSelector<VisitOndemandModel>(),
                  AppSearchInputField(onSearch: (val){
                    vm.query=val;
                    vm.getVisits(true);
                  }),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      if(appUserProvider.userProfile.classificationId!=VisitDefaults.observerId)
                        AppButtonSmall(text: VisitMessages.createVisit ,onTab: (){
                          vm.onCreateVisit(context);
                        },icon: Icons.person_add,color: AppColors.primary),
                    ],
                  ),
                  Expanded(
                    child: Consumer<VisitListViewModel<VisitOndemandModel>>(
                        builder: (_, vm, __) {
                          return PaginatedListView<VisitOndemandModel>(
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
