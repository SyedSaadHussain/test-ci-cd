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
import 'package:mosque_management_system/core/models/visit.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/data/services/visit_service.dart';
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

class VisitFilterModal extends StatefulWidget {
  final CustomOdooClient client;
  final Function onClick;
  final FieldListData? fields;
  Visit? filter;
  VisitFilterModal({required this.client,required this.onClick,this.filter,this.fields});
  @override
  _VisitFilterModalState createState() => _VisitFilterModalState();
}

class _VisitFilterModalState extends State<VisitFilterModal> {
  CityData data= CityData();
  List<Region> filteredUsers= [];
  VisitService? _visitService;

  TextEditingController _controller = TextEditingController();

  List<String> filteredItems = [];
  List<ComboItem> visitTypes=[];
  List<ComboItem> prayerNames=[];
  List<ComboItem> priorityValues=[];
  List<ComboItem> imamOffWorks=[];
  List<ComboItem> moazenOffWorks=[];
  List<ComboItem> electricMeterViolations=[];
  List<ComboItem> waterMeterViolations=[];
  List<ComboItem> mosqueViolations=[];
  List<ComboItem> holyQuranViolations=[];
  Visit _filter=Visit(id: 0);

  @override
  void initState() {

    super.initState();
    if(this.widget.filter!=null)
      _filter=Visit.shallowCopy(this.widget.filter!);

    setState(() {

    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visitService = VisitService(this.widget.client!,userProfile: userProvider.userProfile);
      loadVisitType();
      loadPrayerNames();
      loadPriorityValues();
      loadImamOffWorks();
      loadMoazenOffWorks();
      loadElectricMeterViolations();
      loadWaterMeterViolations();
      loadMosqueViolations();
      loadHolyQuranViolations();
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }

  void filterSearchResults(String query) {

  }
  void loadVisitType(){
    _visitService!.getVisitFilter("visit_type").then((value){
      visitTypes= value;
      setState(() {

      });
    });
  }

  void loadPrayerNames(){
    _visitService!.getVisitFilter("prayer_name").then((value){
      prayerNames= value;
      setState(() {

      });
    });
  }

  void loadPriorityValues(){
    _visitService!.getVisitFilter("priority_value").then((value){
      priorityValues= value;
      setState(() {

      });
    });
  }

  void loadImamOffWorks(){
    _visitService!.getVisitFilter("imam_off_work").then((value){
      imamOffWorks= value;
      setState(() {

      });
    });
  }

  void loadMoazenOffWorks(){
    _visitService!.getVisitFilter("moazen_off_work").then((value){
      moazenOffWorks= value;
      setState(() {

      });
    });
  }

  void loadElectricMeterViolations(){
    _visitService!.getVisitFilter("electric_meter_violation").then((value){
      electricMeterViolations= value;
      setState(() {

      });
    });
  }

  void loadWaterMeterViolations(){
    _visitService!.getVisitFilter("water_meter_violation").then((value){
      waterMeterViolations= value;
      setState(() {

      });
    });
  }

  void loadMosqueViolations(){
    _visitService!.getVisitFilter("mosque_violation").then((value){
      mosqueViolations= value;
      setState(() {

      });
    });
  }
  void loadHolyQuranViolations(){
    _visitService!.getVisitFilter("holy_quran_violation").then((value){
      holyQuranViolations= value;
      setState(() {

      });
    });
  }

  late UserProvider userProvider;
  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
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

                      CustomFormField(title: this.widget.fields!.getField("visit_type").label,

                        value:_filter.visitType??0 ,onChanged:(val){
                        print(val);
                          _filter.visitType = val;
                          setState((){});
                        },options: visitTypes
                        ,type: FieldType.radio,
                        action: [
                          _filter.visitType==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                              _filter.visitType = null;
                              setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("prayer_name").label,

                        value:_filter.prayerName??0 ,onChanged:(val){
                        print(val);
                          _filter.prayerName = val;
                          setState((){});
                        },options: prayerNames
                        ,type: FieldType.radio,
                        action: [
                          _filter.prayerName==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                              _filter.prayerName = null;
                              setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("priority").label,

                        value:_filter.priorityVal??'' ,onChanged:(val){
                        print(val);
                          _filter.priorityVal = val;
                          setState((){});
                        },options: priorityValues
                        ,type: FieldType.radio,
                        action: [
                          _filter.priorityVal==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                              _filter.priorityVal = null;
                              setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("imam_off_work").label,

                        value:_filter.imamOffWork??0 ,onChanged:(val){
                          print(val);
                          _filter.imamOffWork = val;
                          setState((){});
                        },options: imamOffWorks
                        ,type: FieldType.radio,
                        action: [
                          _filter.imamOffWork==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.imamOffWork = null;
                            setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("moazen_off_work").label,

                        value:_filter.moazenOffWork??0 ,onChanged:(val){
                          print(val);
                          _filter.moazenOffWork = val;
                          setState((){});
                        },options: moazenOffWorks
                        ,type: FieldType.radio,
                        action: [
                          _filter.moazenOffWork==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.moazenOffWork = null;
                            setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("electric_meter_violation").label,

                        value:_filter.electricMeterViolation??0 ,onChanged:(val){
                          print(val);
                          _filter.electricMeterViolation = val;
                          setState((){});
                        },options: electricMeterViolations
                        ,type: FieldType.radio,
                        action: [
                          _filter.electricMeterViolation==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.electricMeterViolation = null;
                            setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("water_meter_violation").label,

                        value:_filter.waterMeterViolation??0 ,onChanged:(val){
                          print(val);
                          _filter.waterMeterViolation = val;
                          setState((){});
                        },options: waterMeterViolations
                        ,type: FieldType.radio,
                        action: [
                          _filter.waterMeterViolation==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.waterMeterViolation = null;
                            setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("mosque_violation").label,

                        value:_filter.mosqueViolation??0 ,onChanged:(val){
                          print(val);
                          _filter.mosqueViolation = val;
                          setState((){});
                        },options: mosqueViolations
                        ,type: FieldType.radio,
                        action: [
                          _filter.mosqueViolation==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.mosqueViolation = null;
                            setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("holy_quran_violation").label,

                        value:_filter.holyQuranViolation??0 ,onChanged:(val){
                          print(val);
                          _filter.holyQuranViolation = val;
                          setState((){});
                        },options: holyQuranViolations
                        ,type: FieldType.radio,
                        action: [
                          _filter.holyQuranViolation==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                            _filter.holyQuranViolation = null;
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