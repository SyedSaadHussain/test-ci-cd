import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/mosque/core/approve_mosque_button.dart';
import 'package:mosque_management_system/features/mosque/createMosque/view/mosque_view_model.dart';
import 'package:mosque_management_system/features/mosque/widget/view/mosque_address_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/mosque_basic_info_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/mosque_condition_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/architectural_structure_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/men_prayer_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/women_prayer_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/employee_info_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/applicant_info_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/residence_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/facilities_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/land_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/audio_electronics_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/safety_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/maintenance_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/meters_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/historical_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/qrcode_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/declarations_section.dart';
import 'package:mosque_management_system/features/mosque/widget/view/contracts_section.dart';
import 'package:mosque_management_system/features/mosque/core/approve_mosque_button.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';


class MosqueView extends StatefulWidget {
  final int mosqueId;
  final String? title; // Optional, for app bar
  // Optional, for app bar

  const MosqueView({Key? key, required this.mosqueId, this.title})
      : super(key: key);

  @override
  State<MosqueView> createState() => _MosqueViewState();
}

class _MosqueViewState extends State<MosqueView>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    final vm = context.read<MosqueBaseViewModel>() as MosqueViewViewModel;
    vm.showDialogCallback=((DialogMessage dialogMessage){
      if (!mounted) return;
      AppNotifier.showDialog(context,dialogMessage);
    });
    vm.tabController = TabController(length: vm.tabsData.length, vsync: this);
    vm.reloadTabController();
    //Move to widget initializer
    vm.loadPage();
    vm.addListener(_onVmUpdated);
  }
  void _onVmUpdated() {

    final vm = context.read<MosqueBaseViewModel>() as MosqueViewViewModel;
    final newLength = vm.tabsData.length;

    if (newLength != vm.tabController?.length) {
      vm.tabController?.dispose();
      vm.tabController = TabController(length: vm.tabsData.length, vsync: this);
      vm.reloadTabController();
      vm.notifyListeners();
    }
  }



  @override
  Widget build(BuildContext context) {
    final vm = context.read<MosqueBaseViewModel>() as MosqueViewViewModel;
    final contract = context.watch<MosqueBaseViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Mosque View (#${widget.mosqueId})'),
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
                            // Conditional: employees for stage 192/263, otherwise applicants
                            (() {
                              final sid = vm.mosqueObj.payload?['stage_id'];
                              final id = sid is int ? sid : int.tryParse('$sid');
                              return (id == 192 || id == 263)
                                  ? const EmployeeInfoSection()
                                  : const ApplicantInfoSection();
                            })(),
                            ResidenceSection(),
                            FacilitiesSection(),
                            LandSection(),
                            AudioElectronicsSection(),
                            SafetySection(),
                            MaintenanceSection(),
                            MetersSection(),
                            HistoricalSection(),
                            QRCodeSection(),
                            DeclarationsSection(),
                            ContractsSection(),
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
