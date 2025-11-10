import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/input_decoration_themes.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/app_version.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/user_credential.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/home/home_screen.dart';
import 'package:mosque_management_system/core/providers/authProvider.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:another_flushbar/flushbar.dart';


class AppUpdateScreen extends StatefulWidget {
  // final CustomOdooClient client;
  final AppVersion version;
  AppUpdateScreen({ required this.version});
  @override
  _AppUpdateScreenState createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends BaseState<AppUpdateScreen> {
  AppVersion? version;
  void initState() {

    version=this.widget.version;
  }
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _userService = UserService(appUserProvider.client!,userProfile:appUserProvider.userProfile );
    // userProvider = Provider.of<UserProvider>(context);
    // _userService!.updateUserProfile(userProvider.userProfile);
  }

  UserService? _userService;
  // Method to handle login
  void doLogin ()  {
    setState(() {
      _isLoading=true;
    });

    _userService!.getAppVersion().then((response){
      setState(() {
        _isLoading=false;
      });

      version=response;
      if(version!=null){
     
        version!.launchAppStore();


      }
    }).catchError((e){
      setState(() {
        _isLoading=true;
      });
    });
  }
  bool _isLoading=false;



  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            AppBackground(),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 100,),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 50,),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),

                        child: Center(child: Text('new_version_title'.tr(),style: TextStyle(color: AppColors.onPrimary,fontSize: 22),textAlign: TextAlign.center,))),

                    SizedBox(height: 10,),
                    Expanded(child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                child:
                                    Text("new_version_detail".tr(),
                                    style: TextStyle(color: AppColors.onPrimary,height: 1.8,fontSize: 16),

                                ),

                              ),
                              SizedBox(height: 10,),
                              HtmlWidget(version!.description??"",
                                customStylesBuilder: (element) {
                                  element.attributes.clear();
                                  return {'color': '#c9e5d8 !important'};
                              },)

                            ],
                          )),
                    )),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: doLogin, // Call _handleLogin method on button press
                      child: SizedBox(
                        width: double.infinity,
                        child:_isLoading?WaveLoader(color: Theme.of(context).colorScheme.primary,size: 25)  : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.rocket),// Add your login icon here
                            SizedBox(width: 8), // Add some spacing between the icon and text
                            Text(
                              "update_app".tr(),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    // this.version!.hasRequiredUpdate?Container():GestureDetector(
                    //
                    //     onTap: (){
                    //       Navigator.of(context).pop();
                    //     },
                    //     child: Text('Not Now',style: TextStyle(color: AppColors.secondly),))


                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}