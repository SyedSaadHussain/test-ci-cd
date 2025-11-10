import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/edit_request/form/create_mosque_edit_view_model.dart';
import 'package:mosque_management_system/features/mosque/mosqueTabs/maintenance_operation_tab.dart';
import 'package:mosque_management_system/features/mosque/widget/tabs_bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';

import 'package:mosque_management_system/features/mosque/mosqueTabs/audio_and_electronics_tab.dart';
import 'package:mosque_management_system/features/mosque/mosqueTabs/mosque_land_tab.dart';
import 'package:mosque_management_system/features/mosque/mosqueTabs/women_prayer_section_tab.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../core/models/mosque_local.dart';
import '../../../../data/repositories/common_repository.dart';
import '../../core/data/mosque_repository.dart';
import '../../../../data/services/custom_odoo_client.dart';
import '../../core/data/mosque_service.dart';
import '../../../../data/services/user_service.dart';
import '../../../../core/constants/config.dart';


import '../../mosqueTabs/basic_info_tab.dart';
import '../../mosqueTabs/employee_info_tab.dart';
import '../../mosqueTabs/logic/validation_scope.dart';
import '../../mosqueTabs/meters_tab.dart';
import '../../mosqueTabs/mosque_address_tab.dart';
import '../../mosqueTabs/mosque_condition_tab.dart';
import '../../mosqueTabs/architectural_structure.dart';
import '../../mosqueTabs/man_prayer_section_tab.dart';
import '../../mosqueTabs/imams_muezzins_details_tab.dart';
import '../../mosqueTabs/safety_equipment_tab.dart';
import '../../mosqueTabs/historical_mosques_tab.dart';
import '../../mosqueTabs/mosque_facilities_tab.dart';



import '../../mosqueTabs/QR_code_panel.dart';

class CreateMosqueScreen extends StatefulWidget {
  final int? mosqueId; // server id (optional)
  final String? localId; // hive id (preferred for offline)
  final bool createIfMissing;
  final Future<MosqueLocal?> Function(String localId)? customLocalLoader;
  final Future<void> Function(String tabKey)? onTabOpened;

  const CreateMosqueScreen({super.key, this.mosqueId, this.localId, this.createIfMissing = true, this.customLocalLoader, this.onTabOpened // NEW
  });
  @override
  State<CreateMosqueScreen> createState() => _CreateMosqueScreenState();
}

class _CreateMosqueScreenState extends BaseState<CreateMosqueScreen>
    with TickerProviderStateMixin  {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late UserService _userService;
  late MosqueRepository _mosqueService;

  @override
  void initState() {
    super.initState();
    final vm = context.read<CreateMosqueBaseViewModel>();
    vm.showDialogCallback=((DialogMessage dialogMessage){
      if (!mounted) return;
      AppNotifier.showDialog(context,dialogMessage);
    });
    vm.tabController = TabController(length: vm.tabs.length, vsync: this);
    vm.onChangeTabs=((){
      print('onChangeTabs...');
      int currentIndex=vm.tabController!.index;
      // Dispose old TabController before recreating
      vm.tabController?.dispose();
      vm.tabController = TabController(length: vm.tabs.length, vsync: this);
      vm.notifyListeners();
      vm.tabController!.animateTo(currentIndex);
      ///Mosque already created on database, now its on drat state and form fill by API
      if(vm.mosqueObj.serverId!=null){
        vm.addTabController();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_)  async{
      // vm.notifyListeners();
      await vm.init();
      // vm.notifyListeners();
      _initServices();
      if (mounted) vm.notifyListeners();

      });
  }

  // -------------------- services --------------------
  void _initServices() {
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);
    final repo = CommonRepository(client);
    _userService = UserService(client);
    final mosqueRepo = MosqueService(client);   // NEW
    _mosqueService = MosqueRepository();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('create_mosque'.tr()),
            bottom: null,
          ),

          body: Column(
            children: [
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    // 🔁 CHANGED: disable tab navigation
                    child: IgnorePointer(ignoring: true, // <-- CHANGED
                      child: TabBar(
                        controller: vm.tabController,
                        isScrollable: true,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                        indicatorPadding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppColors.primary.withOpacity(.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        unselectedLabelColor: Colors.grey.shade400,
                        labelColor: AppColors.primary,
                        labelStyle: const TextStyle(fontSize: 12),
                        tabs: vm.tabs.map((t) {
                          return Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    t,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),

              // ---- Tab content ----
              Expanded(
                child: Form(
                  key: vm.formDetailKey,
                  child: TabBarView(
                    controller: vm.tabController,
                    // 🔁 CHANGED: disable swipe navigation
                    physics: const NeverScrollableScrollPhysics(), // <-- CHANGED
                    children: [
                      BasicInfoTab(),
                      MosqueAddressTab(
                        local: vm.mosqueObj,
                        editing: true,
                      ),
                      MosqueConditionTab(
                        local: vm.mosqueObj,
                        editing: true,
                        // onRulesChange: _applyConditionRule,
                        fields: vm.fields,
                        // onRulesChange: (show) => setState(() => _showDependentTabs = show),
                      ),

                      if(vm.mosqueObj.mosqueCondition=='abandoned_mosque' || vm.mosqueObj.mosqueCondition=='existing_mosque')
                        ...[
                          ArchitecturalStructureTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                          MenPrayerSectionTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                          WomenPrayerSectionTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                          if (!vm.hideEmployeeInfoTab)
                            EmployeeInfoTab(
                                local: vm.mosqueObj,
                                editing: true,
                                fields: vm.fields),

                          ImamsMuezzinsDetailsTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                          MosqueFacilitiesTab(
                            local: vm.mosqueObj,
                            editing: true,
                            updateLocal: (m){
                            },
                            fields: vm.fields,),
                          MosqueLandTab(
                              local: vm.mosqueObj,
                              editing: true,
                              fields : vm.fields),
                          AudioElectronicsTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                          SafetyEquipmentTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields:vm.fields,),
                          MaintenanceOperationTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                          MetersTab(
                            local: vm.mosqueObj,
                            editing: true,
                          ),
                          HistoricalMosquesTab(
                              local: vm.mosqueObj,
                              editing: true,
                              fields:vm.fields),
                          QrCodePanelTab(
                            local: vm.mosqueObj,
                            editing: true,
                            fields: vm.fields,),
                        ]
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabsBottomNavigation(),
            ),
          ),
        ),
        Selector<CreateMosqueBaseViewModel, bool>(
          selector: (_, vm) => vm.isLoading,
          builder: (_, isLoading, __) {
            if (isLoading)
              return ProgressBar();
            else
              return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}