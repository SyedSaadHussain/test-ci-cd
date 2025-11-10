// features/mosque/edit_request/widget/mosque_edit_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';

import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

// for MosqueViewContract
import 'package:mosque_management_system/features/mosque/edit_request/view/mosque_edit_view_model.dart';


class MosqueEditActionButtons extends StatelessWidget {
  const MosqueEditActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MosqueBaseViewModel>();

    // If it's normal view, nothing to show
    if (!(vm.canAccept || vm.canRefuse || vm.canSend || vm.canSetToDraft)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (vm.canSetToDraft)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: AppButtonSmall(
                text: 'set_to_draft'.tr(),
                color: AppColors.gray,
                isFullWidth: false,
                onTab: () {
                  showDisclaimerDialogWithReason(
                    context,
                    text: VisitDefaults.declarationText,
                    fieldLabel: 'observation_text'.tr(),
                    isRequired: true,
                    onApproved: (String observationText) => vm.onSetToDraft(observationText),
                  );
                },
              ),
            ),
          if (vm.canRefuse)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: AppButtonSmall(
                text: 'reject_for_duplication'.tr(),
                color: AppColors.deepRed,
                isFullWidth: false,
                onTab: () {
                  showDisclaimerDialogWithReason(
                    context,
                    text: VisitDefaults.declarationText,
                    fieldLabel: 'Reject_Reason'.tr(),
                    isRequired: true,
                    onApproved: (String reason) => vm.onRefuse(VisitDefaults.declarationText,reason),
                  );
                },
              ),
            ),
          // if (vm.canSend)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 2.0),
          //     child: AppButtonSmall(
          //       text: 'Send'.tr(),
          //       color: AppColors.info,
          //       isFullWidth: false,
          //       onTab: () {
          //         showDisclaimerDialog(
          //           context,
          //           text: SystemDefault.declarationText,
          //           onApproved: () => vm.onSend(SystemDefault.declarationText),
          //         );
          //       },
          //     ),
          //   ),
          if (vm.canAccept)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: AppButtonSmall(
                text: 'accept'.tr(),
                color: AppColors.deepGreen,
                isFullWidth: false,
                onTab: () {
                  showDisclaimerDialog(
                    context,
                    text: VisitDefaults.declarationText,
                    onApproved: () => vm.onAccept(VisitDefaults.declarationText),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
