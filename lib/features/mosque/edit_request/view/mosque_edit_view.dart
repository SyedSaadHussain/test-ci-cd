import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:provider/provider.dart';

import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';

import 'package:mosque_management_system/features/mosque/edit_request/view/mosque_edit_view_model.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

// your sections
import '../../core/approve_mosque_button.dart';
import '../../widget/view/mosque_basic_info_section.dart';
import '../../widget/view/mosque_address_section.dart';
import '../../widget/view/mosque_condition_section.dart';
import '../../widget/view/architectural_structure_section.dart';
import '../../widget/view/men_prayer_section.dart';
import '../../widget/view/women_prayer_section.dart';
import '../../widget/view/residence_section.dart';
import '../../widget/view/facilities_section.dart';
import '../../widget/view/land_section.dart';
import '../../widget/view/audio_electronics_section.dart';
import '../../widget/view/safety_section.dart';
import '../../widget/view/maintenance_section.dart';
import '../../widget/view/meters_section.dart';
import '../../widget/view/historical_section.dart';
import '../../widget/view/qrcode_section.dart';

class MosqueEditView extends StatefulWidget {
  final int? requestId;
  final String? title;

  const MosqueEditView({Key? key, this.requestId, this.title}) : super(key: key);

  @override
  State<MosqueEditView> createState() => _MosqueEditViewState();
}

class _MosqueEditViewState extends State<MosqueEditView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final vm = context.read<MosqueEditViewViewModel>();
    vm.showDialogCallback=((DialogMessage dialogMessage){
      if (!mounted) return;
      AppNotifier.showDialog(context,dialogMessage);
    });
    vm.tabController = TabController(length: vm.tabsData.length, vsync: this);
    vm.reloadTabController();
    vm.loadPage();
    vm.addListener(_onVmUpdated);
  }

  void _onVmUpdated() {

    final vm = context.read<MosqueBaseViewModel>() as MosqueEditViewViewModel;
    final newLength = vm.tabsData.length;

    if (newLength != vm.tabController?.length) {
      vm.tabController?.dispose();
      vm.tabController = TabController(length: vm.tabsData.length, vsync: this);
      vm.reloadTabController();
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MosqueEditViewViewModel>();
    final contract = context.watch<MosqueBaseViewModel>();


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Mosque Edit (#${widget.requestId})'),
        actions: [
          // Workflow buttons in AppBar (same as edit request design)
          const MosqueEditActionButtons(),
        ],
      ),

      body: Stack(
        children: [
          Column(
            children: [
              // ---- Rounded TabBar container (same as edit request design) ----
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(.2),
                    width: 1.0,
                  ),
                ),
                child: TabBar(
                  controller: vm.tabController,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.primary.withOpacity(.10),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  unselectedLabelColor: Colors.grey.shade400,
                  labelStyle: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                  tabs: vm.tabsData.map((t) {
                    return Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (t.icon != null) ...[
                            Icon(t.icon, size: 16),
                            const SizedBox(width: 3),
                          ],
                          Flexible(
                            child: Text(
                              t.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ---- Tab content ----
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: TabBarView(
                    controller: vm.tabController,
                    children: [
                      MosqueBasicInfoSection(),
                      MosqueAddressSection(),
                      MosqueConditionSection(),
                      if(vm.showDependentTabs)
                      ...[
                          ArchitecturalStructureSection(),
                          MenPrayerSection(),
                          WomenPrayerSection(),
                          ResidenceSection(),
                          FacilitiesSection(),
                          LandSection(),
                          AudioElectronicsSection(),
                          SafetySection(),
                          MaintenanceSection(),
                          MetersSection(),
                          HistoricalSection(),
                          QRCodeSection(),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ---- Loading overlay (same as edit request design) ----
          Selector<MosqueBaseViewModel, bool>(
            selector: (_, c) => c.isLoading,
            builder: (_, loading, __) => loading ? ProgressBar() : const SizedBox.shrink(),
          ),
        ],
      ),
    );


  }
}
