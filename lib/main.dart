import 'dart:io';
//
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/environment.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/services/session_manager.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/notification_service.dart';
import 'package:mosque_management_system/core/providers/authProvider.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/Jailbreak_detector.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/jailbreak_checker.dart';
import 'package:mosque_management_system/core/utils/security.dart';
import 'package:mosque_management_system/core/services/shared_preference.dart';
import 'package:mosque_management_system/features/home/home_view_model.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/shared/widgets/rooted_device.dart';
import 'package:mosque_management_system/shared/widgets/waiting_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/models/User.dart';
import 'features/home/home_screen.dart';
import 'features/login/login_screen.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mosque_management_system/core/utils/android_security.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'features/mosque/core/models/employee_local.dart';
import 'features/mosque/core/models/mosque_edit_request_model.dart';
import 'features/mosque/core/models/mosque_local.dart';
import 'features/screens/welcome_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// @pragma('vm:entry-point') // Optional but recommended
// Future<void> handleBackgroundNotification(RemoteMessage msg) async{
//   final isLoggedIn = await UserPreferences().isLoggedIn();
//   if (msg.notification == null && isLoggedIn) {
//     dynamic totalCount=await UserPreferences().incNotificationCount();
//     NotificationService().showNotification(
//       id: 0,
//       title: "MOIA",
//       body: "You have $totalCount unread messages",
//     );
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Required!
//   //HttpOverrides.global = MyHttpOverrides();
//   await LocalizeAndTranslate.init(
//     assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
//     supportedLanguageCodes: <String>['ar', 'en'],
//     defaultType: LocalizationDefaultType.asDefined,
//   );
//
//   // final JailbreakDetector _jailbreakDetector = JailbreakDetector();
//   //
//   //  print('checkis_DebuggerAttached');
//   // if(Platform.isIOS && (await Security.isDebuggerAttached()=="true")){
//   //   print('isDebuggerAttached');
//   //    exit(0);
//   // }
//   //
//   //
//   // print('final_isDebuggerAttached');
//   // await _jailbreakDetector.initPlatformState();
//   // if(_jailbreakDetector.isDeveloperMode || _jailbreakDetector!.isJailbroken){
//   //   exit(0);
//   // }
//
//   final jailbreakChecker = JailbreakChecker();
//   await jailbreakChecker.checkSecurity();
//
//
//   runApp(const MyApp());
// }

