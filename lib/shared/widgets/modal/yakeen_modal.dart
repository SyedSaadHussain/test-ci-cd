import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/models/user_notification.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/data/services/visit_service.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;
import 'package:timeago/timeago.dart' as timeago;

class yakeenModal extends StatefulWidget {
  final CustomOdooClient client;
  final Function onClose;
  yakeenModal({required this.client,required this.onClose});
  @override
  _yakeenModalState createState() => _yakeenModalState();
}

class _yakeenModalState extends State<yakeenModal> {
  CityData data= CityData();
  List<Region> filteredUsers= [];
  UserService? _userServices;

  Visit _filter=Visit(id: 0);
  late MosqueService _mosqueService;
  @override
  void initState() {

    super.initState();
    setState(() {

    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mosqueService = MosqueService(this.widget.client!,userProfile: userProvider.userProfile);

    });
  }
  @override
  void dispose() {
    super.dispose();

  }
  Employee newEmployee=Employee(id: 0);
  bool isLoading=false;
  YakeenData? yakeen;
  validateYakeenAPI(){

    setState(() {
      isLoading=true;
    });
    String nameArabic='';
    String nameEnglish='';
    // print(isLoading.birthday);
    _mosqueService!.validteYakeenApi(newEmployee).then((value){

      if(value['result']['code']==200){
        isYakeenValidate=true;

        dynamic info=value['personBasicInfo'];
        nameArabic=(JsonUtils.toText(info['firstName'])??"")+ " " + (JsonUtils.toText(info['fatherName'])??"")+ " " + (JsonUtils.toText(info['grandFatherName'])??"")+ " " + (JsonUtils.toText(info['familyName'])??"");
        nameEnglish=(JsonUtils.toText(info['firstNameT'])??"")+ " " + (JsonUtils.toText(info['fatherNameT'])??"")+ " " + (JsonUtils.toText(info['grandFatherNameT'])??"")+ " " + (JsonUtils.toText(info['familyNameT'])??"");
        yakeen=YakeenData();
        yakeen!.nameEnglish=nameEnglish;
        yakeen!.nameArabic=nameArabic;
        yakeen!.json=value.toString();
        // yakeen!.nationalId=newEmployee.identificationId;
        // yakeen!.nationality=JsonUtils.toText(info['nationalityDescAr']);

        print(nameArabic);
        print(nameEnglish);
        newEmployee.name=nameArabic;
      }else
      {
        Flushbar(
          icon: Icon(Icons.warning,color: Colors.white,),
          backgroundColor: AppColors.danger,
          message: value['result']['error']['errorDetail']['errorMessage'],
          duration: Duration(seconds: 3),
        ).show(context);
      }


      setState(() {
        // isYakeenValidate=true;
        isLoading=false;
      });
    }).catchError((e){
      print(e);
      setState(() {
        isLoading=false;
      });
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: 'Data Not found',
        duration: Duration(seconds: 3),
      ).show(context);
    });
  }
  String identificationId='';
  String birthday='';
  String? birthdayHijri;
  bool isYakeenValidate=false;
  final _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        // this.widget.onClose(yakeen);
        return true;
      },
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Padding(
              padding: MediaQuery.of(context).viewInsets,
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
                  child: Form(
                    key: _formKey,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          SizedBox(height: 20),
                          Text('get_from_yakeen'.tr(),style: TextStyle(color: AppColors.gray,fontWeight: FontWeight.bold,fontSize: 24),textAlign: TextAlign.center,),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color:  isYakeenValidate? AppColors.success.withOpacity(.1):AppColors.gray.withOpacity(.1),
                              shape: BoxShape.circle, // Make the container circular
                            ),
                            child: Container(
                                padding: EdgeInsets.all(25),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: isYakeenValidate? AppColors.success.withOpacity(.1):AppColors.gray.withOpacity(.1),
                                  shape: BoxShape.circle, // Make the container circular

                                ),

                                child: Icon(isYakeenValidate?FontAwesomeIcons.userCheck: FontAwesomeIcons.user ,color: isYakeenValidate? AppColors.success.withOpacity(.3): AppColors.gray.withOpacity(.3),size: 50,)),
                          ),
                          SizedBox(height: 10),
                          Expanded(

                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      yakeen!=null?Container(width: double.infinity, child: Text(yakeen!.nameArabic??"",textAlign: TextAlign.center,style: AppTextStyles.defaultHeadingSm,),):Container(),
                                      CustomFormField(title: 'identification_id',value: newEmployee.identificationId,isRequired: true,onChanged:(val) {

                                        newEmployee.identificationId = (val??"").toString();
                                        setState(() {

                                        });
                                      },type: FieldType.number,isDisable:isYakeenValidate, suffixIcon:isYakeenValidate?Icon(Icons.check_circle,color: Colors.green.withOpacity(.6),):null),

                                      CustomFormField(title: ('birthday'),value: newEmployee.birthday,onChanged:(val,{DateConversion? dateConversion}) {



                                        newEmployee.birthday = val;
                                        print(val);
                                        if(dateConversion!=null){
                                          print(dateConversion!.hijriDate);
                                          newEmployee.birthdayHijri=(dateConversion!.yearHijri??"")+"-"+(dateConversion!.monthHijri??"");
                                        }else{
                                          newEmployee.birthdayHijri=null;
                                        }
                                        setState(() {

                                        });

                                      }  ,type: FieldType.date,isRequired: true,isDisable:isYakeenValidate, suffixIcon:isYakeenValidate?Icon(Icons.check_circle,color: Colors.green.withOpacity(.6),):null),


                                      SizedBox(height: 50,)
                                    ],
                                  ),
                                ),
                              )
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(text: 'close'.tr(),color: AppColors.gray,onTab: (){

                                  Navigator.pop(context);

                                }),
                              ),
                              isYakeenValidate?Expanded(
                                child:PrimaryButton(text: "save".tr(),onTab: ()async{
                                  this.widget.onClose(yakeen);
                                  Navigator.pop(context);
                                },),
                              ):Expanded(
                                child:PrimaryButton(text: "verify".tr(),onTab: ()async{

                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    validateYakeenAPI();
                                  }

                                },),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            isLoading
                ? ProgressBar()
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}