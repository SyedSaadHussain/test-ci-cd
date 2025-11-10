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
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/shared/widgets/modal/mosque_filter_modal.dart';
import 'package:mosque_management_system/features/screens/create_masjid.dart';
import 'package:mosque_management_system/features/screens/mosque_detail.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/ScrollHelper.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/image_circle.dart';
import 'package:mosque_management_system/shared/widgets/image_data.dart';
import 'package:mosque_management_system/shared/widgets/list_item.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:mosque_management_system/shared/widgets/tag_button.dart';
import 'package:mosque_management_system/shared/widgets/ui_widgets.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:provider/provider.dart';

class AllMosques extends StatefulWidget {
  // final CustomOdooClient client;
  final dynamic? filter;
  AllMosques({this.filter});
  @override
  _AllMosquessState createState() => _AllMosquessState();
}
class _AllMosquessState extends BaseState<AllMosques> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late OdooClient client;
  MosqueService? _mosqueService;
  Mosque mosqueFilter=Mosque(id: 0);
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
  // late UserProvider userProvider;
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
    loadMasjidView();
    getStages();
  }
  List<TabItem>? stages;
  void getStages(){
    _mosqueService!.getMosqueStagesTabs().then((value){
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
  @override
  void dispose() {
    // _searchController.dispose();
    super.dispose();
  }
  MosqueData _mosqueData =MosqueData();
  String query='';
  void filterList() {
    // query=_searchController.text;
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

    _mosqueService!.getAllMosques(_mosqueData.pageSize,_mosqueData.pageIndex,query,filterField:filterField,filterValue: filterValue,filter: mosqueFilter ).then((value){

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
  FieldListData fields=FieldListData();
  void loadMasjidView(){
    _mosqueService!.loadMosqueView().then((list){

      fields.list=list;

    }).catchError((e) {

    });

  }
  void showFilterModal(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return MosqueFilterModal(client: appUserProvider.client!,
            filter: mosqueFilter,
            fields: fields,
            onClick: (Mosque filter){
              mosqueFilter=Mosque.shallowCopy(filter);
              Navigator.of(context).pop();
              getMosques(true);
        });
      },
    );
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
  // TextEditingController _searchController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        // appBar: AppBar(
        //   title: Text('mosques'.tr()),
        // ),

        key: _scaffoldKey,
        body: Stack(
          children: [
            AppBackground(),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomBar(title:'mosques'.tr(),actions: [
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
                  ]),
                   Expanded(
                     child: Container(
                       decoration: AppBoxDecoration.mainBody,
                       child: Column(
                         children: [
                           Column(
                             children: [
                               Container(

                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                        child:SearchInputField(onSearch: (val){
                                          query=val;
                                          filterList();
                                        },)
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical: 8),

                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children:  [
                                              AppNewTagButton(

                                                index: 0,
                                                activeButtonIndex: activeButtonIndex,
                                                title: "all".tr(),
                                                onChange: () {
                                                  setState(() {
                                                    filterValue=null;
                                                    activeButtonIndex = 0;
                                                  });
                                                  // Call your function here
                                                  getMosques(true);
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
                                                    getMosques(true);
                                                  },
                                                );
                                              }).toList()],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                             ],
                           ),
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
                                     return  AppListItem(
                                       onTap: (){
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) => new MosqueDetail(
                                               mosqueId: _mosqueData.list[index].id,
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
                                             ImageCircle(id: _mosqueData.list[index].id??0, modelName: Model.mosque, fieldId: "outer_image",uniqueId: "",baseUrl: appUserProvider.baseUrl,headersMap: _headersMap,height: 50,width: 50,),

                                             Expanded(child:Container(
                                               padding: EdgeInsets.symmetric(horizontal: 5),
                                               child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children: [
                                                   Text(_mosqueData.list[index].name??'',style: AppTextStyles.cardTitle,),
                                                   Row(
                                                     children: [
                                                       Text(_mosqueData.list[index].city??"",style: AppTextStyles.cardSubTitle),
                                                     ],
                                                   ),


                                                 ],
                                               ),
                                             )),
                                             // Text(_mosqueData.list[index].state??''),
                                             // AppTag(title: convertToDisplayString(_mosqueData.list[index].stage??""))
                                             AppTag(title: _mosqueData.list[index].stage??"")


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
                                       padding: EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                                       margin: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
                                       child: ListTile(
                                         onTap: (){

                                           Navigator.push(
                                             context,
                                             MaterialPageRoute(
                                               builder: (context) => new MosqueDetail(
                                                 mosqueId: _mosqueData.list[index].id,
                                                 onCallback: (){
                                                   getMosques(true);
                                                 },),
                                               //HalqaId: 1
                                             ),
                                           );
                                         },

                                         contentPadding: EdgeInsets.all(0),



                                         title: Container(
                                           //color: Colors.lightBlueAccent,

                                           child: Row(
                                             children: [
                                               ImageData(id: _mosqueData.list[index].id??0, modelName: Model.mosque, fieldId: "outer_image",uniqueId: _mosqueData.list[index].uniqueId,baseUrl: appUserProvider.baseUrl,headersMap: _headersMap,height: 70,width: 60,),

                                               Expanded(child:Container(
                                                 padding: EdgeInsets.symmetric(horizontal: 5),
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                   children: [
                                                     Text(_mosqueData.list[index].name??'',style: TextStyle(color:Colors.black.withOpacity(.7),fontSize: 15),),
                                                     _mosqueData.list[index].city==null?Container():Text(_mosqueData.list[index].city!,style: TextStyle(color:Colors.grey),),
                                                     Text(convertToDisplayString(_mosqueData.list[index].stage??""),style: TextStyle(color:Colors.grey),),

                                                   ],
                                                 ),
                                               )),
                                               // Text(_mosqueData.list[index].state??''),


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
