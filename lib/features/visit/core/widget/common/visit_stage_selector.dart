import 'package:flutter/material.dart';
import 'package:mosque_management_system/features/visit/core/message/visit_messages.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:provider/provider.dart';

class VisitStageSelector<T extends VisitModelBase> extends StatelessWidget {

  const VisitStageSelector({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitListViewModel<T>>();
    return  Selector<VisitListViewModel<T>, (int?,int?)>(
        selector: (_, vm) => (vm.stages?.length,vm.currentStageId),
        builder: (_, val, __) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                AppNewTagButton(
                  index: null,
                  activeButtonIndex: vm.currentStageId,
                  title: VisitMessages.allVisits,
                  onChange: () {
                    vm.updateStage(null);
                  },
                ),

                ...(vm.stages??[])!.map((stage) {
                  return AppNewTagButton(
                    key: stage.globalKey,
                    index: stage.key,
                    activeButtonIndex: vm.currentStageId,
                    title: (stage.value??""),
                    onChange: () {
                      vm.updateStage(stage.key);
                    },
                  );
                })],
            ),
          ),
        );
      }
    );
  }
}