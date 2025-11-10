import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/models/employee_category.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/utils/asset_json_utils.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/network_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/date_conversion_helper.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/image_circle.dart';
import 'package:mosque_management_system/shared/widgets/image_data.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}
class _ProfileScreenState extends BaseState<ProfileScreen> {

  FieldListData fields=FieldListData();
  dynamic headerMap;
  @override
  void initState(){
    super.initState();
    loadView();
  }
  void loadView() async{
    headerMap = await AppUtils.getHeadersMap();
    fields.list=[];
    final fieldItems = await AssetJsonUtils.loadView<FieldList>(
      path: 'assets/views/employee_view.json',
      fromKeyValue: (key, value) => FieldList.fromStringJson(key, value),
    );
    fields.list.addAll(fieldItems);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        color: Colors.grey.withOpacity(.08),
        child: Stack(
          children: [
            Column(
              children: [

                SizedBox(height: 10),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child:
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              ImageCircle(id: userProvider.userProfile.userId??0, modelName: Model.employee, fieldId: "avatar_128",baseUrl: appUserProvider.baseUrl, headersMap: headerMap,width: 70,height: 80,),
                              SizedBox(width: 8,),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(userProvider.userProfile.name??"",style: TextStyle(color: AppColors.onPrimary,fontSize: 18),),
                  
                                      Text(userProvider.userProfile.employeeId.toString()??"",style: TextStyle(color: AppColors.onPrimary,fontSize: 13),  softWrap: true,),
                  
                                    ],
                                  )
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        color: Colors.white

                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    //decoration: BodyBoxDecoration4(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 5,),
                                AppTitle2("user_info".tr(), Icons.person),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade200, // You can change this color to match your design
                                      width: 1, // Width of the border in pixels
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // AppUtils.isOldDate(userInfo["birthday"])?AppListTitle2(title: fields.getField('birthday').label,subTitle: birthdayOld??"")
                                      //     :AppListTitle2(title: fields.getField('birthday').label,subTitle: JsonUtils.toText(userInfo["birthday"])??"",isDate: true),
                                      AppListTitle2(title: fields.getField('identification_id').label,subTitle: appUserProvider.userProfile.identificationId),
                                      AppListTitle2(title: fields.getField('staff_relation_type').label,subTitle: appUserProvider.userProfile.staffRelationType),
                                      AppListTitle2(title: fields.getField('classification_id').label,subTitle: userProvider.userProfile.classification,hasDivider:false),


                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                AppTitle2("work_information".tr(), Icons.shopping_bag),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade200, // You can change this color to match your design
                                      width: 1, // Width of the border in pixels
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      AppListTitle2(title: fields.getField('work_phone').label,subTitle: appUserProvider.userProfile.phone??""),
                                      AppListTitle2(title: fields.getField('work_email').label,subTitle: appUserProvider.userProfile.email??""),
                                       CustomListField(title: fields.getField('state_ids').label,
                                         employees: (userProvider.userProfile.stateIds??[])
                                        ,builder: (ComboItem item){
                                          return  Text(item.value??"",style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 14),);
                                        },
                                      ),

                                      CustomListField(title: fields.getField('city_ids').label,
                                        employees: (userProvider.userProfile.cityIds??[])
                                        ,builder: (ComboItem item){
                                          return  Text(item.value??"",style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 14),);
                                        },

                                      ),
                                      CustomListField(title: fields.getField('moia_center_ids').label,
                                        employees: (userProvider.userProfile.moiaCenterIds??[])
                                        ,builder: (ComboItem item){
                                          return  Text(item.value??"",style: TextStyle(color: Colors.black.withOpacity(.6),fontSize: 14),);
                                        },
                                      ),
                                      //AppListTitle2(title: fields.getField('district_id').label,subTitle: JsonUtils.getName(userInfo["district_id"])??""),
                                      AppListTitle2(title: fields.getField('parent_id').label,
                                          subTitle: userProvider.userProfile.parent,hasDivider: false),


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
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar:BottomNavigation(selectedIndex: 1),
    );
  }
}
