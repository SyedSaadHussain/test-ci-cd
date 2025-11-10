import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/user_notification.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/shared/widgets/modal/notification_detail_modal.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/no_data.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}
class _NotificationListScreenState extends BaseState<NotificationListScreen> {

  //region for variable
  UserService? _userService;
  UserNotificationData _notificationData =UserNotificationData();
  FieldListData fields=FieldListData();
  //endregion

  //region for events
  @override
  void initState(){
    super.initState();
    timeago.setLocaleMessages('ar', timeago.ArMessages(),);
  }
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _userService = UserService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    getNotificationCount();
  }
  @override
  void dispose() {
    super.dispose();
  }
  //endregion

  //region for methods
  void getAllNotifications(bool isReload){

    if(isReload){
      _notificationData.reset();
      setState(() {

      });
    }

    _notificationData.init();

    _userService!.getNotifications(_notificationData.pageSize,_notificationData.pageIndex).then((value){
      _notificationData.isloading=false;
      if(value.list.isEmpty)
        _notificationData.hasMore=false;
      else {
        _notificationData.count=value.count;
        _notificationData.list!.addAll(value.list!.toList());
      }
      setState((){});
    }).catchError((e){
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.flushColor,
        message: e.message,
        duration: Duration(seconds: 3),
      ).show(context);
      //isLoading=false;
      setState((){
        _notificationData.isloading=false;
        _notificationData.hasMore=false;
      });


    });
  }
  void markRead(UserNotification notification){

    if(notification.isRead==false){
      _userService!.unreadNotificationAPI(notification.id??0).then((response){
        notification.isRead=true;
        appUserProvider.decrementNotifiCount();
        setState(() {

        });
      });
    }

  }
  openNotificationModal(UserNotification notification){
    var copyNotification=UserNotification.shallowCopy(notification);
    markRead(notification);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return NotificationDetailModal(client: appUserProvider.client!,
            userNotification: copyNotification,
            onClose: (){

              Navigator.of(context).pop();
            });
      },
    );
  }
  void getNotificationCount(){

    _userService!.getNotificationCountAPI().then((response){
      print('getNotificationCount');
      print(response);
      appUserProvider.setNotificationCount(response);
    });

  }
  //endregion

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            AppBackground(),
            Container(
              child: Column(
                children: [
                  AppCustomBar(title:'notifications'.tr(),actions: [
                  ]
                  ),
                  Expanded(
                    child: Container(
                      decoration: AppBoxDecoration.mainBody,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           SizedBox(height: 10,),
                          (_notificationData.hasMore==false && _notificationData.list.length==0)?
                          NoDataFound():
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ListView.builder(
                                itemCount: _notificationData.list!.length+((_notificationData.hasMore)?1:0),
                                itemBuilder: (context, index) {
                                  if(index >= _notificationData.list!.length)
                                  {
                                    if(_notificationData.isloading==false){
                                      _notificationData.pageIndex=_notificationData.pageIndex+1;
                                      getAllNotifications(false);
                                    }
                                    return Container(
                                        height: 100,
                                        child: ProgressBar(opacity: 0));
                                  }else{
                                    return  GestureDetector(
                                      onTap: (){
                                        openNotificationModal(_notificationData.list[index]);
                                      },
                                      child: Opacity(
                                        opacity:(_notificationData.list[index].isRead??false)?0.5:1.0 ,
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10,bottom: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey.shade200,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(12),
                                                margin: EdgeInsets.symmetric(horizontal: 5),
                                                decoration: BoxDecoration(
                                                  color: _notificationData.list[index].color.withOpacity(.3),
                                                  shape: BoxShape.circle, // Make the container circular
                                                ),
                                                child: Icon(Icons.notifications,color:_notificationData.list[index].color.withOpacity(.7),size:25 ,),
                                              ),
                                              Expanded(child:Container(
                                                padding: EdgeInsets.symmetric(horizontal: 5),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(_notificationData.list[index].title??"",style: (_notificationData.list[index].isRead??false)?AppTextStyles.cardTitle: AppTextStyles.cardTitleHeading,),
                                                    Text(_notificationData.list[index].detail??"",maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,style: AppTextStyles.cardTitle,),
                                                    Row(
                                                      children: [
                                                        Expanded(child: Container()),
                                                        Text(_notificationData.list[index].createdDate==null?"":timeago.format(_notificationData.list[index].createdDate!, locale: context.locale.languageCode, allowFromNow: true),style: AppTextStyles.hint,),
                                                      ],
                                                    )

                                                  ],
                                                ),
                                              )),
                                              Icon(Icons.arrow_forward_ios_sharp,color: AppColors.gray,size: 12,)


                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
