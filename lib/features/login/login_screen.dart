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
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/database.dart';
import 'package:mosque_management_system/core/models/user_credential.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/network_service.dart';
import 'package:mosque_management_system/features/home/home_screen.dart';
import 'package:mosque_management_system/core/providers/authProvider.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/Jailbreak_detector.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/jailbreak_checker.dart';
import 'package:mosque_management_system/core/utils/proxy_http_client%20.dart';
import 'package:mosque_management_system/core/utils/security.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/features/login/login_view_model.dart';
import 'package:mosque_management_system/features/login/widget/action_buttons.dart';
import 'package:mosque_management_system/features/login/widget/biometric_login.dart';
import 'package:mosque_management_system/features/login/widget/login_form.dart';
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
import '../../shared/widgets/dynamic_popup_demo.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel()..init(),
      child:  _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({Key? key}) : super(key: key);

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {

  final JailbreakDetector _jailbreakDetector = JailbreakDetector();

  String dgAttached="";
  bool amICompromised=false;
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (state == AppLifecycleState.resumed) {
      final jailbreakChecker = JailbreakChecker();
      await jailbreakChecker.checkSecurity();
      //await checkSecurity();
    }
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider = context.read<UserProvider>();
      userProvider.clear();

    });
  }


  @override
  void dispose() {
    super.dispose();
  }


  late UserProvider userProvider;
  late LoginViewModel vm;
  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    vm = context.watch<LoginViewModel>();
    userProvider = Provider.of<UserProvider>(context);

    return ((_jailbreakDetector.isJailbroken == true ||  _jailbreakDetector.isDeveloperMode==true || dgAttached=="true" || amICompromised))?RootedDevice():Scaffold(
      body: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body:
        Stack(
          children: [

            Positioned.fill(
              child: Opacity(
                opacity: .4,
                child: Image.asset(
                  'assets/images/splash.png', // Replace with your image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Form(
                key: vm.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0), // Top left corner radius
                          topRight: Radius.circular(20.0), // Top right corner radius
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Text('log_in_to_continue'.tr(),style: AppTextStyles.defaultHeading1,),
                                Config.isProxyEnable?TextFormField(
                                  style: TextStyle(color: Colors.grey),
                                  decoration: AppInputDecoration.firstInputDecoration(context,label: "Proxy[IP:PORT]",icon: Icons.security),

                                  onSaved: (value){
                                    vm.proxy=value??"";
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },

                                ):Container(),
                                SizedBox(height: 5,),
                                vm.loginOnlyBiometric==true?
                                BiometricLogin():
                                Column(
                                  children: [
                                    LoginForm(),
                                    ActionButtons(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          keyboardVisible?Container():Container(
                            // height: 240,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/images/welcome_banner.png',

                                fit: BoxFit.fitWidth,
                              ),
                            ),
                         
                          )
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

    );
  }
}