import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/features/mosque/createMosque/form/create_mosque_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';

class TabsBottomNavigation extends StatelessWidget {
  const TabsBottomNavigation({super.key});  // recommended to forward the key

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateMosqueBaseViewModel>();
    print('vm.isShowNextBtn');
    // print(vm.tabController!.index);

    Widget buildRow() {
      final children = <Widget>[];

      // Previous (hidden on the very first tab)
      if (vm.isShowBackBtn) {
        children.add(
          Expanded(
            child: SizedBox(
              height: 40,
              child: AppButton(
                text: 'previous'.tr(),
                color: AppColors.gray,
                onTab: (){
                  vm.onBack(context);
                },
              ),
            ),
          ),
        );
      }

      void gap() {
        if (children.isNotEmpty) children.add(const SizedBox(width: 10));
      }

      if (vm.isShowNextBtn) {
        // Next (for all but last tab)
        gap();
        children.add(
          Expanded(
            child: SizedBox(
              height: 40,
              child: AppButton(
                text: 'next'.tr(),
                color: AppColors.primary,
                onTab: vm.onNext,
              ),
            ),
          ),
        );
      }
      if (vm.isShowSubmitBtn) {
        // Submit (only on last tab) — always the last button
        gap();
        children.add(
          Expanded(
            child: SizedBox(
              height: 40,
              child: AppButton(
                text: 'submit'.tr(),
                color: AppColors.primary,
                onTab:(){
                  vm.onSubmit(context);
                },
              ),
            ),
          ),
        );
      }
      if (vm.isShowSendButton) {
        // Submit (only on last tab) — always the last button
        gap();
        children.add(
          Expanded(
            child: SizedBox(
              height: 40,
              child: AppButton(
                text: 'send'.tr(),
                color: AppColors.danger,
                onTab:(){
                  vm.onSubmit(context);
                },
              ),
            ),
          ),
        );
      }

      return Row(children: children);
    }

    // Fallback if no TabController in tree
    return buildRow();

  }
}