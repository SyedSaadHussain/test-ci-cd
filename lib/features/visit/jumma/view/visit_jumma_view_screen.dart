
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/visit/core/data/visit_repository.dart';

import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_basic_info_section.dart';
import 'package:mosque_management_system/features/visit/jumma/view/visit_jumma_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/approve_visit_button.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_building_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_dawah_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_device_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_imam_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_khateeb_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_khutba_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_maintenance_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_mosque_meter_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_mosque_status_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_safety_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_security_section.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitJummaViewScreen extends StatefulWidget {
  final VisitModel visit;
  final Function? onCallback;
  const VisitJummaViewScreen({super.key, required this.visit,this.onCallback});

  @override
  State<VisitJummaViewScreen> createState() => _VisitJummaViewScreenState();
}

 class _VisitJummaViewScreenState extends BaseState<VisitJummaViewScreen> with TickerProviderStateMixin {

  //region Variables

  //region Lifecycle
  @override
  void initState() {
    super.initState();

    final vm = context.read<VisitViewModel<VisitJummaModel>>();
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
    final vm = context.read<VisitViewModel<VisitJummaModel>>()  as  VisitJummaViewViewModel;

    return Scaffold(
      appBar: AppBar(
        title:   Text(VisitMessages.jummahVisit),
        actions: [
          VisitActionButton<VisitJummaModel>()
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
                                child: Consumer<VisitViewModel<VisitJummaModel>>(
                                    builder: (context, vm, _) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                        child: TabBarView(
                                            controller: vm.tabController,
                                            // physics: const NeverScrollableScrollPhysics(),
                                            children:[

                                              ViewBasicInfoSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),

                                              //mansoob
                                              ViewKhateebSection(visit: vm.visitObj,fields: vm.fields),

                                              ViewKhutbaSection(visit: vm.visitObj,fields: vm.fields),
                                              //meters
                                              ViewMosqueMeterSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),
                                              //building
                                              ViewBuildingSection(visit: vm.visitObj,fields: vm.fields,headersMap: vm.headerMap,),
                                              //device
                                              ViewDeviceSection(visit: vm.visitObj,fields: vm.fields),
                                              //safty
                                              ViewSafetySection(visit: vm.visitObj,fields: vm.fields),
                                              //Maintenance
                                              ViewMaintenanceSection(visit: vm.visitObj,fields: vm.fields),
                                              //Security
                                              ViewSecuritySection(visit: vm.visitObj,fields: vm.fields),
                                              //Dawah
                                              ViewDawahSection(visit: vm.visitObj,fields: vm.fields),
                                              //status
                                              ViewMosqueStatusSection(visit: vm.visitObj,fields: vm.fields),
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
          Selector<VisitViewModel<VisitJummaModel>, bool>(
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