Future<void> main() async {
  ///Setup the env of app base on --dart-define=ENV=[ENV_VARIABLE], if no value set it get from Config.defaultFlutterEnv
  const env = String.fromEnvironment('ENV', defaultValue: Config.defaultFlutterEnv);
  switch (env) {
    case 'dev':
      EnvironmentConfig.init(Environment.staging);
      break;
    case 'uat':
      EnvironmentConfig.init(Environment.uat);
      break;
    case 'preprod':
      EnvironmentConfig.init(Environment.preprod);
      break;
    case 'prod':
      EnvironmentConfig.init(Environment.prod);
      break;
    default:
      EnvironmentConfig.init(Environment.staging);
      break;
  }
  WidgetsFlutterBinding.ensureInitialized(); // Required!
  final info = await PackageInfo.fromPlatform();

  await Hive.initFlutter();
  Hive.registerAdapter(VisitOndemandModelAdapter());
  Hive.registerAdapter(RegularVisitModelAdapter());
  Hive.registerAdapter(VisitFemaleModelAdapter());
  Hive.registerAdapter(VisitJummaModelAdapter());
  Hive.registerAdapter(VisitLandModelAdapter());
  Hive.registerAdapter(VisitEidModelAdapter());
  Hive.registerAdapter(PrayerTimeAdapter());
  Hive.registerAdapter(ComboItemAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(MosqueLocalAdapter());
  Hive.registerAdapter(EmployeeLocalAdapter());
  Hive.registerAdapter(MosqueEditRequestModelAdapter());

  // Initialize Sentry FIRST
  if (Config.enableSentry) {
    await SentryFlutter.init(
      (o) {
        o.dsn =
            'https://226258d47bab4466d6269cde32acc869@o4509633048477696.ingest.us.sentry.io/4509633059749888';

        // REQUIRED for performance
        // o.enableAutoPerformanceTracing = true; // turns on transactions/spans
        // o.tracesSampleRate = 0.3; // start 0.3–1.0, tune later
        // // optional but useful
        // o.profilesSampleRate = 0.2; // mobile CPU profiling
        // o.sendDefaultPii = true;
        // o.debug = true; // <-- add
        o.diagnosticLevel = SentryLevel.debug; // <-- add

        // good hygiene for dashboards
        o.environment = kReleaseMode ? 'production' : 'debug';
        o.release = '${info.packageName}@${info.version}+${info.buildNumber}';

        // (optional) only propagate tracing to your domains
        // o.tracePropagationTargets.addAll([
        //
        //   // or plain strings are okay too:
        //    'http://172.20.10.75:8069/',
        //    'moia.gov.sa',
        // ]);
      },
      appRunner: () async {
        await initializeApp();
      },
    );
  } else {
    await initializeApp(); //  Sentry not used
  }
}
// YOUR original localization init
// await LocalizeAndTranslate.init(
//   assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
//   supportedLanguageCodes: <String>['ar', 'en'],
//   defaultType: LocalizationDefaultType.asDefined,
// );
//
// // YOUR original security check
// final jailbreakChecker = JailbreakChecker();
// await jailbreakChecker.checkSecurity();
//
// // Now run your app!
// runApp(const MyApp());
//     },
//   );
// }

Future<void> initializeApp() async {
  await LocalizeAndTranslate.init(
    assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
    supportedLanguageCodes: <String>['ar', 'en'],
    defaultType: LocalizationDefaultType.asDefined,
  );

  final jailbreakChecker = JailbreakChecker();
  await jailbreakChecker.checkSecurity();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _noScreenshot = NoScreenshot.instance;

  String dgAttached = "";
  final JailbreakDetector _jailbreakDetector = JailbreakDetector();
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Config.isEnableSS)
      _noScreenshot.screenshotOn();
    else
      _noScreenshot.screenshotOff();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // await checkSecurity();
      final jailbreakChecker = JailbreakChecker();
      await jailbreakChecker.checkSecurity();
    }
  }

  Future<void> checkSecurity() async {
    if (Platform.isIOS) {
      dgAttached = await Security.isDebuggerAttached();
      if (dgAttached == "true") {
        exit(0);
      }
    }
    await _jailbreakDetector.initPlatformState();
    if (_jailbreakDetector.isDeveloperMode || _jailbreakDetector.isJailbroken) {
      if (mounted) {
        setState(() {}); // Trigger a rebuild after initialization
      }
      exit(0);
    }
  }

  // const MyApp({super.key});
  Future<bool> isUserLogin() async {
    final jailbreakChecker = JailbreakChecker();
    await jailbreakChecker.checkSecurity();
    try {
      return await SessionManager.instance.isLoggedIn();
    } catch (e) {
      return false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(
            create: (context) => HomeViewModel(
              context.read<UserProvider>(), // inject dependency
            ),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey, // ← here
            // style 1
            // navigatorObservers: [SentryNavigatorObserver()],
            localizationsDelegates: context.delegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            builder: (BuildContext context, Widget? child) {
              child = LocalizeAndTranslate.directionBuilder(context, child);
              if (EnvironmentConfig.envName!=Environment.prod) {
                  return Banner(
                  message: EnvironmentConfig.envName.name,
                  location: BannerLocation.topEnd,
                  color: Colors.red,
                  textStyle: TextStyle(fontSize: 15,),
                  child: child,
                  );
              }
              return child;
            },
            theme: ThemeData(
              canvasColor: Colors.white,
              tabBarTheme: TabBarTheme(
                  unselectedLabelColor: Colors.grey, dividerHeight: 1),
              appBarTheme: AppBarTheme(
                  backgroundColor: AppColors.backgroundColor.withOpacity(.5),
                  surfaceTintColor: AppColors.backgroundColor,
                  titleTextStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.gray,
                      fontWeight: FontWeight.w300)),
              dialogTheme: DialogTheme(
                backgroundColor: Colors.white, // 👈 Add this
                titleTextStyle:
                    TextStyle(fontSize: 20, color: Color(0xff4a4a4a)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                ),
              ), // Change this color as needed
              scaffoldBackgroundColor:  AppColors.backgroundColor,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppColors.secondly),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the value as needed
                    ),
                  ),
                  // Customize other button properties here
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,

                fillColor: Colors.white,
                hintStyle:
                    TextStyle(color: Colors.grey), // Set hint text color here
                labelStyle:
                    TextStyle(color: Colors.grey), // Set label text color here
                contentPadding: EdgeInsets.all(15),
                isDense: true,
                // errorStyle: TextStyle(fontSize: 0),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors
                        .grey.shade300, // Set your desired border color here
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors
                        .grey.shade300, // Set your desired border color here
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors
                        .grey.shade300, // Set your desired border color here
                  ),
                ),
              ),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: AppColors.primary,
                primaryContainer: AppColors.primaryContainer,
                secondary: AppColors.secondly,
              ),
            ),
            home: FutureBuilder(
                future: isUserLogin(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return WaitingPage(() {
                        isUserLogin();
                        // setState(() {});
                      });
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else if ((_jailbreakDetector.isJailbroken == true ||
                          _jailbreakDetector.isDeveloperMode == true ||
                          dgAttached == "true"))
                        return RootedDevice();
                      else if (snapshot.data == false)
                        return WelcomeScreen();
                      else {
                        //Navigator.pushReplacementNamed(context, '/dashboard');
                        return HomeScreen();
                      }
                  }
                }),
            routes: {
              '/login': (context) => WelcomeScreen(),
              '/dashboard': (context) => HomeScreen(),
              // '/blueButton': (context) => BlueButton(),
            }),
      ),
    );
  }
}
