import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/current_date.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/features/notification/notification_list_screen.dart';
import 'package:mosque_management_system/features/settings/settings_screen.dart';
import 'package:mosque_management_system/shared/widgets/prayer_clock.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget {

  const TopBar({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return  SafeArea(
      child: Align(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Main content
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            userProvider.userProfile.name ?? "",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              // Handle tap here
                            },
                            child: Icon(
                              userProvider.isDeviceVerify
                                  ? Icons.check_circle
                                  : Icons.warning,
                              color: userProvider.isDeviceVerify
                                  ? Colors.green
                                  : Colors.amber,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Gray overlay with centered loader
                    if (userProvider.isLoadingProfile)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4), // semi-transparent overlay
                            borderRadius: BorderRadius.circular(15),
                          ),

                          alignment: Alignment.center,
                          child:  SizedBox(
                            width: 24,
                            height: 24,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppColors.gray, // wave color
                              size: 20,                 // size of wave animation
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
              ,

              Expanded(child: Container()),
              GestureDetector(
                onTap: (){
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AllKhutbas(),
                  //   ),
                  // );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationListScreen(),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppColors.onPrimaryLight,
                        shape: BoxShape.circle, // Make the container circular
                      ),
                      child: Icon(Icons.notifications_active_rounded,color:Theme.of(context).colorScheme.primary,size:16 ,),
                    ),
                    if (userProvider.TotalNotification>0)
                      Positioned(
                        right: 0,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            userProvider.TotalNotification.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.onPrimaryLight,
                  shape: BoxShape.circle, // Make the container circular
                ),
                child: PopupMenuButton(
                  child: Icon(AppIcons.bar,color:Theme.of(context).colorScheme.primary,size:16 ,),
                  padding: EdgeInsets.zero,
                  color: AppColors.flushColor,
                  //icon: Icon(Icons.more_vert,color:Theme.of(context).colorScheme.primary ,), // Dotted button icon
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.settings,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.7),),
                        title: Text('settings'.tr(),style: TextStyle(color:Theme.of(context).colorScheme.onPrimary.withOpacity(.7) ),),
                      ),
                      value: 'settings',
                    ),

                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.logout,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.7) ),
                        title: Text('logout'.tr(),style: TextStyle(color:Theme.of(context).colorScheme.onPrimary.withOpacity(.7) )),
                      ),
                      value: 'logout',
                    ),
                  ],
                  onSelected: (value) {
                    // Handle menu item selection
                    switch (value) {
                      case 'settings':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            new Settings(),
                          ),
                        );
                        break;
                      case 'logout':
                        // final client = CustomOdooClient();
                        // client.destroySessionCustom();
                        SessionManager.instance.logout();
                        break;
                    }
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}