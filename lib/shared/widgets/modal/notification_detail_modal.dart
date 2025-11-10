import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/models/user_notification.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/data/services/visit_service.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;
import 'package:timeago/timeago.dart' as timeago;

class NotificationDetailModal extends StatefulWidget {
  final CustomOdooClient client;
  final Function onClose;
  final UserNotification? userNotification;
  NotificationDetailModal({required this.client,required this.onClose,this.userNotification});
  @override
  _NotificationDetailModalState createState() => _NotificationDetailModalState();
}

class _NotificationDetailModalState extends State<NotificationDetailModal> {
  CityData data= CityData();
  List<Region> filteredUsers= [];
  UserService? _userServices;

  Visit _filter=Visit(id: 0);

  @override
  void initState() {

    super.initState();
    setState(() {

    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userServices = UserService(this.widget.client!,userProfile: userProvider.userProfile);

    });
  }
  @override
  void dispose() {
    super.dispose();

  }



  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        this.widget.onClose();
        return true;
      },
      child: SizedBox(
         height: MediaQuery.of(context).size.height /1.3,
        child: Container(

          // margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), // Adjust top radius here
              topRight: Radius.circular(8),
            ),
          ),

          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                SizedBox(height: 20),
                Text('notification_detail'.tr(),style: TextStyle(color: AppColors.gray,fontWeight: FontWeight.bold,fontSize: 24),textAlign: TextAlign.center,),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: this.widget.userNotification!.color.withOpacity(.1),
                    shape: BoxShape.circle, // Make the container circular
                  ),
                  child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: this.widget.userNotification!.color.withOpacity(.1),
                        shape: BoxShape.circle, // Make the container circular
                      ),
                      child: Icon(Icons.notifications_active_rounded,color: this.widget.userNotification!.color.withOpacity(.4),size: 80,)),
                ),
                SizedBox(height: 10),
                Expanded(

                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Container()),
                              Text(this.widget.userNotification!.createdDate==null?"":timeago.format(this.widget.userNotification!.createdDate!, locale: context.locale.languageCode, allowFromNow: true),style: AppTextStyles.hint,),
                            ],
                          ),
                            Container(
                                width: double.infinity,
                                child: Text(this.widget.userNotification!.title??"",style: AppTextStyles.cardTitleHeading,textAlign: TextAlign.center,)),


                          SizedBox(height: 20),
                          Text(this.widget.userNotification!.detail??"",
                              style: TextStyle(
                                color:Colors.black.withOpacity(.7),fontSize: 13,
                                height: 2,
                                // Line height multiplier (1.5x the font size)
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                ),
                AppButton(text: 'close'.tr(),color: AppColors.defaultColor,onTab: (){
                  this.widget.onClose();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}