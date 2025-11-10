import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/features/home/widget/app_menu.dart';
import 'package:mosque_management_system/features/home/widget/clock_panel.dart';
import 'package:mosque_management_system/features/home/widget/error_panel.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/Jailbreak_detector.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/jailbreak_checker.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/features/home/widget/optional_update_panel.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/rooted_device.dart';
import 'package:provider/provider.dart';
import 'widget/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    if (state == AppLifecycleState.resumed) {
      final jailbreakChecker = JailbreakChecker();
      jailbreakChecker.checkSecurity();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  String dgAttached="";

  final JailbreakDetector _jailbreakDetector = JailbreakDetector();
  @override
  void initState() {
    //Check Security for jail break
    final jailbreakChecker = JailbreakChecker();
    jailbreakChecker.checkSecurity();
    super.initState();
    //Check if user is Login
    checkLogin();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //Get UserId from Shared preferences
      SessionManager.instance.getUser().then((User user){
        homeProvider = Provider.of<HomeViewModel>(context, listen: false);
        homeProvider.init(user.userId,context);
        homeProvider.showDialogCallback=((DialogMessage dialogMessage){
          if (!mounted) return;
          AppNotifier.showDialog(context,dialogMessage);
        });

      });
    });
  }

  checkLogin(){

    SessionManager.instance.isLoggedIn().then((val){
      if(val==false){
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', (Route<dynamic> route) => false);
      }
    });
  }

  late UserProvider userProvider;
  late HomeViewModel homeProvider;
  @override
  Widget build(BuildContext context) {

    homeProvider = context.watch<HomeViewModel>();
    userProvider = Provider.of<UserProvider>(context);


    return ((_jailbreakDetector.isJailbroken == true  || _jailbreakDetector.isDeveloperMode==true || dgAttached=="true"))?RootedDevice():Scaffold(
      body: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
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
            Column(
              children: [
                Stack(
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child:
                      Column(
                        children: [
                          SizedBox(height: 15),
                          TopBar(),
                         ClockPanel()
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child:Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      color: Colors.white,
                    ),
                    width: double.infinity,

                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ErrorPanel(),
                          OptionalUpdatePanel(),
                          SizedBox(height: 15,),
                          AppMenu()
                        ],
                      ),
                    ),
                  ),

                ),

              ],
            ),
            // ((loadingUserInfo??false))
            //     ? ProgressBar(label: 'profile'.tr())
            //     : SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar:BottomNavigation(selectedIndex: 0),
    );
  }
}