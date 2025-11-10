import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/hive/hive_registry.dart';
import 'package:mosque_management_system/core/models/app_version.dart';
import 'package:mosque_management_system/core/models/device_info.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/core/models/prayer_time_clock.dart';
import 'package:mosque_management_system/core/models/service_menu.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';
import 'package:mosque_management_system/core/utils/app_notifier.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/device_detail.dart';
import 'package:mosque_management_system/core/utils/list_extension.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/app_update/app_update_screen.dart';

class HomeViewModel extends ChangeNotifier {
  late UserService userService;
  PrayerTimeClock? prayerTime;
  List<ServiceMenu> menu = [];
  // UserProfile? userProfile;
  String? errorMessage;
  bool isNewVersionAvailable = false;
  AppVersion? version;

  final UserProvider _userProvider;
  Function?  showDialogCallback;

  String? welcomeText;

  HomeViewModel(this._userProvider) {}

  init(userId, context) {
    errorMessage = null;

    ///Load menu
    loadMenu();

    ///Set initial value of provide, client, set language  and check session expire
    _userProvider.init(context);

    ///if User id is 0 means provider is not set yet, once we set so only user Id change
    if (_userProvider.userProfile.userId == 0)
      _userProvider.setUserProfile(UserProfile(userId: userId));

    ///create user object for API operation
    userService =
        UserService(CustomOdooClient(), userProfile: _userProvider.userProfile);



    ///Get User profile
    _userProvider.getUserProfile().then((user) {
      loadAPI(context);
    }).catchError((e){
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e));

    });
  }

  loadAPI(context) async {

    /// this API call server at most once per day
    await loadPrayerTime();

    ///Check for update, any version is available
    await checkForUpdated(context);

    ///Check the current status from API and reset the provider and hive for user profile
    checkDeviceVerification(false);

    ///this API call server at most once after new release
    updateVersionNumber();
  }

  ///Update Latest App version in CRM, this will only call API if current version and cloud version is different
  Future<void> updateVersionNumber() async{
    try{
      if (_userProvider.userProfile.userAppVersion != null) {
        await userService.updateAppVersion(_userProvider.userProfile.userAppVersion);
      }
    }catch(e){
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e,hideTimeOutError: true));
    }
  }

  ///Check any update is available
  Future<void> checkForUpdated(context) async{
    try{
      isNewVersionAvailable = false;

      await userService.getAppVersion().then((response) {
        version = response;
        if (version != null && version!.hasUpdate) {
          if (version!.hasRequiredUpdate) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => new AppUpdateScreen(
                  version: version!,
                ),
              ),
            );
          } else {
            isNewVersionAvailable = true;
          }
        }
      });
    }
    catch(e){
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e,hideTimeOutError: true));
    }

  }

  loadMenu() {
    menu = [];
    menu.add(ServiceMenu(
        name: 'all_khutbas',
        menuUrl: 'KHUTBA_MANAGEMENT',
        icon: Icons.mic,
        color: AppColors.primary,
        imagePath: 'assets/images/khutba.png',
        isImageColor: true));
    menu.add(ServiceMenu(
        name: 'kpi',
        menuUrl: 'KPI',
        icon: Icons.bar_chart,
        color: AppColors.primary));
    menu.add(ServiceMenu(
        name: 'visit',
        menuUrl: 'VISIT',
        icon: AppIcons.groupUsers,
        color: AppColors.primary));
    menu.add(ServiceMenu(
        name: 'mosque',
        menuUrl: 'MOSQUE',
        icon: AppIcons.mosque,
        color: AppColors.primary));
    menu.add(ServiceMenu(
        name: 'mosque_utilities',
        menuUrl: 'MOSQUE_UTILITIES',
        icon: Icons.electric_meter,
        color: AppColors.primary));
    // menu.add(ServiceMenu(
    //     name: 'transfer_of_employee_and_observer',
    //     menuUrl: 'EMPLOYEE_TRANSFERS',
    //     icon: Icons.swap_horiz,
    //     color: AppColors.primary));
    menu.add(ServiceMenu(
        name: 'user_guide',
        menuUrl: 'USER_GUIDE',
        icon: Icons.menu_book,
        color: AppColors.primary));
    notifyListeners();
  }

  ///Load date from hive for today, if not fetch today prayer time and save in hive, also use same time in visit
  Future<void> loadPrayerTime() async {
    // prayerTime=null;
    // notifyListeners();
    try{
      List<PrayerTime>? prayers;
      prayers = await HiveRegistry.prayerTime.getAll();
      if (prayers.length == 0) {
        await getTodayPrayerTime();
      } else {
        PrayerTime? currentPrayerTime = prayers.firstOrNull;
        if (DateFormat('yyyy-MM-dd').format(currentPrayerTime!.fajarTime!) !=
            DateFormat('yyyy-MM-dd').format(DateTime.now())) {
          await getTodayPrayerTime();
        } else {
          prayerTime = PrayerTimeClock.fromPrayerTime(currentPrayerTime);
          prayerTime!.setCurrentPrayerTime();
          notifyListeners();
        }
      }
    }catch(e){
      showDialogCallback!(DialogMessage(type: DialogType.errorException, message: e,hideTimeOutError: true));

    }
  }

  ///get today prayer time and save in hive
  Future<void> getTodayPrayerTime() async {
    PrayerTime? currentPrayerTime;
    List<PrayerTime>? prayers;
    prayers = await userService.getTodayPrayerTime();
    if (prayers.length > 0) {
      currentPrayerTime = prayers.firstOrNull;
      prayerTime = PrayerTimeClock.fromPrayerTime(currentPrayerTime!);
      prayerTime!.setCurrentPrayerTime();
      notifyListeners();
    }
  }

  /// isOnlyLoad true when call API to save status and only update to UI
  Future<void> checkDeviceVerification(bool isOnlyLoad) async{
    errorMessage = '';
    ///UserId is not 0 means user is exits
    if (_userProvider.userProfile.userId != 0) {
      DeviceDetail().getImei().then((deviceDetail) {
        DeviceInformation? loginDevice = null;
        List<DeviceInformation> registeredDevices = [];
        userService
            .getUserImei(_userProvider.userProfile.userId)
            .then((values) {
          registeredDevices = values;

          ///Get all block devices where IMEI is currently device and in not_use
          final blockedDevice = registeredDevices.firstWhereOrNull(
            (rec) =>
                (rec.imei ?? "").trim() == (deviceDetail!.imei ?? "").trim() &&
                (rec.status ?? "").trim().toLowerCase() == "not_use",
          );

          ///if the current device not in use. then skip the further process and show error on mobile
          if (blockedDevice != null) {
            _userProvider.setDeviceStatus(false);
            errorMessage = "device_not_in_use".tr();
            notifyListeners();
            return;
          }

          loginDevice = registeredDevices
              .where((rec) => (rec.imei ?? "") == (deviceDetail!.imei ?? ""))
              .firstOrNull;

          if (loginDevice != null) {
            if (loginDevice!.status == "live")
              _userProvider.setDeviceStatus(true);
            else
              _userProvider.setDeviceStatus(false);
          } else {
            _userProvider.setDeviceStatus(false);

            ///if the  new IMEI is come then insert into system
            if (isOnlyLoad == false &&
                AppUtils.isNotNullOrEmpty(deviceDetail!.imei)) {
              deviceDetail.status =
                  registeredDevices.length > 0 ? "temp" : "live";
              deviceDetail.employeeId = _userProvider.userProfile.employeeId;
              userService.saveImei(deviceDetail).then((values) {
                checkDeviceVerification(true);
              }).catchError((_) {
                try {
                  errorMessage = _.message;
                } catch (e) {
                  errorMessage = '';
                }
                notifyListeners();
              });
              // }
            }
          }
        }).catchError((e) {});
      });
    }
  }
}
