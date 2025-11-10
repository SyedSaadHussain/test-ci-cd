import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/input_decoration_themes.dart';
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/employee.dart';
import 'package:mosque_management_system/core/models/ir_attachment.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/mosque_region.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/models/res_partner.dart';
import 'package:mosque_management_system/core/models/survey_user_input.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/models/yakeen_data.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/data/services/visit_service.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';
import 'package:mosque_management_system/shared/widgets/list/city_list.dart';
import 'package:mosque_management_system/shared/widgets/list/combo_list.dart';
import 'package:mosque_management_system/shared/widgets/list/mosque_user_list.dart';
import 'package:mosque_management_system/shared/widgets/list/multi_item_list.dart';
import 'package:mosque_management_system/shared/widgets/list/region_list.dart';
import 'package:mosque_management_system/shared/widgets/modal/survey_configuration.dart';
import 'package:mosque_management_system/shared/widgets/modal/yakeen_modal.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/FullImageViewer.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/image_circle.dart';
import 'package:mosque_management_system/shared/widgets/image_data.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/state_button.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class SurveyResponse{
  bool? isSuccess;
  String? message;
  List<ComboItem>? errors;

  SurveyResponse({
     this.isSuccess,
     this.message,
     this.errors
  });
}
class SurveyDetail extends StatefulWidget {
  final SurveyUserInput? surveyInput;
  final Function? onCallback;
  SurveyDetail({this.onCallback,this.surveyInput});
  @override
  _SurveyDetailState createState() => _SurveyDetailState();
}

class _SurveyDetailState extends BaseState<SurveyDetail> with TickerProviderStateMixin   {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late OdooClient client;
  late VisitService _visitService;
  late MosqueService _mosqueService;
  UserService? _userService;
  late SurveyService _surveyService;

  List<TabForm> _tabs=[];
  bool isLoading=true;
  void previousTab(){
    _tabController.animateTo(_tabController.index-1);
  }
  void nextTab(){
    _tabController.animateTo(_tabController.index+1);
  }
  late TabController _tabController = TabController(length: 0, vsync: this);
  TextStyle? labelStyle1;

  @override
  void initState(){

    super.initState();
    labelStyle1= TextStyle(color: Colors.black.withOpacity(.7),fontSize: 13,fontWeight: FontWeight.bold);
    print('init');
    print(this.widget.surveyInput!.url??"");
  }
  List<List<double>> coordinates=[];
  List<VisitConfigurationData> visitSections=[];
  VisitConfigurationData configurationData=VisitConfigurationData();
  VisitConfigurationData configurationData1=VisitConfigurationData();

