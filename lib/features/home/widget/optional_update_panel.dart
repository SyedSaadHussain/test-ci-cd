import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/shared/widgets/buttons/app_button.dart';
import 'package:provider/provider.dart';

class OptionalUpdatePanel extends StatelessWidget {
  const OptionalUpdatePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final userProvider = context.read<UserProvider>();
    return   vm.isNewVersionAvailable?Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.only(top: 15),

      decoration: BoxDecoration(
        color: AppColors.onPrimaryLight,
        borderRadius: BorderRadius.circular(5), // Adjust the radius here
      ),
      child: Row(

          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.info,color: AppColors.primary,size: 16,)),

            Expanded(child: Text('new_version_title'.tr(),style: AppTextStyles.cardTitle,  overflow: TextOverflow.ellipsis )),
            AppButtonSmall(text: 'update_app'.tr(),color: AppColors.primary,onTab: (){
              vm.version!.launchAppStore();
            })

          ]
      ),
    ):Container();
  }
}
