//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:mosque_management_system/main.dart';
// import 'package:mosque_management_system/features/notification/notification_list_screen.dart';
// import 'package:mosque_management_system/core/providers/user_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotificationService{
//   final notificationPlugin=FlutterLocalNotificationsPlugin();
//
//   bool _isInitialized = false;
//   bool get isInitialized => _isInitialized;
//
//   Future<void> iniNotification() async {
//     // If already initialized, return
//     if (_isInitialized) return;
//
//
//     // Prepare Android initialization settings
//     const initSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // Prepare iOS initialization settings
//     const initSettingIos = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const initSetting = InitializationSettings(
//       iOS: initSettingIos,
//       android: initSettingAndroid,
//     );
//
//     // Initialize the plugin
//     await notificationPlugin.initialize(initSetting,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // Handle notification tapped
//       String? payload = response.payload;
//       BuildContext? ctx = navigatorKey.currentContext;
//       var appUserProvider = Provider.of<UserProvider>(ctx!, listen: false);
//       if(appUserProvider.client!=null){
//         navigatorKey.currentState?.push(
//           MaterialPageRoute(
//             builder: (context) => AllNotifications(),
//           ),
//         );
//       }
//     },);
//
//     _isInitialized = true;
//   }
//
//   Future<void> showNotification({int id=0,String? title,String? body}) async {
//
//      BigTextStyleInformation bigTextStyleInformation =
//     BigTextStyleInformation(
//       body??"",
//       htmlFormatBigText: true,
//       contentTitle: title??null,
//       htmlFormatContentTitle: false,
//       summaryText: '',
//       htmlFormatSummaryText: true,
//     );
//      AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//         'daily_channel_ids', 'Daily Notification',
//         channelDescription: 'Daily Notification Channel',
//         styleInformation: bigTextStyleInformation,
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//
//
//     );
//      NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails, iOS: DarwinNotificationDetails());
//     await notificationPlugin.show(
//         id++,  title ?? '',
//         body ?? '', notificationDetails);
//   }
//
// }