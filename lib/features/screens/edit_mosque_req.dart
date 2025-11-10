import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/base_state.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque_edit_request.dart';
import 'package:mosque_management_system/data/services/mosque_service.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/shared/widgets/dialogs/disclaimer_dialog.dart';
import 'package:mosque_management_system/core/styles/custom_box_decoration.dart';
import 'package:mosque_management_system/core/styles/text_styles.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_list_title.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/bottom_navigation.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';


class EditMosqueReq extends StatefulWidget {
  final int requestId;
  final Function? onCallback;
  EditMosqueReq({required this.requestId,this.onCallback});
  @override
  State<EditMosqueReq> createState() => _EditMosqueReqState();
}

class _EditMosqueReqState extends BaseState<EditMosqueReq> {


  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
  }
  UserService? _userService;
  late MosqueService _mosqueService;
  FieldListData fields=FieldListData();
  bool isLoading=true;

  //Call All API from this Event
  @override
  void widgetInitialized() {
    super.widgetInitialized();
    _userService = UserService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    _mosqueService = MosqueService(appUserProvider.client!,userProfile: appUserProvider.userProfile);
    loadView();
  }
  void loadView(){
    _mosqueService.loadEditMosqueReqView().then((list){
      fields.list=list;
      setState(() {
      });
      getMosqueDetail();
    }).catchError((e){
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
  }
  MosqueEditRequest _request =MosqueEditRequest(id: 0);
  void getMosqueDetail(){
    setState((){
      isLoading=true;
    });
    _mosqueService!.getMosqueRequestDetail(this.widget.requestId).then((value){
      _request=value;

      setState((){
        isLoading=false;
      });

    }).catchError((e){

      //isLoading=false;
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
  }

  submitRequest(){
    setState(() {
      isLoading=true;
    });

    _mosqueService!.submitMosqueRequest(_request.id).then((value){
      getMosqueDetail();

      setState(() {
        isLoading=false;
      });
      this.widget.onCallback!();
    }).catchError((_){

      setState(() {
        isLoading=false;
      });

      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: _.message.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    });

  }



  final _formRefuseKey = GlobalKey<FormState>();
  String? refuseMessage;
  showRefuseModal(){
    setState(() {
      refuseMessage='';
    });
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), // Adjust top radius here
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                ModalTitle('refuse_reason'.tr(),FontAwesomeIcons.fileEdit),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formRefuseKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomFormField(title: '',value: refuseMessage,isRequired: true,onChanged:(val) => refuseMessage = val,type: FieldType.textArea,),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(text: "refuse".tr(),onTab:(){


                                if (_formRefuseKey.currentState!.validate()) {
                                  _formRefuseKey.currentState!.save();
                                  rejectRequest(refuseMessage);
                                };
                              },color: AppColors.warning),
                            ),
                            SizedBox(width: 1,),
                            Expanded(
                              child: AppButton(text: "cancel".tr(),onTab:(){
                                Navigator.pop(context);
                              },color: AppColors.gray),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  rejectRequest(refuseReason){
    Navigator.pop(context);
    setState(() {
      isLoading=true;
    });

    _mosqueService!.rejectMosqueEditRequest(refuseReason,_request.id).then((value){
      getMosqueDetail();
      setState(() {
        isLoading=false;
      });
      this.widget.onCallback!();
    }).catchError((_){

      setState(() {
        isLoading=false;
      });

      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: _.message.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    });

  }
  approveRequest(){
    setState(() {
      isLoading=true;
    });

    _mosqueService!.approveMosqueRequest(_request.id).then((value){
      getMosqueDetail();
      setState(() {
        isLoading=false;
      });
      this.widget.onCallback!();
    }).catchError((_){

      setState(() {
        isLoading=false;
      });

      Flushbar(
        icon: Icon(Icons.warning,color: Colors.white,),
        backgroundColor: AppColors.danger,
        message: _.message.toString(),
        duration: Duration(seconds: 3),
      ).show(context);
    });

  }



  @override
  Widget build(BuildContext context) {


     // userProvider = Provider.of<UserProvider>(context);
    //loadLeaveMenu(userProvider.menuRights);
    return SafeArea(

      child: Scaffold(
        backgroundColor: AppColors.primary,
          body: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: .4,
                  child: Image.asset(
                    'assets/images/splash.png', // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    //height: 170,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.onPrimary.withOpacity(.5),size: 25 , ),
                              ),
                            ),
                            Text('mosque_edit_request'.tr(),style: AppTextStyles.appBarTitle,),

                          ],
                        ),
                        SizedBox(height: 15,),
                        Text(_request.name??"",style: AppTextStyles.appBarTitle,),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                      decoration: AppBoxDecoration.mainBody,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(

                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    AppListTitle2(title: fields.getField('mosque_id').label,subTitle: _request.mosque??''),

                                    AppListTitle2(title: fields.getField('number').label,subTitle: _request.number??''),

                                    AppListTitle2(title: fields.getField('supervisor_id').label,subTitle: _request.supervisor??''),

                                    AppListTitle2(title: fields.getField('date_submit').label,subTitle: _request.dateSubmit??''),
                                    AppListTitle2(title: fields.getField('create_date').label,subTitle: _request.createDate??''),
                                    AppListTitle2(title: fields.getField('region_id').label,subTitle: _request.region??''),
                                    AppListTitle2(title: fields.getField('description').label,subTitle: _request.description??''),
                                    (_request.state=='reject')?
                                    AppListTitle2(title: fields.getField('refuse_text').label,subTitle: _request.refuseText??''):Container(),

                                    SizedBox(height: 20,),

                                  ],
                                ),
                              ),
                            ),
                          ),
                          _request.canTakeAction?Row(
                            children: [
                              Expanded(
                                child: AppButton(text: 'approve'.tr(),onTab: (){
                                  approveRequest();
                                },color: AppColors.primary,),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: AppButton(text: 'reject'.tr(),onTab: (){
                                  showRefuseModal();
                                },color: AppColors.warning),
                              )
                            ],
                          ): _request.canSubmit?Row(
                            children: [
                              Expanded(
                                child: AppButton(text: 'submit'.tr(),onTab: (){
                                  submitRequest();
                                },color: AppColors.primary,),
                              ),
                              // SizedBox(width: 5,),
                              // Expanded(
                              //   child: AppButton(text: 'edit',onTab: (){
                              //
                              //   },color: AppColors.secondly),
                              // )
                            ],
                          ):Container()
                        ],
                      ),
                    ),
                  ),


                ],
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
