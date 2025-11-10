import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/user_credential.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/jailbreak_checker.dart';
import 'package:mosque_management_system/core/utils/proxy_http_client%20.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/features/home/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mosque_management_system/main.dart';

class LoginViewModel extends ChangeNotifier {

  bool isLoading=false;
  bool loginWithUserName=false;
  bool isObscureText=true;
  bool? canCheckBiometrics;
  bool isAuthenticating = false;
  String? name;
  bool isAllowLocalAuth=false;
  String errorMsg='';
  String authorized='';
  final LocalAuthentication auth = LocalAuthentication();
  final formKey = new GlobalKey<FormState>();
  late CommonRepository _odooRepository ;
  LoginViewModel() {

  }

  bool get loginOnlyBiometric =>(loginWithUserName==false) && (canCheckBiometrics??false) && isAllowLocalAuth && (name!=null && name!="");//
  // bool get loginOnlyBiometric => (canCheckBiometrics??false) && isAllowLocalAuth && AppUtils.isNotNullOrEmpty(name);//

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
  );
  void init() {
    // checkSecurity();
    final jailbreakChecker = JailbreakChecker();
    jailbreakChecker.checkSecurity();

    _secureStorage.read(key: "credentialUserName").then((onValue){
      name=onValue;
      notifyListeners();
    });
    //remove if logout by session out



    checkBiometrics();
    UserPreferences().isAllowLocalAuth().then((value) {
      isAllowLocalAuth=value;
      notifyListeners();
    });

  }

  Future<void> checkBiometrics() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }
    canCheckBiometrics = canCheckBiometrics;
    notifyListeners();
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    isAuthenticating = false;
    notifyListeners();
  }

  Future<void> togglePasswordVisibility() async{
    isObscureText = !isObscureText;
    notifyListeners();
  }

  Future<void> doLogin (context,userName,password)  async{

    errorMsg="";
    final form = formKey.currentState;
    try{


      if (form!.validate()) {

        form.save();

        FocusScope.of(context).unfocus();


        await _secureStorage.write(key: 'credentialUserName', value: userName);
        await _secureStorage.write(key: 'credentialUserPassword', value: password);

        _handleLogin(context);
      } else {
      }
    }
    catch(e){
      print('eeeeeeeee');
      print(e);

    }

  }
  String proxy ='';
  Future<void> _handleLogin(context) async {


    http.BaseClient? httpClient;
    if(Config.isProxyEnable){
      httpClient = CustomHttpClient(proxy).createClient();
    }
    CustomOdooClient.resetInstance();
    final client = CustomOdooClient.getInstance(EnvironmentConfig.baseUrl);

    _odooRepository = CommonRepository(client);

    FocusScope.of(context).unfocus();
    startLoading();
    final Future<Map<String, dynamic>> successfulMessage
    =  _odooRepository.authenticate(EnvironmentConfig.baseUrl??"",EnvironmentConfig.dbValue,"","");
    successfulMessage.then((response) {
      if(httpClient!=null)
        httpClient!.close();
      httpClient=null;

      stopLoading();
      if (response['status']) {
        name='';

        SessionManager.instance.saveProxy(proxy).then((_) {
          try{
            HiveRegistry.clearAllBoxes().then((val){
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                    (
                    Route<dynamic> route) => false, // Removes all previous routes

              );
            });
          }catch(e){
            ///still redirect if any issue occure
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
                  (
                  Route<dynamic> route) => false, // Removes all previous routes

            );
          }



          // });
        });
        //Navigate to the next screen upon successful login

      } else {
        if(httpClient!=null)
          httpClient!.close();
        httpClient=null;


        errorMsg=response['message'].toString()=="Invalid_credential"?"incorrect_password".tr():response['message'].toString();
        notifyListeners();
        if(response['message'].toString()=="Invalid_credential"){
          _secureStorage.delete(key: 'credentialUserName');
          _secureStorage.delete(key: 'credentialUserPassword');
          name=null;
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: AppColors.flushColor,
              behavior: SnackBarBehavior.fixed, // <-- sits at the bottom, no padding
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }).catchError((e){
      if(httpClient!=null)
        httpClient!.close();
      httpClient=null;

    });


  }
  stopLoading(){
    isLoading=false;
    notifyListeners();
  }
  startLoading(){
    isLoading=true;
    notifyListeners();
  }

  Future<void> authenticate(context) async {
    if(!isAllowLocalAuth){
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.flushColor,
        title: 'warning'.tr(),
        message: "enable_local_authentication".tr(),
        duration: Duration(seconds: 3),
      ).show(context);
    }else if(AppUtils.isNullOrEmpty(name)){
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor:  AppColors.flushColor,
        title: 'warning'.tr(),
        message: "please_login".tr(),
        duration: Duration(seconds: 3),
      ).show(context);
    }else{
      // await auth.stopAuthentication();
      bool authenticated = false;
      try {
        isAuthenticating = true;
        authorized = 'Authenticating';
        notifyListeners();
        authenticated = await auth.authenticate(
            localizedReason: 'localized_reason',
            // authMessages:  <AuthMessages>[
            //   AndroidAuthMessages(
            //     signInTitle: 'sign_in_title'.tr(),
            //     cancelButton: 'cancel'.tr(),
            //     biometricHint: 'biometric_hint'.tr(),
            //   ),
            // ],
            options: AuthenticationOptions(useErrorDialogs: true,sensitiveTransaction: false)

        ).catchError((_){
          isAuthenticating = false;
          notifyListeners();
        });
        isAuthenticating = false;
        notifyListeners();
      } on PlatformException catch (e) {
        await auth.stopAuthentication();
        isAuthenticating = false;
        authorized = 'Error - ${e.message}';
        notifyListeners();

        return;
      }
      if(authenticated){
        //_username=userCredentail!.userName;
        // _password=userCredentail!.password;
        _handleLogin(context);
      }
    }

  }


}