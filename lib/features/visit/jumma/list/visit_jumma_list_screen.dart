import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/data/services/custom_odoo_client.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/app_visit_list_card.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_stage_selector.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_screen.dart';
import 'package:mosque_management_system/features/visit/jumma/form/visit_jumma_form_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/list/visit_jumma_list_view_model.dart';
import 'package:mosque_management_system/features/visit/jumma/view/visit_jumma_view_screen.dart';
import 'package:mosque_management_system/features/visit/jumma/view/visit_jumma_view_model.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_screen.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/offline_toggle.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitJummaListScreen extends StatefulWidget {
   final String title;
   const VisitJummaListScreen({super.key,required this.title});

  @override
  State<VisitJummaListScreen> createState() => _VisitJummaListScreenState();
}

 class _VisitJummaListScreenState  extends BaseState<VisitJummaListScreen> with TickerProviderStateMixin {


   //region Lifecycle
   @override
   void initState() {
     super.initState();
   }


   @override
   Widget build(BuildContext context) {
     final vm = context.watch<VisitListViewModel<VisitJummaModel>>()  as  VisitJummaListViewModel;

     return Scaffold(
       appBar: AppBar(
         title:  Text(widget.title),
         actions: [
           Selector<VisitListViewModel<VisitJummaModel>, bool?>(
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
       body: Selector<VisitListViewModel<VisitJummaModel>, bool?>(
           selector: (_, vm) => (vm.isOfflineView),
           builder: (_, val, __) {
             return
               vm.isOfflineView?
               Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: Consumer<VisitListViewModel<VisitJummaModel>>(
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
                   VisitStageSelector<VisitJummaModel>(),
                   AppSearchInputField(onSearch: (val){
                     vm.query=val;
                     vm.getVisits(true);
                   }),
                   Expanded(
                     child: Consumer<VisitListViewModel<VisitJummaModel>>(
                         builder: (_, vm, __) {
                           return PaginatedListView<VisitJummaModel>(
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
