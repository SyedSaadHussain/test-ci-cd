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
import 'package:mosque_management_system/shared/widgets/list/mosque_user_list.dart';
import 'package:mosque_management_system/shared/widgets/list/region_list.dart';
import 'package:mosque_management_system/features/screens/all_mosques.dart';
import 'package:mosque_management_system/features/screens/create_employee.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
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

class CreateMosque extends StatefulWidget {
  // final CustomOdooClient client;
  // CreateMosque({required this.client});
  @override
  _CreateMosqueViewState createState() => _CreateMosqueViewState();
}
class _CreateMosqueViewState extends BaseState<CreateMosque> {
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

    _mosqueService.loadMosque().then((_mosque){
      newMosque=_mosque;

    });

    _mosqueService.loadMosqueView().then((list){

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
  // late UserProvider userProvider;

  StepperType _type = StepperType.horizontal;


  int _index = 0;
  void go(int index) {
    if (index == -1 && _index <= 0 ) {

      return;
    }

    if (index == 1 && _index >= 2) {
     
      return;
    }

    setState(() {
      _index += index;
    });
  }
  showRegionModal(){
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return RegionList(client: appUserProvider.client!,
          countryId: newMosque.countryId??0,
          onItemTap: (Region val){
  
          newMosque.region=val.name;
          newMosque.regionId=val.id;

          newMosque.city=null;
          newMosque.cityId=null;

          newMosque.moiaCenter=null;
          newMosque.moiaCenterId=null;
          
          setState(() {

          });
      
            Navigator.of(context).pop();

          },);
      },
    );
  }
  showDistrictModal(){
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return DistrictList(client: appUserProvider.client!,
          onItemTap: (Distract val){
          
            newMosque.district=val.name;
            newMosque.districtId=val.id;
         
            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  showCenterModal(){
    
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        
        return CenterList(client: appUserProvider.client!,
          cityId: newMosque.cityId??0,
          onItemTap: (MoiCenter val){
 
            newMosque.moiaCenter=val.name;
            newMosque.moiaCenterId=val.id;


            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  showCityModal(){
    
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return CityList(client: appUserProvider.client!,
          regionId: newMosque.regionId,

          onItemTap: (City val){

             newMosque.city=val.name;
             newMosque.cityId=val.id;

             newMosque.moiaCenter=null;
             newMosque.moiaCenterId=null;
          
            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  showAlimModal(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MosqueUserList(client: appUserProvider.client!,
          onItemTap: (City val){
            newMosque.alImam=val.name;
            newMosque.alImamId=val.id;
            setState(() {

            });
            Navigator.of(context).pop();
          },);
      },
    );
  }
  showAlmudhinModal(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MosqueUserList(client: appUserProvider.client!,
          onItemTap: (City val){
            newMosque.alMudhin=val.name;
            newMosque.alMudhinId=val.id;
            setState(() {

            });
            Navigator.of(context).pop();
          },);
      },
    );
  }
  showAlkhatibModal(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MosqueUserList(client: appUserProvider.client!,
          onItemTap: (City val){
            newMosque.alKhatib=val.name;
            newMosque.alKhatibId=val.id;
            setState(() {

            });
            Navigator.of(context).pop();
          },);
      },
    );
  }
  showComboListModal(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ComboBoxList(client: appUserProvider.client!,
          label: fields.getField('classification_id').label,
          source: 'classification',
          onItemTap: (ComboItem val){
        
            newMosque.classification=val.value;
            newMosque.classificationId=val.key;
            
            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  showComboListModalMosque(){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ComboBoxList(client: appUserProvider.client!,
          label: fields.getField('mosque_type_id').label,
          source: 'mosque_type', // ✅ This drives the source selector
          onItemTap: (ComboItem val){

            newMosque.mosqueType=val.value;
            newMosque.mosqueTypeId=val.key;

            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  createMosque(){
    setState(() {
      isSaving=true;
    });

    _mosqueService!.createMosque(newMosque).then((value){
      
        setState(() {
          _index = 1;
          isSaving=false;
        });
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

    // await Future.delayed(Duration(seconds: 2));
    // setState(() {
    //   _index = 2;
    //   isSaving=false;
    // });
  }
  final _formKey = GlobalKey<FormState>();
  final _crewFormKey = GlobalKey<FormState>();
  bool isVisiablePermission=false;
  late GPSPermission permission;
  List<Employee> _observers=[];
  FieldListData fields=FieldListData();
  void confirmationMessage(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('confirm'.tr()),
          content: Text('current_location'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                createMosque();
                Navigator.of(context).pop(); // Closes the dialog
                // Perform your action here
                // For example, you can delete something or confirm an action
              },
              child: Text('confirm'.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
                // Perform any other action you want here
                // This could be canceling the action or doing nothing
              },
              child: Text('cancel'.tr()),
            ),
          ],
        );
      },
    );
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
                                    Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),size: 25 , ),
                                    Text('create_new_mosque'.tr(),style: TextStyle(color: AppColors.onPrimary,fontSize: 20),)
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
                      child: _index==1?Column(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 100),
                              child: Expanded(
                                child: Column(
                                  children: [
                                    Icon(FontAwesomeIcons.smile,color: AppColors.secondly,size: 200,),
                                    SizedBox(height: 30,),

                                    Text("success".tr(),style: TextStyle(color: AppColors.secondly,fontSize: 40),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: PrimaryButton(text: "view_detail".tr(),onTab: (){
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  new MosqueDetail(mosqueId: newMosque.id,),
                                ),
                              );
                            }),
                          )
                        ],
                      ):Column(
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
                                    CustomFormField(title: fields.getField('name').label,value: newMosque.name,isRequired: true,onChanged:(val) => newMosque.name = val,),

                                    CustomFormField(title: fields.getField('region_id').label,onTab: (){
                                      showRegionModal();
                                    },value: newMosque.region,isReadonly:true,isSelection:true,isRequired: true,),

                                    CustomFormField(title: fields.getField('city_id').label,onTab: (){
                                      showCityModal();
                                    },value: newMosque.city,isReadonly:true,isDisable: (newMosque.region==null),isSelection:true,isRequired: true,),

                                    CustomFormField(title: fields.getField('moia_center_id').label,onTab: (){
                                      showCenterModal();
                                    },value: newMosque.moiaCenter,isReadonly:true,isSelection:true,isRequired: true,),


                                    newMosque.isAnotherNeighborhood??false?Container():CustomFormField(title: fields.getField('district').label,onTab: (){
                                      showDistrictModal();
                                    },value: newMosque.district,isReadonly:true,isSelection:true),

                                    CustomFormField(title: fields.getField('is_another_neighborhood').label,value: newMosque.isAnotherNeighborhood,
                                        onChanged:(val){
                                          newMosque.isAnotherNeighborhood= val;
                                          setState(() {});
                                        } ,type:FieldType.boolean),

                                    newMosque.isAnotherNeighborhood??false?
                                    CustomFormField(title: fields.getField('another_neighborhood_char').label,value: newMosque.anotherNeighborhoodChar,onChanged:(val) => newMosque.anotherNeighborhoodChar = val,):Container(),



                                    CustomFormField(title: fields.getField('street').label,value: newMosque.street,onChanged:(val) => newMosque.street = val,),
                                    CustomFormField(title: fields.getField('classification_id').label,onTab: (){
                                      showComboListModal();
                                    },value: newMosque.classification,isReadonly:true,isSelection:true,isRequired: true,),
                                    CustomFormField(title: fields.getField('mosque_type_id').label,onTab: (){
                                      showComboListModalMosque();
                                    },value: newMosque.mosqueType,isReadonly:true,isSelection:true,isRequired: false,),


                                    CustomFormField(title: fields.getField('establishment_date').label,value: newMosque.establishmentDate,onChanged:(val) {

                                      newMosque.establishmentDate = val;

                                      setState(() {

                                      });
                                    } ,type: FieldType.date,),



                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child:PrimaryButton(text: "create".tr(),onTab: ()async{

                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                permission=new GPSPermission(
                                    allowDistance: 0,
                                    latitude:0,
                                    longitude:0,
                                    isOnlyGPS: true
                                );
                                setState((){
                                  isVisiablePermission=true;
                                });
                                permission.checkPermission();
                                setState(() {
                                  isSaving=true;
                                });
                                permission.listner.listen((value){
                                  if(value){

                                    newMosque.latitude=double.parse(permission.currentPosition!.latitude.toStringAsFixed(6));
                                    newMosque.longitude= double.parse(permission.currentPosition!.longitude.toStringAsFixed(6));
                                    setState((){
                                      isVisiablePermission=false;
                                      isSaving=false;
                                    });
                                    confirmationMessage();
                                    //createMosque();

                                  }else{
                                    // setState((){
                                    //   isVisiablePermission=false;
                                    // });
                                  }
                                  setState((){

                                  });
                                });

                              }

                            }),
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
