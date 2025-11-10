import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_service.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/app_visit_list_card.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_stage_selector.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/list/visit_eid_list_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/view/visit_eid_view_screen.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/features/visit/eid/form/visit_eid_form_screen.dart';
import 'package:mosque_management_system/features/visit/eid/view/visit_eid_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/offline_toggle.dart';
import 'package:mosque_management_system/shared/paginated_List_view.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_search_input_field.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitEidListScreen extends StatefulWidget {
  final String title;
  const VisitEidListScreen({super.key,required this.title});

  @override
  State<VisitEidListScreen> createState() => _VisitEidListScreenState();
}

 class _VisitEidListScreenState extends BaseState<VisitEidListScreen> with TickerProviderStateMixin {

   //region Lifecycle
   @override
   void initState() {
     super.initState();
   }
   
   @override
   Widget build(BuildContext context) {
     final vm = context.watch<VisitListViewModel<VisitEidModel>>()  as  VisitEidListViewModel;
     return Scaffold(
       appBar: AppBar(
         title:   Text(widget.title),
         actions: [
           Selector<VisitListViewModel<VisitEidModel>, bool?>(
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
       body: Selector<VisitListViewModel<VisitEidModel>, bool?>(
           selector: (_, vm) => (vm.isOfflineView),
           builder: (_, val, __) {
             return
               vm.isOfflineView?
               Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(
                       child: Consumer<VisitListViewModel<VisitEidModel>>(
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
                   VisitStageSelector<VisitEidModel>(),
                   AppSearchInputField(onSearch: (val){
                     vm.query=val;
                     vm.getVisits(true);
                   }),
                   Expanded(
                     child: Consumer<VisitListViewModel<VisitEidModel>>(
                         builder: (_, vm, __) {
                           return PaginatedListView<VisitEidModel>(
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
