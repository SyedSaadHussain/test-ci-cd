import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/view/view_basic_info_section.dart';
import 'package:mosque_management_system/features/visit/regular/form/visit_regular_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/visit_form_bottom.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/building_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/dawah_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/device_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/imam_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/maintenance_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/mosque_meter_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/mosque_status_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/safety_section.dart';
import 'package:mosque_management_system/features/visit/core/widget/form/security_section.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:flutter/material.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';

 class VisitRegularFormScreen extends StatefulWidget {
  final RegularVisitModel visit;
  const VisitRegularFormScreen({super.key, required this.visit});

  @override
  State<VisitRegularFormScreen> createState() => _VisitRegularFormScreenState();
}

 class _VisitRegularFormScreenState extends BaseState<VisitRegularFormScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    final vm = context.read<VisitFormViewModel<RegularVisitModel>>();
    vm.tabController = TabController(length: vm.tabs.length, vsync: this);
    // vm.formDetailKey=vm.formDetailKey;
    vm.showDialogCallback=((DialogMessage dialogMessage){
      if (!mounted) return;
      AppNotifier.showDialog(context,dialogMessage);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.init();
    });
  }

  @override
  void dispose() {
    // tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitFormViewModel<RegularVisitModel>>()  as  VisitRegularFormViewModel;
    // final vm = context.watch<VisitFormViewModel<RegularVisitModel>>();
    return Scaffold(
      appBar: AppBar(
          title:   Text(VisitMessages.regularVisit),
          actions:[
            Container(
            height: 40,
            child: AppNewTagButton(
                title: 'delete_cache'.tr(),
                onChange:() async{
                  vm.deleteCache(context);

                }
            ),
          ),
            Consumer<VisitFormViewModel<RegularVisitModel>>(
                builder: (context, vm, _) {
                  return  vm.visitObj.isDataVerified? Container(
                    // height: 40,
                    child: AppButtonSmall(
                        text: 'save'.tr(),
                        color: AppColors.deepGreen,
                        isOutline: true,
                        onTab:() async{
                          vm.saveVisit();
                        }
                    ),
                  ):Container();
                }
            )


          ]

      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                  key: vm.formDetailKey,
                  // autovalidateMode: AutovalidateMode.disabled,
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
                                child: IgnorePointer(
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
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: TabBarView(
                                    controller: vm.tabController,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children:[
                                      SingleChildScrollView(
                                        child: Consumer<VisitFormViewModel<RegularVisitModel>>(
                                            builder: (context, vm, _) {
                                              vm.visitObj.employee=appUserProvider.userProfile.name;
                                              return  ViewBasicInfoSection(visit: vm.visitObj,fields: vm.fields,headersMap: null);
                                            }
                                        ),
                                      ),
                                      ImamSection<RegularVisitModel>(),

                                      MosqueMeterSection<RegularVisitModel>(),
                                      //buildinf
                                      BuildingSection<RegularVisitModel>(),
                                      //device
                                      DeviceSection<RegularVisitModel>(),
                                      SafetySection<RegularVisitModel>(),
                                      MaintenanceSection<RegularVisitModel>(),
                                      SecuritySection<RegularVisitModel>(),
                                      DawahSection<RegularVisitModel>(),
                                      MosqueStatusSection<RegularVisitModel>(),
                                    ]



                                    ,
                                  ),
                                ),
                              ),

                              SafeArea
                                (child: VisitFormBottom<RegularVisitModel>()),


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
          Selector<VisitFormViewModel<RegularVisitModel>, bool>(
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
