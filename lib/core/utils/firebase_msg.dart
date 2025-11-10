// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:mosque_management_system/data/services/notification_service.dart';
// import 'package:mosque_management_system/main.dart';
// import 'package:mosque_management_system/core/providers/user_provider.dart';
// import 'package:mosque_management_system/core/services/shared_preference.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FirebaseMsg{
//
//   final msgService=FirebaseMessaging.instance;
//
//   initFCM() async{
//     try {
//       await msgService.requestPermission();
//       var token=await msgService.getToken();
//       print('token:$token');
//       if (token != null) {
//         await UserPreferences().saveFcmToken(token);
//       }
//
//       FirebaseMessaging.onMessage.listen(handleOnMessage);
//     } catch (e) {
//       print("initFCM failed: $e");
//       // Check if it's a FirebaseInstallationsException and try to reset
//       if (e.toString().contains('FirebaseInstallationsException')) {
//         print("Resetting Firebase Installation ID...");
//       }
//     }
//   }
// }
//
// Future<void> handleOnMessage(RemoteMessage msg) async{
//   if(msg.notification==null){
//     dynamic totalCount=await UserPreferences().incNotificationCount();
//     final context = navigatorKey.currentContext;
//     var provider=await Provider.of<UserProvider>(context!, listen: false);
//     provider.setNotificationCount(totalCount);
//   }
// }
//
