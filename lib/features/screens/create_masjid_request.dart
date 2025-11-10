import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/center.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/distract.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_edit_request.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/shared/widgets/list/center_list.dart';
import 'package:mosque_management_system/shared/widgets/list/city_list.dart';
import 'package:mosque_management_system/shared/widgets/list/combo_list.dart';
import 'package:mosque_management_system/shared/widgets/list/district_list.dart';
import 'package:mosque_management_system/shared/widgets/list/mosque_list.dart';
import 'package:mosque_management_system/shared/widgets/list/mosque_user_list.dart';
import 'package:mosque_management_system/shared/widgets/list/region_list.dart';
import 'package:mosque_management_system/features/screens/all_mosques.dart';
import 'package:mosque_management_system/features/screens/create_employee.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/custom_enhance_stepper.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CreateMosqueRequest extends StatefulWidget {
  final Function? onCallback;
  CreateMosqueRequest({this.onCallback});
  @override
  _CreateMosqueRequestState createState() => _CreateMosqueRequestState();
}
class _CreateMosqueRequestState extends BaseState<CreateMosqueRequest> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  late UserService _userService;
  late MosqueService _mosqueService;
  List<Employee> _imams=[];
  List<Employee> _muezzin=[];
  List<Employee> _khadem=[];
  List<Employee> _khatib=[];
  bool isSaving=true;
  UserProfile _userProfile =UserProfile(userId: 0);
  Mosque newMosque=Mosque(id: 0);
  MosqueEditRequest newRequest=MosqueEditRequest(id: 0);

  bool isVerifyDevice(){
    //return true;
    if(appUserProvider.isDeviceVerify) return true;
    else{
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: "device_not_unverified".tr(),
        duration: Duration(seconds: 3),
      ).show(context);
      return false;
    }


  }
  @override
  void initState(){
    super.initState();

  }


  @override
  void widgetInitialized() {
    super.widgetInitialized();
    // userProvider = Provider.of<UserProvider>(context);
    _userService = UserService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    _mosqueService = MosqueService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    // _userService!.updateUserProfile(appUserProvider.userProfile);
    // _mosqueService.updateUserProfile(appUserProvider.userProfile);


    _mosqueService.loadEditMosqueReqView().then((list){

      fields.list=list;
      setState(() {
        isSaving=false;
      });

    }).catchError((e){
      setState(() {
        isSaving=false;
      });
    });
  }
  submitRequest(){
    setState(() {
      isSaving=true;
    });

    _mosqueService!.submitMosqueRequest(newRequest.id).then((value){

      setState(() {
        isSaving=false;
      });
      this.widget.onCallback!();
      Navigator.pop(context);
    }).catchError((_){

      setState(() {
        isSaving=false;
      });
      this.widget.onCallback!();
      Navigator.pop(context);

      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: _.message.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    });

  }

  createMosqueReq(bool isSubmit){
    setState(() {
      isSaving=true;
    });

    _mosqueService!.createMosqueRequest(newRequest).then((value){
  
         newRequest.id=value.id;
        if(isSubmit){
          submitRequest();
        }else{
          setState(() {
            isSaving=false;
          });
          this.widget.onCallback!();
          Navigator.pop(context);
        }

      

    }).catchError((_){
   
      setState(() {
        isSaving=false;
      });
   

      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: _.message.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    });

  }
  final _formKey = GlobalKey<FormState>();
  FieldListData fields=FieldListData();
  showMosqueModal(){
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return MosqueList(client: appUserProvider.client!,
          userProfile: appUserProvider.userProfile,
          title: fields.getField('mosque_id').label,
          onItemTap: (Mosque val){
            newRequest.mosqueId=val.id;
            newRequest.mosque=val.name;
            onChangeMosqueReq();
            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }

  onChangeMosqueReq(){
      _mosqueService.onChangeMosqueReq(newRequest.mosqueId!).then((value){
        newRequest.number=value.number;
        newRequest.regionId=value.regionId;
        newRequest.region=value.region;
        setState(() {

        });
      });
  }


  @override
  Widget build(BuildContext context) {
    appUserProvider = Provider.of<UserProvider>(context);
    return SafeArea(

      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Container(

          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    //height: 170,
                    child:
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                child: Row(
                                  children: [
                                    Icon(Icons.arrow_back,color: AppColors.onPrimary,size: 25 , ),
                                    Text('add_new_request'.tr(),style: AppTextStyles.appBarTitle,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        color: Colors.white

                      ),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                      //decoration: BodyBoxDecoration4(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // CustomListField(title: fields.getField('observer_ids').label,employees: _observers,),
                                    CustomFormField(title: fields.getField('mosque_id').label,onTab: (){
                                      showMosqueModal();
                                    },value: newRequest.mosque,isReadonly:true,isSelection:true,isRequired: true,),


                                    CustomFormField(title: fields.getField('number').label,value: newRequest.number,isReadonly: true),

                                    CustomFormField(title: fields.getField('region_id').label,value: newRequest.region,isReadonly: true),

                                    CustomFormField(title: fields.getField('description').label,
                                      value: newRequest.description,onChanged:(val){
                                        newRequest.description = val;
                                        setState((){});
                                      }
                                      ,type: FieldType.textArea,
                                    ),



                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child:Row(
                              children: [
                                Expanded(
                                  child: AppButton(text: "submit".tr(),onTab: ()async{

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                        createMosqueReq(true);

                                    }

                                  },color: AppColors.primary),
                                ),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: AppButton(text: "save".tr(),onTab: ()async{

                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                         createMosqueReq(false);

                                    }

                                  },color: AppColors.secondly),
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
              isSaving
                  ? ProgressBar()
                  : SizedBox.shrink(),
            ],
          ),
        ),
        //bottomNavigationBar:this.widget.client==null?null:BottomNavigation(client: this.widget.client!,selectedIndex: 2),
      ),
    );
  }
}
