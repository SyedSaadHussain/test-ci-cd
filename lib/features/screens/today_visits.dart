import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/input_decoration_themes.dart';
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/data/services/visit_service.dart';
import 'package:mosque_management_system/shared/widgets/modal/visit_filter_modal.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/features/screens/visit_detail.dart';
import 'package:mosque_management_system/features/screens/webview_screen.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/ScrollHelper.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/gps_permission.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/image_circle.dart';
import 'package:mosque_management_system/shared/widgets/image_data.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/survey.dart';


class TodayVisits extends StatefulWidget {
  // final CustomOdooClient client;
  final dynamic? filter;
  TodayVisits({this.filter});
  @override
  _TodayVisitsState createState() => _TodayVisitsState();
}
class _TodayVisitsState extends BaseState<TodayVisits> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late OdooClient client;
  VisitService? _visitService;
  String query='';
  dynamic? filterField;
  dynamic filterValue;
  int activeButtonIndex = 0;
  Visit visitFilter=Visit(id: 0,priorityVal: null);
  @override
  void initState(){
    super.initState();
    filterField=(this.widget.filter?? {})["default_filter"];
    filterValue=(this.widget.filter?? {})["filtervalue"];
    filterValue=filterValue==0?null:filterValue;
    //filterValue=193;
    activeButtonIndex=filterValue??0;

    //getContacts(true);
  }
  dynamic _headersMap;
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _visitService = VisitService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    //_visitService!.updateUserProfile(appUserProvider.userProfile);
    _visitService!.getHeadersMap().then((headerMap){_headersMap=headerMap;setState(() {

    });});
    getVisitStages();
    loadMasjidView();
  }
  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
  VisitData _visitData =VisitData();
  void filterList() {
    FocusScope.of(context).unfocus();
    // query=_searchController.text;
    getVisits(true);
  }
  List<TabItem>? stages;
  void getVisitStages(){

    _visitService!.getVisitStages().then((value){
      stages=value;
      setState(() {

      });
      ScrollHelper.scrollToTab(
        stages: stages??[],
        activeButtonIndex: activeButtonIndex,
      );
    }).catchError((e){

    });
  }
  void clearSearch(String searchText) {
    if(searchText==''){
      query=searchText;
      getVisits(true);
    }
  }
  void getVisits(bool isReload){

    if(isReload){
      _visitData.reset();
      setState(() {

      });
      
      // return;
    }
    _visitData.init();



    _visitService!.getVisits(_visitData.pageSize,_visitData.pageIndex,query,filterField:filterField,filterValue: filterValue,filter: visitFilter ).then((value){
      _visitData.isloading=false;
      if(value.list==null || value.list.isEmpty)
        _visitData.hasMore=false;
      else {
        _visitData.count=value.count;
        _visitData.list!.addAll(value.list!.toList());
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
        _visitData.isloading=false;
      });
      _visitData.hasMore=false;

    });
  }
  FieldListData fields=FieldListData();
  void loadMasjidView(){
    _visitService!.loadVisitView().then((list){

      fields.list=list;

    }).catchError((e) {

    });

  }

  void showFilterModal(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return VisitFilterModal(client: appUserProvider.client!,
            filter: visitFilter,
            fields: fields,
            onClick: (Visit filter){
              visitFilter=Visit.shallowCopy(filter);
              Navigator.of(context).pop();
              getVisits(true);
            });
      },
    );
  }

  // TextEditingController _searchController = TextEditingController();
  bool isVisiablePermission=false;
  late GPSPermission permission;

  //late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        // appBar: AppBar(
        //   title: Text('search_visits'.tr()),
        // ),

        key: _scaffoldKey,
        body: Stack(
          children: [
            AppBackground(),
            Container(
              child: Column(
                children: [
                  AppCustomBar(title:'search_visits'.tr(),actions: [
                    IconButton(onPressed: (){

                    }, icon:GestureDetector(
                      onTap:(){
                        showFilterModal();
                      },
                      child: Row(
                        children: [
                          Text('filter'.tr(),style: TextStyle(color: Colors.white),),Icon(Icons.filter_alt_outlined,)],

                      ),
                    ) ,)
                  ]

                  ),
                  Expanded(
                    child: Container(
                      decoration: AppBoxDecoration.mainBody,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // isVisiablePermission? Visibility(
                          //   visible:  isVisiablePermission,
                          //   child: Container(
                          //       margin: EdgeInsets.only(bottom: 5),
                          //       padding: EdgeInsets.all(10),
                          //       //height: 30,
                          //       decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(7),
                          //         color: permission.status==GPSPermissionStatus.authorize?AppColors.primaryText :AppColors.primaryText,
                          //       ),
                          //       child: Row(
                          //         children: [
                          //           permission.status==GPSPermissionStatus.authorize?Icon(Icons.check_circle,color: AppColors.success,):Icon(Icons.warning_amber,color: AppColors.warning,),
                          //           SizedBox(width: 5,),
                          //           Expanded(
                          //               child: Text(permission.statusDesc,style: TextStyle(fontSize: 13 ,color: permission.status==GPSPermissionStatus.authorize?AppColors.success: AppColors.warning),)
                          //           ),
                          //           !permission.isCompleted?SizedBox(
                          //               height: 25.0,
                          //               width: 25.0,
                          //               child: CircularProgressIndicator(color: AppColors.warning,)):permission.showTryAgainButton?
                          //           TextButton(
                          //               style: TextButton.styleFrom(
                          //                   padding: EdgeInsets.zero,
                          //                   minimumSize: Size(50, 25),
                          //                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //                   alignment: Alignment.centerLeft),
                          //               onPressed: () {
                          //                 if(permission.status==GPSPermissionStatus.locationDisabled){
                          //                   permission.enableMobileLocation();
                          //                 }else if(permission.status==GPSPermissionStatus.permissionDenied){
                          //                   permission.allowPermission();
                          //                 }else if(permission.status==GPSPermissionStatus.failFetchCoordinate || permission.status==GPSPermissionStatus.unAuthorizeLocation){
                          //                   permission.getCurrentLocation();
                          //                 }
                          //               },child: Text('try_again'.tr(),style: TextStyle(color: AppColors.warning,decoration: TextDecoration.underline,),)):Container() ,
                          //         ],
                          //       )
                          //   ),
                          // ):Container(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                  child:
                                  SearchInputField(onSearch: (val){
                                    query=val;
                                    filterList();
                                  }),
                                  // TextField(
                                  //   controller:_searchController ,
                                  //   onEditingComplete: () {
                                  //     // Your code here, triggered when the user submits the input
                                  //     filterList();
                                  //   },
                                  //   onChanged: (val){
                                  //     if(val.isEmpty)
                                  //       filterList();
                                  //   },
                                  //   style: TextStyle(color: AppColors.gray),
                                  //   decoration: AppInputDecoration.defaultInputDecoration(label: "search".tr(),icon: Icons.search,
                                  //   onTab: (){
                                  //     filterList();
                                  //   }
                                  //   ),
                                  // ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),

                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child:  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children:  [
                                        AppNewTagButton(
                                          index: 0,
                                          activeButtonIndex: activeButtonIndex,
                                          title: "All",
                                          onChange: () {
                                            setState(() {
                                              filterValue=null;
                                              activeButtonIndex = 0;
                                            });
                                            // Call your function here
                                            getVisits(true);
                                          },
                                        ),

                                        ...(stages??[])!.map((stage) {
                                          return AppNewTagButton(
                                            key: stage.globalKey,
                                            index: stage.key,
                                            activeButtonIndex: activeButtonIndex,
                                            title: (stage.value??""),
                                            onChange: () {
                                              setState(() {
                                                filterValue=stage.key;
                                                activeButtonIndex = stage.key;
                                              });
                                              // Call your function here
                                              getVisits(true);
                                            },
                                          );
                                        }).toList()],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          (_visitData.isloading==false && _visitData.list!.length==0)?Center(child: Text('no_record_found'.tr(),style: TextStyle(color: Colors.grey),)):Container(),
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
                                itemCount: _visitData.list!.length+((_visitData.hasMore)?1:0),
                                itemBuilder: (context, index) {
                                  if(index >= _visitData.list!.length)
                                  {
                                    if(_visitData.isloading==false){
                                      _visitData.pageIndex=_visitData.pageIndex+1;
                                      getVisits(false);
                                    }
                                    return Container(
                                        height: 100,
                                        child: ProgressBar(opacity: 0));
                                  }else{
                                    var visit = _visitData.list[index];

                                    return  AppListItem(
                                       color: _visitData.list[index].priorityColor??null,
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => new VisitDetail(
                                              visitIdId: _visitData.list[index].id!,
                                              onCallback: (){
                                                getVisits(true);
                                              },
                                            ),
                                            //HalqaId: 1
                                          ),
                                        );
                                      },
                                      child: Container(
                                        //color: Colors.lightBlueAccent,

                                        child: Row(
                                          children: [
                                            ImageCircle(id: _visitData.list[index].id??0, modelName: Model.visit, fieldId: "outer_image",uniqueId: "",baseUrl: appUserProvider.baseUrl,headersMap: _headersMap,height: 50,width: 50,title: _visitData.list[index].mosqueSequenceNo,),

                                            Expanded(child:Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(_visitData.list[index].mosqueSequenceNo??'',style: AppTextStyles.cardTitle,softWrap: true,),
                                                  Row(
                                                    children: [

                                                      Text(_visitData.list[index].name.toString()!,style: AppTextStyles.cardSubTitle),
                                                      (_visitData.list[index].dateOfVisitGreg??"")==""?Container():Text(' | ',style: AppTextStyles.cardSubTitle),
                                                      Text(_visitData.list[index].dateOfVisitGreg??"",style: AppTextStyles.cardSubTitle),

                                                    ],
                                                  ),


                                                ],
                                              ),
                                            )),
                                            // Text(_mosqueData.list[index].state??''),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                AppTag(title: _visitData.list[index].stage??""),
                                                SizedBox(height: 5,),
                                                AppTagSm(title: _visitData.list[index].priorityValue.tr()??"",color:_visitData.list[index].priorityColor??AppColors.defaultColor ),



                                              ],
                                            )


                                          ],
                                        ),
                                      ),
                                    );
                                    return Container(

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey.shade200, // Change this to your desired border color
                                          width: 1.0, // Adjust the width as needed
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                      margin: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
                                      child: ListTile(
                                        onTap: (){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => new VisitDetail(
                                                visitIdId: _visitData.list[index].id!,
                                                onCallback: (){
                                                  getVisits(true);
                                                },
                                              ),
                                              //HalqaId: 1
                                            ),
                                          );
                                        },

                                        contentPadding: EdgeInsets.all(0),

                                        // leading:

                                        title: Row(
                                          children: [
                                            ImageData(id: _visitData.list[index].mosqueSequenceNoId??0, modelName: Model.mosque, fieldId: "outer_image",uniqueId: _visitData.list[index].uniqueId,baseUrl: appUserProvider.baseUrl,headersMap: _headersMap,height: 80,width: 70,),

                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                //color: Colors.lightBlueAccent,

                                                child:
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Expanded(child:Text(_visitData.list[index].mosqueSequenceNo??'',style: TextStyle(color:Colors.black.withOpacity(.7),fontSize: 12),)),


                                                        ],
                                                      ),
                                                      // Text(_visitData.list[index].priority.toString()),
                                                      Text(_visitData.list[index].name.toString(),style: TextStyle(color:Colors.grey,fontSize: 12),),
                                                      Text(_visitData.list[index].stage??"" ,style: TextStyle(color:Colors.grey,fontSize: 12),),
                                                      _visitData.list[index].dateOfVisitGreg==null?Container():Text(_visitData.list[index].dateOfVisitGreg.toString()!,style: TextStyle(color:Colors.grey,fontSize: 12),),
                                                    ],
                                                  )
                                              ),
                                            ),
                                          ],
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
