import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/app_visit_list_card.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_stage_selector.dart';
import 'package:mosque_management_system/features/visit/female/form/visit_female_form_screen.dart';
import 'package:mosque_management_system/features/visit/female/form/visit_female_form_view_model.dart';
import 'package:mosque_management_system/features/visit/female/list/visit_female_list_view_model.dart';
import 'package:mosque_management_system/features/visit/female/view/visit_female_view_screen.dart';
import 'package:mosque_management_system/features/visit/female/view/visit_female_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/offline_toggle.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/image_circle.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitFemaleListScreen extends StatefulWidget {
   final String title;
   const VisitFemaleListScreen({super.key,required this.title});

  @override
  State<VisitFemaleListScreen> createState() => _VisitFemaleListScreenState();
}

 class _VisitFemaleListScreenState extends BaseState<VisitFemaleListScreen> with TickerProviderStateMixin {

   @override
   void initState() {
     super.initState();
   }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VisitListViewModel<VisitFemaleModel>>()  as  VisitFemaleListViewModel;
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.title),
        actions: [
          Selector<VisitListViewModel<VisitFemaleModel>, bool?>(
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
      body: Selector<VisitListViewModel<VisitFemaleModel>, bool?>(
          selector: (_, vm) => (vm.isOfflineView),
          builder: (_, val, __) {
            return
              vm.isOfflineView?
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Consumer<VisitListViewModel<VisitFemaleModel>>(
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
                  VisitStageSelector<VisitFemaleModel>(),
                  AppSearchInputField(onSearch: (val){
                    vm.query=val;
                    vm.getVisits(true);
                  }),
                  Expanded(
                    child: Consumer<VisitListViewModel<VisitFemaleModel>>(
                        builder: (_, vm, __) {
                          return PaginatedListView<VisitFemaleModel>(
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
