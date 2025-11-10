import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/features/khutba/list/khutba_list_screen.dart';
import 'package:mosque_management_system/features/kpi/ui/screens/kpi_menu_screen.dart';
import 'package:mosque_management_system/features/mosque/menu/mosque_menu_screen.dart';
import 'package:mosque_management_system/features/mosque_utilities/mosque_utilities_menu.screen.dart';
import 'package:mosque_management_system/features/transfers_employee_observers/employee_transfers_menu_screen.dart';
import 'package:mosque_management_system/features/visit/dashboard/visit_dashboard.dart';
import 'package:mosque_management_system/shared/widgets/buttons/service_button.dart';
import 'package:provider/provider.dart';

import '../../user_guide/user_guide_screen.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final userProvider = context.read<UserProvider>();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'services'.tr(),
                  style: AppTextStyles.heading2,
                )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                    vm.menu.length,
                    (index) => ServiceButton(
                        text: vm.menu[index].name.tr(),
                        icon: vm.menu[index].icon,
                        color: AppColors.backgroundColor,
                        iconPath: vm.menu[index].imagePath,
                        onColor: AppColors.primary,
                        isIconPathColor: vm.menu[index].isImageColor ?? true,
                        onTab: () {
                          if (userProvider.isDeviceVerify ||
                              Config.disableValidation) {
                            switch (vm.menu[index].menuUrl) {
                              case 'KHUTBA_MANAGEMENT':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KhutbaListScreen()),
                                );
                                break;

                              case 'KPI':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => new KpiMenuScreen(),
                                    //HalqaId: 1
                                  ),
                                );
                                break;
                              case 'VISIT':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        new VisitDashboardView(),
                                    //HalqaId: 1
                                  ),
                                );
                                break;
                              case 'MOSQUE':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        new MosqueMenuScreen(),
                                  ),
                                );
                                break;
                              case 'MOSQUE_UTILITIES':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        new MosqueUtilitiesMenuScreen(),
                                  ),
                                );
                                break;

                              case 'EMPLOYEE_TRANSFERS':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        new EmployeeTransferMenuScreen(),
                                  ),
                                );
                                break;
                              case 'USER_GUIDE':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          new UserGuideScreen(),
                                    ));
                                break;
                              default:
                                print('');
                            }
                          } else {
                            AppNotifier.showDialog(
                                context,
                                DialogMessage(
                                    type: DialogType.errorText,
                                    message: 'device_not_unverified'.tr()));
                          }
                        }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
