// import 'dart:async';
// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:mosque_management_system/core/constants/app_colors.dart';
// import 'package:mosque_management_system/core/models/User.dart';
// import 'package:mosque_management_system/core/models/app_version.dart';
// import 'package:mosque_management_system/core/models/device_info.dart';
// import 'package:mosque_management_system/core/models/menuRights.dart';
// import 'package:mosque_management_system/core/models/prayer_time_clock.dart';
// import 'package:mosque_management_system/core/models/service_menu.dart';
// import 'package:mosque_management_system/core/utils/app_utils.dart';
// import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
// import 'package:mosque_management_system/data/repositories/common_repository.dart';
// import 'package:mosque_management_system/data/services/notification_service.dart';
// import 'package:mosque_management_system/data/services/user_service.dart';
// import 'package:mosque_management_system/features/app_update/app_update_screen.dart';
// import 'package:mosque_management_system/features/home/home_view_model.dart';
// import 'package:mosque_management_system/features/khutba/khutba_list_screen.dart';
// import 'package:mosque_management_system/features/screens/all_mosque_request.dart';
// import 'package:mosque_management_system/features/screens/all_mosques.dart';
// import 'package:mosque_management_system/features/screens/assign_visit.dart';
// import 'package:mosque_management_system/features/notification/notification_list_screen.dart';
// import 'package:mosque_management_system/features/screens/create_masjid.dart';
// import 'package:mosque_management_system/features/screens/create_visit.dart';
// import 'package:mosque_management_system/features/kpi/kpi_screen.dart';
// import 'package:mosque_management_system/features/profile/profile_screen.dart';
// import 'package:mosque_management_system/features/settings/settings_screen.dart';
// import 'package:mosque_management_system/features/screens/surveylist_screen.dart';
// import 'package:mosque_management_system/features/screens/today_visits.dart';
// import 'package:mosque_management_system/core/providers/user_provider.dart';
// import 'package:mosque_management_system/core/styles/text_styles.dart';
// import 'package:mosque_management_system/core/utils/Jailbreak_detector.dart';
// import 'package:mosque_management_system/core/utils/app_icons.dart';
// import 'package:mosque_management_system/core/constants/config.dart';
// import 'package:mosque_management_system/core/utils/current_date.dart';
// import 'package:mosque_management_system/core/utils/device_detail.dart';
// import 'package:mosque_management_system/core/utils/jailbreak_checker.dart';
// import 'package:mosque_management_system/core/utils/json_utils.dart';
// import 'package:mosque_management_system/core/utils/list_extension.dart';
// import 'package:mosque_management_system/core/utils/proxy_http_client%20.dart';
// import 'package:mosque_management_system/core/utils/security.dart';
// import 'package:mosque_management_system/core/services/shared_preference.dart';
// import 'package:mosque_management_system/core/utils/trace_location_service.dart';
// import 'package:mosque_management_system/features/visit/dashboard/visit_dashboard.dart';
// import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
// import 'package:mosque_management_system/shared/widgets/app_container.dart';
// import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
// import 'package:mosque_management_system/shared/widgets/prayer_clock.dart';
// import 'package:mosque_management_system/shared/widgets/rooted_device.dart';
// import 'package:mosque_management_system/shared/widgets/service_button.dart';
// import 'package:mosque_management_system/shared/widgets/tag_button.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/io_client.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// import '../screens/main_survey_visit.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
//
//   late CommonRepository _odooRepository;
//   CustomOdooClient? client;
//   UserService? _userService;
//   int? _loginEmployeeId;
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async{
//     if (state == AppLifecycleState.resumed) {
//       final jailbreakChecker = JailbreakChecker();
//       jailbreakChecker.checkSecurity();
//     }
//
//
//
//     if (state == AppLifecycleState.resumed) {
//       traceLocation.resumed();
//        // userProvider.resetNotificationCount();
//       // getNotificationCount();
//     } else if (state == AppLifecycleState.paused) {
//       print('isAppInForeground');
//       traceLocation.paused();
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _timer?.cancel();
//     traceLocation.dispose();
//     if(client!=null)
//       client!.close();
//     super.dispose();
//   }
//
//   Timer? _timer;
//   String dgAttached="";
//
//   late CurrentDate currentDate;
//   List<ServiceMenu> menu=[];
//   MenuRights? menuRights;
//   void getMenuRights(){
//      setState(() {
//        loadingMenuRights=true;
//      });
//     _userService!.getMenuRightsAPI().then((value){
//       loadingMenuRights=false;
//       menuRights=value;
//       menu=menuRights!.getAllMenus();
//
//       setState(() {
//
//       });
//
//     }).catchError((e){
//       setState(() {
//         loadingMenuRights=false;
//       });
//       Flushbar(
//         icon: Icon(
//           Icons.warning,
//           color: Colors.white,
//         ),
//         backgroundColor: AppColors.flushColor,
//         message: AppUtils.getErrorMessage(e),
//         duration: Duration(seconds: 3),
//       ).show(context);
//     });
//   }
//
//   late TraceLocationService traceLocation;
//   @override
//   void initState() {
//     // checkSecurity();
//     final jailbreakChecker = JailbreakChecker();
//     jailbreakChecker.checkSecurity();
//
//     super.initState();
//
//     homeProvider = Provider.of<HomeViewModel>(context, listen: false);
//     // homeProvider.init();
//
//     userProvider = Provider.of<UserProvider>(context, listen: false);
//     loadApplication();
//
//     currentDate=CurrentDate();
//     WidgetsBinding.instance.addObserver(this);
//     traceLocation=TraceLocationService(interval: 60,onTimeUpdate: (val){
//       userProvider.setCoordinates(val);
//     });
//     traceLocation.startTracing();
//
//   }
//
//   String? fcmToken;
//   bool? loadingUserInfo;
//   bool? loadingMenuRights;
//   void loadApplication(){
//
//     try{
//         Future<User> user = UserPreferences().getUser();
//         user.then((value) {
//
//           http.BaseClient? httpClient;
//           //Set Proxy if App build fot burp testing.
//           if(Config.isProxyEnable){
//             httpClient = CustomHttpClient(value.proxy??"").createClient();
//           }
//           //Create Client that will use by all screen
//           userProvider.initializeClient("",value.session,httpClient);
//           client = userProvider.client;
//           if(client==null){
//             Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
//           }
//           // userProvider.setDatabaseUrl(value.baseUrl);
//
//
//
//
//           _odooRepository = CommonRepository(client);
//           //Update User profile in provider
//           dynamic currentLanguage=LocalizeAndTranslate.getLanguageCode()=='ar'?Language.arabic:Language.english;
//           setState(() {
//               loadingUserInfo=true;
//           });
//           _odooRepository!.getUserInfoAPI(currentLanguage).then((value) {
//             setState(() {
//               loadingUserInfo=false;
//             });
//             Sentry.configureScope((scope) {
//               scope.setUser(SentryUser(
//                   id:value.userId.toString(),
//                   name: value.name.toString()
//               ));
//             });
//             userProvider.setUserProfile(value);
//             _loginEmployeeId=value.employeeId;
//             checkDeviceVerification(false);
//             userProvider.setLanguage(LocalizeAndTranslate.getLanguageCode());
//             _userService = UserService(client!,userProfile: userProvider.userProfile);
//
//             getPrayerTime();
//             getMenuRights();
//             checkForUpdated();
//             updateVersionNumber(value.userAppVersion);
//             // getNotificationCount();
//             //Update FCM if is different
//             // if(value.fcmToken!=fcmToken){
//             //   _userService!.updateToken(fcmToken);
//             // }
//
//           }).catchError((e){
//             setState(() {
//               loadingUserInfo=false;
//             });
//             Flushbar(
//               icon: Icon(
//                 Icons.warning,
//                 color: Colors.white,
//               ),
//               backgroundColor: AppColors.flushColor,
//               message: AppUtils.getErrorMessage(e),
//               duration: Duration(seconds: 3),
//             ).show(context);
//
//             _userService = UserService(client!,userProfile: userProvider.userProfile);
//             getPrayerTime();
//             getMenuRights();
//           });
//
//           //Check Is Sessoin Expire
//           _odooRepository.ischeckSessionExpire().timeout(Duration(seconds: 5)).then((value){
//             if (value) {
//               // userProvider.logout();
//               UserPreferences().logout();
//             }
//           });
//         });
//     }
//     catch(e){
//       Flushbar(
//         icon: Icon(
//           Icons.warning,
//           color: Colors.white,
//         ),
//         backgroundColor: AppColors.flushColor,
//         message: AppUtils.getErrorMessage(e),
//         duration: Duration(seconds: 3),
//       ).show(context);
//     }
//   }
//
//   final JailbreakDetector _jailbreakDetector = JailbreakDetector();
//   bool isNewVersionAvailable=false;
//   AppVersion? version;
//   void checkForUpdated(){
//     isNewVersionAvailable=false;
//
//     _userService!.getAppVersion().then((response){
//       version=response;
//       if(version!=null && version!.hasUpdate){
//         if(version!.hasRequiredUpdate){
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//               new AppUpdateScreen(version: version!,),
//             ),
//           );
//         }else{
//           isNewVersionAvailable=true;
//           setState(() {
//
//           });
//         }
//
//
//         // version!.showAlertIfNecessary(context);
//       }
//     });
//
//   }
//   void updateVersionNumber(currentVersion){
//     _userService!.updateAppVersion(currentVersion).then((response){
//
//     });
//
//   }
//   String? errorMessage;
//   void checkDeviceVerification(bool isOnlyLoad){
//     errorMessage='';
//     if(_loginEmployeeId!=null) {
//
//       DeviceDetail().getImei().then((deviceDetail) {
//         DeviceInformation? loginDevice = null;
//         List<DeviceInformation> registeredDevices = [];
//         _userService!.getUserImei(_loginEmployeeId!).then((values) {
//
//           registeredDevices = values;
//           loginDevice = registeredDevices
//               .where((rec) => (rec.imei ?? "") == (deviceDetail!.imei ?? ""))
//               .firstOrNull;
//
//           if (loginDevice != null) {
//             if (loginDevice!.status == "live")
//               userProvider.setDeviceStatus(true);
//             else
//               userProvider.setDeviceStatus(false);
//           } else {
//             userProvider.setDeviceStatus(false);
//
//             if (isOnlyLoad == false &&
//                 AppUtils.isNotNullOrEmpty(deviceDetail!.imei)) {
//               //No need this code
//               //loginDevice=registeredDevices.where((rec)=>(rec.employeeId??"")==(userProvider.userProfile.employeeId)).firstOrNull;
//               //if(loginDevice==null){
//               deviceDetail!.status =
//               registeredDevices.length > 0 ? "temp" : "live";
//               _userService!.saveImei(deviceDetail).then((values) {
//                 checkDeviceVerification(true);
//               }).catchError((_) {
//
//                 try{
//                   errorMessage=_.message;
//                 }catch(e){
//                   errorMessage='';
//                 }
//                 setState(() {
//
//
//                 });
//               });
//               // }
//             }
//           }
//         }).catchError((e) {
//
//         });
//       });
//     }
//
//   }
//
//   List<dynamic>  visitGraph=[];
//   List<dynamic>  surveyGraph=[];
//   List<dynamic>   mosqueGraph=[];
//   List<dynamic>?  visitSummaryDetail;
//   PrayerTimeClock? _prayerTime;
//   void loadPrayerTime(){
//     _userService!.getPrayerTime().then((value){
//
//       _prayerTime=value;
//       _prayerTime!.setCurrentPrayerTime();
//       try{
//         _timer!.cancel();
//       }catch(e){
//
//       }
//       DateTime targetTime=_prayerTime!.upComingPrayerDateTime;
//       Duration timeUntilTarget = targetTime.isBefore(DateTime.now())
//           ? Duration.zero // If the target time has already passed, set it to 0
//           : targetTime.difference(DateTime.now());
//
//       // Schedule the timer to reload upcomming prayer time
//       if (timeUntilTarget > Duration.zero) {
//         timeUntilTarget += Duration(minutes: 1);
//         _timer = Timer(timeUntilTarget, (){
//           _prayerTime!.setCurrentPrayerTime();
//         });
//       }
//       setState(() {
//       });
//     }).catchError((e){
//       print(e);
//     });
//   }
//   void getPrayerTime(){
//     loadPrayerTime();
//   }
//
//
//   late UserProvider userProvider;
//   late HomeViewModel homeProvider;
//   @override
//   Widget build(BuildContext context) {
//
//     homeProvider = context.watch<HomeViewModel>();
//     userProvider = Provider.of<UserProvider>(context);
//     // if(_userService!=null)
//     //   _userService!.updateUserProfile(userProvider.userProfile);
//
//
//     return ((_jailbreakDetector.isJailbroken == true  || _jailbreakDetector.isDeveloperMode==true || dgAttached=="true"))?RootedDevice():Scaffold(
//       body: Scaffold(
//         backgroundColor: Theme.of(context).primaryColor,
//         body: Stack(
//           children: [
//             Positioned.fill(
//               child: Opacity(
//                 opacity: .4,
//                 child: Image.asset(
//                   'assets/images/splash.png', // Replace with your image URL
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 Stack(
//                   children: [
//
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 15),
//                       child:
//                       Column(
//                         children: [
//
//                           SizedBox(height: 50,),
//                           Align(
//                               alignment: Alignment.topRight,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Icon(Icons.notifications_active_rounded,color:Theme.of(context).colorScheme.onPrimary,size:20 ,),
//
//                                   Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white, // Background color
//                                       borderRadius: BorderRadius.circular(15), // Rounded corners
//
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Text(userProvider.userProfile.name??"",style: TextStyle(color: AppColors.primary,fontSize: 14),),
//                                         Container(
//                                           padding: EdgeInsets.symmetric(horizontal: 5),
//                                           child: userProvider.isDeviceVerify?GestureDetector(
//                                             onTap: (){
//
//                                             },
//                                             child: Icon(
//                                               Icons.check_circle,
//                                               color: Colors.green, // Set the color to green
//                                               size: 20.0, // Optional: Adjust the size of the icon
//                                             ),
//                                           ):GestureDetector(
//                                             onTap: (){
//
//                                               checkDeviceVerification(false);
//                                             },
//                                             child: Icon(
//                                               Icons.warning,
//                                               color: Colors.amber, // Set the color to green
//                                               size: 20.0, // Optional: Adjust the size of the icon
//                                             ),
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//
//                                   Expanded(child: Container()),
//                                   GestureDetector(
//                                     onTap: (){
//                                       // Navigator.push(
//                                       //   context,
//                                       //   MaterialPageRoute(
//                                       //     builder: (context) => AllKhutbas(),
//                                       //   ),
//                                       // );
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => NotificationListScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                           padding: EdgeInsets.all(6),
//                                           margin: EdgeInsets.symmetric(horizontal: 5),
//                                           decoration: BoxDecoration(
//                                             color: AppColors.onPrimaryLight,
//                                             shape: BoxShape.circle, // Make the container circular
//                                           ),
//                                           child: Icon(Icons.notifications_active_rounded,color:Theme.of(context).colorScheme.primary,size:16 ,),
//                                         ),
//                                         if (userProvider.TotalNotification>0)
//                                           Positioned(
//                                             right: 0,
//                                             top: -5,
//                                             child: Container(
//                                               padding: const EdgeInsets.all(2),
//                                               decoration: const BoxDecoration(
//                                                 color: Colors.red,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               constraints: const BoxConstraints(
//                                                 minWidth: 14,
//                                                 minHeight: 14,
//                                               ),
//                                               child: Text(
//                                                 userProvider.TotalNotification.toString(),
//                                                 style: const TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 12,
//                                                 ),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.all(6),
//                                     decoration: BoxDecoration(
//                                       color: AppColors.onPrimaryLight,
//                                       shape: BoxShape.circle, // Make the container circular
//                                     ),
//                                     child: PopupMenuButton(
//                                       child: Icon(AppIcons.bar,color:Theme.of(context).colorScheme.primary,size:16 ,),
//                                       padding: EdgeInsets.zero,
//                                       color: AppColors.flushColor,
//                                       //icon: Icon(Icons.more_vert,color:Theme.of(context).colorScheme.primary ,), // Dotted button icon
//                                       itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//                                         PopupMenuItem(
//                                           child: ListTile(
//                                             leading: Icon(Icons.settings,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.7),),
//                                             title: Text('settings'.tr(),style: TextStyle(color:Theme.of(context).colorScheme.onPrimary.withOpacity(.7) ),),
//                                           ),
//                                           value: 'settings',
//                                         ),
//
//                                         PopupMenuItem(
//                                           child: ListTile(
//                                             leading: Icon(Icons.logout,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.7) ),
//                                             title: Text('logout'.tr(),style: TextStyle(color:Theme.of(context).colorScheme.onPrimary.withOpacity(.7) )),
//                                           ),
//                                           value: 'logout',
//                                         ),
//                                       ],
//                                       onSelected: (value) {
//                                         // Handle menu item selection
//                                         switch (value) {
//                                           case 'settings':
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) =>
//                                                 new Settings(),
//                                               ),
//                                             );
//                                             break;
//                                           case 'logout':
//                                             UserPreferences().logout();
//                                             break;
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               )
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children:[
//                                 Expanded(child: PrayerClock(onTab: (){
//                                   loadPrayerTime();
//                                 }, size: 180,currentDate: currentDate.hijriMonthYear,
//                                   title: Row(
//                                     children: [
//                                       Text(
//                                         (_prayerTime?.currentPrayerTime??""),
//                                         style: TextStyle(
//                                           color: Colors.white.withOpacity(.8),
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                       SizedBox(width: 2,),
//                                       Text(
//                                         (_prayerTime?.currentPrayerName.tr()??""),
//                                         style: TextStyle(
//                                           color: Colors.white.withOpacity(.8),
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                       Text(
//                                         ' >> ',
//                                         style: TextStyle(
//                                             color: Colors.white.withOpacity(.8),
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold
//                                         ),
//                                       ),
//                                       Text(
//                                         (_prayerTime?.upComingPrayerTime??""),
//                                         style: TextStyle(
//                                           color: Colors.white.withOpacity(.8),
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                       SizedBox(width: 2,),
//                                       Text(
//                                         (_prayerTime?.upComingPrayerName.tr()??""),
//                                         style: TextStyle(
//                                           color: Colors.white.withOpacity(.8),
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ],
//                                   ),)),
//                               ]
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Expanded(
//                   child:Container(
//                     padding: EdgeInsets.symmetric(horizontal: 0),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(15.0),
//                         topRight: Radius.circular(15.0),
//                       ),
//                       color: Colors.white,
//                     ),
//                     width: double.infinity,
//
//                     child: ((loadingMenuRights??false))?ProgressBar(label: 'services'.tr()):SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           //
//                           isNewVersionAvailable?Container(
//                             padding: EdgeInsets.symmetric(horizontal: 0),
//                             margin: EdgeInsets.only(top: 15),
//
//                             decoration: BoxDecoration(
//                               color: AppColors.onPrimaryLight,
//                               borderRadius: BorderRadius.circular(5), // Adjust the radius here
//                             ),
//                             child: Row(
//
//                                 children: [
//                                   Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 8),
//                                       child: Icon(Icons.info,color: AppColors.primary,size: 16,)),
//
//                                   Expanded(child: Text('new_version_title'.tr(),style: AppTextStyles.cardTitle,  overflow: TextOverflow.ellipsis )),
//                                   AppButtonSmall(text: 'update_app'.tr(),color: AppColors.primary,onTab: (){
//                                     version!.launchAppStore();
//                                   })
//
//                                 ]
//                             ),
//                           ):Container(),
//                           (errorMessage??"")!=""?Container(
//
//                             margin: EdgeInsets.only(top: 15),
//
//                             decoration: BoxDecoration(
//                               color: AppColors.warning.withOpacity(.1),
//                               borderRadius: BorderRadius.circular(5), // Adjust the radius here
//                             ),
//                             child: Row(
//                                 children: [
//                                   Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 8),
//                                       child: Icon(Icons.warning,color: AppColors.warning,size: 16,)),
//
//                                   Expanded(child:
//                                   Container(
//                                       padding: EdgeInsets.symmetric(vertical: 8),
//                                       child: Text((errorMessage??"").trim(),style: AppTextStyles.cardTitle,  overflow: TextOverflow.visible ))),
//
//
//                                 ]
//                             ),
//                           ):Container(),
//
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10.0),
//                                 topRight: Radius.circular(10.0),
//                               ),
//                               color: Colors.white,
//                             ),
//                             width: double.infinity,
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(height: 20,),
//                                   Container(
//                                       padding: EdgeInsets.symmetric(horizontal: 5),
//                                       child: Text('services'.tr(),style: AppTextStyles.heading2,)),
//
//                                   Container(
//                                     padding: EdgeInsets.symmetric(horizontal: 5),
//                                     child: MediaQuery.removePadding(
//                                       context: context,
//                                       removeTop: true,
//                                       child: GridView.count(
//                                         crossAxisCount: 3,
//                                         shrinkWrap: true,
//                                         physics: NeverScrollableScrollPhysics(),
//                                         children: List.generate(
//                                           menu.length,
//                                               (index) =>
//                                               ServiceButton(text: menu[index].name.tr(),icon: menu[index].icon,color: AppColors.backgroundColor,
//                                                   iconPath: menu[index].imagePath,
//                                                   onColor: AppColors.primary,
//
//                                                   isIconPathColor: menu[index].isImageColor??true,
//                                                   onTab: (){
//                                                     switch (menu[index].menuUrl) {
//                                                       case 'KHUTBA_MANAGEMENT':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(builder: (context) => KhutbaListScreen()),
//                                                         );
//                                                         break;
//                                                       case 'NEW_MOSQUE':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new CreateMosque(),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'MOSQUE_EDIT_REQUEST':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new AllMosqueRequest(),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'KPI':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new KpiScreen(),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'VISIT':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new VisitDashboardView(),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'CREATE_VISIT':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new CreateVisit(),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'ASSIGN_VISIT':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new AssignVisit(),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'TODAY_VISIT':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new TodayVisits(filter: this.menuRights!.searchVisit!.filter),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'MOSQUES':
//                                                         Navigator.push(
//                                                           context,
//                                                           MaterialPageRoute(
//                                                             builder: (context) => new AllMosques(filter: this.menuRights!.mosqueList!.filter),
//                                                             //HalqaId: 1
//                                                           ),
//                                                         );
//                                                         break;
//                                                       case 'SURVEY_VISITS':
//                                                         final userProvider = Provider.of<UserProvider>(context, listen: false);
//
//                                                         if (userProvider.isDeviceVerify || Config.disableValidation) {
//                                                           Navigator.push(
//                                                             context,
//                                                             MaterialPageRoute(
//                                                               builder: (context) => SurveyVisitScreen(),
//                                                             ),
//                                                           );
//                                                         } else {
//                                                           Flushbar(
//                                                             icon: Icon(Icons.warning, color: Colors.white),
//                                                             backgroundColor: AppColors.danger,
//                                                             message: "device_not_unverified".tr(),
//                                                             duration: Duration(seconds: 3),
//                                                           ).show(context);
//                                                         }
//                                                         break;
//                                                       default:
//                                                         print('');
//                                                     }
//
//                                                   }),
//                                         ),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 ),
//                 // Add more widgets as needed
//               ],
//             ),
//             ((loadingUserInfo??false))
//                 ? ProgressBar(label: 'profile'.tr())
//                 : SizedBox.shrink(),
//           ],
//         ),
//       ),
//       bottomNavigationBar:client==null?null:BottomNavigation(selectedIndex: 0),
//     );
//   }
// }