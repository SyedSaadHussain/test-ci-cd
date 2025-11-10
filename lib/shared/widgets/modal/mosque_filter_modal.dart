import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/models/res_city.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
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

class MosqueFilterModal extends StatefulWidget {
  final CustomOdooClient client;
  final Function onClick;
  final FieldListData? fields;
  Mosque? filter;
  MosqueFilterModal({required this.client,required this.onClick,this.filter,this.fields});
  @override
  _MosqueFilterModalState createState() => _MosqueFilterModalState();
}

class _MosqueFilterModalState extends State<MosqueFilterModal> {
  CityData data= CityData();
  List<Region> filteredUsers= [];
  MosqueService? _mosqueService;

  TextEditingController _controller = TextEditingController();

  List<String> filteredItems = [];
  List<ComboItem> classifications=[];
  List<ComboItem> regions=[];
  List<ComboItem> cities=[];
  Mosque _filter=Mosque(id: 0);

  @override
  void initState() {

    super.initState();
    if(this.widget.filter!=null)
      _filter=Mosque.shallowCopy(this.widget.filter!);

    setState(() {

    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mosqueService = MosqueService(this.widget.client!,userProfile: userProvider.userProfile);
      // print(userProvider.userProfile.companyId);
      loadClassification();
      loadRegion();
      if(_filter.regionId!=null)
        loadCities();
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  void filterSearchResults(String query) {

  }
  void loadClassification(){
    _mosqueService!.getMosqueFilter("classification_id").then((value){
       classifications= value;
      setState(() {

      });
    });
  }
  void loadRegion(){
    _mosqueService!.getMosqueFilter("region_id").then((value){
      regions= value;
      setState(() {

      });
    });
  }
  void loadCities(){
    var domain=[['region_id','=',_filter.regionId]];
    _mosqueService!.getMosqueFilter("city_id",domain: domain).then((value){
      cities= value;
      setState(() {

      });
    });
  }
  void searchRecords(bool isReload){
 
    if(isReload){
      data.reset();
    }
    data.init();
  }
  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    // _mosqueService!.repository.userProfile=userProvider.userProfile;
    return SizedBox(
       height: MediaQuery.of(context).size.height /1.2,
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
          margin: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModalTitle("filter".tr(),FontAwesomeIcons.filter,leading:IconButton(icon: Icon(Icons.close,color: Colors.grey,),onPressed: (){
                Navigator.of(context).pop();
              },)
              ),
              SizedBox(height: 10),
              Expanded(

                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      CustomFormField(title: this.widget.fields!.getField("classification_id").label,

                        value:_filter.classificationId??0 ,onChanged:(val){
                        print(val);
                          _filter.classificationId = val;
                          setState((){});
                        },options: classifications
                        ,type: FieldType.radio,
                        action: [
                          _filter.classificationId==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                              _filter.classificationId = null;
                              setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("region_id").label,
                        value:_filter.regionId??0 ,onChanged:(val){
                          print(val);
                          _filter.regionId = val;
                          _filter.cityId = null;
                          cities=[];
                          setState((){});
                          loadCities();
                        },options: regions
                        ,type: FieldType.radio,
                        action: [
                          _filter.regionId==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.regionId = null;
                            _filter.cityId = null;
                            cities=[];
                            setState((){});
                          })
                        ],
                      ),

                      _filter.regionId==null?Container():CustomFormField(title: this.widget.fields!.getField("city_id").label,
                        value:_filter.cityId??0 ,onChanged:(val){
                          print(val);
                          _filter.cityId = val;
                          setState((){});
                        },options: cities
                        ,type: FieldType.radio,
                        action: [
                          _filter.cityId==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.cityId = null;
                            setState((){});
                          })
                        ],
                      ),
                    ],
                  ),
                )
              ),
              AppButton(text: 'apply'.tr(),color: AppColors.primary,onTab: (){
                this.widget.onClick(_filter);
              })
            ],
          ),
        ),
      ),
    );
  }
}