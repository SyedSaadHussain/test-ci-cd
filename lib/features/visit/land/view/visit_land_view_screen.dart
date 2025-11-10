
import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/land/view/visit_land_view_model.dart';
import 'package:mosque_management_system/features/visit/land/widget/view/view_buildings_infrastructure_section.dart';
import 'package:mosque_management_system/features/visit/land/widget/view/view_completion_notes_section.dart';
import 'package:mosque_management_system/features/visit/land/widget/view/view_env_conditions_section.dart';
import 'package:mosque_management_system/features/visit/land/widget/view/view_land_basic_info_section.dart';
import 'package:mosque_management_system/features/visit/land/widget/view/view_land_type_section.dart';
import 'package:mosque_management_system/features/visit/land/widget/view/view_utilities_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/approve_visit_button.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitLandViewScreen extends StatefulWidget {
  final VisitModelBase visit;
  final Function? onCallback;
  const VisitLandViewScreen({super.key, required this.visit,this.onCallback});

  @override
  State<VisitLandViewScreen> createState() => _VisitLandViewScreenState();
}

 class _VisitLandViewScreenState extends BaseState<VisitLandViewScreen> with TickerProviderStateMixin {

  //region Variables

    @override
    void initState() {
      super.initState();

      final vm = context.read<VisitViewModel<VisitLandModel>>();
      vm.tabController = TabController(length: vm.tabs.length, vsync: this);
      vm.showDialogCallback=((DialogMessage dialogMessage){
        if (!mounted) return;
        AppNotifier.showDialog(context,dialogMessage);
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.loadAPI();
      });
    }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitViewModel<VisitLandModel>>()  as  VisitLandViewViewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(VisitMessages.landVisit),
        actions: [
           VisitActionButton<VisitLandModel>()
        ],
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Expanded(
                          child:Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary.withOpacity(.2), // Border color
                                    width: 1.0, // Border width
                                  ),
                                ),
                                child: Container(
                                  child: TabBar(
                                    controller: vm.tabController,
                                    labelPadding: EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.zero,
                                    isScrollable:true,
                                    indicatorPadding: EdgeInsets.zero,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabAlignment: TabAlignment.start,
                                    indicator: BoxDecoration(
                                      color: AppColors.primary.withOpacity(.1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),

                                      ),
                                    ),
                                    unselectedLabelColor: Colors.grey.shade400,
                                    labelStyle: TextStyle(color: AppColors.primary,fontSize: 12),
                                    tabs:vm.tabs!.map<Widget>((dynamic tab) {
                                      // Here you can create the content for each tab
                                      return  Tab( child: Row(
                                        mainAxisSize: MainAxisSize.min, // Ensures that the row takes the minimum space
                                        mainAxisAlignment: MainAxisAlignment.center, // Centers the children within the Row
                                        children: [
                                          SizedBox(width: 3), // Optional spacing between icon and text
                                          Flexible(
                                            child: Text(
                                                tab.toString(),
                                                overflow: TextOverflow.ellipsis
                                            ),
                                          ),
                                        ],
                                      ));
                                    }).toList(),

                                  ),
                                ),
                              ),
                              Expanded(
                                child: Consumer<VisitViewModel<VisitLandModel>>(
                                    builder: (context, vm, _) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        child: TabBarView(
                                            controller: vm.tabController,
                                            // physics: const NeverScrollableScrollPhysics(),
                                            children:[
                                              ViewLandBasicInfoSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),
                                              ViewLandTypeSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),
                                              ViewBuildingsInfrastructureSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),
                                              ViewUtilitiesSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),
                                              ViewEnvConditionsSection(visit: vm.visitObj,fields: vm.fields,),
                                              ViewCompletionNotesSection(visit: vm.visitObj,fields: vm.fields,),
                                            ]
                                        ),
                                      );
                                    }
                                ),
                              ),



                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
          Selector<VisitViewModel<VisitLandModel>, bool>(
            selector: (_, vm) => vm.isLoading,
            builder: (_, isLoading, __) {
              if (isLoading)
                return ProgressBar();
              else
                return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
