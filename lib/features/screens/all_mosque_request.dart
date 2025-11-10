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
import 'package:mosque_management_system/core/models/mosque_edit_request.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/features/screens/create_masjid_request.dart';
import 'package:mosque_management_system/features/screens/edit_mosque_req.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/image_circle.dart';
import 'package:mosque_management_system/shared/widgets/image_data.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

class AllMosqueRequest extends StatefulWidget {
  // final CustomOdooClient client;
  final dynamic? filter;
  AllMosqueRequest({this.filter});
  @override
  _AllMosqueRequestState createState() => _AllMosqueRequestState();
}
class _AllMosqueRequestState extends BaseState<AllMosqueRequest> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late OdooClient client;
  MosqueService? _mosqueService;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String convertToDisplayString(String status) {
    List<String> parts = status.split('_'); // Split by underscores
    List<String> capitalizedParts = parts.map((part) => capitalize(part)).toList();
    return capitalizedParts.join(' '); // Join parts with spaces
  }
  dynamic _headersMap;
  dynamic? filterField;
  dynamic? filterValue;
  int activeButtonIndex = 0;
  @override
  void initState(){
    super.initState();
    filterField=(this.widget.filter?? {})["default_filter"];
    filterValue=(this.widget.filter?? {})["filtervalue"];
    filterValue=filterValue==0?null:filterValue;
    //filterValue=189;
    activeButtonIndex=filterValue??0;

    Future.delayed(Duration.zero, () {
      // This code will run after the current frame

    });
    //getContacts(true);
  }
  FieldListData fields=FieldListData();
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    // userProvider = Provider.of<UserProvider>(context);
    _mosqueService = MosqueService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    _mosqueService!.getHeadersMap().then((headerMap){
      _headersMap=headerMap;
      setState(() {

      });
    });
    _mosqueService!.loadEditMosqueReqView().then((list){

      fields.list=list;
      states=fields.getComboList('state');
      
      setState(() {
      });

    }).catchError((e){

    });
    getStages();
  }
  String getStateDesc(dynamic key){
      var obj=states.where((item) => item.key ==key).toList();
  
      return obj.length>0?obj[0].value??"":"";
  }
  List<ComboItem> states=[];

  List<ComboItem>? stages;
  void getStages(){
    _mosqueService!.getMosqueStages().then((value){
      stages=value;
      setState(() {

      });
    }).catchError((e){

    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  MosqueEditRequestData _mosqueData =MosqueEditRequestData();
  String query='';
  void filterList() {
    query=_searchController.text;
    getMosques(true);
  }
  void clearSearch(String searchText) {
    if(searchText==''){
      query=searchText;
      getMosques(true);
    }
  }
  void getMosques(bool isReload){

    if(isReload){
      _mosqueData.reset();
    }
    _mosqueData.init();
    // setState(() {});

    _mosqueService!.getEditMosqueRequest(_mosqueData.pageSize,_mosqueData.pageIndex,query,filterField:filterField,filterValue: filterValue ).then((value){

      _mosqueData.isloading=false;
      if(value.list==null || value.list.isEmpty)
        _mosqueData.hasMore=false;
      else {
        _mosqueData.count=value.count;
        _mosqueData.list!.addAll(value.list!.toList());
      }
      setState((){});
    }).catchError((e){

      _mosqueData.hasMore=false;
      _mosqueData.isloading=false;
      setState((){});
      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: e.message,
        duration: Duration(seconds: 3),
      ).show(context);

    });
  }
  Widget buildRoundButton(int index,String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          activeButtonIndex = index; // Update the active button index
        });
        getMosques(true);
      },
      child: Container(
        // width: 50,
        //height: 50,
        margin: EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15), // Adjust the radius as needed
          color: activeButtonIndex == index ? AppColors.secondly : Colors.transparent,
          border: Border.all(color: AppColors.secondly),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: activeButtonIndex == index ? Colors.white : AppColors.secondly),
        ),
      ),
    );
  }
  TextEditingController _searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        backgroundColor: AppColors.primary,

        key: _scaffoldKey,
        body: Stack(
          children: [
            AppBackground(),
            Container(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AppBar(
                    backgroundColor: Colors.transparent, // Make AppBar transparent
                    title: Text('mosque_edit_request'.tr(),style: AppTextStyles.appBarTitle,),
                    iconTheme:  IconThemeData(
                      color: AppColors.onPrimary, // Change this to your desired icon color
                    ),// Your title here
                  ),
                  Expanded(
                    child: Container(
                      decoration: AppBoxDecoration.mainBody,
                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      //color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            child: Column(
                              children: [

                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                                  child: TextField(
                                    controller:_searchController ,
                                    onEditingComplete: () {
                                      // Your code here, triggered when the user submits the input
                                      filterList();
                                    },
                                    onChanged: (val){

                                      if(val.isEmpty)
                                        filterList();
                                    },
                                    style: AppTextStyles.textForm,
                                    decoration:  AppInputDecoration.defaultInputDecoration(label: "search".tr(),icon: Icons.search,
                                        onTab: (){
                                          filterList();
                                        }
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Text('all_request'.tr(),style: AppTextStyles.defaultHeading1,),
                                  Expanded(child: Container()),
                                  AppButtonSmall(text: 'add_new_request'.tr(),onTab: (){

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => new CreateMosqueRequest(
                                          onCallback: (){
                                            getMosques(true);
                                          },),
                                        //HalqaId: 1
                                      ),
                                    );

                                  },color: AppColors.primary,icon: Icons.add_circle_outlined )
                                ],
                              )),
                          (_mosqueData.isloading==false && _mosqueData.list!.length==0)?Center(child: Text('no_record_found'.tr(),style: TextStyle(color: Colors.grey),)):Container(),
                          Expanded(
                            child: Container(

                              padding: EdgeInsets.all(5),

                              child: ListView.builder(
                                itemCount: _mosqueData.list!.length+((_mosqueData.hasMore)?1:0),
                                itemBuilder: (context, index) {
                                  if(index >= _mosqueData.list!.length)
                                  {
                                    if(_mosqueData.isloading==false) {
                                      _mosqueData.pageIndex = _mosqueData.pageIndex + 1;
                                      getMosques(false);
                                    }
                                    return Container(
                                        height: 100,
                                        child: ProgressBar(opacity: 0));
                                  }else{
                                    return AppListItem(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => new EditMosqueReq(
                                              requestId: _mosqueData.list[index].id,
                                              onCallback: (){
                                                getMosques(true);
                                              },),
                                            //HalqaId: 1
                                          ),
                                        );
                                      },
                                      child: Container(
                                        //color: Colors.lightBlueAccent,

                                        child: Row(
                                          children: [
                                            ImageCircle(id: _mosqueData.list[index].mosqueId??0, modelName: Model.mosque, fieldId: "outer_image",uniqueId: "",baseUrl: appUserProvider.baseUrl,headersMap: _headersMap,height: 50,width: 50,),

                                            Expanded(child:Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(_mosqueData.list[index].mosque??'',style: AppTextStyles.cardTitle,),
                                                  Row(
                                                    children: [
                                                      Text(_mosqueData.list[index].name!,style: AppTextStyles.cardSubTitle),
                                                      Text(' | ',style: AppTextStyles.cardSubTitle),
                                                      Text(_mosqueData.list[index].dateSubmit??"",style: AppTextStyles.cardSubTitle),
                                                    ],
                                                  ),


                                                ],
                                              ),
                                            )),
                                            // Text(_mosqueData.list[index].state??''),
                                            AppTag(title: getStateDesc(_mosqueData.list[index].state??""))


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
