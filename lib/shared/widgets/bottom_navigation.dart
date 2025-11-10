import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/features/profile/profile_screen.dart';
import 'package:mosque_management_system/features/screens/services.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/main.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';

import 'dart:io' as io;


import 'package:mosque_management_system/core/services/shared_preference.dart';

class BottomNavigation extends StatefulWidget {
  // final CustomOdooClient client;
  final int selectedIndex;
  BottomNavigation({required this.selectedIndex});
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  @override
  void initState() {

  }
  //int _selectedIndex = 4;
  //UserPreferences
  @override
  Widget build(BuildContext context) {
    //HalqaProvider auth = Provider.of<HalqaProvider>(context);
    return SizedBox(
      // height: 30,
      child: BottomNavigationBar(
        backgroundColor: AppColors.backgroundColor,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.black54.withOpacity(.5),
        iconSize: 21,
        unselectedFontSize: 11,
        selectedFontSize: 11,
        showSelectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        currentIndex: this.widget.selectedIndex, // this
        type: BottomNavigationBarType.fixed,// will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(AppIcons.home),
            label: 'home'.tr(),
            activeIcon:  Icon(AppIcons.home),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.apps_rounded),
          //   label: 'services'.tr(),
          //   activeIcon:  Icon(Icons.apps_rounded),
          // ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.userReload),
            label: 'profile'.tr(),
            activeIcon:  Icon(AppIcons.userReload),
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.logout),
            label: 'logout'.tr(),
            activeIcon:  Icon(AppIcons.logout),
          ),

        ],
        onTap: (int index) {

          switch (index) {

            case 0:
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/dashboard', (Route<dynamic> route) => false);
              // if(index!=this.widget.selectedIndex) {
              //
              // }
              break;
            // case 1:
            //   if(index!=this.widget.selectedIndex) {
            //     if(this.widget.selectedIndex!=0)
            //       Navigator.pop(context);
            //
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>
            //         new Services(),
            //       ),
            //     );
            //   }
            //   break;
            case 1:
              if(index!=this.widget.selectedIndex) {
                if(this.widget.selectedIndex!=0)
                  Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    new ProfileScreen(),
                  ),
                );
              }
              break;

            case 2: // Logout case
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('confirmation'.tr()),
                    content: Text('are_you_sure'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('cancel'.tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          SessionManager.instance.logout();
                        },
                        child: Text('logout'.tr()),
                      ),
                    ],
                  );
                },
              );
              break;



          }
        },
      ),
    );
  }
}