import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/constants/model.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/core/models/mosque.dart';
import 'package:mosque_management_system/core/models/region.dart';
import 'package:mosque_management_system/core/network/custom_odoo_client.dart';
import 'package:mosque_management_system/data/services/user_service.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/shared/widgets/ProgressBar.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:mosque_management_system/shared/widgets/app_title.dart';
import 'package:mosque_management_system/shared/widgets/service_button.dart';
import 'package:provider/provider.dart';
import 'dart:io' as io;

import '../../../core/models/meter.dart';

class MeterFrom extends StatefulWidget {
  final CustomOdooClient client;
  final Meter? item;
  final String? labelName;
  final String title;
  final Function? onSave;
  final Mosque? mosque;
  final dynamic headersMap;
  final bool isAttachment;
  final bool isShared;
  MeterFrom({required this.client,this.title='',this.onSave,this.item,this.labelName,this.mosque,this.headersMap,this.isAttachment=false,this.isShared=false});
  @override
  _MeterFromState createState() => _MeterFromState();
}

class _MeterFromState extends State<MeterFrom> {
  RegionData regionData= RegionData();
  List<Region> filteredUsers= [];
  UserService? _userService;


  List<String> filteredItems = [];
  late Meter _meter;
  late Mosque _mosque;
  @override
  void initState() {
    super.initState();
    _meter=this.widget.item??Meter(id: 0);
    _mosque =this.widget.mosque??Mosque(id: 0);
    Future.delayed(Duration(seconds: 0),(){
      setState(() {
      });
    });
  }

  final _formMeterKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
  }
  @override
  Widget build(BuildContext context) {


   
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


            _meter.id>0? ModalTitle(this.widget.title,Icons.edit):ModalTitle(this.widget.title,Icons.add),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formMeterKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomFormField(title: this.widget.labelName,value: _meter.name,isRequired: true,onChanged:(val) => _meter.name = val,type: FieldType.textField,),

                    this.widget.isShared? CustomFormField(title: "shared".tr(),value: _meter.mosqueShared,isRequired: true,onChanged:(val) {
                      _meter.mosqueShared = val;
                      setState(() {

                      });
                    } ,type: FieldType.boolean,):Container(),

                    // Text(_meter.attachmentId.toString()),
                    this.widget.isAttachment ?CustomFormField(title: "attachment".tr(),
                        value: (_meter.attachmentId==null || _meter.attachmentId=='')?'':'${userProvider.baseUrl}/web/image?model=meter.meter&id=${_meter.id}&field=attachment_id&unique=${_meter.uniqueId}',
                        onChanged:(val) {
                          _meter
                              .attachmentId =
                              val;
                          setState(() {
                          });
                        },type: FieldType.image
                        ,headersMap: this.widget.headersMap,isRequired: true,):Container(),




                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: _meter.id! > 0?PrimaryButton(text: "update".tr(),onTab:(){


                            if (_formMeterKey.currentState!.validate()) {
                              _formMeterKey.currentState!.save();
                              this.widget.onSave!(_meter);
                            };
                          }):PrimaryButton(text: "create".tr(),onTab:(){


                            if (_formMeterKey.currentState!.validate()) {
                              _formMeterKey.currentState!.save();
                             
                              this.widget.onSave!(_meter);
                            };
                          }),
                        ),
                        Expanded(
                          child: SecondaryButton(text: "cancel".tr(),onTab:(){
                            Navigator.pop(context);
                          }),
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
  }
}


class MosqueMeterFrom extends StatefulWidget {
  final CustomOdooClient client;
  final MosqueMeter? item;
  final String? labelName;
  final String title;
  final Function? onSave;
  final Mosque? mosque;
  final dynamic headersMap;
  final bool isAttachment;
  final bool isShared;
  final FieldListData? fields;
  MosqueMeterFrom({required this.client,this.title='',this.onSave,this.item,this.labelName,this.mosque,this.headersMap,this.isAttachment=false,this.isShared=false,this.fields});
  @override
  _MosqueMeterFromState createState() => _MosqueMeterFromState();
}

