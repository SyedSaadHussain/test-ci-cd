import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/current_date.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/features/notification/notification_list_screen.dart';
import 'package:mosque_management_system/features/settings/settings_screen.dart';
import 'package:mosque_management_system/shared/widgets/prayer_clock.dart';
import 'package:provider/provider.dart';

class ErrorPanel extends StatelessWidget {

  const ErrorPanel({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);
    return  AppUtils.isNotNullOrEmpty(vm.errorMessage)?Container(

      margin: EdgeInsets.only(left: 5,right: 5,top: 10),
      // padding: EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(.1),
        borderRadius: BorderRadius.circular(10), // Adjust the radius here
      ),
      child: Row(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.warning,color: AppColors.warning,size: 16,)),

            Expanded(child:
            Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text((vm.errorMessage??"").trim(),style: AppTextStyles.cardTitle,  overflow: TextOverflow.visible ))),


          ]
      ),
    ):Container();
  }
}