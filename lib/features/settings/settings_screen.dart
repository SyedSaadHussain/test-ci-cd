import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/device_detail.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  // final CustomOdooClient client;
  Settings();
  @override
  _SettingsViewState createState() => _SettingsViewState();
}
class _SettingsViewState extends BaseState<Settings> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double? totalLeaveBal;
  bool isAllowLocalAuth=true;
  PackageInfo? packageInfo;
  @override
  void initState(){
    super.initState();
    UserPreferences().isAllowLocalAuth().then((value) {
      setState(() {
        isAllowLocalAuth=value;
      });
    });
    PackageInfo.fromPlatform().then((value){

      packageInfo=value;
      setState(() {

      });
    });
    getDeviceInfo();
  }
  String? UUId;
  getDeviceInfo(){
    DeviceDetail().getImei().then((deviceDetail){
      UUId=deviceDetail!.imei;
      setState(() {

      });
    });
  }

  bool notificationsEnabled = true;
  int notificationInterval = 15;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0), // Adjust the height here
          child: AppBar(
            backgroundColor: Colors.grey.withOpacity(.08),
          ),
        ),
        //backgroundColor: Config.headerColor,
        body: Container(
          color: Colors.grey.withOpacity(.08),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      //decoration: BodyBoxDecoration4(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text('settings'.tr(),style: TextStyle(fontSize: 30,color: AppColors.gray),)),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10), // Set border radius here
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal:15,vertical: 10 ),
                                            child: Text( 'preferences'.tr(),style: TextStyle(color: AppColors.gray.withOpacity(.8),fontWeight: FontWeight.bold),)),
                                        AppListTitle(title: 'biometric_authentication'.tr(),subTitle: isAllowLocalAuth?'enable'.tr():'disable'.tr(),iconColor:Colors.teal,icon: Icons.fingerprint_outlined,
                                            onTab: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('biometric_authentication'.tr()),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            UserPreferences().setAllowLocalAuth(true);

                                                            setState(() {
                                                              isAllowLocalAuth=true;
                                                            });
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Container(
                                                            width: double.infinity, // Full width
                                                            //color: context.locale.languageCode != 'ar' ? AppColors.success : AppColors.gray,
                                                            padding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed

                                                            child: Text(
                                                              'enable'.tr(),
                                                              style: TextStyle(color: isAllowLocalAuth ? AppColors.success : AppColors.gray), // Adjust text color as needed
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            UserPreferences().setAllowLocalAuth(false);
                                                            setState(() {
                                                              isAllowLocalAuth=false;
                                                            });
                                                            Navigator.of(context).pop();
                                                          },
                                                          child:
                                                          Container(
                                                            width: double.infinity, // Full width
                                                            //color: context.locale.languageCode != 'ar' ? AppColors.success : AppColors.gray,
                                                            padding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed
                                                            child: Text(
                                                              'disable'.tr(),
                                                              style: TextStyle(color: !isAllowLocalAuth ? AppColors.success : AppColors.gray), // Adjust text color as needed
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                        ),
                                        Divider(color: Colors.grey.shade200,),
                                        AppListTitle(title: 'selected_language'.tr(),subTitle: context.locale.languageCode!='ar'?'English':'العربي',iconColor:Colors.green,icon: Icons.language,
                                            onTab: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                                                    ),
                                                    // backgroundColor: Colors.grey,
                                                    title: Text('selected_language'.tr()),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            LocalizeAndTranslate.setLanguageCode('en');
                                                            appUserProvider.setLanguage(LocalizeAndTranslate.getLanguageCode());
                                                            LocalizeAndTranslate.setLocale(context.locale);
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Container(
                                                            width: double.infinity, // Full width
                                                            //color: context.locale.languageCode != 'ar' ? AppColors.success : AppColors.gray,
                                                            padding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed

                                                            child: Text(
                                                              'English',
                                                              style: TextStyle(color: context.locale.languageCode!='ar' ? AppColors.success : AppColors.gray), // Adjust text color as needed
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            LocalizeAndTranslate.setLanguageCode('ar');
                                                            appUserProvider.setLanguage(LocalizeAndTranslate.getLanguageCode());
                                                            LocalizeAndTranslate.setLocale(context.locale);
                                                            Navigator.of(context).pop();
                                                          },
                                                          child:
                                                          Container(
                                                            width: double.infinity, // Full width
                                                            //color: context.locale.languageCode != 'ar' ? AppColors.success : AppColors.gray,
                                                            padding: EdgeInsets.symmetric(vertical: 8.0), // Adjust padding as needed
                                                            child: Text(
                                                              'العربي',
                                                              style: TextStyle(color: context.locale.languageCode=='ar' ? AppColors.success : AppColors.gray), // Adjust text color as needed
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10), // Set border radius here
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.symmetric(horizontal:15,vertical: 10 ),
                                            child: Text('general_information'.tr(),style: TextStyle(color: AppColors.gray.withOpacity(.8),fontWeight: FontWeight.bold),)),
                                        AppListTitle(title: 'platform'.tr(),subTitle: Platform.isAndroid?'Android'.tr():'IOS'.tr(),iconColor:Colors.lightBlueAccent,icon: Icons.phone_android_outlined),
                                        Divider(color: Colors.grey.shade200,),
                                        packageInfo==null?Container():AppListTitle(title: 'version'.tr(),subTitle: (packageInfo!.version+'+'+packageInfo!.buildNumber.toString()),iconColor:Colors.blueGrey,icon: Icons.numbers),
                                        Divider(color: Colors.grey.shade200,),
                                        packageInfo==null?Container():AppListTitle(
                                            title: 'device_UID'.tr(),
                                            subTitle: UUId ?? "no_UID_available".tr(),
                                            iconColor: Colors.teal,
                                            icon: Icons.numbers,
                                            trailing: (UUId != null && UUId!.isNotEmpty)?IconButton(
                                              icon: Icon(Icons.copy, color: Colors.blueGrey),
                                              onPressed: () {
                                                Clipboard.setData(ClipboardData(text: UUId!));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('copied_to_clipboard'.tr()),
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                            ):null
                                        ),
                                        Divider(color: Colors.grey.shade200,),

                                        if(Config.enableSentry)
                                        AppListTitle(title: 'senetry log',subTitle: 'enable'.tr(),icon: Icons.remove_red_eye,iconColor:Colors.red,),
                                        if(Config.disableValidation)
                                        AppListTitle(title: 'Disable Validation',subTitle: 'enable'.tr(),icon: Icons.error,iconColor:Colors.red,),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