class _MosqueMeterFromState extends State<MosqueMeterFrom> {
  RegionData regionData= RegionData();
  List<Region> filteredUsers= [];
  UserService? _userService;


  List<String> filteredItems = [];
  late MosqueMeter _meter;
  late Mosque _mosque;
  @override
  void initState() {
    super.initState();
    _meter=this.widget.item??MosqueMeter(id: 0);
    _mosque =this.widget.mosque??Mosque(id: 0);
    Future.delayed(Duration(seconds: 0),(){
      setState(() {
      });
    });
  }

  final _formMeterKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = Provider.of<UserProvider>(context);
  }
  @override
  Widget build(BuildContext context) {



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


            _meter.id>0? ModalTitle(this.widget.title,Icons.edit):ModalTitle(this.widget.title,Icons.add),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formMeterKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    // _meter.meterType=="electric" ?
                    CustomFormField(title: "attachment".tr(),
                      value: (_meter.attachmentId==null || _meter.attachmentId=='')?'':'${userProvider.baseUrl}/web/image?model=${_meter.meterType=="electric"?Model.mosqueMeter:Model.waterMeter}&id=${_meter.id}&field=attachment_id&unique=${_meter.uniqueId}',
                      onChanged:(val) {
                        _meter
                            .attachmentId =
                            val;
                        setState(() {
                        });
                      },type: FieldType.image
                      ,headersMap: this.widget.headersMap,isRequired: true,),
                    //_meter.mosque??false
                    _meter.meterType=="electric" ?CustomFormField(title: this.widget.fields!.getField("meter_new").label??" ",value: _meter.meterNew,isRequired: true,onChanged:(val) {
                      _meter.meterNew = val;
                      setState(() {

                      });

                    } ,type: FieldType.boolean,):Container(),
                    Row(
                      children: [
                        Expanded(child: CustomFormField(title: this.widget.fields!.getField("meter_number").label??"",value: _meter.meterNumber,isRequired: true,onChanged:(val) => _meter.meterNumber = val,type: FieldType.textField,)),

                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: CustomFormField(title: this.widget.fields!.getField("imam").label??" ",value: _meter.imam,isRequired: true,onChanged:(val) {
                            _meter.imam = val;
                            setState(() {

                            });
                          } ,type: FieldType.boolean,),
                        ),
                        Expanded(
                          child: CustomFormField(title: this.widget.fields!.getField("muezzin").label??" ",value: _meter.muezzin,isRequired: true,onChanged:(val) {
                            _meter.muezzin = val;
                            setState(() {

                            });
                          } ,type: FieldType.boolean,),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: CustomFormField(title: this.widget.fields!.getField("mosque").label??" ",value: _meter.mosque,isRequired: true,onChanged:(val) {
                            _meter.mosque = val;
                            setState(() {

                            });
                          } ,type: FieldType.boolean,),
                        ),
                        Expanded(
                          child: CustomFormField(title: this.widget.fields!.getField("facility").label??" ",value: _meter.facility,isRequired: true,onChanged:(val) {
                            _meter.facility = val;
                            setState(() {

                            });
                          } ,type: FieldType.boolean,),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: _meter.id! > 0?PrimaryButton(text: "update".tr(),onTab:(){


                            if (_formMeterKey.currentState!.validate()) {
                              _formMeterKey.currentState!.save();
                              this.widget.onSave!(_meter);
                            };
                          }):PrimaryButton(text: "create".tr(),onTab:(){


                            if (_formMeterKey.currentState!.validate()) {
                              _formMeterKey.currentState!.save();

                              this.widget.onSave!(_meter);
                            };
                          }),
                        ),
                        Expanded(
                          child: SecondaryButton(text: "cancel".tr(),onTab:(){
                            Navigator.pop(context);
                          }),
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
  }
}