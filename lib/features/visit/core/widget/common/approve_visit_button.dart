import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/features/visit/core/constants/system_default.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_form_view_model.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_view_model.dart';
import 'package:mosque_management_system/features/visit/core/widget/common/takeaction_disclaimer_dialog.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';
import 'package:provider/provider.dart';

 class VisitActionButton<T extends VisitModelBase> extends StatelessWidget {
   VisitActionButton({super.key});
  String terms=VisitDefaults.draftStateValue;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VisitViewModel<T>>();
    return Selector<VisitViewModel<T>, (
    bool?, bool?, bool?
    )>(
        selector: (_, vm) => (
        vm.visitObj.displayButtonUnderprogress,
        vm.visitObj.displayButtonAction,
        vm.visitObj.displayButtonAccept,
        ),
        builder: (_, values, __) {
        return Row(
          children: [
            if(vm.visitObj.displayButtonUnderprogress??false)
               AppButtonSmall(
              text: VisitMessages.underProgress,
              color: AppColors.gray,
              onTab: () {
                vm.onUnderProgress();
              },
            ),
            if(vm.visitObj.displayButtonAction??false)
              AppButtonSmall(
              text: VisitMessages.takeAction,
              color: AppColors.deepRed,
              onTab: () {
                vm.getActionTypes().then((types){
                  takeActionDisclaimerDialog<T>(
                    context,
                    fields: vm.fields,
                    text: VisitDefaults.declarationText,
                    onApproved: (TakeVisitActionModel action) {
                      action.disclaimer=VisitDefaults.declarationText;
                      vm.onTakeAction(action);
                    },
                    actionTypes: types
                  );
                });
              },
            ),
            if(vm.visitObj.displayButtonAccept??false)
             AppButtonSmall(
              text: VisitMessages.accept,
              color: AppColors.deepGreen,
              onTab: () {
                showDisclaimerDialog(
                  context,
                  text: VisitDefaults.declarationText,
                  onApproved: () {
                    vm.onAccept!(VisitDefaults.declarationText);
                  },
                );
              },
            ),
          ],
        );
      }
    );
  }
}