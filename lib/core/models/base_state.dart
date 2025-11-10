import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';


abstract class BaseState<T extends StatefulWidget> extends State<T> {
  CustomOdooClient? appClient = null;
  bool _initialized = false;
  late UserProvider appUserProvider;
  bool appLoading=false;
  @override
  void initState() {
    super.initState();
    List<int> heavyData = List.generate(1000000, (index) => index);
    heavyData.clear();
   
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   if(_initialized==false){
    //       _initialized=true;
    //       widgetInitialized();
    //     }
    // });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_initialized==false){
      _initialized=true;
      appUserProvider = Provider.of<UserProvider>(context);
      widgetInitialized();
    }
  }

  void widgetInitialized(){
    appClient = appUserProvider.client;

    // Add this
    final user = appUserProvider.userProfile;
    if (user != null) {
      try{
          if(Config.enableSentry) {
            Sentry.configureScope((scope) {
              scope.setUser(SentryUser(
                id: user.userId.toString(), // or just user.id if String
                username: user.name,
                extras: {
                  'employeeId': user.employeeId ?? '',
                  // any custom fields you want
                },
              ));
            });
          }
      }catch(e){

      }
    }




    // if(appClient!=null)
    //   checkSession();
  }
  // void checkSession() async {
  //   try {
  //     var repository = CommonRepository(appClient);
  //     bool isLoggedIn = !(await repository.ischeckSessionExpire().timeout(Duration(seconds: 5)));
  //
  //     if (!isLoggedIn) {
  //       UserPreferences().logout(false);
  //     }
  //   } catch (e) {
  //
  //   }
  //
  // }
  
}