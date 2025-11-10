import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jhijri_picker/jhijri_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/models/date_conversion.dart';
import 'package:mosque_management_system/core/styles/app_input_decoration.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:mosque_management_system/core/utils/app_utils.dart';
import 'package:jhijri/jHijri.dart';



class AppDateField extends StatefulWidget {
  final Function? onSave;
  final Function? onTab;
  final Function? onChanged;
  final Function? onChangedDetail;
  final String? title;
  final bool isRequired;
  final bool isDisable;
  final bool isReadonly;
  final DateTime? maxDate;
  final DateTime? minDate;
  final dynamic value;
//List<DropdownMenuItem<String>>
  AppDateField({
    this.onSave,this.onTab,this.onChanged,this.onChangedDetail,this.title,this.value,
    this.isRequired=false, this.isDisable=false, this.isReadonly=false,this.maxDate,this.minDate
    });

  @override
  _AppDateFieldState createState() => _AppDateFieldState();
}

class  _AppDateFieldState extends State<AppDateField> {



  @override
  void dispose() {
    _controller.dispose();
    _controllerHijri.dispose();
    super.dispose();
  }
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerHijri = TextEditingController();
  final OutlineInputBorder outlineInputBorder = OutlineInputBorder(

    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: Colors.grey, // Adjust opacity or use Colors.grey directly
      width: 1.0, // This ensures it's 1px wide
    ),
  );

  bool showDateCombo=false;

  String? _selectedHijriDay;
  String? _selectedHijriMonth;
  String? _selectedHijriYear;
  String? _selectedGregDay;
  String? _selectedGregMonth;
  String? _selectedGregYear;
  DateTime? _selectedDate;
  DateTime? _tempSelectedDate;
   DateTime? maxDateTime;
   dynamic maxHijriDate;
   dynamic minHijriDate;
   dynamic selectedVaue;
  @override
  void initState() {
    maxDateTime= widget.maxDate ?? DateTime.now().add(Duration(days: 5 * 365));
    maxHijriDate = HijriCalendar.fromDate(maxDateTime!);
    selectedVaue = widget.value;
  }

  var selectedDateHijri = new HijriCalendar.now();

  Future<void> _selectHijriDate(BuildContext context) async {
    FocusScope.of(context).unfocus();

    showGlobalDatePicker(
      context: context,
      startDate: JDateModel(
          jhijri: JHijri(
            fYear: minHijriDate?.hYear??1357,
            fMonth: minHijriDate?.hMonth??1,
            fDay: minHijriDate?.hDay??1,
          )),
      selectedDate: JDateModel(jhijri: JHijri(fDay: selectedDateHijri.hDay,
          fMonth: selectedDateHijri.hMonth,
          fYear: selectedDateHijri.hYear)),
      endDate: JDateModel(
          jhijri: JHijri(
              fDay: maxHijriDate.hDay,
              fMonth: maxHijriDate.hMonth,
              fYear: maxHijriDate.hYear
          )),
      pickerMode: DatePickerMode.day,
      pickerTheme: Theme.of(context),
      //textDirection: TextDirection.rtl,
      //locale: const Locale("ar", "SA"),
      okButtonText: "حفظ",
      cancelButtonText: "عودة",
      onChange: (JPickerValue value) {

        _tempSelectedDate=value.date;
      },
      onOk: (JPickerValue value) {
        var g_date = new HijriCalendar();
        // setState(() {
        //
        // });
        //selectedDateHijri = new HijriCalendar.fromDate(value.date);
        if(_tempSelectedDate!=null){
          selectedDateHijri = new HijriCalendar.fromDate(_tempSelectedDate!);
          _controllerHijri.text=add_zero(selectedDateHijri.hDay) +
              '-' +
              add_zero(selectedDateHijri.hMonth) +
              '-' +
              selectedDateHijri.hYear.toString();
          ;
        }

        _selectedDate =
            g_date.hijriToGregorian(selectedDateHijri.hYear, selectedDateHijri.hMonth, selectedDateHijri.hDay);

        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        _controller.text=formatter.format(_selectedDate!);

        dateConversion= DateConversion(hijriDate: _controllerHijri.text);
        dateConversion!.triggerValue();
        // widget.onChanged!(_controller.text!,dateConversion:dateConversion);
        widget.onChanged?.call(_controller.text!); // Standard
        widget.onChangedDetail?.call(_controller.text!,dateConversion);
        selectedVaue=_controller.text;
        Future.delayed(Duration(seconds: 0),(){
          Navigator.pop(context);
          setState(() {

          });
        });
        //
      },
      onCancel: () {
        Navigator.pop(context);
      },
      primaryColor: Colors.blue,
      calendarTextColor: Colors.white,
      backgroundColor: Colors.black,
      borderRadius: const Radius.circular(10),
      buttonTextColor: Colors.white,
      headerTitle: const Center(
        child: Text("التقويم الهجري", style: TextStyle(color: Colors.white),),
      ),
    );
  }

  String add_zero(your_number) {
    // return your_number.toString();
    var num = '' + your_number.toString();
    if (your_number < 10) {
      num = '0' + num;
    }
    return num;
  }
  DateConversion? dateConversion;

  Future<void> _selectDate(BuildContext context) async {
    if(_controller.text.isNotEmpty)
      _selectedDate=DateTime.parse(_controller.text);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (_selectedDate??DateTime.now()).isBefore(AppUtils.minGregDate())?AppUtils.minGregDate():(_selectedDate??DateTime.now()),
      firstDate: widget.minDate??AppUtils.minGregDate(),
      lastDate: maxDateTime!,
    );
    if (picked != null && picked != _selectedDate){
      // setState(() {
      //
      // });
      _selectedDate = picked;
      selectedDateHijri = new HijriCalendar.fromDate(_selectedDate!);
      _controller.text=formatter.format(_selectedDate!);

      _controllerHijri.text = add_zero(selectedDateHijri.hDay) +
          '-' +
          add_zero(selectedDateHijri.hMonth) +
          '-' +
          selectedDateHijri.hYear.toString();


      dateConversion= DateConversion(hijriDate: _controllerHijri.text);
      dateConversion!.triggerValue();
      // this.widget.onChanged!(_controller.text!,dateConversion);
      widget.onChanged?.call(_controller.text!); // Standard
      widget.onChangedDetail?.call(_controller.text!,dateConversion);
      selectedVaue=_controller.text;

      setState(() {

      });

    }

  }

  @override
  Widget build(BuildContext context) {
    print('rrrrrrrrr');
    print(selectedVaue);
    print(_controller.text);
    if(selectedVaue!=null && selectedVaue!=''){
      Future.delayed(Duration(seconds: 0), () {
        _controller.text=selectedVaue??"";
        _selectedDate=DateTime.parse(_controller.text);
        if(_selectedDate!.isAfter(AppUtils.minGregDate().add(Duration(days: -1)))){
          selectedDateHijri = new HijriCalendar.fromDate(_selectedDate!);
          _controllerHijri.text = add_zero(selectedDateHijri.hDay) +
              '-' +
              add_zero(selectedDateHijri.hMonth) +
              '-' +
              selectedDateHijri.hYear.toString();
        }
      });
    }else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectedDate=null;

        _controller.text = '';
        _controllerHijri.text='';
        if(widget.minDate!=null)
          minHijriDate = HijriCalendar.fromDate(widget.minDate!);
      });

    }


    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text(this.widget.title??"",style:AppTextStyles.formLabel),
        Container(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (text) {
                    if (this.widget.isRequired && (text == null || text.isEmpty)) {
                      return 'please_pick_a_date'.tr();
                    }
                    return null;
                  },
                  // onChanged: (val){
                  //
                  //   if(this.widget.onChanged!=null){
                  //       this.widget.onChanged!(val);
                  //   }
                  // },
                  onSaved: (val){

                    if(this.widget.onSave!=null){
                        this.widget.onSave!(val);
                    }

                  },
                  enabled:!this.widget.isDisable,
                  onTap: (){
                    if(this.widget.onTab!=null)
                      this.widget.onTab!();

                  },

                  readOnly:true,
                  controller: _controller,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                    suffixIcon:IconButton( icon: Icon(Icons.calendar_month,color: Colors.grey.withOpacity(1)),
                      onPressed: (){
                        _selectDate(context);
                      },
                    ),
                    filled: true,

                    fillColor: this.widget.isDisable?AppColors.formDisabledField:AppColors.formField,

                    // Customize the appearance of the input fields for the first theme
                    focusedBorder: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    disabledBorder:outlineInputBorder,
                    border: outlineInputBorder,
                    // Add more customizations as needed
                  ),
                  //controller: _usernameController,


                ),
              ),
              SizedBox(width: 5,),
              Expanded(
                child: TextFormField(
                  //this.widget.type==FieldType.textArea?
                  //this.isDisable

                  validator: (text) {
                    if (this.widget.isRequired && (text == null || text.isEmpty)) {
                      return '';
                    }
                    return null;
                  },
                  // onChanged: (val){
                  //
                  // },
                  onSaved: (val){

                  },
                  enabled:!this.widget.isDisable,
                  onTap: (){


                  },

                  readOnly:true,
                  controller: _controllerHijri,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
                    suffixIcon:IconButton( icon: Icon(Icons.calendar_month,color: Colors.grey.withOpacity(1)),
                      onPressed: (){
                        _selectHijriDate(context);
                      },
                    ),
                    filled: true,
                    fillColor: this.widget.isDisable?AppColors.formDisabledField:AppColors.formField,

                    // Customize the appearance of the input fields for the first theme
                    focusedBorder: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    disabledBorder:outlineInputBorder,
                    border: outlineInputBorder,
                    // Add more customizations as needed
                  ),
                  //controller: _usernameController,


                ),
              ),
            ],
          ),
        ),
      ],

    );
  }



}
