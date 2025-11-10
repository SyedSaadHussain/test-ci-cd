import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';
import 'package:mosque_management_system/features/visit/core/viewmodel/visit_list_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_new_tag_button.dart';
import 'package:mosque_management_system/shared/widgets/cards/app_card.dart';
import 'package:provider/provider.dart';

class AppVisitListCard<T extends VisitModelBase> extends StatelessWidget {
  final VoidCallback? onTap;
  final T visit;

  const AppVisitListCard({
    super.key,
    this.onTap,
    required this.visit
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.read<VisitListViewModel<T>>();
    final userProvider = Provider.of<UserProvider>(context);
    return AppCard(
         color: visit.priorityColor,
        onTap: (){
       vm.onClickVisit(context,visit,userProvider?.userProfile?.employeeId);

    },child: Container(
      //color: Colors.lightBlueAccent,

      child: Row(
        children: [
          Expanded(child:Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(visit.listTitle??''
                  ,style: AppTextStyles.cardTitle
                  ,softWrap: true,),
                Text(visit.listSubTitle.toString()!
                    ,style: AppTextStyles.cardSubTitle
                )

              ],
            ),
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTag(title: visit.stage??""),
              if(vm.canDownload(visit: visit,loginId: userProvider?.userProfile?.employeeId))
                AppButtonSmall(text: 'download'.tr(),color: AppColors.tertiary.withOpacity(.1),
                    icon: Icons.download,
                    onColor:AppColors.tertiary,
                    onTab: () async{
                      vm.downloadVisit(context,visit);
                    }
                ),
              SizedBox(height: 10,)
            ],
          )
        ],
      ),
    ),isLoading:visit.isLoading);
  }
}