  dynamic _headersMap;
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _surveyService = SurveyService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    // getVisitConfiguration();
    getSurveyDetail();

  }
  String visitState="";
  void getSurveyDetail(){
    _surveyService.getSurveyDetail(this.widget.surveyInput!.id!).then((result){
      print('result');
      print(result);
      visitSections=result['tabs'];
      visitState=result['state'];
        _tabController = TabController(length: visitSections.length, vsync: this);
        setState((){
          isLoading=false;
        });
    });
  }
  void getVisitConfiguration(){
    setState((){
      isLoading=false;
    });


    configurationData.sectionName="saad";
    configurationData.list=[];
    // configurationData.list!.add(VisitConfiguration(id: 0,name: "saad",fieldType:FieldType.matrix,
    //     isHint: true,
    //     hintMessage: "أكتب ملاحظاتك على حالة تسجيل الإمام في النظام (إن وجدت)",
    //     matrixOptions:[
    //       ComboItem(key: "1", value: "نظافة وصيانة المسجد"),
    //       ComboItem(key: "2", value: "نظافة وصيانة المسجد"),
    //     ],options: [ComboItem(key: 1, value: "	ممتاز"),ComboItem(key: 2, value: "متوسط"),ComboItem(key: 3, value: "متوسط1"),]
    // ));
    // configurationData.list!.add(VisitConfiguration(id: 1,name: "Is Imam Exist",fieldType:FieldType.selection,
    // options:[
    //   ComboItem(key: "yes", value: "Yes"),
    //   ComboItem(key: "no", value: "No"),
    // ],value:'no',isRequired: true,isSystem: true
    // ));
    //
    // configurationData.list!.add(VisitConfiguration(id: 2,name: "Is Imam Present",fieldType:FieldType.selection,
    //     options:[
    //       ComboItem(key: "yes", value: "Yes"),
    //       ComboItem(key: "no", value: "No"),
    //     ],visibleFieldQuestion: 1,visibleFieldAnswer:"no",defaultValue:"no",isRequired: true
    // ));
    //
    // configurationData.list!.add(VisitConfiguration(id: 3,name: "Imam",fieldType:FieldType.selection,
    //     options:[
    //       ComboItem(key: "1", value: "Imam 1"),
    //       ComboItem(key: "2", value: "Imam 2"),
    //     ],visibleFieldQuestion: 2,visibleFieldAnswer:"yes",isRequired: true,isHint: true,hintMessage: "(إن وجدت) أكتب ملاحظاتك أثناء تحضير الإمام",
    // ));
    // configurationData.list!.add(VisitConfiguration(id: 4,name: "Imam Description",fieldType:FieldType.textArea,
    //     visibleFieldQuestion: 2,visibleFieldAnswer:"yes",isHint: true,hintMessage: "this is test"
    // ));
    // configurationData.list!.add(VisitConfiguration(id: 5,name: "visit Types",fieldType:FieldType.multiSelect,
    //     isRequired: true,isHint: true,hintMessage: "(إن وجدت) أكتب ملاحظاتك أثناء تحضير الإمام",
    //     options:[
    //       ComboItem(key: "1", value: "Female"),
    //       ComboItem(key: "2", value: "Male"),
    //       ComboItem(key: "3", value: "Friday"),
    //     ],value: []
    // ));
    // configurationData.list!.add(VisitConfiguration(id: 6,name: "Visit Name",fieldType:FieldType.textField,
    //
    // ));
    visitSections.add(configurationData);
    // configurationData1.sectionName="secondTab";
    // configurationData1.list=[];
    //
    //
    // configurationData1.list!.add(VisitConfiguration(id: 7,name: "Total Prayer",fieldType:FieldType.number,
    //
    // ));
    //
    // configurationData1.list!.add(VisitConfiguration(id: 8,name: "Area",fieldType:FieldType.double,
    //
    // ));
    //
    // configurationData1.list!.add(VisitConfiguration(id: 9,name: "Area",fieldType:FieldType.date,
    //
    // ));
    // visitSections.add(configurationData1);
    setState(() {

    });
  }
  Map<String, dynamic>  payload={};
  List<ComboItem> errors=[];
  void submit(){
    // this.widget.onCallback!();
    errors=[];
    payload= {};
    VisitConfigurationData? currentConfig;
    // visitSections.forEach((item) {
    print('_tabController.index');
    print(_tabController.index);
    currentConfig=visitSections[_tabController.index];
    currentConfig.list!.forEach((rec){
        // if(rec.value!=null){
          if((rec.isYakeen??false)){
            // if(rec.value!=null){
              payload[rec.id.toString()] = [
                rec.value==null?"":rec.value.json.toString(),
                {"comment": rec.comments??""},
                {"comment": rec.comments??""}
              ];
            // }
          }
          else if(rec.fieldType==FieldType.image){
            if(AppUtils.isNotNullOrEmpty(rec.value)){
              payload[rec.id.toString()]=[[rec.value],["IMAGE"]];
            }
          }
          else if(rec.fieldType==FieldType.matrix){
            dynamic matrixPayload={};
            (rec.value??[])!.forEach((rec){
              matrixPayload[rec[0].toString()]=[rec[1]];
            });
            // Only add "comment" if matrixPayload has data

            if (AppUtils.isNotNullOrEmpty(rec.comments)) {
              matrixPayload["comment"] = rec.comments;
            }
            payload[rec.id.toString()]=matrixPayload;

          }else{
            payload[rec.id.toString()] = [
              (rec.value??""),
              {"comment": rec.comments??""},
              {"comment": rec.comments??""}
            ];

          }

        // }
      });
    payload['page_id']=currentConfig.pageId;
    payload['mobile']="mobile";
    // });
    print(payload);
    setState((){
      isLoading=true;
    });
    _surveyService.submitSurvey(payload,this.widget.surveyInput!.submitToken).then((response){
      isLoading=false;
      print('response.isSuccess');
      print(response.isSuccess);
          if(response.isSuccess??true){
            if(!isShowSubmitBtn){
              // print(_tabController.index);
              currentConfig=visitSections[_tabController.index+1];
              if((currentConfig!.list??[]).length>0){
                  nextTab();
              }else{
                    print('load record');
                    setState((){
                      isLoading=true;
                    });
                    _surveyService.getSurveyDetailByPageId(this.widget.surveyInput!.id!,currentConfig!.pageId.toString()).then((result){
                      print('result');
                      print(result);
                      visitSections[_tabController.index+1]=result;
                       setState((){
                        isLoading=false;
                      });
                       nextTab();
                    }).catchError((onError){
                      setState((){
                        isLoading=false;
                      });
                    });
              }

            }else{
              this.widget.onCallback!();
              Navigator.of(context).pop();
            }

          }else{
            errors=response.errors??[];
            if(AppUtils.isNotNullOrEmpty(response.message??"")){
              Flushbar(
                icon: Icon(Icons.warning,color: Colors.white,),
                backgroundColor: AppColors.danger,
                message: response.message??"",
                duration: Duration(seconds: 3),
              ).show(context);
            }
          }
          setState(() {

          });
          // if(!isShowSubmitBtn){
          //   nextTab();
          // }else{
          //   this.widget.onCallback!();
          // }

    }).catchError((e){
      setState((){});
      setState((){
        isLoading=false;
      });
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: e.message,
        duration: Duration(seconds: 3),
      ).show(context);
    });
    print(payload);
  }
  ShowYakeenModal(VisitConfiguration config){

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {

        return yakeenModal(client: appUserProvider.client!,
          onClose: (YakeenData? data){
          print(data);
              if(data!=null){
                print('data');
                config.value=data;
                setState(() {

                });
                print('config.value.nameEnglish');
                print(config.value.nameEnglish);
              }

          },
        );
      },
    );

  }
  Widget _buildCell(String text, {bool isHeader = false}) {
    return Container(
      width: 60,
      height: 50,
      alignment: Alignment.center,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isHeader ? Colors.blue[100] : Colors.grey[200],
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
      ),
    );

  }

  bool get isShowBackBtn => visitSections.length>1 && _tabController.index>0;
  bool get isShowNextBtn => visitSections.length>1 && _tabController.index!=_tabController.length-1;
  bool get isShowSubmitBtn => _tabController.index==_tabController.length-1;
  VisitConfigurationData? currentData;
  final _formDetailKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        key: _scaffoldKey,
        body: Form(
          key: _formDetailKey,
          child: Container(
            color: Colors.grey.withOpacity(.08),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 10),
                     child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // Text((_mosque!.displayButtonRefuse??false).toString()),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical:0),
                              child: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),size: 25 , ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Text('visit'.tr(),style: TextStyle(color: AppColors.onPrimary,fontSize: 18),)
                        ],
                      ),
                   ),



                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                ImageCircle(id: this.widget.surveyInput!.mosqueId??0, modelName: Model.mosque, fieldId: "outer_image",uniqueId: this.widget.surveyInput!.dateOfVisitGreg??"",baseUrl: appUserProvider.baseUrl,headersMap: _headersMap,height: 50,width: 50,),

                                SizedBox(width: 8,),
                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text((this.widget.surveyInput!.mosqueName??""),style: TextStyle(color: AppColors.onPrimary,fontSize: 20,fontWeight: FontWeight.bold),),
                                        Text(this.widget.surveyInput!.sequenceNo??"",style: TextStyle(color: AppColors.onPrimary,fontSize: 13),  softWrap: true,),
                                        // Text(this.widget.surveyInput!.submitToken??"",style: TextStyle(color: AppColors.onPrimary,fontSize: 13),  softWrap: true,),

                                      ],
                                    )
                                ),
                              ]
                          ),

                        ],
                      ),
                    ),

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
                        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        //decoration: BodyBoxDecoration4(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child:
                                DefaultTabController(
                                  length: visitSections.length, // Number of tabs
                                  child: Container(

                                    child: Column(
                                      children: [
                                        Expanded(
                                          child:Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  ),
                                                  border: Border.all(
                                                    color: AppColors.primary.withOpacity(.2), // Border color
                                                    width: 1.0, // Border width
                                                  ),
                                                ),
                                                child: IgnorePointer(
                                                  child: TabBar(
                                                    controller: _tabController,
                                                    labelPadding: EdgeInsets.symmetric(horizontal:visitSections.length>4?15:3),
                                                    padding: EdgeInsets.zero,
                                                    isScrollable:visitSections.length>4?true:false,
                                                    indicatorPadding: EdgeInsets.zero,
                                                    indicatorSize: TabBarIndicatorSize.tab,
                                                    tabAlignment: visitSections.length>4? TabAlignment.start:TabAlignment.fill,



                                                    indicator: BoxDecoration(
                                                      color: AppColors.primary.withOpacity(.1), // Background color for the active tab
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(8.0),

                                                      ),
                                                    ),
                                                    unselectedLabelColor: Colors.grey.shade400,
                                                    labelStyle: TextStyle(color: AppColors.primary,fontSize: 12),
                                                    tabs:visitSections!.map((VisitConfigurationData tab) {
                                                      // Here you can create the content for each tab
                                                      return  Tab( child: Row(
                                                        mainAxisSize: MainAxisSize.min, // Ensures that the row takes the minimum space
                                                        mainAxisAlignment: MainAxisAlignment.center, // Centers the children within the Row
                                                        children: [
                                                          SizedBox(width: 3), // Optional spacing between icon and text
                                                          Flexible(
                                                            child: Text(
                                                                tab.sectionName,
                                                                overflow: TextOverflow.ellipsis
                                                            ),
                                                          ),
                                                        ],
                                                      ));
                                                    }).toList(),

                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: TabBarView(
                                                  controller: _tabController,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  children:
                                                    visitSections!.map((VisitConfigurationData config) {
                                                      currentData=config;
                                                      // Here you can create the content for each tab
                                                      return  ListView.builder(
                                                        itemCount: config.list!.length,
                                                        itemBuilder: (context, index) {
                                                          // print(index);


                                                          if(config.isVisible(config.list![index])){

                                                            return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                            if(config.list![index].fieldType==FieldType.matrix)
                                                               Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  MatrixField(title: config.list![index].name,
                                                                    labelStyle: labelStyle1,
                                                                    horizontalOptions: config.list![index].options
                                                                    ,verticalOptions: config.list![index].matrixOptions,values: config.list![index].value??[],isEditMode: true,
                                                                    onChanged: (questionKey,answerKey,flag){

                                                                      print(questionKey);
                                                                      print(answerKey);
                                                                      if(config.list![index].value==null)
                                                                        config.list![index].value=[];

                                                                      // int ind = config.list[index].value.indexWhere((pair) => pair[0] == questionKey);

                                                                      // bool flag=true;
                                                                      if (flag) {
                                                                        config.list![index].value.removeWhere((pair) => pair[0] == questionKey);
                                                                        // Add new [x, y]
                                                                        config.list![index].value.add([questionKey, answerKey]);

                                                                      } else {
                                                                        // Remove [x, y] if it exists
                                                                        config.list![index].value.removeWhere((pair) => pair[0] == questionKey && pair[1] == answerKey);
                                                                      }
                                                                      setState(() {

                                                                      });
                                                                      print(config.list![index].value);
                                                                    },
                                                                  ),
                                                                  // AppHint(text: config.list![index].commentsMessage,isHide:config.list![index].isHint==false,)
                                                                ],
                                                              )

                                                            else if(config.list![index].fieldType==FieldType.multiSelect)

                                                                Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                CustomFormField(title: config.list![index].name,
                                                                  labelStyle: labelStyle1,
                                                                  onTab: (){

                                                                    showModalBottomSheet(
                                                                      context: context,
                                                                      builder: (BuildContext context) {
                                                                        print('sssssss');
                                                                        print(config.list![index].value);
                                                                        return MultiItemList(
                                                                          client: appUserProvider.client!,
                                                                          selectedValue: config.list![index].value,
                                                                          title: 'select_tag'.tr(),
                                                                          items: config.list![index].options??[],
                                                                          onItemTap: (ComboItem val){

                                                                            print('val.keyval.key');
                                                                            print(val.value);


                                                                            if(config.list![index].value==null)
                                                                              config.list![index].value=[];
                                                                            if (!config.list![index].value!.contains(val.key)) {
                                                                              config.list![index].value!.add(val.key);
                                                                            }
                                                                            setState(() {

                                                                            });

                                                                            Navigator.of(context).pop();
                                                                          },);
                                                                      },
                                                                    );

                                                                  },value: config.list![index].value,
                                                                  // isRequired: true,
                                                                  options: config.list![index].options,isReadonly:true,isSelection:true,type: FieldType.multiSelect,
                                                                  builder:(ComboItem value){
                                                                    return MultiTag(title:value.value??"",onTab: (){
                                                                      config.list![index].value!.removeWhere((categoryId) => categoryId == value.key);
                                                                      setState(() {

                                                                      });

                                                                    });
                                                                  },
                                                                ),

                                                                // AppHint(text: config.list![index].hintMessage,isHide:config.list![index].isHint==false,)
                                                              ],
                                                            )
                                                            else if(config.list![index].fieldType==FieldType.checkBox)

                                                                CustomFormField(title: (config.list![index].name??""),
                                                              labelStyle: labelStyle1,

                                                              value: config.list![index].value,onChanged:(val,bool isNew){

                                                                  if(isNew){
                                                                    if(config.list![index].value==null)
                                                                      config.list![index].value=[];
                                                                    if (!config.list![index].value!.contains(val.key)) {
                                                                      config.list![index].value!.add(val.key);
                                                                    }

                                                                  }else{
                                                                    (config.list![index].value??[])!.removeWhere((key) => key == val.key);
                                                                  }
                                                                  setState(() {

                                                                  });

                                                              }
                                                              ,type:config.list![index].fieldType,
                                                              options:config.list![index].options,
                                                              // isRequired: config.list![index].isRequired!,
                                                            )
                                                            else if(config.list![index].fieldType==FieldType.datetime)


                                                                CustomFormField(title: (config.list![index].name??""),
                                                                  labelStyle: labelStyle1,
                                                                  suffixIcon:

                                                                  GestureDetector(
                                                                      onTap: () async{
                                                                        final DateTime? date = await showDatePicker(
                                                                          context: context,
                                                                          initialDate: DateTime.now(),
                                                                          firstDate: DateTime(2000),
                                                                          lastDate: DateTime(2101),
                                                                        );

                                                                        if (date == null) return null;

                                                                        final TimeOfDay? time = await showTimePicker(
                                                                          context: context,
                                                                          initialTime: TimeOfDay.now(),
                                                                        );

                                                                        if (time == null) return null;

                                                                        // Optional: Get current seconds
                                                                        final now = DateTime.now();

                                                                        // Combine date and time into DateTime object
                                                                        final combined = DateTime(
                                                                          date.year,
                                                                          date.month,
                                                                          date.day,
                                                                          time.hour,
                                                                          time.minute,
                                                                          now.second, // use current seconds
                                                                        );

                                                                        // Format to "yyyy-MM-dd HH:mm:ss"
                                                                        final formatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(combined);
                                                                        config.list![index].value=formatted;
                                                                        setState(() {

                                                                        });
                                                                      },
                                                                      child: Icon(Icons.calendar_month_sharp,color: AppColors.gray,)),


                                                                  value: config.list![index].value,onChanged:(val){

                                                                  }
                                                                  ,type:config.list![index].fieldType,
                                                                  isReadonly: true,
                                                                  // isRequired: config.list![index].isRequired!,
                                                                )
                                                            else if((config.list![index].isYakeen??false)==true)


                                                                 CustomFormField(title: (config.list![index].name??""),
                                                              labelStyle: labelStyle1,

                                                              action: [
                                                                AppButtonSmall(text: 'get_from_yakeen'.tr(),
                                                                    isOutline: true,color: AppColors.secondly,
                                                                    onTab: () async{

                                                                      ShowYakeenModal(config.list![index]);
                                                                    })
                                                              ],
                                                              value: config.list![index].value!=null?config.list![index].value.nameArabic??"Yakeen":'',onChanged:(val){

                                                              }
                                                              ,type:config.list![index].fieldType,
                                                              isReadonly: true,
                                                              // isRequired: config.list![index].isRequired!,
                                                            )
                                                            else
                                                               if(config.list![index].isSystem??false)
                                                                   AppListTitle2(title:  config.list![index].name??"",
                                                                      labelStyle: labelStyle1,
                                                                      subTitle: config.list![index].value,selection:config.list![index].options)
                                                               else
                                                                   Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  CustomFormField(title: (config.list![index].name??""),
                                                                    labelStyle: labelStyle1,

                                                                    value: config.list![index].value,onChanged:(val){


                                                                      config.list![index].value=val;
                                                                      print('ssssss');
                                                                      print(config.list![index].id);
                                                                      print(config.list![index].value);
                                                                      setState((){});

                                                                    }
                                                                    ,type:config.list![index].fieldType??FieldType.textField,
                                                                    options:config.list![index].options,
                                                                    // isRequired: config.list![index].isRequired!,
                                                                  ),


                                                                ],
                                                              )

                                                            ,
                                                            (config.list![index].isComments??false)?Column(
                                                              crossAxisAlignment: CrossAxisAlignment.end, // Ensures everything aligns left
                                                              children: [
                                                                TextField(
                                                                  maxLines: null,
                                                                  minLines: 1,
                                                                  keyboardType: TextInputType.multiline,
                                                                  onChanged: (val){

                                                                    config.list![index].comments=val;
                                                                  },
                                                                  style: TextStyle(
                                                                    color: Colors.black.withOpacity(.5), // 👈 Change input text color here
                                                                    fontSize: 15,
                                                                  ),


                                                                  decoration: InputDecoration(
                                                                    hintText: (config.list![index].commentsHint??'')==''?
                                                                    'أضف تعليقًا...':config.list![index].commentsHint,
                                                                    hintStyle: TextStyle(
                                                                      color: Colors.grey.shade400,
                                                                      fontSize: 14,
                                                                      fontStyle: FontStyle.italic, // Optional
                                                                    ),

                                                                    enabledBorder: UnderlineInputBorder(
                                                                      borderSide: BorderSide(color: Colors.grey.shade300), // Same when not focused
                                                                    ),
                                                                    focusedBorder: UnderlineInputBorder(
                                                                      borderSide: BorderSide(color: Colors.grey.shade300), // Same when focused
                                                                    ),
                                                                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                                                                  ),
                                                                ),

                                                                // CustomFormField(title: (""),
                                                                //
                                                                //         value: config.list![index].comments,onChanged:(val){
                                                                //
                                                                //           config.list![index].comments=val;
                                                                //           setState((){});
                                                                //
                                                                //         }
                                                                //         ,type:FieldType.textArea,
                                                                //         hintText:config.list![index].commentsHint
                                                                //     ),
                                                              ],
                                                            ):SizedBox()
                                                            ,

                                                              if(errors.where((a)=>a.key.toString()==config.list![index].id.toString()).firstOrNull!=null)
                                                                Text(errors.where((a)=>a.key.toString()==config.list![index].id.toString()).first.value??"",style: AppTextStyles.error,)


                                                              ],
                                                            );


                                                          }

                                                          else
                                                          {
                                                            return Container();
                                                          }
                                                        },
                                                      );
                                                    }).toList()


                                                  ,
                                                ),
                                              ),
                                              // Text((payload??"").toString()),

                                            ],
                                          ),
                                        ),
                                        // visitState=="new"?
                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: AppMediumButton(title: 'start'.tr(),onPressed: (){
                                        //         //
                                        //         setState(() {
                                        //           isLoading=true;
                                        //         });
                                        //         _surveyService.startSurvey(this.widget.surveyInput!.submitToken).then((respnse){
                                        //           setState(() {
                                        //             isLoading=true;
                                        //           });
                                        //           getSurveyDetail();
                                        //         }).catchError((e){
                                        //           setState(() {
                                        //             isLoading=false;
                                        //           });
                                        //           Flushbar(
                                        //             icon: Icon(Icons.warning,color: Colors.white,),
                                        //             backgroundColor: AppColors.danger,
                                        //             message: e.message,
                                        //             duration: Duration(seconds: 3),
                                        //           ).show(context);
                                        //         });
                                        //
                                        //
                                        //
                                        //       },color: AppColors.danger,),
                                        //
                                        //     ),
                                        //   ],
                                        // )
                                        //     :
                                        Row(
                                          children: [

                                            isShowBackBtn?Expanded(
                                              child: AppMediumButton(title: 'previous'.tr(),color: AppColors.secondly,onPressed: (){

                                                previousTab();

                                                setState(() {

                                                });

                                              }),
                                            ):Container(),
                                            isShowNextBtn?Expanded(
                                              child: AppMediumButton(title: 'next'.tr(),onPressed: (){
                                                if (_formDetailKey.currentState!.validate()) {
                                                  _formDetailKey.currentState!.save();
                                                  print('success..');
                                                  // print(currentData!.pageId.toString());

                                                  submit();
                                                  // nextTab();
                                                }

                                                setState(() {

                                                });
                                              },),

                                            ):Container(),
                                            isShowSubmitBtn?Expanded(
                                              child: PrimaryButton(text: "send".tr(),onTab:(){

                                                if (_formDetailKey.currentState!.validate()) {
                                                  _formDetailKey.currentState!.save();
                                                  print('success..');
                                                  submit();
                                                }

                                                setState(() {

                                                });

                                              }),
                                            ):Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )

                            ),



                          ],
                        ),
                      ),
                    ),
          
                    // Expanded(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.only(
                    //         topLeft: Radius.circular(15.0),
                    //         topRight: Radius.circular(15.0),
                    //         bottomLeft: Radius.circular(15.0),
                    //         bottomRight: Radius.circular(15.0),
                    //       ),
                    //     ),
                    //     child: Column(
                    //       children: [
                    //         Expanded(
                    //           child: Container(
                    //
                    //             margin: EdgeInsets.symmetric(horizontal: 5),
                    //
                    //             padding: EdgeInsets.symmetric(horizontal: 5),
                    //             child: ListView.builder(
                    //               itemCount: configurationData.list.length,
                    //               itemBuilder: (context, index) {
                    //                 // print(index);
                    //
                    //
                    //                 if(configurationData.isVisible(configurationData.list[index])){
                    //                   if(configurationData.list[index].fieldType==FieldType.multiSelect){
                    //
                    //                     return CustomFormField(title: configurationData.list[index].name,
                    //                       onTab: (){
                    //
                    //                         showModalBottomSheet(
                    //                           context: context,
                    //                           builder: (BuildContext context) {
                    //                             print('sssssss');
                    //                             print(configurationData.list[index].value);
                    //                             return MultiItemList(
                    //                               client: appUserProvider.client!,
                    //                               selectedValue: configurationData.list[index].value,
                    //                               title: 'select_tag'.tr(),
                    //                               items: configurationData.list[index].options??[],
                    //                               onItemTap: (ComboItem val){
                    //
                    //                                 if(configurationData.list[index].value==null)
                    //                                   configurationData.list[index].value=[];
                    //                                 if (!configurationData.list[index].value!.contains(val.key)) {
                    //                                   configurationData.list[index].value!.add(val.key);
                    //                                 }
                    //                                 setState(() {
                    //
                    //                                 });
                    //
                    //                                 Navigator.of(context).pop();
                    //                               },);
                    //                           },
                    //                         );
                    //
                    //                       },value: configurationData.list[index].value,
                    //                       options: configurationData.list[index].options,isReadonly:true,isSelection:true,type: FieldType.multiSelect,
                    //                       builder:(ComboItem value){
                    //                         return MultiTag(title:value.value??"",onTab: (){
                    //                           configurationData.list[index].value!.removeWhere((categoryId) => categoryId == value.key);
                    //                           setState(() {
                    //
                    //                           });
                    //
                    //                         });
                    //                       },
                    //                     );
                    //                   }else{
                    //                     return  CustomFormField(title: configurationData.list[index].name,
                    //                       value: configurationData.list[index].value,onChanged:(val){
                    //                         print('ssssss');
                    //                         configurationData.list[index].value=val;
                    //                         setState((){});
                    //
                    //                       }
                    //                       ,type:configurationData.list[index].fieldType??FieldType.textField,
                    //                       options:configurationData.list[index].options,isRequired:configurationData.list[index].isRequired! ,
                    //                     );
                    //                   }
                    //                 }
                    //                 else
                    //                   {
                    //                     return Container();
                    //                   }
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //         Text(payload.toString()),
                    //         Row(
                    //           children: [
                    //             Expanded(
                    //               child: PrimaryButton(text: "send".tr(),onTab:(){
                    //
                    //                 if (_formDetailKey.currentState!.validate()) {
                    //                   _formDetailKey.currentState!.save();
                    //                   print('success..');
                    //                   submit();
                    //                 }
                    //
                    //                 setState(() {
                    //
                    //                 });
                    //
                    //               }),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
          
                    // Text(configurationData.list[0].value),
                  ],
                ),
                isLoading
                    ? ProgressBar()
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
