import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/input_decoration_themes.dart';
import 'package:mosque_management_system/core/models/database.dart';
import 'package:mosque_management_system/core/models/user_credential.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/network_service.dart';
import 'package:mosque_management_system/features/home/home_screen.dart';
import 'package:mosque_management_system/features/login/login_screen.dart';
import 'package:mosque_management_system/core/providers/authProvider.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/Jailbreak_detector.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/proxy_http_client%20.dart';
import 'package:mosque_management_system/core/utils/security.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/rooted_device.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/wave_loader.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>  with WidgetsBindingObserver{
  final formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.png', // Replace with your image URL
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                  
                    children: [
                  
                      Image.asset(
                        'assets/images/logo.png',
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 30,),

                  
                  
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dy < 0) {
                    Navigator.of(context).push(_createRoute());
                  }
                },
                onTap: (){
                  Navigator.of(context).push(_createRoute());
                },
                child: Container(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Text('swipe_up_sign_in'.tr(),style: TextStyle(color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child:  Image.asset(
                            'assets/images/arrow_up.png',

                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0), // Set your desired radius
                            topRight: Radius.circular(30.0), // Set your desired radius
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ],
      ),

    );
  }


  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Starting position (off the bottom)
        const end = Offset.zero; // Ending position (on screen)
        const curve = Curves.easeInOut; // Transition curve

        // Apply the animation to the transition
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 800),
    );
  }
}