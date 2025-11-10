import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/User.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/center.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/distract.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/employee_category.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/models/survey.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/repositories/common_repository.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/data/services/visit_service.dart';
import 'package:mosque_management_system/shared/widgets/list/center_list.dart';
import 'package:mosque_management_system/shared/widgets/list/city_list.dart';
import 'package:mosque_management_system/shared/widgets/list/combo_list.dart';
import 'package:mosque_management_system/shared/widgets/list/district_list.dart';
import 'package:mosque_management_system/shared/widgets/list/mosque_list.dart';
import 'package:mosque_management_system/shared/widgets/list/mosque_user_list.dart';
import 'package:mosque_management_system/shared/widgets/list/multi_item_list.dart';
import 'package:mosque_management_system/shared/widgets/list/region_list.dart';
import 'package:mosque_management_system/shared/widgets/list/visit_type_list.dart';
import 'package:mosque_management_system/features/screens/all_mosques.dart';
import 'package:mosque_management_system/features/screens/create_employee.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/features/screens/visit_detail.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/custom_enhance_stepper.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class AssignVisit extends StatefulWidget {
  // final CustomOdooClient client;
  // CreateVisit({required this.client});
  @override
  _AssignVisitState createState() => _AssignVisitState();
}
class _AssignVisitState extends BaseState<AssignVisit> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late SurveyService _surveyService;
  bool isSaving=false;
  UserSurvey newUserSurvey=UserSurvey();
  final _formKey = GlobalKey<FormState>();
  FieldListData fields=FieldListData();
  List<int> observerIds=[];

  @override
  void initState(){
    super.initState();
  }

  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _surveyService = SurveyService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    loadView();
  }

  void loadView(){
    _surveyService.loadAssignVisitView().then((list){
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

  createUserSurvey(){
    setState(() {
      isSaving=true;
    });
    _surveyService!.createUserSurvey(newUserSurvey).then((value){
      isSaving=false;
      newUserSurvey.reset();
      setState(() {

      });
      Flushbar(
        icon: Icon(Icons.check_circle,color: Colors.white,),
        backgroundColor: AppColors.flushColor,
        message: 'success'.tr(),
        duration: Duration(seconds: 2),
      ).show(context).then((val){
        Navigator.of(context).pop();
      });
    }).catchError((e){
      setState(() {
        isSaving=false;
      });
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: e.message.toString(),
        duration: Duration(seconds: 3),
      ).show(context).then((val){

      });

    });

  }
  dynamic domain=null;
  showVisitTypeModal(){
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return VisitTypeList(client: appUserProvider.client!,
          userProfile: appUserProvider.userProfile,
          title:  fields.getField('visit_form_id').label,
          domain: domain,
          onItemTap: (ComboItem val){
            newUserSurvey.visitFormId=val.key;
            newUserSurvey.visitForm=val.value;

            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  showMosqueModal(){
    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return MosqueList(client: appUserProvider.client!,
          userProfile: appUserProvider.userProfile,
          title: fields.getField('mosque_id').label,
          onItemTap: (Mosque val){
            newUserSurvey.mosqueId=val.id;
            newUserSurvey.mosqueName=val.name;
            onChangeMosque();
            setState(() {

            });
            Navigator.of(context).pop();

          },);
      },
    );
  }
  onChangeMosque(){
     _surveyService.onChangeMosqueOnAssignSurvey(newUserSurvey.mosqueId!).then((response){
        domain=response;
        setState(() {

        });
     }).catchError((e){
       domain=null;
     });
  }
  showObserverModal(){

    showModalBottomSheet(

      context: context,
      builder: (BuildContext context) {
        return MosqueUserList(client: appUserProvider.client!,
          type: "employee",
          title: fields.getField('employee_id').label,

          // supervisorId: appUserProvider.userProfile.employeeId,

          onItemTap: (Employee val){

            newUserSurvey.employeeName=val.name;
            newUserSurvey.employeeId=val.id;
            setState(() {

            });
            Navigator.of(context).pop();
          },);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                    Text('assign_visit'.tr(),style: TextStyle(color: AppColors.onPrimary,fontSize: 20),)
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
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                                    SizedBox(height: 10,),
                                    CustomFormField(title: fields.getField('mosque_id').label,onTab: (){
                                      showMosqueModal();
                                    },value: newUserSurvey.mosqueName,isReadonly:true,isSelection:true,isRequired: true,),

                                    domain!=null? Column(
                                      children: [
                                        CustomFormField(title: fields.getField('employee_id').label,onTab: (){
                                          showObserverModal();
                                        },value: newUserSurvey.employeeName,isReadonly:true,isSelection:true,isRequired: true,),

                                        CustomFormField(title: fields.getField('visit_form_id').label,onTab: (){
                                          showVisitTypeModal();
                                        },value: newUserSurvey.visitForm,isReadonly:true,isSelection:true,isRequired: true,),

                                        CustomFormField(title: fields.getField('on_date').label,
                                          onChanged:(val){
                                            newUserSurvey.onDate = val;

                                            setState((){});
                                          },
                                          value: newUserSurvey.onDate,type: FieldType.date,),

                                      ],
                                    ):Container(),


                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(text: "create".tr(),onTab: ()async{
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    createUserSurvey();
                                  }

                                }),
                              ),
                            ],
                          )

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
