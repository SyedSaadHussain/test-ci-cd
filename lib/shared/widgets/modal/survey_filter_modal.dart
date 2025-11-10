import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/survey_user_input.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/survey_service.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:provider/provider.dart';

class SurveyFilterModal extends StatefulWidget {
  final CustomOdooClient client;
  final Function onClick;
  final FieldListData? fields;
  SurveyUserInput? filter;
  SurveyFilterModal({required this.client,required this.onClick,this.filter,this.fields});
  @override
  _SurveyFilterModalState createState() => _SurveyFilterModalState();
}

class _SurveyFilterModalState extends State<SurveyFilterModal> {

  //region for varaibles
  SurveyService? _surveyService;
  List<ComboItem> regions=[];
  List<ComboItem> Priorities=[];
  SurveyUserInput _filter=SurveyUserInput();
  late UserProvider userProvider;

  //endregion

  //region for events
  @override
  void initState() {

    super.initState();
    if(this.widget.filter!=null)
      _filter=SurveyUserInput.shallowCopy(this.widget.filter!);

    setState(() {

    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _surveyService = SurveyService(this.widget.client!,userProfile: userProvider.userProfile);
      loadRegions();
      loadPriority();
    });
  }
  @override
  void dispose() {
    super.dispose();

  }

  //endregion

  //region for methods

  void loadRegions(){
    _surveyService!.getVisitFilter("region_id").then((value){
      regions= value;
      setState(() {

      });
    });
  }

  void loadPriority(){
    _surveyService!.getVisitFilter("priority_value").then((value){
      Priorities= value;
      setState(() {

      });
    });
  }
  //endregion


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

                      CustomFormField(title: this.widget.fields!.getField("region_id").label,

                        value:_filter.regionId??0 ,onChanged:(val){
                        print(val);
                          _filter.regionId = val;
                          setState((){});
                        },options: regions
                        ,type: FieldType.radio,
                        action: [
                          _filter.regionId==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                              _filter.regionId = null;
                              setState((){});
                          })
                        ],
                      ),
                      CustomFormField(title: this.widget.fields!.getField("priority_value").label,

                        value:_filter.priorityValue??0 ,onChanged:(val){
                        print(val);
                          _filter.priorityValue = val;
                          setState((){});
                        },options: Priorities
                        ,type: FieldType.radio,
                        action: [
                          _filter.priorityValue==null?Container():
                          AppCircleButton(icon: Icons.close,onTab: (){
                              _filter.priorityValue = null;
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